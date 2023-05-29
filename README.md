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
|디자인패턴|coordinator, mvvm, mvc|
|아키텍처|클린 아키텍처|

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

## 프로젝트 진행중 겪었던 문제

### [UILabel BaseLine 문제](https://sandclock-itblog.tistory.com/163)
