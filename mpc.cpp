#include<iostream>
#include<tuple>
#include<string>
#include<fstream>
#include<vector>
#include<Eigen/Dense>
#include "mpc.h"

using namespace Eigen;
using namespace std;

MPC::MPC(MatrixXd Ai,MatrixXd Bi,MatrixXd Ci,
            unsigned int fi, unsigned int vi,MatrixXd w3i,
            MatrixXd w4i, MatrixXd x0i,MatrixXd trajDesiredi )
{
    //declare as private members
    A=Ai;
    B=Bi;
    C=Ci;
    f=fi;
    v=vi;
    w3=w3i;
    w4=w4i;
    x0=x0i;
    trajDesired=trajDesiredi;
    
    n=A.rows();
    m=B.cols();
    r=C.rows();

    k=0;


    //extract a part of trajectory for control
    unsigned int maxSimSamples=trajDesired.rows()-f;

    //--------------xx----------
    states.resize(n, maxSimSamples); 
    states.setZero();
    states.col(0)=x0;

    inputs.resize(m, maxSimSamples-1); 
    inputs.setZero();
   
    outputs.resize(r, maxSimSamples-1); 
    outputs.setZero();

    O.resize(f*r,n);
    O.setZero();

    //making matrix O
    MatrixXd powA;
    powA.resize(n,n);

    for(int i=0;i<f;i++)
    {
        if(i==0)
        {
            powA=A;
        }
        else
        {
            powA=powA*A;
        }


            O(seq(i*r,(i+1)*r-1),all)=C*powA;

    }

    M.resize(f*r,v*m);
    M.setZero();

    MatrixXd In;
    In= MatrixXd::Identity(n,n);

    MatrixXd sumLast;
    sumLast.resize(n,n);
    sumLast.setZero();

    for (int i=0; i<f;i++)
    {
        // until the control horizon
        if(i<v)
        {
            for (int j=0; j<i+1;j++)
            {
                if (j==0)
                {
                    powA=In;
                }
                else
                {
                    powA=powA*A;
                   
                    
                }
                M(seq(i*r,(i+1)*r-1),seq((i-j)*m,(i-j+1)*m-1))=C*powA*B;//what
                
            }
        }
        // from the control horizon 
        else
        {
            for(int j=0;j<v;j++)
            {
                if (j==0)
                {
                        sumLast.setZero();
                        for (int s=0;s<i+v+2;s++)
                        {
                            if (s == 0)
                            {
                                powA=In;
                            }
                            else
                            {
                                powA=powA*A;
                            }
                            sumLast=sumLast+powA;
                        }
                        M(seq(i*r,(i+1)*r-1),seq((v-1)*m,(v)*m-1))=C*sumLast*B;


                }
                else
                {

                    powA=powA*A;
                    M(seq(i*r,(i+1)*r-1),seq((v-1-j)*m,(v-j)*m-1))=C*powA*B;
        

                }

            }

        }
    }

    MatrixXd tmp;
    tmp.resize(v*m,v*m);

    tmp=M.transpose()*w4*M+w3;
    gainMatrix=(tmp.inverse())*(M.transpose())*w4;


}

void MPC::PropagateAndCompute()
{

    // splice the desired control trajectory
    MatrixXd desiredControlTrajectory;
    desiredControlTrajectory=trajDesired(seq(k,k+f-1),all);
    
    //s is used to solve for the optimal input
    MatrixXd vectorS;
    vectorS=desiredControlTrajectory-O*states.col(k);

    //--------CONNTROL COMPUTATION----------
    MatrixXd inputSequenceComputed;
    inputSequenceComputed=gainMatrix*vectorS;
    //-------------------------

    //slice out the first entry
    inputs.col(k)=inputSequenceComputed(seq(0,m-1),all);

    // feed the control input to the system, update outputs with the state, and propagate time
    states.col(k+1)=A*states.col(k)+B*inputs.col(k);//x_k+1
    outputs.col(k)=C*states.col(k);//y_k
    k+=1;

}

void MPC::saveData(string desiredTrajf, string inputsf, string statesf, string outputsf, string Of, string Mf)const
{
    const static IOFormat CSVFormat(FullPrecision, DontAlignCols, ", ", "\n");
	
	ofstream file1(desiredTrajf);
	if (file1.is_open())
	{
		file1 << trajDesired.format(CSVFormat);
		
		file1.close();
	}

	ofstream file2(inputsf);
	if (file2.is_open())
	{
		file2 << inputs.format(CSVFormat);
		file2.close();
	}
	
	ofstream file3(statesf);
	if (file3.is_open())
	{
		file3 << states.format(CSVFormat);
		file3.close();
	}

	ofstream file4(outputsf);
	if (file4.is_open())
	{
		file4 << outputs.format(CSVFormat);
		file4.close();
	}

    ofstream file5(Of);
	if (file5.is_open())
	{
		file5 << O.format(CSVFormat);
		file5.close();
	}


ofstream file6(Mf);
	if (file6.is_open())
	{
		file6 << M.format(CSVFormat);
		file6.close();
	}
}