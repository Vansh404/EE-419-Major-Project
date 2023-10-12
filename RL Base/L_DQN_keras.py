from keras.layers import Dense, Activation
from keras.models import Sequential, load_model
from keras.optimizers import Adam
import numpy as np

#able to re-use this
class ReplayBuffer(object):
    def __init__(self,max_size,input_shape,n_actions,discrete=False):
        self.mem_size=max_size 
        self.mem_ctr=0
        self.input_shape=input_shape
        self.discrete=discrete
        self.state_memory=np.zeros((self.mem_size,input_shape))
        self.new_state_memory=np.zeros((self.mem_size,self.input_shape))
        dtype=np.int8 if self.discrete else np.float32#one hot encoding if discrete action space
        self.action_memory=np.zeros((self.mem_size,n_actions),dtype=dtype)
        self.reward_memory=np.zeros(self.mem_size)
        self.terminal_memory=np.zeros(self.mem_size,dtype=np.float32)# we dont want to take in the reward in the final state as it belongs to another episode

    def store_transition(self,state,action,reward,state_,done):
        index=self.mem_ctr % self.mem_size #keeps track of what mem array we on
        self.state_memory[index]=state
        self.next_state_memory[index]=state_
        
        self.reward_memory[index]=reward
        self.terminal_memory[index]=1 - int(done)
        if self.discrete:
            #one hot encoding for discrete action space
            actions=np.zeros(self.action_memory.shape[1])
            actions[action]=1
            self.action_memory[index]=actions
        else:
            self.action_memory[index]=action
        self.mem_ctr += 1

    def sample_batch(self,batch_size):
        max_mem=min(self.mem_ctr,self.mem_size)
        batch=np.random.choice(max_mem,batch_size)
        states=self.state_memory[batch]
        states_=self.new_state_memory[batch]
        rewards=self.reward_memory[batch]
        actions=self.action_memory[batch]
        terminal=self.terminal_memory[batch]

        return states,states_,rewards,actions,terminal

def DQN(lr,n_actions,input_dims,fc1_dims,fc2_dims):
    model=Sequential([
              Dense(fc1_dims,input_shape=(input_dims, )),
              Activation('relu'),
              Dense(fc2_dims),
              Activation('relu'),
              Dense(n_actions)])

    model.compile(optimizer=Adam(lr=lr),loss='mse')
    return model

class Agent(object):
    def __init__(self,alpha,gamma,n_actions,epsilon,batch_size,input_dims,epsilon_dec=0.996,epsilon_end=0.01,mem_size=1000000,fname='dqn_model.h5'):
        self.action_space=[i for i in range(n_actions)]
        #self.n_actions=n_actions
        self.gamma=gamma
        self.epsilon=epsilon
        #self.alpha=alpha
        self.epsilon_dec=epsilon_dec
        self.epsilon_end=epsilon_end
        self.batch_size=batch_size
        self.model_file=fname
        self.memory= ReplayBuffer(mem_size,input_dims,n_actions,discrete=True)
        self.q_eval=DQN(alpha,n_actions,input_dims,256,256)

    def rememeber(self,state,action,reward,new_state,done):
        self.memory.store_transition(state,action,reward,new_state,done)#doesnt work without this lmao

    def choose_action(self,state):
        state=state[np.newaxis, :]
        if np.random.random()<self.epsilon:
            action=np.random.choice(self.action_space)
        else:
            actions=self.q_eval.predict(state)#pass the state through the network, and get the value for all the actions for that state
            action=np.argmax(actions)#select the most valuable action
        return action
    
    #KEY FUNCTION
    def learn(self):
        if self.memory.mem_ctr < self.batch_size:
            return #wait for memeory to fill up till at least the batch size
        state,action,reward,new_state,done=self.memory.sample_batch(self.batch_size)
        #Convert back from 1 Hot
        action_values=np.array(self.action_space, dtype=np.int8)
        action_indices=np.dot(action,action_values)# Integer rep of actions

        q_eval=self.q_eval.predict(state)
        q_next=self.q_eval.predic(new_state)

        q_target=q_eval.copy()

        batch_index=np.arange(self.batch_size,dtype=np.int32)

        q_target[batch_index, action_indices] = reward+self.gamma*np.max(q_next,axis=1)*done

        _ = self.q_eval.fit(state,q_target,verbose=0) #loss computation with q target

        self.epsilon=self.epsilon-self.epsilon_dec \
                      if self.epsilon>self.epsilon_end else self.epsilon_end

    def save_model(self):
        self.q_eval.save(self.model_file)

    def load_model(self):
        self.q_eval=load_model(self.model_file)









