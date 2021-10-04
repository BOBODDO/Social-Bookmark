# Entity 및 Behavior 설계

## Entity
> Object, 즉 요소를 의미합니다. 프로젝트의 구현에 필요한 Object 요소들을 설계 과정에서 단순히 나열합니다

* 회원
* 북마크
* 댓글
* 좋아요/싫어요
* 신고
* 관리자기능
* 공개범위(Public/Private)

## Behavior
> Queries, 즉 Object를 가지고 역할을 수행하는 동작들을 단순히 나열합니다

* 회원의 가입/로그인 기능
* 관리자가 회원의 북마크를 삭제 및 관리 가능한 기능
* 북마크 대분류 생성하기(To Study/To Read)
* 북마크의 공개범위 지정하기(Public/Private)
* Public 북마크인 경우, 타 회원을 내 북마크를 열람할 수 있게 초대하는 기능
* 북마크 내용에 대해 좋아요/싫어요 및 신고 접수 가능한 기능
* 북마크 작성 기능(URL삽입, 간단한 본문 삽입)
* 해당 북마크에 대해 댓글을 작성하는 기능(서브 코멘트)
* 타 회원으로부터 북마크 공유에 초대받았을 경우, 수락/거부하는 기능

## 생성 테이블 및 칼럼
> 상기 명시된 Entity 및 Behavior의 구현에 필요한 테이블과 칼럼을 나열합니다

1. User 테이블
* Num(Primary Key,auto increment) : 인덱스에 사용될 메인 키
* Id : 아이디
* Password : 암호화 필요
* Nick : 닉네임
* RegDate : 가입 날짜
* RecentLogin : 최근 로그인
* Status : Normal인지 Punished인지
* SuperUser : 최고관리자 여부

2. Bookmark 테이블
* Num(Primary Key,auto increment) : 인덱스에 사용될 메인 키
* Category : 어떤 분류에 속하는 북마크인지, Category테이블과 Foreign Key로 연결 필요
* CreatedUser : 어떤 회원이 생성한 북마크인지, User테이블과 Foreign Key로 연결 필요
* AuthorizedUser : 해당 북마크를 열람할 수 있는 회원, User 테이블과 Foreign Key로 연결 필요
* URL : 북마크에 지정된 URL 주소 값
* Content : 북마크 URL과 같이 기재된 컨텐츠 내용
* RegDate : 생성날짜
  
추가로 Vote 테이블과 Blamed 테이블에 값 삽입시 프로시저를 통해 미리 신고/추천/비추천 시 그 횟수를 쿼리해서 Count 해 놓는 Column을 생성하면 좋을 듯 하다
Foreign Key 연결 필요 : Blamed(신고 접수), Vote(추천/비추천), Comment(해당 북마크에 작성된 댓글), User, Category

3. Category 테이블
* Num(Primary Key, Auto increment) : 인덱스에 사용될 메인 키
* Name : 카테고리 이름
* CreatedUser : 어떤 회원이 생성한 카테고리인지, User테이블과 Foreign Key로 연결 필요
* RegDate : 생성날짜
* Status : Public인지 Private 인지

4. Vote 테이블
* Num(Primary Key, Auto increment) : 인덱스에 사용될 메인 키
* Bookmark : 어떤 북마크에 대한 추천/비추천인지, Bookmark 테이블과 Foreign Key로 연결 필요
* VotedUser : 누가 추천했는지, User테이블과 Foreign Key로 연결 필요
* VotedLog : 추천 했는지(1), 비추천했는지(-1)

5. Comment 테이블
* Num(Primary Key, Auto increment) : 인덱스에 사용될 메인 키
* Bookmark : 어떤 북마크에 대한 댓글인지, Bookmark 테이블과 Foreign Key로 연결 필요
* RegDate : 등록날짜
* CreatedUser : 해당 댓글을 작성한 회원, User 테이블과 Foreign Key로 연결 필요
* Content : 댓글 내용
  
6. Blamed 테이블
* Num(Primary Key, Auto increment) : 인덱스에 사용될 메인 키
* Bookmark : 어떤 북마크에 대한 신고인지, Bookmark 테이블과 Foreign Key로 연결 필요
* BlamedUser : 누가 신고했는지, User테이블과 Foreign Key로 연결 필요
* BlamedLog : 신고 했는지(1), 신고 취소 했는지(-1)