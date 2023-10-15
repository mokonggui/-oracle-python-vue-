-- 创建账号基本信息表
CREATE TABLE AccountInfo (
    aname VARCHAR2(50)  ,
    ID INTEGER PRIMARY KEY,
    password VARCHAR2(20)  ,
    power VARCHAR2(10) default 'N'
);

-- 添加注释
COMMENT ON TABLE AccountInfo IS '账号基本信息表';
COMMENT ON COLUMN AccountInfo.aname IS '用户名';
COMMENT ON COLUMN AccountInfo.ID IS '工号或学号';
COMMENT ON COLUMN AccountInfo.password IS '密码';
COMMENT ON COLUMN AccountInfo.power IS '权限';

-- 创建读者基本信息表
CREATE TABLE ReaderInfo (
    Readernum INTEGER PRIMARY KEY ,
    ReaderName VARCHAR2(30) ,
    Readersex VARCHAR2(10) ,
    Address VARCHAR2(100) ,
    Linkway VARCHAR2(30)  ,
    ReaderAge INTEGER  ,
    Readerid VARCHAR2(20)  
);

-- 添加注释
COMMENT ON TABLE ReaderInfo IS '读者基本信息表';
COMMENT ON COLUMN ReaderInfo.Readernum IS '学号';
COMMENT ON COLUMN ReaderInfo.ReaderName IS '姓名';
COMMENT ON COLUMN ReaderInfo.Readersex IS '性别';
COMMENT ON COLUMN ReaderInfo.Address IS '居住地址';
COMMENT ON COLUMN ReaderInfo.Linkway IS '联系方式';
COMMENT ON COLUMN ReaderInfo.ReaderAge IS '年龄';
COMMENT ON COLUMN ReaderInfo.Readerid IS '身份证号';

--创建管理员信息表
CREATE TABLE AdminInfo (
    Adminum INTEGER PRIMARY KEY ,
    Adminame VARCHAR2(15),
    Admisex VARCHAR2(8),
    Age INTEGER ,
    AdmiID VARCHAR2(20) ,
    Alinkway VARCHAR2(15)
);

-- 添加注释
COMMENT ON TABLE AdminInfo IS '图书管理员信息表';
COMMENT ON COLUMN AdminInfo.Adminum IS '管理员ID';
COMMENT ON COLUMN AdminInfo.Adminame IS '姓名';
COMMENT ON COLUMN AdminInfo.Admisex IS '性别';
COMMENT ON COLUMN AdminInfo.Age IS '年龄';
COMMENT ON COLUMN AdminInfo.AdmiID IS '身份证号';
COMMENT ON COLUMN AdminInfo.Alinkway IS '联系方式';

-- 创建图书表
CREATE TABLE Book (
    Booknum INTEGER PRIMARY KEY,
    Bookname VARCHAR2(15)  ,
    Author VARCHAR2(20)  ,
    Publish VARCHAR2(30)  ,
    Price NUMBER  ,
    Stock INTEGER  ,
    Category VARCHAR2(50) 
);

-- 添加注释
COMMENT ON TABLE Book IS '图书信息表';
COMMENT ON COLUMN Book.Booknum IS '图书编号';
COMMENT ON COLUMN Book.Bookname IS '书名';
COMMENT ON COLUMN Book.Author IS '作者';
COMMENT ON COLUMN Book.Publish IS '出版社';
COMMENT ON COLUMN Book.Price IS '价格';
COMMENT ON COLUMN Book.Stock IS '库存';
COMMENT ON COLUMN Book.Category IS '分类';


-- 创建借阅订单表
CREATE TABLE BorrowOrder (
    borrowID INTEGER PRIMARY KEY,
    readernum INTEGER,
    borrowdate DATE ,
    borrowprice NUMBER ,
    borrowterm INTEGER  ,
    borrowstate VARCHAR2(50) 
);

-- 添加注释
COMMENT ON TABLE BorrowOrder IS '借阅订单表';
COMMENT ON COLUMN BorrowOrder.borrowID IS '借阅单号';
COMMENT ON COLUMN BorrowOrder.readernum IS '学号';
COMMENT ON COLUMN BorrowOrder.borrowdate IS '借阅日期';
COMMENT ON COLUMN BorrowOrder.borrowprice IS '借阅价格';
COMMENT ON COLUMN BorrowOrder.borrowterm IS '借阅期限';
COMMENT ON COLUMN BorrowOrder.borrowstate IS '借阅状态';

-- 创建借阅明细信息表
CREATE TABLE BorrowDetail (
    borrowID INTEGER primary key,
    Booknum INTEGER,
    borrownumber INTEGER 
);

-- 添加注释
COMMENT ON TABLE BorrowDetail IS '借阅明细信息表';
COMMENT ON COLUMN BorrowDetail.borrowID IS '借阅单号';
COMMENT ON COLUMN BorrowDetail.Booknum IS '图书编号';
COMMENT ON COLUMN BorrowDetail.borrownumber IS '借阅数量';


-- 创建预约订单表
CREATE TABLE PreOrder (
    preID INTEGER PRIMARY KEY,
    readernum INTEGER  ,
    predate DATE  ,
    buydate DATE
);

-- 添加注释
COMMENT ON TABLE PreOrder IS '预约订单表';
COMMENT ON COLUMN PreOrder.preID IS '预约单号';
COMMENT ON COLUMN PreOrder.readernum IS '学号';
COMMENT ON COLUMN PreOrder.predate IS '预约日期';
COMMENT ON COLUMN PreOrder.buydate IS '订单日期';


--创建预约明细信息表
CREATE TABLE PreOrderInfo (
    preID INTEGER,
    Booknum INTEGER ,
    prenumber INTEGER ,
    PRIMARY KEY (preID)
);

-- 添加注释
COMMENT ON TABLE PreOrderInfo IS '预约订单信息表';
COMMENT ON COLUMN PreOrderInfo.preID IS '预约单号 ';
COMMENT ON COLUMN PreOrderInfo.Booknum IS '图书编号 ';
COMMENT ON COLUMN PreOrderInfo.prenumber IS '预约数量';

ALTER TABLE ReaderInfo
ADD CONSTRAINT fk_ReaderInfo_AccountInfo FOREIGN KEY (Readernum) REFERENCES AccountInfo (ID);

ALTER TABLE AdminInfo
ADD CONSTRAINT fk_AdminInfo_AccountInfo FOREIGN KEY (Adminum) REFERENCES AccountInfo (ID);

ALTER TABLE BorrowOrder
ADD CONSTRAINT fk_borrow_reader FOREIGN KEY (readernum) REFERENCES ReaderInfo (Readernum);

ALTER TABLE PreOrder
ADD CONSTRAINT fk_pre_reader FOREIGN KEY (readernum) REFERENCES ReaderInfo (Readernum);

ALTER TABLE BorrowOrder
ADD CONSTRAINT fk_borrowdetail_borrow FOREIGN KEY (borrowID) REFERENCES BorrowDetail (borrowID);

ALTER TABLE PreOrder
ADD CONSTRAINT fk_borrowdetail_borrow2 FOREIGN KEY (preID) REFERENCES PreOrderInfo(preID);

INSERT INTO AccountInfo (aname, ID, password, power) VALUES ('张三',55,55,'Y');
INSERT INTO AccountInfo (aname, ID, password, power) VALUES ('李四',11,11,'N');

INSERT INTO ReaderInfo (Readernum, ReaderName, Readersex, Address, Linkway, ReaderAge, Readerid) 
       VALUES (11, '鲍麒', '男', 11, 11, 11, 11);
       
INSERT INTO AdminInfo (Adminum, Adminame, Admisex, Age, AdmiID, Alinkway) 
       VALUES (55, '张三三', '男', 55, 55, 55);

INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (1,1,2,3,4,5,6);
INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (2,1,2,3,4,15,6);
INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (3,1,2,3,4,15,6);

INSERT INTO BorrowDetail (borrowID, Booknum, borrownumber) VALUES (1,4,1);
INSERT INTO PreOrderInfo (preID, Booknum, prenumber) VALUES (1,4,1);

INSERT INTO BorrowOrder (borrowID, readernum, borrowdate, borrowprice, borrowterm, borrowstate) 
       VALUES (1, 11, SYSDATE, '0', 3, '未归还');
INSERT INTO PreOrder (preID, readernum, predate,buydate) 
       VALUES (1, 11, SYSDATE,SYSDATE);
     
    
--读者信息视图
CREATE or replace VIEW ReaderInformationView 
AS
   SELECT R.Readernum, R.ReaderName, R.ReaderAge, R.Readersex, R.Address, R.Linkway, A.aname, R.Readerid
   FROM ReaderInfo R
   JOIN AccountInfo A ON R.Readernum = A.ID;
   
   
--管理员信息视图
CREATE or replace VIEW AdminInformationView 
AS
   SELECT D.Adminum, D.Adminame, D.Age, D.Admisex, D.ALinkway, A.aname, D.AdmiID
   FROM AdminInfo D
   JOIN AccountInfo A ON D.Adminum = A.ID;


--添加图书时自动图书编号+1，下一个加的编号是空缺的编号
CREATE OR REPLACE TRIGGER booknum_trigger
BEFORE INSERT ON BOOK
FOR EACH ROW
DECLARE
  v_max_Booknum INTEGER;
  v_count       INTEGER;
BEGIN
  -- 获取已有的最大编号
  SELECT MAX(Booknum) INTO v_max_Booknum FROM BOOK;
  -- 如果没有记录，将最大编号设置为 0
  IF v_max_Booknum IS NULL THEN
    v_max_Booknum := 0;
  END IF;
  -- 检查是否存在空缺的编号
  FOR i IN 1..v_max_Booknum + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM BOOK WHERE Booknum = i;
    IF v_count = 0 THEN
      :NEW.Booknum := i;
      RETURN;
    END IF;
  END LOOP;
  -- 如果没有找到空缺的编号，就使用最大编号加 1
  :NEW.Booknum := v_max_Booknum + 1;
END;


--借阅时自动借阅详情表编号+1
CREATE OR REPLACE TRIGGER jieyue_trigger
BEFORE INSERT ON BorrowDetail
FOR EACH ROW
DECLARE
  v_max_borrowID INTEGER;
BEGIN
  SELECT MAX(borrowID) + 1 INTO v_max_borrowID FROM BorrowDetail;
  IF v_max_borrowID IS NULL THEN
    v_max_borrowID := 1;
  END IF;
  :NEW.borrowID := v_max_borrowID;
END;


--借阅时自动借阅表编号+1
CREATE OR REPLACE TRIGGER jieyue_trigger1
BEFORE INSERT ON BorrowOrder
FOR EACH ROW
DECLARE
  v_max_borrowID INTEGER;
BEGIN
  SELECT MAX(borrowID) + 1 INTO v_max_borrowID FROM BorrowOrder;
  IF v_max_borrowID IS NULL THEN
    v_max_borrowID := 1;
  END IF;
  :NEW.borrowID := v_max_borrowID;
END;


-- 更新借阅状态
CREATE OR REPLACE TRIGGER jieyue_trigger2
AFTER UPDATE ON BorrowDetail
FOR EACH ROW
DECLARE
  v_borrownumber INTEGER;
BEGIN
  -- 获取更新后的借阅数量
  v_borrownumber := :NEW.borrownumber;
  
  -- 检查借阅数量是否为 0
  IF v_borrownumber = 0 THEN
    -- 更新对应的 BorrowOrder 表的借阅状态
    UPDATE BorrowOrder
    SET borrowstate = '已归还'
    WHERE borrowID = :NEW.borrowID;
  END IF;
END;


--预约时自动预约明细表编号+1，下一个加的编号是空缺的编号
CREATE OR REPLACE TRIGGER yuyueyue_trigger
BEFORE INSERT ON PreOrderInfo
FOR EACH ROW
DECLARE
  v_max_preID INTEGER;
  v_count       INTEGER;
BEGIN
  -- 获取已有的最大编号
  SELECT MAX(preID) INTO v_max_preID FROM PreOrderInfo;
  -- 如果没有记录，将最大编号设置为 0
  IF v_max_preID IS NULL THEN
    v_max_preID := 0;
  END IF;
  -- 检查是否存在空缺的编号
  FOR i IN 1..v_max_preID + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM PreOrderInfo WHERE preID = i;
    IF v_count = 0 THEN
      :NEW.preID := i;
      RETURN;
    END IF;
  END LOOP;
  -- 如果没有找到空缺的编号，就使用最大编号加 1
  :NEW.preID := v_max_preID + 1;
END;  


--预约时自动预约表编号+1，下一个加的编号是空缺的编号
CREATE OR REPLACE TRIGGER yuyueyue_trigger1
BEFORE INSERT ON PreOrder
FOR EACH ROW
DECLARE
  v_max_preID INTEGER;
  v_count       INTEGER;
BEGIN
  -- 获取已有的最大编号
  SELECT MAX(preID) INTO v_max_preID FROM PreOrder;
  -- 如果没有记录，将最大编号设置为 0
  IF v_max_preID IS NULL THEN
    v_max_preID := 0;
  END IF;
  -- 检查是否存在空缺的编号
  FOR i IN 1..v_max_preID + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM PreOrder WHERE preID = i;
    IF v_count = 0 THEN
      :NEW.preID := i;
      RETURN;
    END IF;
  END LOOP;
  -- 如果没有找到空缺的编号，就使用最大编号加 1
  :NEW.preID := v_max_preID + 1;
END;    



-- 预约存储过程
CREATE OR REPLACE PROCEDURE PreBook (
    p_readernum IN INTEGER,
    p_booknum IN INTEGER,
    p_borrownumber IN INTEGER,
    p_borrowterm IN DATE
) AS
    v_stock INTEGER;
BEGIN
    -- 检查库存是否足够
    IF p_borrownumber > 0 THEN
        SELECT Stock INTO v_stock FROM Book WHERE Booknum = p_booknum;

        IF v_stock >= p_borrownumber THEN
            -- 减少库存
            UPDATE Book SET Stock = Stock - p_borrownumber WHERE Booknum = p_booknum;
        
            -- 插入预约明细表记录
            INSERT INTO PreOrderInfo (Booknum, prenumber)
            VALUES (p_booknum, p_borrownumber);
            
            -- 插入预约表数据
            INSERT INTO PreOrder (readernum, predate, Buydate)
            VALUES (p_readernum, p_borrowterm, SYSDATE);
        
            -- 提交事务
            COMMIT;
        ELSE
            -- 库存不足，抛出异常
            RAISE_APPLICATION_ERROR(-20001, '库存不足');
        END IF;
    ELSE
        -- 非法借阅数量，抛出异常
        RAISE_APPLICATION_ERROR(-20002, '非法借阅数量');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- 发生异常时回滚事务
        ROLLBACK;
        -- 重新抛出异常
        RAISE;
END;


--预约取消存储过程
CREATE OR REPLACE PROCEDURE PreBookBack (
    p_preID IN INTEGER
) AS
    v_booknum INTEGER;
    v_bookid INTEGER;
BEGIN
    --预约图书数
    select prenumber into v_booknum from PreOrderInfo where preID = p_preID;
    --预约书号
    select Booknum into v_bookid from PreOrderInfo where preID = p_preID;
    --更新库存
    update book
        SET Stock = Stock + v_booknum
        WHERE Booknum = v_bookid;
    --删除预约信息二表
    delete from PreOrder where preID = p_preID;
    delete from PreOrderInfo where preID = p_preID;
    --提交事务
    commit;
END;


--借阅存储过程
CREATE OR REPLACE PROCEDURE BorrowBook (
    p_readernum IN INTEGER,
    p_booknum IN INTEGER,
    p_borrownumber IN INTEGER,
    p_borrowterm IN INTEGER
) AS
    v_stock INTEGER;
BEGIN
    -- 检查库存是否足够
    IF p_borrownumber > 0 THEN
        SELECT Stock INTO v_stock FROM Book WHERE Booknum = p_booknum;

        IF v_stock >= p_borrownumber THEN
            -- 减少库存
            UPDATE Book SET Stock = Stock - p_borrownumber WHERE Booknum = p_booknum;
        
            -- 插入借阅记录
            INSERT INTO BorrowDetail (Booknum, Borrownumber)
            VALUES (p_booknum, p_borrownumber);
            
            -- 插入借阅表数据
            INSERT INTO BorrowOrder (readernum, borrowdate, borrowprice, borrowterm, borrowstate)
            VALUES (p_readernum, SYSDATE, '0', p_borrowterm, '未归还');
        
            -- 提交事务
            COMMIT;
        ELSE
            -- 库存不足，抛出异常
            RAISE_APPLICATION_ERROR(-20001, '库存不足');
        END IF;
    ELSE
        -- 非法借阅数量，抛出异常
        RAISE_APPLICATION_ERROR(-20002, '非法借阅数量');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- 发生异常时回滚事务
        ROLLBACK;
        -- 重新抛出异常
        RAISE;
END;


-- 还书存储过程
CREATE OR REPLACE PROCEDURE ReturnBook (
    p_borrowID IN INTEGER,
    p_booknum IN INTEGER,
    p_returnnumber IN INTEGER
) AS
BEGIN
        -- 更新借阅记录
        UPDATE BorrowDetail
        SET borrownumber = borrownumber - p_returnnumber
        WHERE borrowID = p_borrowID;

        -- 增加库存
        UPDATE Book SET Stock = Stock + p_returnnumber WHERE Booknum = p_booknum;

        -- 提交事务
        COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- 没有找到对应的借阅记录，抛出异常
        RAISE_APPLICATION_ERROR(-20003, '未找到对应的借阅记录');
    WHEN OTHERS THEN
        -- 发生异常时回滚事务
        ROLLBACK;
        -- 重新抛出异常
        RAISE;
END;



--求书总量函数
CREATE OR REPLACE FUNCTION func1
RETURN NUMBER
IS
    total_stock1 NUMBER := 0;
    total_stock2 NUMBER := 0;
    total_stock3 NUMBER := 0;
    total_stock NUMBER := 0;
BEGIN
    -- 获取book表中的stock和                       
    SELECT sum(stock) INTO total_stock1 FROM book;
    
    -- 获取PreOrderInfo表中的prenumber和
    SELECT sum(prenumber) INTO total_stock2 FROM PreOrderInfo;

    -- 获取BorrowDetail表中的borrownumber和
    SELECT sum(borrownumber) INTO total_stock3 FROM BorrowDetail;
    
    total_stock := total_stock1+total_stock2+total_stock3;

    RETURN total_stock;
END;




