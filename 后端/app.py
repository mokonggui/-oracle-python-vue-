import sys
from flask import Flask, request
import cx_Oracle
import datetime
# 连接到Oracle数据库
conn = cx_Oracle.connect('system/manager@DESKTOP-5GGP7N0:1521/ORCL')
# 创建游标
cur = conn.cursor()

class Fun:
    # 取消预约
    def yuyue2(self, ID):
        try:
            # 调用预约取消存储过程
            cur.callproc('PreBookBack', [ID])
            conn.commit()
            # 存储过程执行成功，将结果存储在result中
            result = 'ok'
        except Exception as e:
            # 存储过程抛出异常，将异常信息存储在result中
            result = 'err'
        return result


    # 获取个人信息
    def massage(self, userNum):
        # 执行查询，获取"Book"表的数据
        query = f"SELECT * FROM ReaderInformationView  where Readernum={userNum}"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 删除用户
    def delete_user(self, ID1):
        query = f"delete from ReaderInfo where Readernum={ID1}"
        cur.execute(query)
        conn.commit()
        query = f"delete from AccountInfo where ID={ID1}"
        cur.execute(query)
        conn.commit()

    # 查看用户数量
    def look_yonghu(self):
        query = "select count(ID) from AccountInfo"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看预约数量
    def look_booking(self):
        query = "select count(preID) from PreOrderInfo"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看图书总数量
    def look_shu(self):
        # 执行函数调用
        cur.execute("SELECT func1() FROM dual")
        books = cur.fetchone()
        return books

    # 查看借阅
    def look_jieyue(self):
        query = "select * from BorrowOrder B join  BorrowDetail B1 on b.borrowID=B1.borrowID ORDER BY b.borrowID ASC"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看个人借阅
    def one_jieyue(self, ID):
        query = f"select * from BorrowOrder B join  BorrowDetail B1 on b.borrowID=B1.borrowID where B.readernum={ID} and borrowstate='未归还' ORDER BY b.borrowID ASC"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看个人预约
    def one_yuyue(self, ID):
        query = f"select * from PreOrder P join  PreOrderInfo P1 on P.preID=P1.preID where p.readernum={ID} ORDER BY P.preID ASC"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看预约
    def look_yuyue(self):
        query = "select * from PreOrder P join  PreOrderInfo P1 on P.preID=P1.preID ORDER BY P.preID ASC"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 借阅
    def jieyue(self, a1, a2, a3, a4):
        try:
            # 调用存储过程
            cur = conn.cursor()
            cur.callproc('BorrowBook', [a1, a2, a3, a4])
            conn.commit()
            # 存储过程执行成功，将结果存储在result中
            return 'ok'
        except Exception as e:
            # 存储过程抛出异常，将异常信息存储在result中
            return 'err'

    # 预约
    def yuyue(self, a1, a2, a3, a4):
        try:
            # 调用存储过程
            cur = conn.cursor()
            date = datetime.datetime.strptime(a4, "%Y-%m-%d")
            cur.callproc('PreBook', [a1, a2, a3, date])
            conn.commit()
            # 存储过程执行成功，将结果存储在result中
            result = 'ok'
        except Exception as e:
            # 存储过程抛出异常，将异常信息存储在result中
            result = 'err'
        return result

    # 借阅还书
    def huanshu(self, a1, a3):
        cur = conn.cursor()
        query = f"select Booknum from BorrowDetail where borrowID={a1}"
        cur.execute(query)
        books = cur.fetchall()
        a2 = books[0][0]
        cur.callproc('ReturnBook', [a1, a2, a3])
        conn.commit()

    # 添加用户
    def add_person(self, ID1, book_info):
        cur = conn.cursor()
        query = f"select ID from AccountInfo where ID = {ID1}"
        cur.execute(query)
        results1 = cur.fetchall()
        if results1:
            return 'err'
        else:
            # 将用户信息插入到数据库中
            query = "INSERT INTO AccountInfo (aname, ID, password) VALUES (:aname, :ID, :password)"
            cur.execute(query, book_info)
            conn.commit()
            # 用户表初始化
            query = "INSERT INTO ReaderInfo (Readernum) VALUES (:Readernum)"
            cur.execute(query, {'Readernum': ID1})
            conn.commit()
            return 'ok'

    # 添加管理员信息
    def add_admin_massage(self, book_info):
        # 将用户信息插入到数据库中
        query = "INSERT INTO AdminInfo (Adminum, Adminame, Admisex, Age, AdmiID, Alinkway) VALUES (:Adminum, :Adminame, :Admisex, :Age, :AdmiID, :Alinkway)"
        cur.execute(query, book_info)
        conn.commit()

    # 添加读者信息
    def add_user_massage(self, book_info):
        # 将用户信息插入到数据库中
        query = "INSERT INTO ReaderInfo (Readernum, ReaderName, Readersex, Address, Linkway, ReaderAge, Readerid) VALUES (:Readernum, :ReaderName, :Readersex, :Address, :Linkway, :ReaderAge, :Readerid)"
        cur.execute(query, book_info)
        conn.commit()

    # 添加书籍
    def add_book(self, book_info):
        # 将图书信息插入到数据库中
        query = "INSERT INTO BOOK (Bookname, author, Publish, Price, Stock, Category) VALUES (:Bookname, :author, :Publish, :Price, :Stock, :Category)"
        cur.execute(query, book_info)
        # 数据库也修改
        conn.commit()

     # 修改书籍
    def modify_books(self, a1, a2, a3, a4, a5, a6, a7):
        # 将图书信息插入到数据库中
        query = f"update BOOK set Bookname='{a2}', author='{a3}', Publish='{a4}', Price={a5}, Stock={a6}, Category='{a7}' where Booknum={a1}"
        cur.execute(query)
        # 数据库也修改
        conn.commit()

    # 修改管理员信息
    def modify_admin(self, a1, a2, a3, a4, a5, a6):
        # 将图书信息插入到数据库中
        query = f"update AdminInfo set Adminame='{a2}', Admisex='{a3}', Age={a4}, AdmiID='{a5}', Alinkway='{a6}' where Adminum={a1}"
        cur.execute(query)
        # 数据库也修改
        conn.commit()

    # 修改读者信息
    def modify_reader(self, a1, a2, a3, a4, a5, a6, a7):
        # 将图书信息插入到数据库中
        query = f"update ReaderInfo set ReaderName='{a2}', Readersex='{a3}', Address='{a4}', Linkway='{a5}', ReaderAge='{a6}', Readerid='{a7}' where Readernum={a1}"
        cur.execute(query)
        # 数据库也修改
        conn.commit()


    # 删除书籍
    def delete_books(self, a1):
        # 将图书信息插入到数据库中
        query = f"delete from book where Booknum={a1}"
        cur.execute(query)
        # 数据库也修改
        conn.commit()

    # 查看图书/用户
    def view_looks(self, table, asc):
        # 执行查询，获取"Book"表的数据
        query = f"SELECT * FROM {table} ORDER BY {asc} ASC"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 查看一本书
    def book_check(self, book_id):
        # 执行查询，获取"Book"表的数据
        query = f"SELECT * FROM book where Booknum= {book_id}"
        cur.execute(query)
        books = cur.fetchall()
        return books

    # 修改密码
    def fun5(self, a1, a2, a3, a4):
        # 执行查询
        query = f"SELECT password FROM AccountInfo WHERE ID = {a1}"
        cur.execute(query)
        # 获取查询结果,返回所有行,为列表
        results = cur.fetchall()
        # 密码验证
        if results and a2 == results[0][0]:
           if a3 == a4:
                query = f"update AccountInfo set password ={a3} WHERE ID = {a1}"
                cur.execute(query)
                conn.commit()
                return 'ok'
           else:
               error = '新密码与确认密码不一致'
               return error
        else:
            error = '账号或者密码错误'
            return error

    # 修改用户信息判定
    def modify_person(self, ID, password):
        # 执行查询
        query = f"SELECT password FROM AccountInfo WHERE ID = {ID}"
        cur.execute(query)
        # 获取查询结果,返回所有行,为列表
        results = cur.fetchall()
        query1 = f"SELECT power FROM AccountInfo WHERE ID = {ID}"
        cur.execute(query1)
        results1 = cur.fetchall()
        # 密码验证
        if results and password == results[0][0]:
            # 管理员验证
            if results1 and (results1[0][0] == "Y" or results1[0][0] == "y"):
                return 1
            # 进入读者页面
            else:
                return 0
        else:
            error = '账号或者密码错误'
            return error

    # 登录验证
    def fun4(self, a1, a2, a3):
        # 执行查询
        query = f"SELECT password FROM AccountInfo WHERE ID = {a1}"
        cur.execute(query)
        # 获取查询结果,返回所有行为列表
        results = cur.fetchall()
        query1 = f"SELECT power FROM AccountInfo WHERE ID = {a1}"
        cur.execute(query1)
        results1 = cur.fetchall()
        if a3 == 'admin':
            a3 = 'Y'
        else:
            a3 = 'N'
        # 密码验证
        if results and a2 == results[0][0]:
            # 验证
            if a3 == results1[0][0]:
                return a1
            else:
                return 'err'
        else:
            return 'err'

    # 关闭路由
    def close(self):
        # 关闭游标和数据库连接
        cur.close()
        conn.close()
        sys.exit()

app = Flask(__name__)


# 登录
@app.route('/api/account/login', methods=['POST'])
def login():
    username = request.form.get('username')
    username = int(username)
    password = request.form.get('password')
    power = request.form.get('power')
    sum = Fun().fun4(username, password, power)
    sum = str(sum)
    return sum


# 注册
@app.route('/api/account/register', methods=['post'])
def register():
    username = request.form.get('username')
    ID = request.form.get('id')
    password = request.form.get('password')
    books = Fun().add_person(ID, (username, ID, password))
    return books


# 查看管理员
@app.route('/api/admin/get', methods=['GET'])
def adminCheck():
    books = Fun().view_looks('AdminInformationView', 'Adminum')
    results = []
    for row in books:
        book = {}
        book['adminNumber'] = row[0]
        book['name'] = row[1]
        book['age'] = row[2]
        book['sex'] = row[3]
        book['phone'] = row[4]
        book['aname'] = row[5]
        book['id'] = row[6]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 添加图书
@app.route('/api/book/add', methods=['POST'])
def addBook():
    book_name = request.form.get('bookName')
    author = request.form.get('author')
    publish = request.form.get('publish')
    price = request.form.get('price')
    stock = request.form.get('stock')
    category = request.form.get('category')
    Fun().add_book((book_name, author, publish, price, stock, category))
    return 'ok'

# 删除书籍
@app.route('/api/book/delete', methods=['GET', 'POST'])
def delete_book():
    book_id = request.form.get('bookId')
    Fun().delete_books(book_id)
    return 'ok'


# 修改图书
@app.route('/api/book/update', methods=['POST'])
def updateBook():
    book_id = request.form.get('bookID')
    book_name = request.form.get('bookname')
    author = request.form.get('author')
    publish = request.form.get('publish')
    price = request.form.get('price')
    stock = request.form.get('stock')
    category = request.form.get('category')
    Fun().modify_books(book_id, book_name, author, publish, price, stock, category)
    return 'ok'

# 查看所有书籍信息
@app.route('/api/book/get', methods=['GET', 'POST'])
def getBook():
    books = Fun().view_looks('book', 'Booknum')
    results = []
    for row in books:
        book = {}
        book['bookId'] = row[0]
        book['bookName'] = row[1]
        book['author'] = row[2]
        book['publish'] = row[3]
        book['price'] = row[4]
        book['stock'] = row[5]
        book['category'] = row[6]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 书籍数量
@app.route('/api/book/sum', methods=['GET', 'POST'])
def book_num():
    books = Fun().look_shu()
    books = str(books[0])
    return books

# 借阅
@app.route('/api/book/borrow', methods=['POST'])
def jieyue():
    # 获取表单数据
    ID = request.form.get('userNumber')
    Booknum = request.form.get('bookID')
    num = request.form.get('num')
    date = request.form.get('days')
    aa = Fun().jieyue(ID, Booknum, num, date)
    return aa

# 查看借阅列表
@app.route('/api/book/borrow/get', methods=['GET'])
def getBorrow():
    books = Fun().look_jieyue()
    results = []
    for row in books:
        book = {}
        book['borrowId'] = row[0]
        book['userNumber'] = row[1]
        book['borrowDate'] = row[2].strftime("%Y-%m-%d")
        book['price'] = row[3]
        book['days'] = row[4]
        book['status'] = row[5]
        book['bookId'] = row[7]
        book['sum'] = row[8]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 借阅还书
@app.route('/api/book/borrow/return', methods=['POST'])
def huanshu():
    # 获取表单数据
    ID = request.form.get('borrowId')
    num = request.form.get('borrowNum')
    Fun().huanshu(ID, num)
    return 'ok'

# 预约
@app.route('/api/book/booking', methods=['POST'])
def yuyue():
    # 获取表单数据
    ID = request.form.get('userNumber')
    Booknum = request.form.get('bookId')
    num = request.form.get('bookingNum')
    date = request.form.get('bookingDate')
    sum = Fun().yuyue(ID, Booknum, num, date)
    return sum

# 查看个人借阅
@app.route('/api/book/borrow/user', methods=['post'])
def getBorrow2():
    reader_id = request.form.get('userNumber')
    books = Fun().one_jieyue(reader_id)
    results = []
    for row in books:
        book = {}
        book['borrowId'] = row[0]
        book['userNumber'] = row[1]
        book['borrowDate'] = row[2].strftime("%Y-%m-%d")
        book['price'] = row[3]
        book['days'] = row[4]
        book['status'] = row[5]
        book['bookId'] = row[7]
        book['sum'] = row[8]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 查看预约
@app.route('/api/book/booking/get', methods=['POST'])
def getReserve():
    books = Fun().look_yuyue()
    results = []
    for row in books:
        book = {}
        book['reservationId'] = row[0]
        book['userNumber'] = row[1]
        book['reservationDate'] = row[2].strftime("%Y-%m-%d")
        book['orderDate'] = row[3].strftime("%Y-%m-%d")
        book['bookId'] = row[5]
        book['reservationNum'] = row[6]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 查看个人预约
@app.route('/api/book/booking/user', methods=['POST'])
def getReserve1():
    reader_id = request.form.get('userNumber')
    books = Fun().one_yuyue(reader_id)
    results = []
    for row in books:
        book = {}
        book['reservationId'] = row[0]
        book['userNumber'] = row[1]
        book['reservationDate'] = row[2].strftime("%Y-%m-%d")
        book['orderDate'] = row[3].strftime("%Y-%m-%d")
        book['bookId'] = row[5]
        book['reservationNum'] = row[6]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 预约取消
@app.route('/api/book/booking/cancel', methods=['POST'])
def huanshu2():
    # 获取表单数据
    ID = request.form.get('reservationId')
    sum = Fun().yuyue2(ID)
    return sum


# 预约数量
@app.route('/api/book/booking/sum', methods=['GET', 'POST'])
def booking_num():
    bs2 = Fun().look_booking()
    bs2 = str(bs2[0][0])
    return bs2

# 查看用户信息
@app.route('/api/user/get', methods=['GET', 'POST'])
def get_user():
    books = Fun().view_looks('ReaderInformationView', 'Readernum')
    results = []
    for row in books:
        book = {}
        book['userNumber'] = row[0]
        book['name'] = row[1]
        book['age'] = row[2]
        book['sex'] = row[3]
        book['address'] = row[4]
        book['phone'] = row[5]
        book['aname'] = row[6]
        book['id'] = row[7]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
    return results

# 用户数量
@app.route('/api/user/sum', methods=['GET', 'POST'])
def user_num():
    bs = Fun().look_yonghu()
    bs = str(bs[0][0])
    return bs

# 删除用户
@app.route('/api/user/delete', methods=['POST'])
def deleteUsers():
    ID = request.form.get('userNumber')
    Fun().delete_user(ID)
    return 'ok'

# 修改读者信息
@app.route('/api/user/update', methods=['POST'])
def modify_reader():
    reader_num = request.form.get('userNumber')
    reader_name = request.form.get('name')
    reader_sex = request.form.get('sex')
    address = request.form.get('address')
    linkway = request.form.get('phone')
    reader_age = request.form.get('age')
    reader_id = request.form.get('id')
    Fun().modify_reader(reader_num, reader_name, reader_sex, address, linkway, reader_age, reader_id)
    return 'ok'

# 获取个人信息
@app.route('/api/user/info', methods=['POST'])
def getInfo():
    Readernum = request.form.get('userNumber')
    books = Fun().massage(Readernum)
    results = []
    for row in books:
        book = {}
        book['userNumber'] = row[0]
        book['username'] = row[1]
        book['age'] = row[2]
        book['sex'] = row[3]
        book['address'] = row[4]
        book['phone'] = row[5]
        book['aname'] = row[6]
        book['id'] = row[7]
        # 添加更多的键值对，根据表的列名和数据位置进行对应
        results.append(book)
        sum = results[0]
    return sum

if __name__ == '__main__':
    app.run(debug=True)
