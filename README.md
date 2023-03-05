# Time-Series
A collection of time series analysis exercises

자격시험을 준비하면서 혹은 시계열 분석관련 강의들을 통해 배운 내용을 정리해둔 곳입니다.

## <b>1. 시계열의 기본 개념들</b>

시계열 자료: 어떠한 대상을 여러 시점에서 관찰한 일련의 기록, 종단 자료

- 자기상관에서 자유롭지 않다. 시계열, 종단면 데이터에서 어떠한 관측치는 독립적이지 않고 같은 확률분포를 가졌다고도 볼 수 없다.

- 시간, 시점들 사이 관계를 통해 미래를 예측하는 Forecasting이 주된 목적이다.

시계열의 주요 번동 4 가지

랜덤(무작위), 계절, 추세, 계절추세(복합) 변동
<div align="center">
<img src = "https://user-images.githubusercontent.com/121419113/220830229-db1df6eb-9c85-4a4e-8e81-5520e3d79225.png" width="700" height="500"/>
</div>
시계열 다루기

- 차분: 직전의 값과의 차이를 구하여 장기적인 추세를 제거하고 "정상화"시킬 때 쓴다. 계절성을 제거할 때는 1년 단위로 차분하는 계절 차분이라고도 한다. (and 역차분, 윈도잉, 합/교집합 등 코드 참조)

- 평활화(smoothing): 과거의 값을 다룰 때 주로 쓰는 기법. 주로 계절적이고 불규칙한 변동들을 제거한다. (by aggregating) 대표적인 방법으로 MA(이동평균기법), 지수평활법 등이 있다.

*여기서 과거의 관측치를 통해 현재의 상태를 추정할 떄 "필터링(Filtering)"이라고도 하고, 미래의 상태를 추정할 떄 "예측(Forecasting)"이라고 하기도 한다.

- 요소분해(decomposing): 어떠한 시계열을 랜덤, 계절, 추세 변동으로 분해한다. 이 때 중요한 것은 랜덤변동이 어떠한 다른 변동이 없는 "정상시계열"을 만족해야 한다는 것이다.




## <b>2. 모델링 </b>

조건: Stationary process

횡단면 데이터(한 시점의 cross sectional한 관측치)와 달리 시계열 데이터는 자기상관에서 자유로울 수 없다. 즉, 어떠한 관측치는 독립적이지 않으며 이전의 관측치에 영향을 받고 있다. (i.i.d 가정 불가능)

이에 bias를 줄이고 객관적인 예측을 하기 위해서 시계열로 구성된 데이터가 가지는 내재적인 패턴을 제거해야 한다.

정상시계열: 어떠한 데이터가 가지고 있는 특징들(추세, 계절, 순환 등)을 제거하여 랜덤화된 시계열을 말하는데, 시점에 따라 평균과 분산이 동일하여 같은 확률분포로써 예측이 가능하다.

*강정상성: 어떤 시점들간의 결합분포가 모두 동일하다.

*약정상성: 1. 어떤 시점에서든 기댓값이 같고 2. 분산이 무한대로 팽창하지 않으며 3. 시점간 공분산이 "시차"에만 의존한다. (약정상성만 충족시켜도 정상성을 가진다고 판단하는게 일반적이다.)
<div align="center">
<img src = "https://assaeunji.github.io/images/stationarity-stochasticprocess.png" width="500" height="300"/>
</div>


<br><br>시계열 데이터의 필수 모델링 과정: 정상성 체크 -> 정상성 처리(비정상 시계열인 경우) -> 정상성 검증(Test), 보통 ADF test를 진행한다. (H0: 비정상시계열이다.)
</br></br>

## <b> 2-1. 단변량 시계열 </b>
<br>
>> Case 1) 정상시계열일 때
</br>

<br>

- AR model

자기자신의 과거 값으로 선형 결합하여 변동을 설명하고 관심 있는 변수를 예측한다.

AR(p): p차 자기회귀 모형

y_t = c + Φ1 * y_t-1 + Φ2 * y_t-2 + ... + Φp * y_t-p + ε_t *ε_t는 잔차이자 백색소음
</br>
<br>
- MA model

평활화(smoothing) 기법을 적용한 모델로, 정상시계열인 백색소음을 평활화하여 남아있는 변동을 설명한다.

MA(q) : q차 이동평균 모형

y_t = c + Θ1 * ε_t-1 + Θ2 * ε_t-2 + ... + Θq * ε_t-q + ε_t
</br>
<br>
- ARMA model

AR + MA

p개의 자기 자신의 과거값과 q개의 과거 백색 잡음의 선형 결합
</br>

__________

<br>
>> Case 2) 비정상시계열일 때
</br>
<br>

- ARIMA model

ARMA모델에 차분의 개념이 포함된 모델. 즉, 비정상시계열을 먼저 정상시계열로 바꾼 뒤(by diffrencing) AR과 MA 모델을 결합한다.

ARIMA(p, d, q) : d차 차분한 데이터에 AR(p) 모형과 MA(q) 모형을 합친 모형

</br>

__________

<br>
>> ACF , PACF
</br>
<br><div align="center">
<img src = "https://user-images.githubusercontent.com/121419113/221362223-05284cac-847a-49bf-a0bc-f22e23dc3c05.png" width="800" height="200"/>
<br>
출처) 패스트캠퍼스
</br></br></div>

ACF에서 q결정(MA모델의 자기상관이 최소화되는 지점), PACF에서 p결정(AR모델의 자기상관이 최소화되는 지점)
<br>
## <b> 2-2. 다변량 시계열 </b>
</br>

<br>
1. VAR(벡터자기회귀, Vector AutoRegressive Model)

현실세계의 현상은 대부분 하나의 요인이 아닌 여러 요인에 의해 일어난다.

즉, 시간에 따라 변화하는 여러 현상들 또한 그 시계열 간의 상관관계가 존재한다.(독립적일 수가 없다.)

이에 벡터자기회귀(VAR)는 k개의 AR식, 여러 시계열을 벡터로 쌓아 현상을 예측한다.

단일 시계열 AR과 다른 점은 설명변수로 자기 자신의 lag뿐 아니라 다른 변수들의 lag도 포함한다는 것이다.
</br>
__________
<br>
2. 변동성 모형 (ARCH, GARCH)

대부분의 시계열 현상, 특히 사회과학에서 나타나는 현상은 등분산성을 충족하지 못한다.

즉, 시간이 흐를수록 그 변동 폭 또한 변화하는 것인데, 보통은 그 폭이 증가하는 추세를 보인다.

이러한 상황에서 특히 금융도메인에서는 변화하는 y값 이외에도 그 변동성까지 통제하고 관리해야 할 필요성을 가지기 마련이다.
</br>
+

- 조건부 분산

x 의 값을 알고 있을 때 이에 대한 조건부확률분포 p(y|x)의 분산

예측문제의 관점으로 보면 조건부분산은 예측의 불확실성를 의미하기도 한다.
<br>
<div align="center">
ARCH
<img src = "![image](https://user-images.githubusercontent.com/121419113/222966546-2adb78fd-1018-4383-9f28-762437fe3798.png)" width="500" height="500"/>
</div>
</br>

<br>
<div align="center">
GARCH
<img src = "![image](https://user-images.githubusercontent.com/121419113/222966601-bfd5b3da-f1c9-4ddc-98eb-ce0bd9fd450b.png)" width="500" height="500"/>
</div>
</br>

## <b>3. 딥러닝과 시계열</b>



