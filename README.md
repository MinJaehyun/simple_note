# Development notes

## 배포 후:
- figma: 와이어 프레임 업데이트
## 베포 전: 
- refactoring: const 적용
- refactoring: var, dynamic, nullable 변수 타입 상세히 명시 및 불필요한 변수 제거
## todo:
- 내부 테스터 모집하기 6월 24일 계정 등록하기(2명)
## Bug Fixes
- 추후: 휴지통: 전체 삭제: 한번 클릭 시 반영되지 않는다.. 2번째는 된다
- 추후: 달력: 메모 추가 시, A RenderFlex overflowed by 220 pixels on the bottom


## 2024-06-22
### Features
- 모든 범주와, 그외 선택한 범주와, 검색창에 입력한 내용에서의, 정렬 및 즐겨 찾기 기능 구현


## 2024-06-21
### Features
- 코드 개선 


## 2024-06-20
### Features
- 범주: 범주 생성하거나 변경 시, 중복 범주로는 변경하지 못하게 설정함
- 범주: 범주 삭제 시, 메모에 설정된 즐겨찾기와 체크 상태가 제거되는 오류 해결함
- 코드 개선


## 2024-06-19
### Features
- (2/2) 개선: 코드 정리
- category 진행하기 (widget 포함)
- Get route 설정 및 색상, 폰트 설정 및 RichText 설정 및 중복 코드 개선


## 2024-06-18
### Features
- 내부 테스트 20명 모집하기: 현재 18명 
- (1/2) 개선: 코드 정리 (중복 코드 제거, 관련 코드끼리 분류)
## Bug Fixes
- 달력: add_memo: 다크 모드에서 내용에 색상이 검정으로 나옴, 흰색나와야 한다 (theme에 설정했으므로, add_memo에서 다시 색상 지정할 필요 없다) 
- Get route 설정 및 색상, 폰트 설정 및 RichText 설정 및 중복 코드 개선
- screens/calendar 완료


## 2024-06-17
### Features
- 광고 설정: 
- ㄴ 메모: 최하단 
- ㄴ 범주: 최하단 
- ㄴ 달력: 최하단 
- ㄴ 설정: 최하단 
- ㄴ add_memo: 내용과 저장 버튼 사이에 
- ㄴ update_memo: 내용과 저장 버튼 사이에 
- ㄴ update_trash_can_memo: 내용과 저장 버튼 사이에
- (1/2) 모든 기능 테스트
- 내부 테스트 20명 모집하기: 현재 8명 (내부 테스터는 시간 소요되므로, 개발하기 전부터 모집하기)


## 2024-06-16
### Features
- (2/2) 즐겨 찾기
- obx 적용 및 grid 오류 해결
- 메모: UI 고민
- 메모: user image 넣는 곳은 사용되고 있지 않으므로 제거하기


## 2024-06-15
### Features
- settings: 버전 정보 설정
- (1/2) 즐겨 찾기
### Bug Fixes
- 오류 찾기
- 달력: index 오류 해결 (체크, 업데이트 메모 기능 재구현)


## 2024-06-14
### Features
- (2/2) ValueListenableBuilder to Obx
### Bug Fixes
- 오류 찾기


## 2024-06-13
### Features
- settings: flutter_email_sender 설치 및 관련 설정 및 구현
- 휴지통: 정렬 기능 개선
- 휴지통: 전체 삭제 기능 구현 (다시 한번 삭제할건지 묻는 dialog 띄우기)
- (1/2) ValueListenableBuilder 걷어내고, Obx 적용하기
### Bug Fixes
- 오류 찾기
- 휴지통: 변경한 내용을 즉시 UI에 반영하지 않고 있다. (controller 사용하므로 obx 적용하기)
- 휴지통: 업데이트 메모에서 복원 클릭 시, 복원된 내용은 메모에 나타나지만, 휴지통에서 지워지지 않고 있다
- 휴지통: 완전히 삭제 후, 리로드가 안되고 있다


## 2024-06-12
### Bug Fixes
- 미분류 or 선택한 범주에 내용 나타내고, 해당 정렬에 맞게 메모 정렬하기
- 메모: 오름차순 정렬을 반대로 하면 순서가 뒤섞여 있다. 왜? 예전 오류나면서 동일한 시간대로 변경된 휴지통 메모를 잘못 사용 (변경 사항 없음)
- 달력: 달력에서 에러난 부분, 다른 위젯 에러 해결하면서 해결함


## 2024-06-11
### Features
### Bug Fixes
- (2/2) 메모: 정렬 오류 해결
- 메모: delete 클릭 시 즉시 UI에 반영하지 않는 오류 해결 (ValueListenableBuilder 내에서 변수를 추적하여 해결)
- ing: 메모: 최초 delete 클릭 시, 즉시 UI에 반영하지 않고 있다.. 처음에는 반영하지 않고, 2번째 이후로는 잘 반영한다.. 왜??


## 2024-06-10
### Bug Fixes
- (1/2) 메모: 정렬 오류 해결


## 2024-06-08
### Features
- 메모 체크 기능 구현 (add memo, update memo, memo card, memo selected category, memo search)
- 달력: 체크 기능 구현
### Bug Fixes
- 크리티컬 이슈: 정렬 맟 역정렬 시, 즐겨찾기 및 todo 체크버튼 및 범주가 엉켜서 나타낸다 (관련 코드 전체 검사) 


## 2024-06-07
### Features
- 메모 및 휴지통 모델에 속성 추가 및 제네레이트, 관련 UI 내외부 우선 정적으로 설정
 

## 2024-06-06
### Features
- 개발자 계정 등록 완료
### Bug Fixes
- emulate 데이터 초기화(wipe data) 후, 격자 에러 발생 (변수 isGridMode는 박스에서 null)
- 메모: 역정렬 후, 삭제 시 잘못된 index를 삭제하고 있다 (반대로 삭제하면 된다. (box.length - 1 - index))


## 2024-06-05
### Features
- 휴지통: 정렬 기능 제거 
- 휴지통: 생성한 순서가 아닌, 삭제한 순서대로 휴지통에 들어가도록 정렬함
### Bug Fixes
- 역정렬 시, 화면 내부와 외부에 메모 카드에 즐찾 수정: 내림차순 정렬하고 작성된 메모장 누르면 정렬 전(오름차순(기본)) 내용을 나타내기
- 테마 변경 시, 배경색 자동 설정
- 테마 변경 시, 에러 발생 (RxBool. Did you forget to register an adapter?)


## 2024-06-03~04
### Features
- refactoring: mvc => mvvm 구조로 변경 (memo, trashCan, category 3개 적용)
1. controller 내에 싱글톤 패턴 파일을 repository/local_data_source 폴더로 이동함.
2. MemoController 에서는 MemoRepository를 직접 호출하여 데이터 작업을 수행하도록 하고,
3. MemoRepository는 데이터 접근 및 저장만을 담당하도록 설계함.
4. 비동기 작업에는 예외처리를 적용하여 오류 처리에 대한 시간을 줄임
### Bug Fixes 
- fixme: 역정렬 후, 메모장 들어와서, 내용 변경하면, 반대로 저장된다.


## 2024-06-01
### Features
- 프로젝트 정리: const 설정, 불필요한 코드와 주석 삭제, var, dynamic 타입 명확히 명시(RxBool, bool)
- 달력: 디자인 심플하게 변경
- 설정: RxBool 값은 함수 내부에 .toggle() 기능으로 간편하게 변경하여 개선
- 범주: 드래그 시, 삭제 아이콘 구현
- GetX 개선
    ~~1. (아.. 각각의 속성을 .obs하는게 아니라, 모델을 .obs 하는게 관리하기 편하다) - 현재 settingsModel 이 없다. 만들기~~~
    ~~2. obs 함수 update() 메서드 내에 작성할 수 있는 부분 찾기~~
    ~~3. GetX는 어떤 데이터든 삽입할 수 있으므로 STF 사용할 필요 없다 - getx 사용한 부분에 class 가 STF인 경우, 개선하기~~
    ~~4. 서버 데이터 가져오는 부분은 onInit() 내 관련 api 설정해서 가져와야 한다 - onInit() 검색 후, 확인하기 (로컬에서 데이터 처리하므로 없을 듯하다)~~
### Bug Fixes
- 달력: overflowed 
- 메모 작성 또는 변경 시, 배경색 미적용
- 다크 모드 시, 색상에 따라 안 보이는 것들 찾기
- 변수명 수정
- ValueListenableBuilder는 setState를 명시적으로 호출하지 않아도 되므로 제거하고, STF를 STL로 변환한다. 테스트 해보기
- 달력: Reorder 사용 시, ValueListenableBuilder는 내부setState를


## 2024-05-31
### Features
- (1/3) 로컬 백업/복구 구현 (주말 포함 3일: 자료 수집 및 내용 이해 1~2일, 코드 분리하여 테스트 성공 후 본 프로젝트에 적용하기) 
### Bug Fixes
- 한글 자음 깨짐 현상: 메모의 검색창에 "ㄱㅏㄴㅏㄷㅏㄹㅏㅁㅏㅂㅏㅅㅏ"로 자음이 깨진다 () 


## 2024-05-30
### Features
- (1/2) 앱 실행 시, flutter native splash 띄우기 
- 메모 디자인 개선: 범위 내 모든 범주 스크롤 구현 및 박스 높이 동일하게 설정
- inspector 보며 쓰지 않는 위젯 제거
- add_memo: 즐찾 사라진게 아니라 메모 생성 시 추가하지 않았다.
- 기능: 범주 18 글자 이상 작성하면 overflow 에러 발생하므로 17로 개선
- 디자인: 메모와 휴지통의 사이즈 개선
- vscode 내 자동 저장 시, const 붙이는 기능 설정 및 적용
- 키보드 한글 적용: language&input 내 한국어 설정 후 우선순위 한국어 설정
### Bug Fixes
- 휴지통으로 이동 시, 즐찾 내,외부에서 삭제하기


## 2024-05-29
### Features
- (2/2) 즐겨 찾기 (모든 카테고리에서 즐겨찾기 구현 / 선택한 카테고리에서 즐겨찾기 구현 / 검색한 카테고리에서 즐겨찾기 구현)
- 메모장에서 삭제한 메모는 휴지통으로 이동하며, 이때, 즐겨찾기한 내용도 취소되어 이동한다 (공통성: 미분류로 지정하며, 즐찾도 취소로 지정된다)
### Bug Fixes
- 크리티컬 이슈: memo model에 isFavorite 속성 추가 후, type 'Null' is not a subtype of type 'bool' in type cast 발생함
- bool isFavorite => bool? isFavorite 처리하여 Nul이 올 수 있도록 설정함 (null 일수도 있지만, 기본값을 false로 지정했으므로 코드상에는 문제가 없다고 생각하여 진행함)
- 검색어 2 누른 상태에서 외부 즐찾 클릭하면, 동일한 내용의 메모로 다른 메모의 index에 이전에 내용으로 덮어씌운다.


## 2024-05-28
### Features
- sortedTime 변수 상위에서 하위로 내려주었는데, GetX 상태관리 적용하여, 하위에 직접 설정함
- 설정: memoPage 정렬
- 메모 및 휴지통: 디자인 개선
- (ing 1/2) 즐겨 찾기 (하단 우측 1/2 위치에 별)


## 2024-05-27
### Features
- (2/2) 폰트: AlertDialog 내부에서 상태를 변경해도, Settings 클래스의 상태가 업데이트되지 않으면 UI에 즉시 반영되지 않고 있다 (Getx 사용하여 상태 관리)
- 글자 크기 조절 시, 메모장 안에 내용 필드만 크기 조절되고 그외에는 글자 크기는 변하지 않는다
- 다크 모드인 경우, 색상은 흰색 적용
- (ing) 메모: 디자인 개선 (~~모든/미분류 범주 앞에 합치기~~, ~~검색 테두리 제거하기~~, ~~x 가세표 개선~~, ~~범주 선택 시, 빨강색 나타내고 나머지 회색보다 한 단계 진한색으로 처리~~)
- 디자인 개선: 흰색 배경색 설정
### Bug Fixes
- memo_Card_widget.dart 에서 int <-> bool 에러 발생 (이 페이지를 사용하는 위치에 코드 수정)
- grid_painter 내에 themeModeBox는 {} 이며 추가된 요소에 의해 인덱스는 변경되므로 인덱스 대신 키를 대입하여 에러 해결


## 2024-05-26
### Features
- 환경 설정: 사용자 정의 - 테마 설정 구현 (변경 전: 메모 페이지 상단에 dark theme 설정을 제거하고, 환경 설정 페이지에 기능 추가함)
- 환경 설정: 사용자 정의 - 격자 배경 설정
- 휴지통 업데이트 격자 설정
### Bug Fixes
- Navigation.of(context).pop()을 두 번 사용하면 검은화면 발생하는 원인: main.dart 에서 GetMaterialApp 와 이하에 MaterialApp을 두 번 사용했기 때문이다 - 이전에 Get.offAll 처리한 내용 복원 완료
- (1/2) 폰트: AlertDialog 내부에서 상태를 변경해도, Settings 클래스의 상태가 업데이트되지 않으면 UI에 즉시 반영되지 않고 있다 (Getx 사용하여 상태 관리 테스트 중...)


## 2024-05-25
### Features
- 메모장 격자 무늬 설정 (add 및 update, MemoPage(총3개), TrashCan(총2개))
- 달력(***): 초기 진입 시, 생성된 날짜에 메모 즉시 나타내기
- (ing) 환경 설정 (1/3): 페이지 구현하기 (상: 테마 설정/폰트 설정/글자 크기, 중: 백업 설정, 하: 개선 사항 문의하기/앱 리뷰하기/앱 정보)
- 환경 설정: 사용자 정의 - 테마 설정 구현
### Bug Fixes 
- 메모 및 업데이트 생성 시, 검은 화면 문제 해결


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