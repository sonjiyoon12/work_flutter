/// record 문법과 typedef 알아 보기
/// DTO --> dart. 3.xx 버전 부터 레코드란 문법을 만들어 줬다.

void main() {
  // 1. 레코드 타입 정의
  (String, int) userInfo = ('홍길동', 20); // 바로 보이는 투명 케이스
  //UserInfo userInfo2 = UserInfo('홍길동', 20); // 잘 포장된 선물 상자
  // 2. 네임드 레코드 타입 정의
  ({String name, int age}) userInfo3 = (name: '홍길동', age: 20);

  // 3. 레코드 문법과 typedef를 보통 많이 활용할 수 있다.
  // 3.2 typedef 를 활용해 보자.
  // ({String name, int age}) --> 대신에 별칭을 사용할 수 있다 왜? -> 미리 정의해 놓았음.
  UserRecord ur = (name: '홍길동', age: 20);

  String localName = userProfile1.name;
  int localAge = userProfile1.age;

  // 통신 요청 ---> Json 문자열 ---> jsonDecode(json) --> Map 구조로 변환 됨
  // 예시 - 맵 구조로 사용하게 된다면 userMap["username"];, userMap["age"];
  // 원래 코드 형태는 일반적으로 Map 구조에 Class 형태로 변환해서 많이 사용함
  // 하지만 간단한 데이터 덩어리라면 앞으로 레코드 문법과 typedef를 사용하면 편리함
}

// class UserInfo {
//   String username;
//   int age;
//
//   UserInfo(this.username, this.age);
// }

// 3.1 typedef 대해서 알아 보자
typedef UserRecord = ({String name, int age});
// typedef란?
// Type definition 의 줄임말로 별칭을 의미한다.
// 복잡한 타입의 이름을 간단한 이름으로 붙이는 역할을 하고
// 마치 긴 주소의 '내집 또는 우리집' 으로 부르는 개념이다.

// 장점 또는 사용하는 이유?
// 가독성 향상, 복잡한 형태를 줄여서 재사용성 높아진다.
// 타입 구조 변경시 typedef만 수정하면 모든 곳에서 반영할 수 있다.
// 타입 안정성 - 컴파일 시점에 타입 체크 오류 확인할 수 있다.

typedef UserProfile = ({String name, int age, String? email});

UserProfile userProfile1 = (name: '티모', age: 10, email: null);
UserProfile userProfile2 = (name: '야스오', age: 20, email: 'a@naver.com');
UserProfile userProfile3 = (name: '몬스터', age: 30, email: 'd@naver.com');

// typedef, 즉 별칭을 안 만들었다면 매번 타입을 선언해주어야 한다.
({String name, int age, String? email}) userProfile4 =
    (name: '티모', age: 10, email: null);
({String name, int age, String? email}) userProfile5 =
    (name: '야스오', age: 20, email: 'a@naver.com');
({String name, int age, String? email}) userProfile6 =
    (name: '몬스터', age: 30, email: 'd@naver.com');

// 함수에서도 레코드 문법과 또는 typedef를 활용할 수 있다.
//Function createUser(String name, int age, String email){}

// 리턴 타입이 레코드인 함수의 선언
({String CarName, int price, String year}) createCar(
    String name, int price, String year) {
  return (CarName: name, price: price, year: year);
}

// ({String CarName, int price, String year}) <-- 여기에 별칭을 부여하자
typedef CarRecord = ({String CarName, int price, String year});

CarRecord createCar2(String name, int price, String year) {
  return (CarName: name, price: price, year: year);
}

// 자료 구조 리스트에서 record 문법을 사용해 보자.
// 레코드만 사용한 문법
List<({String CarName, int price, String year})> carList = [
  (CarName: "페라리", price: 100, year: "2025"),
  (CarName: "람보르기니", price: 1000, year: "2025"),
  (CarName: "부가티", price: 500, year: "2025"),
];

// 레코드 + 별칭 문법을 사용한 코드
List<CarRecord> carList2 = [
  (CarName: "페라리", price: 100, year: "2025"),
  (CarName: "람보르기니", price: 1000, year: "2025"),
  (CarName: "부가티", price: 500, year: "2025"),
];
