import request from "@/utils/request";

//添加图书
export const addBook = (bookName: string, author: string, 
    publish: string, price: number, stock: number, category: string) => request({
    url: '/book/add',
    method: 'post',
    data: {
        bookName,
        author,
        publish,
        price,
        stock,
        category,
    },
})

//删除图书
export const deleteBook = (bookId: number) => request({
    url: '/book/delete',
    method: 'post',
    data: {
        bookId,
    },
})

//修改图书
export const updateBook = (bookID: number, bookname: string, author: string, 
        publish: string, price: number, stock: number, category: string) => request({
    url: '/book/update',
    method: 'post',
    data: {
        bookID,
        bookname,
        author,
        publish,
        price,
        stock,
        category,
    },
})

//查看图书列表
export const getBook = () => request({
    url: '/book/get',
    method: 'get',
})

//获取图书的总数量
export const getBookNum = () => request({
    url: '/book/sum',
    method: 'get',
})


//借阅书籍
export const borrowBook = (bookID: number, userNumber: number, num: number, days: number) => request({
    url: '/book/borrow',
    method: 'post',
    data: {
        bookID,
        userNumber,
        num,
        days,
    },
})

//查看借阅列表
export const getBorrow = () => request({
    url: '/book/borrow/get',
    method: 'get',
})

//归还书籍
export const returnBook = (borrowId: string ,borrowNum: number) => request({
    url: '/book/borrow/return',
    method: 'post',
    data: {
        borrowId,
        borrowNum,
    },
})

//预约书籍 
export const reservationBook = (userNumber: number, bookId: number,
        bookingDate: string, bookingNum: number) => request({
    url: '/book/booking',
    method: 'post',
    data: {
        userNumber,
        bookId,
        bookingDate,
        bookingNum,
    },
})

//查看个人借阅
export const getUserBorrow = (userNumber: number) => request({
    url: '/book/borrow/user',
    method: 'post',
    data: {
        userNumber,
    },
})

//查看预约列表
export const getReservation = () => request({
    url: '/book/booking/get',
    method: 'post',
})

//查看个人预约
export const getUserReservation = (userNumber: number) => request({
    url: '/book/booking/user',
    method: 'post',
    data: {
        userNumber,
    },
})

//取消预约
export const cancelBooking = (reservationId: number) => request({
    url: '/book/booking/cancel',
    method: 'post',
    data: {
        reservationId,
    },
})

//获取预约总数量
export const getReservationNum = () => request({
    url: '/book/booking/sum',
    method: 'get',
})