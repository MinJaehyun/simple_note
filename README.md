# Release notes

## todo: 우선 중요하면서 긴급하면서 간단한 것을 처리하자!
- 프로젝트 마무리 전: const 설정
- 프로젝트 마무리 전: var, dynamic, nullable(?) 변수의 타입 정확히 기입하기 및 불필요한 변수 제거
- 11: (어려움) 달력 초기 진입 시, 생성된 날짜에 메모 즉시 나타내기
- 11: 태그 기능
- 11: 달력: 일정에 시간 기능 구현
- 11: 메모: 입력창 더보기 
- 10: 범주: crud 위젯 분리 (현재 변경되는 코드가 많아서 막바지에 작업하기)
- 10: add_memo 와 update_memo는 동일한 코드가 존재한다. 리텍토링 할건지? (2개 이상은 아니다)
- 10: figma: 와이어프레임 동기화
- 5: 즐겨찾기 (메모 상단 우측 별)
- 5: 설정: 팝업창 내에 시간 설정 팝업창 내에 2024.05.14를 2024년05월14일 2:26:30AM처럼 여러 종류의 날짜 설정하는 기능 
- 5: 설정: 글꼴 선택 기능, 스킨 선택 기능, 줄 노트 표시 기능 (줄 노트는 메모가 작성 완료된 보기 상태에서만 나타나고, 변경 작업 중에는 나타내지 않는다)
경- 광고 넣기, - 광고 넣고 바로 어플 등록 진행 할건지? (검색하기)
- (ing) ? 설정 페이지에 정렬 기능, 다크 모드 기능 담기
- (ing) 모든 페이지에 기능 구현되어 있는지부터 확인하기


## 2024-05-25
### Features
-


## 2024-05-24
### Features
- (2/2) 범주 및 메모(***): 범주 삭제 시, 해당 범주 내에 메모들의 범주를 '미분류'로 지정되어 메모장에 남기기
- 범주 및 메모: 범주 업데이트 시, 해당 범주 내에 메모들의 범주를 '업데이트된 이름'으로 지정되어 메모장에 남기기
- 범주: add, update, delete 기능을 함수형 위젯으로 분리
- 범주: listTile Reorder 기능 구현(임시 완료)
- box.save() 사용하기 위해 memo model에 extends HiveObject 설정
- getx 설정 및 settings 에 snackbar 추가
### Bug Fixes
- ReorderableListView 내에 ListView.builder 사용할 수 없으므로 코드 수정 - setState() callback argument returned a Future. 에러 발생하나 데이터 crud 가능한 상태이며 앱 사용에는 문제가 없긴 하다.


## 2024-05-23
### Features
- (1/2) 범주 및 메모(***): 범주 삭제 시, 해당 범주 내에 메모들의 범주를 '미분류'로 지정되어 메모장에 남기기
- const 설정
- var, dynamic, nullable 변수의 타입 정확히 기입하기 및 불필요한 변수 제거
- 메모: add_memo 에서 범주 생성 누르면 페이지로 이동하는게 아닌, 생성 팝업 띄우기
- 메모: update_memo 에서 범주 생성 누르면 페이지로 이동하는게 아닌, 생성 팝업 띄우기
- 휴지통: update_trash_can_memo 에서 범주 생성 누르면 페이지로 이동하는게 아닌, 생성 팝업 띄우기
### Bug Fixes
- 범주: 수정 누르면 해당 범주의 메모들의 범주가 변경되지 않는다. (그대로 있다)


## 2024-05-22
### Features
- 폴더 구조 명칭 개선
- 범주 삭제 문구 기능 구현
### Bug Fixes
- 범주: 미분류 개수 오류 


## 2024-05-21
### Features
- (2/2) 검색창 구현 완료
- 코드 개선: control_statements.dart 내에 5가지 분기문을 3가지로 개선함
- 카드 내에 수정/삭제 팝업 버튼 중복 코드 리펙토링
- (정보)선택한 카테고리가 없으면(null이면), '모든' 에 담긴다
- '모든'와 '미분류'의 카드 양식이 다른점 개선하기
- 휴지통: x 가세표 구현
- 메모:  x 가세표 구현
### Bug Fixes
- update_trash_can_memo: 메모 복원 시, 설정한 카테고리로 이동한다


## 2024-05-20
### Features
- 달력: 사용하지 않는 타이머 삭제하고 작성된 시간으로 나타내기
- 메모: 카드 메뉴 제목과 라인 맞추기
- 메모: 카드 시간 최하단에 위치 시키기
- 메모: 정렬 버튼 기능 개선
- 공통: 시간 나타내는 부분 통일하기
- 공통: 내용 입력창 1줄만 나타낸다 -> update 시에는 여러줄로 나타내기 위해 입력값이 없으면 null 설정하고, 입력값이 있으면 100라인 설정
- 휴지통 페이지 구현: 메모 삭제 시, 휴지통에 들어가기 (휴지통에 내용은 완전히 삭제될 수 있다)
- 휴지통 페이지 구성: (상단: (~~simple note~~, ~~정렬~~ ), ~~중단-1: (1/2) 검색창, ~~중단-2: 모든 메모~~, ~~하단: 네비게이션바~~)
- ~~쇼핑 범주에 담는 메모를 삭제하면, 휴지통에 담긴 메모에는 쇼핑 범주가 그대로 담겨있다. 그런데 쇼핑 범주를 삭제하면 관련된 모든 메모(휴지통 포함)는 미분류 로 정해져야 한다. 범주를 삭제 시, "관련 범주 안에 모든 메모는 미분류로 지정 됩니다" 문구 나타내기~~


## 2024-05-19
### Features
- (ing 2/2) Google login 및 Google Cloud drive 에 내 기기 데이터 백업 - 파일 경로 지정하는 부분에서 에러 발생
- 새로운 Flutter 프로젝트(flutter_firebase_hive_) 만들고, - firebase 와 hive 연동하여 데이터 저장 및 가져오는 과정 테스트 하여 데이터 연동하기 - 위 이론 정리하고나서 프로젝트 진행하기


## 2024-05-18
### Features
- 해제된 controller 는 dispose 하여 리소스 낭비 막기
- 모든 페이지 공통: 다크 모드 구현
- (ing 1/2) Google drive 와 내 기기에 데이터 백업 ㅡ 하려는게 google drive 동기화가 맞는지?


## 2024-05-17
### Features
- 팝업 삭제 질문 추가
- add_memo: 스크롤 구현
- update_memo: 스크롤 구현


## 2024-05-16
### Features
- (2/2) 메모: 정렬 구현
- 달력: 하단 메모 UI 만들 및 수정/삭제 기능 연동
- 달력: 메모에 시작 시간, 종료 시간을 나타내기 위해 memo model 수정 
### Bug Fixes
- 모델: positional parameter, named parameter, optional 설정 수정
- 메모: 수정 버튼을 누르면 되는데, 카드 자체를 누르면 모든 메모장 내용이 마지막 내용을 나타내고 있다


## 2024-05-15
### Features 
- 검색창 디자인 개선 및 전체 부분적으로 디자인 개선
- (정보) 엡데이트 메모의 시간은 변경할 수 없다는 원칙으로 한다
- (1/2) 메모: 정렬 구현 


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