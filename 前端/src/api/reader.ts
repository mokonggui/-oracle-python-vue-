import request from "@/utils/request";

//获取用户信息
export const getUser = () => request({
    url: '/user/get',
    method: 'get',
})

//获取用户的总数量
export const getUserNum = () => request({
    url: '/user/sum',
    method: 'get',
})

//删除用户
export const deleteUser = (userNumber: string) => request({
    url: '/user/delete',
    method: 'post',
    data: {
        userNumber
    }
})

//修改用户信息
export const updateUser = (userNumber: string, name: string,
        age: number, sex: string,
        address: string, phone: string, id: string) => request({

    url: '/user/update',
    method: 'post',
    data: {
        userNumber,
        name,
        age,
        sex,
        address,
        phone,
        id
    }
})

//获取个人信息
export const getReaderInfo = (userNumber: number) => request({
    url: '/user/info',
    method: 'post',
    data: {
        userNumber
    }
})