# Time-series
A collection of time series analysis exercises

1. 시계열의 기본 개념들

시계열 자료: 어떠한 대상을 여러 시점에서 관찰한 일련의 기록, 종단 자료

- 자기상관에서 자유롭기 어렵다.

- 시간, 시점들 사이 관계를 통해 미래를 예측하는 Forecasting이 주된 목적이다.

시계열의 주요 번동 4 가지

랜덤(무작위), 계절, 추세, 계절추세

![image](https://user-images.githubusercontent.com/121419113/220830229-db1df6eb-9c85-4a4e-8e81-5520e3d79225.png)

시계열 다루기

- 차분: 직전의 값과의 차이를 구하여 장기적인 추세를 제거하고 "정상화"시킬 때 쓴다. 계절성을 제거할 때는 1년 단위로 차분하는 계절 차분이라고도 한다. (and 역차분, 윈도잉, 합/교집합 등 코드 참조)

- 평활화(smoothing): 

- 필터링:

- 요소분해:
