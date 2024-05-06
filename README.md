# Release notes

## todo
- 이전에 프로젝트 진행 계획 가져오기 (트렐로)
- commit 번호를 링크로 달기
- 입력칸 늘리기: add 메모(maxLines: 6)
- 카테고리 내에 crud 위젯으로 분리하기
- (ing)


## 2024-05-06
### Features
- 홈페이지에 범주 클릭하면, 관련된 범주를 가지고 있는 메모만 화면에 나타내기 
- (ing) 범주명 모두 만들고, 홈페이지와 범주페이지에서 맨 왼쪽에 나타낸다


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
