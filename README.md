# Release notes

## todo: 우선 중요하면서 긴급하면서 간단한 것을 처리하자!
- 3: 홈페이지에 흐릿하게 움직이는 배경이미지 넣기
- 4: 다크 모드
- 5: Goolge drive 와 내 기기에 데이터 백업 
- 5: 즐겨찾기 (메모 상단 우측 별)
- 5: 범주: crud 위젯 분리 (현재 변경되는 코드가 많아서 막바지에 작업하기)
- 5: figma: 와이어프레임 동기화 
- 5: (어려움) 달력 초기 진입 시, 생성된 날짜에 메모 즉시 나타내기
- 5: 설정: 팝업창 내에 시간 설정 팝업창 내에 2024.05.14를 2024년05월14일 2:26:30AM처럼 여러 종류의 날짜 설정하는 기능 
- 5: 설정: 글꼴 선택 기능, 스킨 선택 기능, 줄 노트 표시 기능 (줄 노트는 메모가 작성 완료된 보기 상태에서만 나타나고, 변경 작업 중에는 나타내지 않는다)
- 5: var 작성 변수 자세히 적기 (전체 검색)
- 메모: 입력창에 더보기 기능
- 메모: 스크롤 기능, 우측에 맨위, 맨아래 이동 버튼
- (ing) 태그 기능
- (ing) 테스트용 광고 추가하기
- (ing)


## 2024-05-15
### Features 
- 검색창 디자인 개선 및 전체 부분적으로 디자인 개선
- (정보) 엡데이트 메모의 시간은 변경할 수 없다는 원칙으로 한다
- (ing) 앱바(메모,달력): 정렬 - 상단에서 시간 가져오기..? 해당 자리에서 처리하면 되지 않나? 아니면 바로 위에서 처리하고 변수 내려주기?
- (ing) 달력: 작성한 순서 변경 하려면?
- (ing) 달력: 메모 리스트 개선 (디자인 및 기능 고민중)


## 2024-05-14
### Features
- auto focus 제거
- 메모: 시간 디자인 변경 (2024년05월14일 2:26:30AM => 2024.05.14)
- 메모: 제목, 내용 입력창 만들기 
- 메모: 제목 입력창 validation 구현 (한 글자 이상 안 들어가면 에러 문구 나타내기 / 앞에 공백 에러 문구 나타내기 / 색상, 에러 문구 추가)
- 메모: 취소 시, "변경 사항을 취소 하시습니까?" 이하에  "변경 취소" 와 "메모장 돌아가기" 팝업 띄우기
- 검색: highlight 기능 구현
- 메모: 날짜 개선 (2024년5월05일 => 2024.05.05)
- 메모: 업데이트 기능 개선
- 메모: 생성 시 범주 명칭을 '미분류'로 나타내기
### Bug Fixes
- 메모: mainText는 빈 문자열도 저장되도록 모델 수정
- 메모: 입력칸 늘리기(maxLines: 45) 
- 범주: RenderFlex overflowed 
- 메모장: IconButton 간격 줄이기 위해 패딩과 마진값을 제거
- 메모장: TextButton 간격 줄이기 위해 패딩과 마진값을 제거


## 2024-05-13
### Features
- 네비게이션바에 툴팁 설정
### Bug Fixes
- navigation bar 아이콘 걸친 영역 클릭하면 아이콘은 작동하지만, 페이지 띄우지 않는다
- 달력 초기 진입 시, 생성한 날짜에 모든 메모를 분홍 마킹으로 내타내야 한다


## 2024-05-12
### Features
- (2/2) search 구현(모든, 미분류, 범주 클릭하면 관련 내용을 하단에 나타내고, 검색한 내용을 제목이나 내용에서 포함하고 있으면 하단 UI에 나타내기) 


## 2024-05-11
### Features
- 하단 navigation bar 구현하기 (curved_navigation_bar: ^1.0.3)
- drawer 내부 요소 변경 (메든 메모, 달력, 휴지통, 범주, 백업은 하단 navigation bar에 등록함으로 기존 요소에서 제거 )
- 홈페이지 디자인 변경
- drawer 없애고, 안에 남은 3가지 기능은 상단 우측 settings에 넣기
- (1/2) search icon 클릭 시, 상단에 검색창 띄우고, 검색어 누르면, 범주 2행은 놔두고 그 밑에 메모장만 관련된 검색 내용 나타내기


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


## 2024-05-02
### Features
- mvc의 controller 폴더 생성
- 범주는 null값이 저장되지 않도록 설정
- 범주: update 구현
### Bug Fixes
- 이전에 입력한 null 필드값을 제거하는 방법(type 'Null' is not a subtype of type 'String' in type cast)
- 범주 생성 페이지에서 범주 생성 후, 빈공백으로 재 생성하면 이전과 같은 내용으로 재생성 되는 오류 (category.dart)
- 'initialValue == null || controller == null': is not true (TextFormField에 TextEditingController를 추가할때 initialValue와 controller 둘 중 하나만 사용해야 한다)


## 2024-04-15 ~ 2024-04-26
### Features
- https://trello.com/b/7wnL6hak/%EA%B0%80%EC%A0%9C-%EA%B0%84%EB%8B%A8-%EB%A9%94%EB%AA%A8%EC%9E%A5with-calendar