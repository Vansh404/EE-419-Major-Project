from keras.datasets import mnist
import numpy as np
from keras.utils import to_categorical
from keras.models import Sequential
from keras.layers import Dense,Flatten

(X_train, y_train), (X_test, y_test) = mnist.load_data()

x_train1=X_train.reshape(-1,28,28,1)/255.0
x_test1=X_test.reshape(-1,28,28,1)/255
y_train1=to_categorical(y_train,num_classes=10)
y_test1=to_categorical(y_test,num_classes=10)

#----
model=Sequential([
    Flatten(input_shape=(28,28,1)),
    Dense(128,activation='relu'),
    Dense(64,activation='relu'),
    Dense(10,activation='softmax'),
    ])
model.compile(optimizer='adam',loss='categorical_crossentropy',metrics=['accuracy'])


model.fit(x_train1,y_train1,epochs=10,batch_size=32,validation_split=0.2)

test_loss, test_accuracy = model.evaluate(x_test1, y_test1)
print(f"Test accuracy: {test_accuracy}")