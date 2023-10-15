<template>
  <div class="box">
    <h3 class="item">登陆</h3>

    <el-input v-model="username" placeholder="请输入账户" class="item"/>

    <el-input
      v-model="password"
      type="password"
      placeholder="请输入密码"
      show-password
      class="item"
    />

    <div class="mb-2 flex items-center text-sm item">
      <el-radio-group v-model="userType" class="ml-4">
        <el-radio label="reader" size="large">用户</el-radio>
        <el-radio label="admin" size="large">管理员</el-radio>
      </el-radio-group>
    </div>
    
    <div class="item">
      <el-button type="success" @click="login" round style="width: 100px;">登陆</el-button>
      <el-button type="success" @click="register" round style="width: 100px;">注册</el-button>
    </div>
    
  </div>

  <el-dialog v-model="registered" title="账户注册" style="text-align: center;" draggable>
    <el-form :model="account">
      <el-form-item label="学号" :label-width="labelWidth">
        <el-input type="number" v-model="account.id" autocomplete="off" />
      </el-form-item>
      <el-form-item label="账户昵称" :label-width="labelWidth">
        <el-input v-model="account.username" autocomplete="off" />
      </el-form-item>
      <el-form-item label="密码" :label-width="labelWidth">
        <el-input v-model="account.password" autocomplete="off" />
      </el-form-item>
      <el-form-item label="确认密码" :label-width="labelWidth">
        <el-input v-model="account.passwordCheck" autocomplete="off" />
      </el-form-item>

      <span class="dialog-footer">
        <el-button @click="registered = false">取消</el-button>
        <el-button type="primary" @click="registerUser">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>
</template>
  
<script setup lang="ts">
  import { reactive, ref } from 'vue';
  import { accountLogin,accountRegister } from '@/api/account';
  import { useRouter } from 'vue-router';
  import useAccountStore from '@/store/modules/account';
  import { ElMessage } from 'element-plus'

  const router = useRouter();
  const accountStore = useAccountStore();
  const username = ref('');
  const password = ref('');
  const userType = ref('reader'); // 默认选择普通用户
  const labelWidth = '140px'
  
  
  const login = () => {
    if (username.value == '' || password.value == '') {
      ElMessage.error('请填写完整信息')
      return 
    }
    accountLogin(
      username.value, 
      password.value,
      userType.value
    ).then(res => {
      if (res.data != 'err') {
        accountStore.userNumber = res.data
        accountStore.username = username.value;
        accountStore.userType = userType.value;
        accountStore.isLogin = true;
        ElMessage.success('登陆成功')
        if (userType.value == 'reader') {
          router.push({ name: "reader", params: { username: username.value } });
        } else {
          router.push({ name: "admin", params: { username: username.value } });
        }
      } else {
        ElMessage.error('账户或密码错误')
      }
    }).catch(err => {
      ElMessage.error('网络原因,登陆失败')
    })
  }

  const account = reactive({
    id: '',
    username: '',
    password: '',
    passwordCheck: '',
    power: 'reader'
  })

  const registered = ref(false)
  const register = () => {
    account.id = ''
    account.username = ''
    account.password = ''
    account.passwordCheck = ''
    registered.value = true
  }

  const registerUser = () => {
    if (account.id == '' || account.username == '' || account.password == '' || account.passwordCheck == '') {
      ElMessage.error('请填写完整信息')
      return 
    }
    registered.value = false
    if (account.password != account.passwordCheck) {
      ElMessage.error('两次密码不一致')
      return 
    }
    accountRegister(account.id, account.username, account.password).then(res => {
      if (res.data == 'ok') {
        ElMessage.success('注册成功')
      }
      else {
        ElMessage.error('注册失败,该学号已注册')
      }
    }).catch(err => {
      ElMessage.error('网络原因,注册失败')
    })
  }
</script>
  
<style scoped>
.box {
  text-align: center;
  display: flex;
  flex-direction: column;
  width: 300px;
  margin: 100px auto;
  padding: 50px;
  border: 1px solid #eee;
  border-radius: 5px;
}

.item {
  margin: 10px 0;
}

</style>