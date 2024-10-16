#ifndef mpc_h
#define mpc_h

#include<string>
#include<Eigen/Dense>
using namespace std;
using namespace Eigen;

class MPC{
    public:
        //Index
        // A,B,C are matrices from the state space description
        // f is the PREDICTION Horizon
        // v is the CONTROL HORIZON
        // w3 is a matrix used in computing the penalty function for subsequent control inputs
        // w4 is a diagonal matrix  used in computing the penalty in tracking
        // x0 are the intial states
        // trajDesired is the desired input trajectory
        MPC(MatrixXd Ai,MatrixXd Bi,MatrixXd Ci,
            unsigned int fi, unsigned int vi,MatrixXd w3i,
            MatrixXd w4i, MatrixXd x0i,MatrixXd trajDesiredi);
        //------------**-------- Propagate dynamics and compute optimal control inputs using this method!
        void PropagateAndCompute();



        /*INDEX-----
        SAVES sim data to an output file
        O,M are funky matrices representing our system
        O=[CA CA^2 CA^3 ...CA^f]
        M=translates control inputs to outputs
        M=CB 0 0 0 0.....0
          CAB CB 0 0 ....0
          CA2B CAB CB 0 ...0
        */
        void MPC::saveData(string desiredTrajf, string inputsf, string statesf, string outputsf, string Of, string Mf) const;
        
    private:
        unsigned int k; //time keeper
        
        /*m-input vector dim
        n-state vector dim
        r-output dim*/
        unsigned int m,n,r;

        MatrixXd A,B,C,Q;
        MatrixXd w3,w4;
        MatrixXd x0;
        MatrixXd trajDesired;
        unsigned int f,v;
        MatrixXd states;
        MatrixXd inputs;
        MatrixXd outputs;
        MatrixXd O;
        MatrixXd M;

        //u=gainMatrix*s
        MatrixXd gainMatrix;
        
        
    
    



};



#endif