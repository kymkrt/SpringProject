show tables;
CREATE DATABASE javagroupS2 CHARACTER SET utf8mb4;

desc noticeBoard;

ALTER TABLE noticeboard ENGINE=InnoDB
ADD CONSTRAINT fk_noticeboard_mid
FOREIGN KEY (mid)
REFERENCES member (remainMid)
ON DELETE CASCADE
on update cascade
; -- member 테이블의 mid가 삭제되면 noticeboard의 관련 행도 삭제

desc member;

alter table noticeBoard   
add constraint 
foreign key(mid) references member (remainMid);


  CREATE TABLE `noticeboard2` (
  `idx` INT(11) NOT NULL AUTO_INCREMENT,
  `mid` VARCHAR(50) NOT NULL,
  `nickName` VARCHAR(30) NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `category` VARCHAR(10) NOT NULL DEFAULT 'others',
  `content` TEXT NOT NULL,
  `hostIp` VARCHAR(40) NOT NULL,
  `openSw` CHAR(3) NULL DEFAULT '공개',
  `viewCnt` INT(11) NULL DEFAULT '0',
  `postDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`idx`),
  CONSTRAINT `fk_noticeboard_mid` 
    FOREIGN KEY (`mid`) 
    REFERENCES `member` (`remainMid`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) 
ENGINE=InnoDB 
COLLATE='utf8mb4_general_ci';

ALTER TABLE `noticeboard` 
  COLLATE = 'utf8mb4_general_ci', 
  ENGINE = InnoDB, 
  ADD CONSTRAINT `fk_noticeboard_mid` 
  FOREIGN KEY (`mid`) 
  REFERENCES `member` (`remainMid`) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE;