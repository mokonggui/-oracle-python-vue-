-- �����˺Ż�����Ϣ��
CREATE TABLE AccountInfo (
    aname VARCHAR2(50)  ,
    ID INTEGER PRIMARY KEY,
    password VARCHAR2(20)  ,
    power VARCHAR2(10) default 'N'
);

-- ���ע��
COMMENT ON TABLE AccountInfo IS '�˺Ż�����Ϣ��';
COMMENT ON COLUMN AccountInfo.aname IS '�û���';
COMMENT ON COLUMN AccountInfo.ID IS '���Ż�ѧ��';
COMMENT ON COLUMN AccountInfo.password IS '����';
COMMENT ON COLUMN AccountInfo.power IS 'Ȩ��';

-- �������߻�����Ϣ��
CREATE TABLE ReaderInfo (
    Readernum INTEGER PRIMARY KEY ,
    ReaderName VARCHAR2(30) ,
    Readersex VARCHAR2(10) ,
    Address VARCHAR2(100) ,
    Linkway VARCHAR2(30)  ,
    ReaderAge INTEGER  ,
    Readerid VARCHAR2(20)  
);

-- ���ע��
COMMENT ON TABLE ReaderInfo IS '���߻�����Ϣ��';
COMMENT ON COLUMN ReaderInfo.Readernum IS 'ѧ��';
COMMENT ON COLUMN ReaderInfo.ReaderName IS '����';
COMMENT ON COLUMN ReaderInfo.Readersex IS '�Ա�';
COMMENT ON COLUMN ReaderInfo.Address IS '��ס��ַ';
COMMENT ON COLUMN ReaderInfo.Linkway IS '��ϵ��ʽ';
COMMENT ON COLUMN ReaderInfo.ReaderAge IS '����';
COMMENT ON COLUMN ReaderInfo.Readerid IS '���֤��';

--��������Ա��Ϣ��
CREATE TABLE AdminInfo (
    Adminum INTEGER PRIMARY KEY ,
    Adminame VARCHAR2(15),
    Admisex VARCHAR2(8),
    Age INTEGER ,
    AdmiID VARCHAR2(20) ,
    Alinkway VARCHAR2(15)
);

-- ���ע��
COMMENT ON TABLE AdminInfo IS 'ͼ�����Ա��Ϣ��';
COMMENT ON COLUMN AdminInfo.Adminum IS '����ԱID';
COMMENT ON COLUMN AdminInfo.Adminame IS '����';
COMMENT ON COLUMN AdminInfo.Admisex IS '�Ա�';
COMMENT ON COLUMN AdminInfo.Age IS '����';
COMMENT ON COLUMN AdminInfo.AdmiID IS '���֤��';
COMMENT ON COLUMN AdminInfo.Alinkway IS '��ϵ��ʽ';

-- ����ͼ���
CREATE TABLE Book (
    Booknum INTEGER PRIMARY KEY,
    Bookname VARCHAR2(15)  ,
    Author VARCHAR2(20)  ,
    Publish VARCHAR2(30)  ,
    Price NUMBER  ,
    Stock INTEGER  ,
    Category VARCHAR2(50) 
);

-- ���ע��
COMMENT ON TABLE Book IS 'ͼ����Ϣ��';
COMMENT ON COLUMN Book.Booknum IS 'ͼ����';
COMMENT ON COLUMN Book.Bookname IS '����';
COMMENT ON COLUMN Book.Author IS '����';
COMMENT ON COLUMN Book.Publish IS '������';
COMMENT ON COLUMN Book.Price IS '�۸�';
COMMENT ON COLUMN Book.Stock IS '���';
COMMENT ON COLUMN Book.Category IS '����';


-- �������Ķ�����
CREATE TABLE BorrowOrder (
    borrowID INTEGER PRIMARY KEY,
    readernum INTEGER,
    borrowdate DATE ,
    borrowprice NUMBER ,
    borrowterm INTEGER  ,
    borrowstate VARCHAR2(50) 
);

-- ���ע��
COMMENT ON TABLE BorrowOrder IS '���Ķ�����';
COMMENT ON COLUMN BorrowOrder.borrowID IS '���ĵ���';
COMMENT ON COLUMN BorrowOrder.readernum IS 'ѧ��';
COMMENT ON COLUMN BorrowOrder.borrowdate IS '��������';
COMMENT ON COLUMN BorrowOrder.borrowprice IS '���ļ۸�';
COMMENT ON COLUMN BorrowOrder.borrowterm IS '��������';
COMMENT ON COLUMN BorrowOrder.borrowstate IS '����״̬';

-- ����������ϸ��Ϣ��
CREATE TABLE BorrowDetail (
    borrowID INTEGER primary key,
    Booknum INTEGER,
    borrownumber INTEGER 
);

-- ���ע��
COMMENT ON TABLE BorrowDetail IS '������ϸ��Ϣ��';
COMMENT ON COLUMN BorrowDetail.borrowID IS '���ĵ���';
COMMENT ON COLUMN BorrowDetail.Booknum IS 'ͼ����';
COMMENT ON COLUMN BorrowDetail.borrownumber IS '��������';


-- ����ԤԼ������
CREATE TABLE PreOrder (
    preID INTEGER PRIMARY KEY,
    readernum INTEGER  ,
    predate DATE  ,
    buydate DATE
);

-- ���ע��
COMMENT ON TABLE PreOrder IS 'ԤԼ������';
COMMENT ON COLUMN PreOrder.preID IS 'ԤԼ����';
COMMENT ON COLUMN PreOrder.readernum IS 'ѧ��';
COMMENT ON COLUMN PreOrder.predate IS 'ԤԼ����';
COMMENT ON COLUMN PreOrder.buydate IS '��������';


--����ԤԼ��ϸ��Ϣ��
CREATE TABLE PreOrderInfo (
    preID INTEGER,
    Booknum INTEGER ,
    prenumber INTEGER ,
    PRIMARY KEY (preID)
);

-- ���ע��
COMMENT ON TABLE PreOrderInfo IS 'ԤԼ������Ϣ��';
COMMENT ON COLUMN PreOrderInfo.preID IS 'ԤԼ���� ';
COMMENT ON COLUMN PreOrderInfo.Booknum IS 'ͼ���� ';
COMMENT ON COLUMN PreOrderInfo.prenumber IS 'ԤԼ����';

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

INSERT INTO AccountInfo (aname, ID, password, power) VALUES ('����',55,55,'Y');
INSERT INTO AccountInfo (aname, ID, password, power) VALUES ('����',11,11,'N');

INSERT INTO ReaderInfo (Readernum, ReaderName, Readersex, Address, Linkway, ReaderAge, Readerid) 
       VALUES (11, '����', '��', 11, 11, 11, 11);
       
INSERT INTO AdminInfo (Adminum, Adminame, Admisex, Age, AdmiID, Alinkway) 
       VALUES (55, '������', '��', 55, 55, 55);

INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (1,1,2,3,4,5,6);
INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (2,1,2,3,4,15,6);
INSERT INTO BOOK (Booknum, Bookname, author, Publish, Price, Stock, Category) VALUES (3,1,2,3,4,15,6);

INSERT INTO BorrowDetail (borrowID, Booknum, borrownumber) VALUES (1,4,1);
INSERT INTO PreOrderInfo (preID, Booknum, prenumber) VALUES (1,4,1);

INSERT INTO BorrowOrder (borrowID, readernum, borrowdate, borrowprice, borrowterm, borrowstate) 
       VALUES (1, 11, SYSDATE, '0', 3, 'δ�黹');
INSERT INTO PreOrder (preID, readernum, predate,buydate) 
       VALUES (1, 11, SYSDATE,SYSDATE);
     
    
--������Ϣ��ͼ
CREATE or replace VIEW ReaderInformationView 
AS
   SELECT R.Readernum, R.ReaderName, R.ReaderAge, R.Readersex, R.Address, R.Linkway, A.aname, R.Readerid
   FROM ReaderInfo R
   JOIN AccountInfo A ON R.Readernum = A.ID;
   
   
--����Ա��Ϣ��ͼ
CREATE or replace VIEW AdminInformationView 
AS
   SELECT D.Adminum, D.Adminame, D.Age, D.Admisex, D.ALinkway, A.aname, D.AdmiID
   FROM AdminInfo D
   JOIN AccountInfo A ON D.Adminum = A.ID;


--���ͼ��ʱ�Զ�ͼ����+1����һ���ӵı���ǿ�ȱ�ı��
CREATE OR REPLACE TRIGGER booknum_trigger
BEFORE INSERT ON BOOK
FOR EACH ROW
DECLARE
  v_max_Booknum INTEGER;
  v_count       INTEGER;
BEGIN
  -- ��ȡ���е������
  SELECT MAX(Booknum) INTO v_max_Booknum FROM BOOK;
  -- ���û�м�¼�������������Ϊ 0
  IF v_max_Booknum IS NULL THEN
    v_max_Booknum := 0;
  END IF;
  -- ����Ƿ���ڿ�ȱ�ı��
  FOR i IN 1..v_max_Booknum + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM BOOK WHERE Booknum = i;
    IF v_count = 0 THEN
      :NEW.Booknum := i;
      RETURN;
    END IF;
  END LOOP;
  -- ���û���ҵ���ȱ�ı�ţ���ʹ������ż� 1
  :NEW.Booknum := v_max_Booknum + 1;
END;


--����ʱ�Զ������������+1
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


--����ʱ�Զ����ı���+1
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


-- ���½���״̬
CREATE OR REPLACE TRIGGER jieyue_trigger2
AFTER UPDATE ON BorrowDetail
FOR EACH ROW
DECLARE
  v_borrownumber INTEGER;
BEGIN
  -- ��ȡ���º�Ľ�������
  v_borrownumber := :NEW.borrownumber;
  
  -- �����������Ƿ�Ϊ 0
  IF v_borrownumber = 0 THEN
    -- ���¶�Ӧ�� BorrowOrder ��Ľ���״̬
    UPDATE BorrowOrder
    SET borrowstate = '�ѹ黹'
    WHERE borrowID = :NEW.borrowID;
  END IF;
END;


--ԤԼʱ�Զ�ԤԼ��ϸ����+1����һ���ӵı���ǿ�ȱ�ı��
CREATE OR REPLACE TRIGGER yuyueyue_trigger
BEFORE INSERT ON PreOrderInfo
FOR EACH ROW
DECLARE
  v_max_preID INTEGER;
  v_count       INTEGER;
BEGIN
  -- ��ȡ���е������
  SELECT MAX(preID) INTO v_max_preID FROM PreOrderInfo;
  -- ���û�м�¼�������������Ϊ 0
  IF v_max_preID IS NULL THEN
    v_max_preID := 0;
  END IF;
  -- ����Ƿ���ڿ�ȱ�ı��
  FOR i IN 1..v_max_preID + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM PreOrderInfo WHERE preID = i;
    IF v_count = 0 THEN
      :NEW.preID := i;
      RETURN;
    END IF;
  END LOOP;
  -- ���û���ҵ���ȱ�ı�ţ���ʹ������ż� 1
  :NEW.preID := v_max_preID + 1;
END;  


--ԤԼʱ�Զ�ԤԼ����+1����һ���ӵı���ǿ�ȱ�ı��
CREATE OR REPLACE TRIGGER yuyueyue_trigger1
BEFORE INSERT ON PreOrder
FOR EACH ROW
DECLARE
  v_max_preID INTEGER;
  v_count       INTEGER;
BEGIN
  -- ��ȡ���е������
  SELECT MAX(preID) INTO v_max_preID FROM PreOrder;
  -- ���û�м�¼�������������Ϊ 0
  IF v_max_preID IS NULL THEN
    v_max_preID := 0;
  END IF;
  -- ����Ƿ���ڿ�ȱ�ı��
  FOR i IN 1..v_max_preID + 1 LOOP
    SELECT COUNT(*) INTO v_count FROM PreOrder WHERE preID = i;
    IF v_count = 0 THEN
      :NEW.preID := i;
      RETURN;
    END IF;
  END LOOP;
  -- ���û���ҵ���ȱ�ı�ţ���ʹ������ż� 1
  :NEW.preID := v_max_preID + 1;
END;    



-- ԤԼ�洢����
CREATE OR REPLACE PROCEDURE PreBook (
    p_readernum IN INTEGER,
    p_booknum IN INTEGER,
    p_borrownumber IN INTEGER,
    p_borrowterm IN DATE
) AS
    v_stock INTEGER;
BEGIN
    -- ������Ƿ��㹻
    IF p_borrownumber > 0 THEN
        SELECT Stock INTO v_stock FROM Book WHERE Booknum = p_booknum;

        IF v_stock >= p_borrownumber THEN
            -- ���ٿ��
            UPDATE Book SET Stock = Stock - p_borrownumber WHERE Booknum = p_booknum;
        
            -- ����ԤԼ��ϸ���¼
            INSERT INTO PreOrderInfo (Booknum, prenumber)
            VALUES (p_booknum, p_borrownumber);
            
            -- ����ԤԼ������
            INSERT INTO PreOrder (readernum, predate, Buydate)
            VALUES (p_readernum, p_borrowterm, SYSDATE);
        
            -- �ύ����
            COMMIT;
        ELSE
            -- ��治�㣬�׳��쳣
            RAISE_APPLICATION_ERROR(-20001, '��治��');
        END IF;
    ELSE
        -- �Ƿ������������׳��쳣
        RAISE_APPLICATION_ERROR(-20002, '�Ƿ���������');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- �����쳣ʱ�ع�����
        ROLLBACK;
        -- �����׳��쳣
        RAISE;
END;


--ԤԼȡ���洢����
CREATE OR REPLACE PROCEDURE PreBookBack (
    p_preID IN INTEGER
) AS
    v_booknum INTEGER;
    v_bookid INTEGER;
BEGIN
    --ԤԼͼ����
    select prenumber into v_booknum from PreOrderInfo where preID = p_preID;
    --ԤԼ���
    select Booknum into v_bookid from PreOrderInfo where preID = p_preID;
    --���¿��
    update book
        SET Stock = Stock + v_booknum
        WHERE Booknum = v_bookid;
    --ɾ��ԤԼ��Ϣ����
    delete from PreOrder where preID = p_preID;
    delete from PreOrderInfo where preID = p_preID;
    --�ύ����
    commit;
END;


--���Ĵ洢����
CREATE OR REPLACE PROCEDURE BorrowBook (
    p_readernum IN INTEGER,
    p_booknum IN INTEGER,
    p_borrownumber IN INTEGER,
    p_borrowterm IN INTEGER
) AS
    v_stock INTEGER;
BEGIN
    -- ������Ƿ��㹻
    IF p_borrownumber > 0 THEN
        SELECT Stock INTO v_stock FROM Book WHERE Booknum = p_booknum;

        IF v_stock >= p_borrownumber THEN
            -- ���ٿ��
            UPDATE Book SET Stock = Stock - p_borrownumber WHERE Booknum = p_booknum;
        
            -- ������ļ�¼
            INSERT INTO BorrowDetail (Booknum, Borrownumber)
            VALUES (p_booknum, p_borrownumber);
            
            -- ������ı�����
            INSERT INTO BorrowOrder (readernum, borrowdate, borrowprice, borrowterm, borrowstate)
            VALUES (p_readernum, SYSDATE, '0', p_borrowterm, 'δ�黹');
        
            -- �ύ����
            COMMIT;
        ELSE
            -- ��治�㣬�׳��쳣
            RAISE_APPLICATION_ERROR(-20001, '��治��');
        END IF;
    ELSE
        -- �Ƿ������������׳��쳣
        RAISE_APPLICATION_ERROR(-20002, '�Ƿ���������');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- �����쳣ʱ�ع�����
        ROLLBACK;
        -- �����׳��쳣
        RAISE;
END;


-- ����洢����
CREATE OR REPLACE PROCEDURE ReturnBook (
    p_borrowID IN INTEGER,
    p_booknum IN INTEGER,
    p_returnnumber IN INTEGER
) AS
BEGIN
        -- ���½��ļ�¼
        UPDATE BorrowDetail
        SET borrownumber = borrownumber - p_returnnumber
        WHERE borrowID = p_borrowID;

        -- ���ӿ��
        UPDATE Book SET Stock = Stock + p_returnnumber WHERE Booknum = p_booknum;

        -- �ύ����
        COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- û���ҵ���Ӧ�Ľ��ļ�¼���׳��쳣
        RAISE_APPLICATION_ERROR(-20003, 'δ�ҵ���Ӧ�Ľ��ļ�¼');
    WHEN OTHERS THEN
        -- �����쳣ʱ�ع�����
        ROLLBACK;
        -- �����׳��쳣
        RAISE;
END;



--������������
CREATE OR REPLACE FUNCTION func1
RETURN NUMBER
IS
    total_stock1 NUMBER := 0;
    total_stock2 NUMBER := 0;
    total_stock3 NUMBER := 0;
    total_stock NUMBER := 0;
BEGIN
    -- ��ȡbook���е�stock��                       
    SELECT sum(stock) INTO total_stock1 FROM book;
    
    -- ��ȡPreOrderInfo���е�prenumber��
    SELECT sum(prenumber) INTO total_stock2 FROM PreOrderInfo;

    -- ��ȡBorrowDetail���е�borrownumber��
    SELECT sum(borrownumber) INTO total_stock3 FROM BorrowDetail;
    
    total_stock := total_stock1+total_stock2+total_stock3;

    RETURN total_stock;
END;




