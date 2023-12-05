# Runcord

## 프로젝트 소개
Runcord는 러닝 도중에 찍고 싶은 사진을 찍고
러닝 기록을 저장해, 그 기록과 찍은 사진을 함께 보여주는 앱입니다.

## 개발 환경 및 기술 스택

|목적|기술 스택|
|------|---|
|최소 버전|15.0|
|로컬 저장소|Core Data|
|화면 프레임워크|UIKit|
|지도|MKMapView|
|디자인패턴|coordinator, 싱글톤 패턴 등등|
|아키텍처 패턴|클린 아키텍처, mvvm, mvc|

## 사용 라이브러리

|라이브러리|사용목적|
|------|---|
|RxSwift, RxCocoa|비동기 처리, viewmodel 바인딩|
|swinject|DI|

## 프로젝트 주 기능
얼마나 뛸지, 언제까지 뛸 지 목표를 정할 수 있어요.<br>

<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/e8d758e5-37f1-42aa-b9dc-cf67c5461b55" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/d5e8930b-8edf-4827-9958-19206a028f63" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/d30ef40e-d6f7-4cca-87d9-a40de38186dc" width="200" height="433">

<br><br>

러닝을 하면서 사진을 찍어서 어디서 사진을 찍었는지 알 수 있어요.<br>
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/19e5abbb-388f-40e0-9add-0ad9825ad2e8" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/793162b4-a085-47a2-887d-aa3087bfb9fa" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/2d600309-68b2-4cae-8bbc-e7a917ac2e1d" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/c38f4973-1e5f-4e2a-9fa4-373901778d73" width="200" height="433">

<br><br>
저장한 러닝기록과 찍은 사진들을 한눈에 볼 수 있어요.<br>
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/ed62e51e-133b-4aad-927f-1372b3d8b551" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/9b7a94cb-7969-473a-943e-51c8b84f6b62" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/06e06ee4-fe68-44d7-bce2-cb79c7d1e928" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/5304a848-5f11-4e1c-8ebc-9542fdc63337" width="200" height="433">

## 아키텍처

### 클린 아키텍처
![Runcord 아키텍처](https://github.com/Kim-Junhwan/Runcord/assets/58679737/729973bf-d4d3-4af7-ab38-6685e6bd9575)
- Data 계층: 로컬 DB에서 데이터를 CRUD하는 책임을 가지고 있습니다. Repository를 구현한 객체를 가지고 있으며, DB에서 직접 데이터를 가져오는 책임을 가지고 있는 객체를 가지고 있습니다.
- Domain 계층: 앱의 비즈니스 로직을 담당합니다. 해당 프로젝트의 경우에는 러닝 기록을 DB에서 CREATE, READ, DELETE 하는것이 주 로직입니다. UseCase, Repository Protocol, Entity를 가지고 있습니다.
- Presentation 계층: UI 로직 관련 책임을 가지고 있습니다.

# 트러블 슈팅 및 

## [UILabel BaseLine 문제](https://sandclock-itblog.tistory.com/163)

## 위치가 튀는 문제

기존 러닝 경로, 현재 사용자의 평균 속도, 달린 거리를 측정하는 방식은 CLLocationManager의 위치 데이터를 통해 계산하는 방식으로 구현.
하지만 GPS 정확도가 떨어지거나 현재 위치가 막 움직이는 경우 좌표가 갑자기 크게 움직여서 가만히 있는데도 경로가 마구 그려지거나, 달린 속도와 거리가 튀는 문제가 발생

<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/4842d0c6-fdc1-473b-80f0-615f1f912f2f" width="200">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/85be4547-0a86-481c-9b6e-057cb47680cf" width="200">

이 문제를 해결하기 위해 CoreMotion의 CMPedoMeter과 CMMotionActivity를 이용하여 해결함. CMMotionActivity를 이용하여 사용자가 현재 정지 상태인지, 이동중인 상태인지를 값을 전달해서 이동중인 상태에서만 러닝 데이터 업데이트를 수행하도록 변경. CMPedoMeter를 이용해서 사용자의 평균 속도, 이동 거리를 업데이트 하는 방식으로 변경

## 장시간 러닝시 과도한 리소스 사용 문제

러닝을 3시간 정도 한 결과 (시뮬레이터 cityRun 기준) 리소스가 다음과 같이 과도하게 많이 사용됨을 확인.
- CPU 사용량: 297,438%
- 메모리 사용량: 1.68GB 
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/db15c89a-8154-4294-8b38-b5accb1d620a" width="400">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/c08a5b0c-961f-47c3-9ee1-1c0eab09ffd9" width="400" >
<br>
매초마다 위치에 관한 데이터가 쌓이므로 이로 인해 메모리가 과도하게 사용되는 것으로 처음엔 생각했으나 계산을 해보니 172.8KB (10800(3시간을 초로 변경) * 16바이트(위경도 Double 타입 크기))의 메모리 공간만 차지하므로 다른 곳에 문제가 있을 것으로 판단하고 기존 경로를 그리는 방식에 변경을 줌. 

### 기존 방식
새로운 위치를 받을때마다 마지막으로 받은 위치 데이터와 받은 위치데이터를 이용하여 새로운 MKPolyline을 생성하여 경로를 그리는 방식

### 개선한 방식
새로운 위치를 받으면 기존 MKPolyline 객체 삭제, 새로운 MKPolyline이 현재 받은 모든 경로가져서 지도상에 표시. 하나의 MKPolyline만을 이용하는 방식으로 개선

### 결과
개선하기 전보다 3배 더 긴 시간을(9시간)을 러닝을 해도 리소스 사용량이 안정적
- CPU 사용량: 9%
- 메모리 사용량: 285MB
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/0e819499-5e91-4da6-a806-ca39ce865849" width="500">
<img src = "https://github.com/Kim-Junhwan/Runcord/assets/58679737/dfc2b23d-1c13-4304-a149-27b4b5246217" width="500">

