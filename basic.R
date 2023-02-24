install.packages('forecast')
install.packages('TSA')
library(forecast)
library(TSA)

##time-series set 만들기

ts(1:10, frequency = 4, start=c(2021, 2)) #frequency는 분기점, start는 시작점 지정

dd <- matrix( c(1342, 1442, 1252, 1343, 	
                1425, 1362, 1256, 1272,
                1243, 1359, 1412, 1253,					
                1201, 1478, 1322, 1406,
                1254, 1289, 1497, 1208))
dd.ts <- ts(data=dd, start=c(2016, 1), frequency=4) #start대신 s, frequency대신 f 가능
dd.ts        

##시계열 특성들

#1. 우연변동 시계열
random1 = matrix( c(1342, 1442, 1252, 1343, 	
                    1425, 1362, 1256, 1272,                  
                    1243, 1359, 1412, 1253,					
                    1201, 1478, 1322, 1406,
                    1254, 1289, 1497, 1208) )

random1.ts = ts(data=random1, start=c(2016, 1), frequency = 4)
random1.ts
plot(random1.ts, main = 'Random Variation Time Series') #말 그대로 랜덤,우연한 변동을 보임

#2. 계절변동 시계열 (seasonality = 계절) # = 주기성 = 계절성
season1.ts <- ts(data=season1 <- matrix(c(1142, 1242, 1452, 1543, 
                                          1125, 1262, 1456, 1572, 
                                          1143, 1269, 1462, 1553, 
                                          1121, 1258, 1472, 1546, 
                                          1154, 1249, 1477, 1548)), s=c(2016, 1), f=4)
season1.ts
plot(season1.ts, main = 'Seasonal Variation Time Series') #보통 일년동안의 변동을 뜻한다.

#3. 추세변동 시계열
trend1.ts <- ts(trend1 <- c(1142, 1242, 1252, 1343, 
                            1225, 1562, 1356, 1572, 
                            1343, 1459, 1412, 1453, 
                            1401, 1478, 1322, 1606, 
                            1554, 1589, 1597, 1408), c(2016, 1), f=4)
plot(trend1.ts, main = 'Trend Variation Time Series')  #최저점을 보고 큰 변화를 본다.

#4. 계절적 추세변동 시계열
st1.ts <- ts(data = st1 <- c(1142, 1242, 1452, 1543, 
                             1225, 1362, 1556, 1672, 
                             1343, 1459, 1662, 1753, 
                             1421, 1558, 1772, 1846, 
                             1554, 1649, 1877, 1948), c(2016, 1), f=4)
plot(st1.ts, main = 'Seasonal-Trend Variation Time Series') #계절변동 + 추세변동

par(mfrow = c(2,2))
plot(random1.ts, main = 'Random Variation Time Series')
plot(season1.ts, main = 'Seasonal Variation Time Series')
plot(trend1.ts, main = 'Trend Variation Time Series')
plot(st1.ts, main = 'Seasonal-Trend Variation Time Series')


#monthplot, 특정 시점만 잘라서 그 변화를 볼 수 있다.
monthplot(random1.ts, main="EDA: Random Variation Series", xlab="Quarter: 2016-2020", ylab="Sales") # 분기별로 모은 값 
monthplot(trend1.ts, main="EDA: Trend Variation Series", xlab="Quarter: 2016-2020", ylab="Sales") # 횡으로 그려진 직선은 평균값

#가장 유명한 데이터. 항공수요
data(airpass)
plot(airpass, main = 'Air Passengers -- Seasonal Adjustment')


## 데이터 다루기 

#차분
dd.ts
diff(dd.ts, 1)
plot(diff(dd.ts, 2))
diff(dd.ts, 1, 2) #diff(data, 차분 수(얼마나 이전), 반복 수)

#역차분
diffinv(dd.ts)

#주기 확인
cycle(dd.ts)
cycle(lag(dd.ts, k=2)) #2만큼 뒤로

prod1 <- ts(matrix(1:24, 8, 3), s=c(2019, 1), f=4, names=c("web", "app", "hyb"))
prod1

prod2 <- ts(matrix(11:22, 4, 3), s=c(2020, 1), f=4, names=c("web", "app", "hyb"))
prod2

#합집합
ts.union(prod1,prod2)

#교집합
ts.intersect(prod1,prod2)

#부분 추출(윈도잉)
window(prod1, s=c(2020,3), delta=1#출력 개수)
window(prod1, c(2019,3), c(2020,3)) #시작, 끝 지정 가능

#통합(aggregation)
aggregate(prod1,
          #nf= 지정하면 시점 고려됨 f=4면 분기, f=2면 반기
          FUN=mean)

###################

##EDA

###################

#평활화, 추세 관찰

airpass

#1. 이동평균법
ma1 <- filter(airpass, filter=rep(1,3)/3)
ma1 <- filter(airpass, filter=rep(1/3,3)) #same

rep(1,3)/3
rep(1/3,3)

ma2 <- filter(airpass, filter=rep(1,6)/6)

ma1
ma2

plot(airpass)
plot(ma1)
plot(ma2) #moving한 스텝이 클 수록 평탄해진다

#필터링 (현재 상태변수의 값 추정)
ma3 = filter(airpass, filter=rep(1, 4)/4 #평활상수
             ,method="convolution" #이동평균, 
             sides=1 #과거값만 보겠다. 필터링의 사상
             )
ma3
plot(ma3)

#이중이동평균법
ma1
ma4 = filter(ma1, filter=rep(1, 3)/3, method="convolution" #이동평균
             ,sides=1 #과거값만 보겠다. 필터링의 사상
)
ma4
plot(ma4)

#가중이동평균법
w1 <- c(0.4, 0.3, 0.2, 0.1) # 평활상수 filter = (0.4, 0.3, 0.2, 0.1) #가중치 지정해주기
ff <- filter(airpass, filter=w1, method="convolution", sides=1) 
ff

#잔차 비교해보기
res1 = ma4 - airpass
res2 = ff - airpass
res2


#예측
#install.packages('forecast')
library(forecast)

f1 = forecast(ff, h=2)
f1

#요소분해
air2 = decompose(airpass,type = "additive") #additive, 가법모형
air2$seasonal
air2$trend
air2$random

#시각화
plot(air2)

#효과적인 요소분해인지 검정. 랜덤변동에 어떠한 추세나 계절변동이 없어야 함
library(tseries)
kpss.test(air2$random) #정상성 검정 H0:정상시계열이다. H1:정상시계열이 아니다.
Box.test(air2$random) #독립성 검정 H0:독립적이다. H1: 독립적이지 않다.
plot(air2$random)


