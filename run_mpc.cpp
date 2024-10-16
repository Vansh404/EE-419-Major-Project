#include <iostream>
#include<Eigen/Dense>

#include "mpc.cpp"
#include "mpc.h"

using namespace Eigen;
using namespace std;

int main()
{

//PARAMETER DEFINITIONS---------------

//pred horizon
unsigned int f=20;

//control horizon
unsigned int v=18;


//SYSTEM DEFINITIONS
double m1=2 ; 
double m2=2  ; 
double k1=100 ; 
double k2=200; 
double d1=1 ; 
double d2=5; 

//# SPRING DAMPER SYSTEM-----------------

    Matrix <double,4,4> Ac {{0, 1, 0, 0},
                            {-(k1+k2)/m1 ,  -(d1+d2)/m1 , k2/m1 , d2/m1},
                            {0 , 0 ,  0 , 1},
                            {k2/m2,  d2/m2, -k2/m2, -d2/m2}};
    Matrix <double,4,1> Bc {{0},{0},{0},{1/m2}}; 
    Matrix <double,1,4> Cc {{1,0,0,0}};

    Matrix <double,4,1> x0 {{0},{0},{0},{0}}; 

//

unsigned int n = Ac.rows();  unsigned int m = Bc.cols(); unsigned int r = Cc.rows();


//DISCRETIZATION----------USING EULERS METHOD

double sampling=0.05;// Ts

MatrixXd In;
In= MatrixXd::Identity(n,n);

MatrixXd A;
MatrixXd B;
MatrixXd C;
A.resize(n,n);
B.resize(n,m);
C.resize(r,n);
A=(In-sampling*Ac).inverse();
B=A*sampling*Bc;
C=Cc;

//thats it, discretization done


// MAKING MATRICES, THESE CARRY WEIGHTS USED IN THE OPTIMIZATION PROCESS

//------------------------
MatrixXd W1;
W1.resize(v*m,v*m);
W1.setZero();

MatrixXd Im;
Im= MatrixXd::Identity(m,m);

for (int i=0; i<v;i++)
{
  if (i==0)
  {
     W1(seq(i*m,(i+1)*m-1),seq(i*m,(i+1)*m-1))=Im;
  }
  else
  {
     W1(seq(i*m,(i+1)*m-1),seq(i*m,(i+1)*m-1))=Im;
     W1(seq(i*m,(i+1)*m-1),seq((i-1)*m,(i)*m-1))=-Im;
  }

}
//---------------------

//------------------
double Q0=0.0000000011;
double Qother=0.0001;

MatrixXd W2;
W2.resize(v*m,v*m);
W2.setZero();

for (int i=0; i<v; i++)
{
  if (i==0)
  {
    // this is for multivariable
    //W2(seq(i*m,(i+1)*m-1),seq(i*m,(i+1)*m-1))=Q0;

    W2(i*m,i*m)=Q0;
  }
  else
  {
    // this is for multivariable
    //W2(seq(i*m,(i+1)*m-1),seq(i*m,(i+1)*m-1))=Qother;
    W2(i*m,i*m)=Qother;

  }
        


}

//------------------


//--------------
MatrixXd W3;
W3=(W1.transpose())*W2*W1;
//-----------------


//---------------
MatrixXd W4;
W4.resize(f*r,f*r);
W4.setZero();

// # in the general case, this constant should be a matrix
double predWeight=10;

for (int i=0; i<f;i++)
{
   //this is for multivariable
  //W4(seq(i*r,(i+1)*r-1),seq(i*r,(i+1)*r-1))=predWeight;
  W4(i*r,i*r)=predWeight;
}
//--------------

//desired trajectroY-------------------
unsigned int timesteps=300;

MatrixXd traj;
traj.resize(timesteps,1);
traj.setZero();

MatrixXd tmp1;
tmp1=MatrixXd::Ones(100,1);

traj(seq(0,100-1),all)=tmp1;
traj(seq(200,timesteps-1),all)=tmp1;


//RUN THE THING
MPC mpc(A, B, C, 
f, v,W3,W4,x0,traj);

//control loop
for(int i=0;i<timesteps-f-1;i++){
    mpc.PropagateAndCompute();
}

mpc.saveData("trajectory.csv", "computedInputs.csv", 
                            "states.csv", "outputs.csv","Omatrix.csv","Mmatrix.csv");

cout<<"DONE"<<endl;
return 0;



}