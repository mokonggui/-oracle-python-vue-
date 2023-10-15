import request from "@/utils/request";


//查看管理员信息
export const getAdmin = () => request({
    url: '/admin/get',
    method: 'get',
})