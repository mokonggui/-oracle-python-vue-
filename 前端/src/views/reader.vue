<template>
  <el-container class="layout-container-demo">
    <el-container class="box">

      <el-col :span="3" class="item" style="height: 100%">
        <h3 class="mb-2" style="text-align: center;">图书借阅系统</h3>
        <el-menu
        default-active="1"
        class="el-menu-vertical-demo"
        >
          <el-menu-item index="1" @click="jump('/home')" >
            <el-icon><House /></el-icon>
            <span>主页</span>
          </el-menu-item>

          <el-menu-item index="2" @click="jump('/adminlist')" v-if="accountStore.isInfoComplete">
            <el-icon><User /></el-icon>
            <span>查看管理员</span>
          </el-menu-item>
          <el-menu-item index="2" @click="jump('/adminlist')" v-else disabled>
            <el-icon><User /></el-icon>
            <span>查看管理员</span>
          </el-menu-item>

          <el-menu-item index="3" @click="jump('/borrow')" v-if="accountStore.isInfoComplete">
            <el-icon><Reading /></el-icon>
            <span>借阅书籍</span>
          </el-menu-item>
          <el-menu-item index="3" @click="jump('/borrow')" v-else disabled>
            <el-icon><Reading /></el-icon>
            <span>借阅书籍</span>
          </el-menu-item>

          <el-menu-item index="4" @click="jump('/booking')" v-if="accountStore.isInfoComplete">
            <el-icon><Notebook /></el-icon>
            <span>查看借阅</span>
          </el-menu-item>
          <el-menu-item index="4" @click="jump('/booking')" v-else disabled>
            <el-icon><Notebook /></el-icon>
            <span>查看借阅</span>
          </el-menu-item>
        </el-menu>
      </el-col>
    
      <el-scrollbar class="item" style="height: 612px;width: 100%">
        <router-view></router-view>
      </el-scrollbar>  
  
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
  import { useRouter } from 'vue-router';
  import useAccountStore from '@/store/modules/account'
  import { ElMessage } from 'element-plus'

  const accountStore = useAccountStore()
  const router = useRouter();

  const jump = (path: string) => {
    if (accountStore.isInfoComplete == false) {
      ElMessage.error('请先完善个人信息')
      router.push('/' + accountStore.username + '/home')
    } else {
      router.push('/' + accountStore.username + path)
    }
  }
  jump('/home')
</script>

<style scoped>
.box {
display: flex;
margin-top: 30px;
margin-bottom: 30px;
}
.item {
margin-left: 30px;
margin-right: 30px;
border: 1px solid #eee;
border-radius: 5px;
}
</style>