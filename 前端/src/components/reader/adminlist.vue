<template>
  <el-table :data="admins.data" style="width: 100%">
    <el-table-column prop="adminNumber" label="工号" width="90" />
    <el-table-column prop="name" label="姓名" width="90" />
    <el-table-column prop="age" label="年龄" width="90" />
    <el-table-column prop="sex" label="性别" width="90" />
    <el-table-column prop="phone" label="联系方式" width="120" />
    <el-table-column prop="id" label="身份证号" width="180" />
  </el-table> 

</template>

<script setup lang="ts">
  import { reactive } from 'vue'
  import { getAdmin } from '@/api/admin'

  const admins = reactive({data: [{
    adminNumber: '',
    name: '',
    age: '',
    sex: '',
    phone: '',
    id: ''
  }]})
  const update = async () => {
    try {
      admins.data = (await getAdmin()).data
    } catch(err) {
      console.log(err)
    }
  }

  update()


</script>

<style scoped>


</style>