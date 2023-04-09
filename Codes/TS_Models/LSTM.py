#라이브러리들
import tensorflow as tf
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd

#데이터 로드
path = "/Users/reign/Downloads/store-sales-time-series-forecasting/"

oil = pd.read_csv(path + 'oil.csv')
trans = pd.read_csv(path + 'transactions.csv')
train = pd.read_csv(path + 'train.csv')
test = pd.read_csv(path + 'test.csv')

#전처리
ts1 = train.copy()
ts2 = oil.copy()
ts1['date'] = pd.to_datetime(ts1['date'])
ts2['date'] = pd.to_datetime(ts2['date'])

def group(df, key, freq, col):
    df_grouped = df.groupby([pd.Grouper(key=key, freq=freq)]).agg(sales_mean = (col, 'mean'))
    df_grouped = df_grouped.reset_index() #date를 인덱스가 아닌 컬럼으로 지정
    return df_grouped

ts1_d = group(ts1, 'date', 'd', 'sales')

def group2(df, key, freq, col):
    df_grouped = df.groupby([pd.Grouper(key=key, freq=freq)]).agg(mean_oil = (col, 'mean'))
    df_grouped = df_grouped.reset_index() #date를 인덱스가 아닌 컬럼으로 지정
    return df_grouped

ts2_d = group2(ts2, 'date', 'd', 'dcoilwtico')
ts2_d = ts2_d.iloc[:1688,]

ts_conc = pd.merge(ts1_d,ts2_d,on='date', how='inner')
ts_conc.dropna(inplace=True) #결측치 제거

########################
## Univariate ##

# one - step forecasting

ts_conc.shape #데이터 살펴볼 때 꼭 timestamp에 따라 나눠보는 습관을 가져라! ex)1년 365일, 

#셋 나누기
TRAIN_SPLIT = 1130 ## 명심해! 이건 윈도우 사이즈가 아니라 학습데이터 전체 크기를 말하는 것이야 about 1130 days
tf.random.set_seed(13) ## 아무거나 집어넣어

# Standardization
uni_data = uni_data.values
uni_train_mean = uni_data[:TRAIN_SPLIT].mean()
uni_train_std = uni_data[:TRAIN_SPLIT].std()
uni_data = (uni_data - uni_train_mean) / uni_train_std  # Standardization

print(uni_data)

#### 매우 중요! 슬라이스 윈도잉

#과거를 얼마만큼 볼 것인지, 얼마만큼의 미래를 예측할 것인지. 즉, 윈도우 사이즈와 타겟사이즈를 잘 정해야 한다.

# Define a specific window for training Neural Network 
def univariate_data(dataset, start_index, end_index, history_size, target_size):
    data = []
    labels = []
                                            #이해를 돕기위해...만약 history_size, 즉, 윈도우 크기가 10이라면?
    start_index = start_index + history_size #start index가 10이 된다. 
    if end_index is None: #end index는 학습 데이터의 마지막이다. (앞에서 지정해준만큼)
        end_index = len(dataset) - target_size #엔드 인덱스가 없다면, 전체 크기에서 타겟을 뺀 만큼이 엔드 인덱스다. (val_dataset을 위함)
    
    #슬라이딩 윈도우 만들기!!
    for i in range(start_index, end_index): #i가 start_index의 처음인 10이었다면?
        indices = range(i - history_size, i) #indices = range(0,10) which is 0,1,2,3,4,5,6,7,8,9
        # Reshape data from (history_size,) to (history_size, 1)
        data.append(np.reshape(dataset[indices], (history_size, 1))) #3D tensor 형태로 인풋 변환해주기 (batch,row,column(dim))
        labels.append(dataset[i+target_size]) #label = i(10) + 0
    return np.array(data), np.array(labels)


univariate_past_history = 10 #윈도우 크기 10으로 지정
univariate_future_target = 0 #future step 1

## univariate_data 함수 이용
x_train_uni, y_train_uni = univariate_data(uni_data, 0, TRAIN_SPLIT,
                                         univariate_past_history,
                                         univariate_future_target)
x_val_uni, y_val_uni = univariate_data(uni_data, TRAIN_SPLIT, None,
                                     univariate_past_history,
                                     univariate_future_target)

print('Single window of past history')
print(x_train_uni[0]) #3차원 텐서
print('\n Target temperature to predict')
print(y_train_uni[0]) #1차원 텐서 aka 벡터


## Simple LSTM 모델링

BATCH_SIZE = 20 #개수
BUFFER_SIZE = 100 #뒤에 쌓아두겠다 효율성 (쉽게 꺼내서 쓸 수 있도록 메모리에 얼마만큼 쌓아둘지 정하는 것이다.)

#단순 LSTM의 최종 인풋 형태
train_univariate = tf.data.Dataset.from_tensor_slices((x_train_uni, y_train_uni))
train_univariate = train_univariate.cache().batch(BATCH_SIZE).repeat()

val_univariate = tf.data.Dataset.from_tensor_slices((x_val_uni, y_val_uni))
val_univariate = val_univariate.batch(BATCH_SIZE).repeat()

#아키테처 구성
simple_lstm_model = tf.keras.models.Sequential([
    tf.keras.layers.LSTM(10, input_shape=np.array(x_train_uni).shape[-2:]), #인풋 shape 주목 (10,1)
    tf.keras.layers.Dense(1)
])

simple_lstm_model.compile(optimizer='adam', loss='mse')

#피팅
EVALUATION_INTERVAL = 300
EPOCHS = 10

simple_lstm_model.fit(train_univariate, epochs=EPOCHS,
                      steps_per_epoch=EVALUATION_INTERVAL,
                      validation_data=val_univariate, validation_steps=50)