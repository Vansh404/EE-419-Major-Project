import gym
import numpy as np
import torch.nn as nn
import torch.optim as optim
import torch as T
import torch.nn.functional as F

#NETWORK CLASS
class linearDQN(nn.Module):
	def __init__(self,lr,n_actions,input_dims):
	 super(linearDQN,self).__init__()

	 self.fc1=nn.Linear(*input_dims,128)
	 self.fc2=nn.Linear(128,n_actions)

	 self.optimizer=optim.Adam(self.parameters(),lr=lr)
	 self.loss=nn.MSELoss()
	 self.device=T.device('cuda:0' if T.cuda.is_available() else 'cpu')
	 self.to(self.device)# Send the entire network to device
	 


	def forwardfunc(self,state):
		layer1=F.relu(self.fc1(state))
		actions=self.fc2(layer1)
		return actions


class Agent():
	def __init__(self,gamma=0.99,epsilon=1.00,epsilon_decay=1e-5,input_dims,n_actions,lr,min_epsilon=0.01)
	self.lr=lr
	self.gamma=gamma
	self.epsilon=epsilon
	self.epsilon_decay=epsilon_decay
    self.input_dims=input_dims
    self.n_actions=n_actions
    self.min_epsilon=min_epsilon
    self.action_space=[i for i in range(self.n_actions)]

    #Define the Q function with the neural network
    self.Q=linearDQN(self.lr,self.n_actions,self.input_dims)

    def choose_action(self,observation):
    	if np.random.random()>self.epsilon:
    		state = T.tensor(observation, dtype=T.float).to(self.Q.device)#Convert np array to cuda tensors
    		actions=self.Q.forward(state)
    		action=T.argmax(actions).item() #Choose the action with the max value and then de-parse it into a np array(from a torch tensor) using item()
        else:
        	action=np.random.choice(self.action_space)

        return action

    def decay_explore(self):
    	self.epsilon=self.epsilon-self.epsilon_decay \
    	              if self.epsilon>self.min_epsilon else self.min_epsilon

    def learn(state,action,reward,state_):
    	self.Q.optimizer.zero_grad()
    	state=T.tensor(state, dtype=T.float).to(self.Q.device)
    	actions=T.tensor(action).to(self.Q.device)
    	rewards=T.tensor(reward).to(self.Q.device)
    	states_=T.tensor(state_, dtype=T.float).to(self.Q.device)
    	