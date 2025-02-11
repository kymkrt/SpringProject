show tables; /*연결됐는지 확인*/
/*미리 이렇게 핵심(기초데이터)를 만들어 두고 나중에 확장한다 다른애들이 이 테이블을 참조 그래서 얘는 중복되면 안됨 */
/*얘는 그래서 */

create table member (
	idx int not null auto_increment, /*회원 고유 번호*/
	/*()숫자 넘으면 오류*/
	mid varchar(30) not null, /*회원 아이디(중복불허) 유니크키*/
	pwd varchar(100) not null, /*회원 비밀번호(SHA256/512 암호화처리 여기선256 보통 256쓴다) 암호화할때는 길이 많이 줘야함*/
	nickName varchar(30) not null, /*회원 닉네임(중복불허/수정가능)*/
	name varchar(30) not null, /*회원 성명(중복허용) 가변길이*/
	gender char(2) not null default '여자', /*회원 성별*/
	birthday datetime default now(), /*회원생일*/
	tel varchar(15),  /*전화번호 : 010-1234-5678 */
	address varchar(180), /*주소(우편번호:다음 API 활용)*/
	email varchar(60) not null, /*이메일(아이디/비밀번호 분실시에 사용) - 형식체크(유효성검사)필수 */
	content text, /*자기소개*/
	photo varchar(100) default 'noimage.jpg', /*회원사진*/	
	userInfor char(3) default '공개', /*회원의 정보 공개 유무(공개/비공개) 고정길이 실무에선 ok/no같은 방식 많이 씀*/
	userDel char(2) default 'NO', /*회원 탈퇴 신청 여부(NO:현재 활동중, OK:탈퇴신청중)*/
	level int default 1, /*회원 등급(0:관리자, 1:준회원, 2:정회원, 3,:우수회원 (4:운영자), 99:탈퇴신청회원)*/
	point int default 100, /* 회원 누적 포인트(최초 가입 포인트는 100지불, 1회 방문시 10포인트 증가, 1일 최대 50포인트까지 허용, 물건 구매시 100당 1포인트 증가)*/
	visitCnt int default 0, /*총 방문 횟수*/
	todayCnt int default 0, /*오늘 방문 카운트*/
	startDate datetime default now(), /*최초 가입일*/
	lastDate datetime default now(), /*마지막 접속일(탈퇴시는 탈퇴한 날짜)*/
	/* salt char(8) not null default '12345678', /*비빌번호 보안을 위한 salt*/ */
	primary key(idx), /*이렇게 미래 해두면 좋다*/
	unique key(mid)
);

create table deleteMemberTemp(
	idx int not null auto_increment,
	test varchar(30) not null,
	primary key(idx),
	unique key(test)
);
drop table deleteMemberTemp;

create table deleteMemberTest(
	idx int not null auto_increment,
	deleteMid varchar(30),
	
	primary key(idx),
	foreign key(deleteMid) references deleteMemberTemp(test)
);

create table deleteMember(
	idx int not null auto_increment,
	deleteMid varchar(30),
	
	primary key(idx),
	foreign key(deleteMid) references member(publicMid)
);

CREATE TABLE `deleteMember` (
    `idx` INT NOT NULL AUTO_INCREMENT,
    `deleteMid` VARCHAR(30),
    PRIMARY KEY (`idx`),
    FOREIGN KEY (`deleteMid`) REFERENCES `member`(`publicMid`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

DESCRIBE member;
SHOW INDEX FROM member;

create table noticeBoard2(
	idx int(11) not null auto_increment,
	mid varchar(50) not null,
	nickName varchar(50) not null,
	title varchar(100) not null,
	category varchar(10) not null default 'others',
	content text not null,
	hostIp varchar(40) not null,
	openSw char(3) default '공개',
	viewCnt int(11) default '0',
	postDate datetime default CURRENT_TIMESTAMP,
	file varchar(200) null default null,
	primary key(idx),
	foreign key(mid) references member (remainMid) on delete cascade on update cascade
);

alter table noticeBoard   
add constraint 
foreign key(mid) references member (remainMid);

desc member;
drop table member;
/*values는 다 써야한다*/
insert into member values (default, 'admin', 'asdf1234', '관리맨', '관리자', '남자', default, '010-5165-3650', '28575 충북 청주시 서원구 사직대로 109, 4층', 'wh40k@naver.com', '관리자입니다', default, default, default, default, default, default, default, default);
select * from member;

select max(point) as point, mid, name from member;

delete from member where name = '김초키';
