from keras.utils import Sequence
from keras.models import Sequential
from tensorflow.keras import layers
from keras.layers import Dense, Dropout, Flatten, LSTM, Embedding
from keras.optimizers import RMSprop,Adam
import keras.backend as K

#모델 정의 예시

#model = Sequential()
#model.add(Embedding(input_length=input_dim))
#model.add(LSTM(units=8, activation = 'relu', input_shape=(1, input_dim)))
#model.add(LSTM(units=8, activation = 'relu', input_shape=(1, input_dim)))
#model.add(LSTM(units=64, activation = 'relu'))
#model.add(Dense(128, activation='relu', input_dim=input_dim))
#model.add(Dense(256, activation='relu'))
#model.add(Dense(512, activation='relu'))
#model.add(Dense(1, activation='relu')) # regression
