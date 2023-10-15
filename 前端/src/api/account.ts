import request from "@/utils/request";

//账户登陆
export const accountLogin = (username: string, password: string, power: string) => request({
    url: '/account/login',
    method: 'post',
    data: {
        username,
        password,
        power,
    },
})

//账户注册
export const accountRegister = (id: string, username: string, password: string) => request({
    url: '/account/register',
    method: 'post',
    data: {
        id,
        username,
        password,
    },
})
