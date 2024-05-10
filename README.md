# Release notes

## 우선 순위
- search 구현하기


## todo
- 와이어프레임 변경된 점 수정하기
- 이전에 프로젝트 진행 계획 가져오기 (트렐로)
- commit 번호를 링크로 달기
- 카테고리 내에 crud 위젯으로 분리하기
- 메모 생성 기능 개선하기(입력칸 늘리기: add 메모(maxLines: 6))
- 작성된 메모는 최신 순으로 정렬하여 UI에 나타내기 
- 추후: 홈페이지에 흐릿하게 움직이는 배경 넣기


## 2024-05-11
### Features
- 하단 navigation bar 구현하기 (curved_navigation_bar: ^1.0.3)
- drawer 내부 요소 변경 (메든 메모, 달력, 휴지통, 범주, 백업은 하단 navigation bar에 등록함으로 기존 요소에서 제거 )
- (ing) 범주 페이지 하단에 navigation bar 만들기
- (ing) 달력 페이지 하단에 navigation bar 만들기
- (ing) 하단 요소 누르면 페이지 이동하는 기능 구현하기
- (ing) drawer 없애고, 안에 남은 3가지 기능은 상단 우측 settings에 넣기
- (ing) search icon 클릭 시, 상단에 검색창 띄우고, 검색어 누르면, 범주 2행은 놔두고 그 밑에 메모장만 관련된 검색 내용 나타내기


## 2024-05-09~10
### Features
- 선택한 날짜에 작성한 메모가 있다면 날짜 바로 밑에 분홍색 마킹하고 개수 나타내기
### Bug Fixes
- 선택한 날짜에 작성한 메모를 출력하지 못함  


## 2024-05-08
### Features
- 달력 구현(날짜 선택하면 선택한 날짜에 생성한 메모 하단에 리스트로 나타내기)
- 선택한 날짜에 작성한 메모가 있다면 그 날짜에 작성한 모든 메모를 나타내기


## 2024-05-07
### Features
- 범주명 '모두', '미분류' 만들고, 홈페이지와 범주페이지에서 구현하기
- 범주 페이지에 '모든', '미분류' 범주 개수 나타내기 
- 달력 구현 (기본 달력 및 스타일 지정)


## 2024-05-06
### Features
- 홈페이지에 범주 클릭하면, 관련된 범주를 가지고 있는 메모만 화면에 나타내기 
### Bug Fixes
- 6개 이상의 메모를 화면에 나타내지 않는다. (범주 선택하도 동일한 에러)


## 2024-05-05
### Features 
- 메모 생성 시, 선택한 범주 저장하고, 업데이트 시, 해당 범주 나타내기


## 2024-05-03~04
### Features
- 범주 중복 생성 불가한 기능 구현
- 업데이트 시, 중복된 범주로 변경 불가 구현
- 홈페이지 상단 UI에 범주를 나타내기


## 1.0.0 (2024-05-02)
### Features
- mvc의 controller 폴더 생성
- 범주는 null값이 저장되지 않도록 설정
- 범주: update 구현
### Bug Fixes
- 이전에 입력한 null 필드값을 제거하는 방법(type 'Null' is not a subtype of type 'String' in type cast)
- 범주 생성 페이지에서 범주 생성 후, 빈공백으로 재 생성하면 이전과 같은 내용으로 재생성 되는 오류 (category.dart)
- 'initialValue == null || controller == null': is not true (TextFormField에 TextEditingController를 추가할때 initialValue와 controller 둘 중 하나만 사용해야 한다)

