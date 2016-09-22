#include "mex.h"
#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#include <cmath>
#include <vector>
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <algorithm>
#include <unistd.h>
#include <map>
#include <iostream>
#include <iterator>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <armadillo>

using namespace std;
using namespace arma;

vector<mat> getMList(vector< vector< vector<colvec> > > &rFCellMatrList, int cardY, int T, colvec &lambda)
{
	vector<mat> mList;
	mat m(cardY, cardY);
	vec a;

	for(int t = 0; t < T; t++)
	{
		for(int i = 0; i < cardY; i++)
		{
			for(int j = 0; j < cardY; j++)
			{
				a = lambda.t()*rFCellMatrList[t][i][j];
				m(i, j) = a(0);
			}
		}

		mList.push_back(m.t());
	}

	return mList;
}

double crf_getLogSum(colvec logVector)
{
	double maxTerm = max(logVector);
	logVector -= maxTerm;

	return (log(sum(exp(logVector))) + maxTerm);
}

void getAlphaT(colvec &alphaT, mat &m)
{
	int cardY = m.n_cols;

	mat inm = repmat(alphaT.t(), cardY, 1).t() + m;
	alphaT.zeros();

	for(int i = 0; i < cardY; i++)
	{
		colvec temp = inm.col(i);
		alphaT(i) = crf_getLogSum(temp);
	}
}

vector<colvec> getAlphaTList(vector<mat> &mList, int cardY, int T)
{
	vector<colvec> alphaTList;
	colvec alphaT(cardY);

	alphaT.zeros();
	alphaT(0) = 1;

	mat m = mList[0];
	alphaT = (alphaT.t()*m).t();

	alphaTList.push_back(alphaT);

	for(int t = 1; t < T; t++)
	{
		m = mList[t];
		getAlphaT(alphaT, m);
		alphaTList.push_back(alphaT);
	}

	return alphaTList;
}

void getBeta(colvec &beta, mat &m)
{
	int cardY = m.n_cols;
	mat inm = repmat(beta, 1, cardY).t() + m;
	beta.zeros();

	for(int i = 0; i < cardY; i++)
	{
		colvec temp = inm.row(i).t();
		beta(i) = crf_getLogSum(temp);
	}
}

vector<colvec> getBetaList(vector<mat> &mList, int cardY, int T)
{
	//get beta vector list backward
	vector<colvec> betaList;
	mat m;
	colvec beta(cardY);

	beta.zeros();

	betaList.insert(betaList.begin(), beta);

	for(int t = T-2; t > -1; t--)
	{
		getBeta(beta, mList[t + 1]);
		betaList.insert(betaList.begin(), beta);
	}

	return betaList;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	vector< vector<mat> > QMatr;
	vector< vector< vector<colvec> > > rFCellMatrList;
	const mwSize *dims;
	const mwSize *dims2;

	//mxArray *QMatr = (double *)mxGetData(prhs[0]);
	mxArray *cell;
	mxArray *cell1;
	mxArray *cell2;
	double *a;

	dims = mxGetDimensions(prhs[0]);

	for(int i = 0; i < dims[0]; i++)
	{
		QMatr.push_back(vector<mat>());

		for(int j = 0; j < dims[1]; j++)
		{
			cell = mxGetCell(prhs[0], i + j*dims[0]);
			dims2 = mxGetDimensions(cell);
			QMatr.back().push_back(mat(dims2[0], dims2[1]));
			a = mxGetPr(cell);

			for(int k = 0; k < dims2[0]; k++)
			{
				for(int l = 0; l < dims2[1]; l++)
				{
					QMatr.back().back()(l, k) = a[k*dims2[1] + l];
				}
			}
		}
	}

	int size = mxGetNumberOfElements(prhs[1]);
	int size2;

	for(int i = 0; i < size; i++)
	{
		rFCellMatrList.push_back(vector< vector<colvec> >());

		cell1 = mxGetCell(prhs[1], i);
		dims2 = mxGetDimensions(cell1);

		for(int k = 0; k < dims2[0]; k++)
		{
			rFCellMatrList.back().push_back(vector<colvec>());

			for(int l = 0; l < dims2[1]; l++)
			{
				cell2 = mxGetCell(cell1, k*dims2[1] + l);
				a = mxGetPr(cell2);

				size2 = mxGetNumberOfElements(cell2);
				rFCellMatrList.back().back().push_back(vec(size2));

				for(int m = 0; m < size2; m++)
				{
					rFCellMatrList.back().back().back()(m) = a[m];
				}
			}
		}
	}

	int cardY = rFCellMatrList[0][0].size();
	int numF = QMatr.size();
	int T = QMatr[0].size();

	a = mxGetPr(prhs[2]);

	colvec lambda(numF);

	for(int i = 0; i < numF; i++)
	{
		lambda(i) = a[i];
	}

	vector<mat> mList = getMList(rFCellMatrList, cardY, T, lambda);

	vector<colvec> alphaTList = getAlphaTList(mList, cardY, T);

	vector<colvec> betaList = getBetaList(mList, cardY, T);

	double logZ = crf_getLogSum(alphaTList[T-1]);

	plhs[0] = mxCreateDoubleMatrix(numF, 1, mxREAL);
	double *rFeature = mxGetPr(plhs[0]);

	double fea = 0.0;
	mat qm;
	mat m;
	mat inm;
	colvec beta;
	colvec alphaT;
	colvec inv;

	for(int j = 0; j < numF; j++)
	{
		fea = 0.0;

		qm = QMatr[j][0];
		m = mList[0];
		beta = betaList[0];

            	alphaT = alphaTList[0];

            	inv = alphaT + beta;
            	inv -= logZ;

		fea += dot(exp(inv), qm.row(0));

		if(isnan(fea))
		{
			cout<<"NaN"<<endl;
		}

		for(int t = 1; t < T; t++)
		{
			qm = QMatr[j][t];
			m = mList[t];
			beta = betaList[t];
			alphaT = alphaTList[t-1];

			inm = repmat(alphaT.t(), cardY, 1).t() + m + repmat(beta, 1, cardY).t();
			inm -= logZ;

			fea += dot(exp(inm), qm);

			if(isnan(fea))
			{
				cout<<"NaN"<<endl;
			}
		}

		rFeature[j] = fea;
	}

	nlhs = 1;
}
