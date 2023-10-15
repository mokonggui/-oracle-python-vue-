<template>
  <p style="text-align: center;">welcome</p>
  <el-divider border-style="dashed"/>

  <el-descriptions
    class="margin-top"
    title="个人信息"
    :column="3"
    :size="size"
    style="margin-left: 20px;margin-right: 20px;"
    border
  >
    <template #extra>
      <el-button type="primary" @click="editWindow">
        <el-icon class="is-loading"><Refresh /></el-icon>
        修改个人信息
      </el-button>
    </template>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><CreditCard /></el-icon>
          学号
        </div>
      </template>
      {{ info.data.userNumber }}
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><user /></el-icon>
          姓名
        </div>
      </template>
      {{ info.data.username }}
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><Calendar /></el-icon>
          年龄
        </div>
      </template>
      {{ info.data.age }}
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><Male /></el-icon>
          性别
        </div>
      </template>
      <el-tag size="small" v-if="info.data.sex">{{ info.data.sex }}</el-tag>
      <div v-else>{{ info.data.sex }}</div>
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><iphone /></el-icon>
          联系方式
        </div>
      </template>
      {{ info.data.phone }}
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><Postcard /></el-icon>
          身份证号
        </div>
      </template>
      {{ info.data.id }}
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><tickets /></el-icon>
          备注
        </div>
      </template>
      <el-tag size="small">School</el-tag>
    </el-descriptions-item>

    <el-descriptions-item>
      <template #label>
        <div class="cell-item">
          <el-icon><office-building /></el-icon>
          居住地址
        </div>
      </template>
      {{ info.data.address }}
    </el-descriptions-item>

  </el-descriptions>

  <el-dialog v-model="edit" title="修改用户信息" style="text-align: center;" draggable>
    <el-form :model="variable">
      <el-form-item label="姓名" :label-width="labelWidth">
        <el-input v-model="variable.name" autocomplete="off" />
      </el-form-item>
      <el-form-item label="年龄" :label-width="labelWidth">
        <el-input type="number" v-model="variable.age" autocomplete="off" />
      </el-form-item>
      <el-form-item label="性别" :label-width="labelWidth">
        <el-input v-model="variable.sex" autocomplete="off" />
      </el-form-item>
      <el-form-item label="居住地址" :label-width="labelWidth">
        <el-input v-model="variable.address" autocomplete="off" />
      </el-form-item>
      <el-form-item label="联系方式" :label-width="labelWidth">
        <el-input type="number" v-model="variable.phone" autocomplete="off" />
      </el-form-item>
      <el-form-item label="身份证号" :label-width="labelWidth">
        <el-input type="number" v-model="variable.id" autocomplete="off" />
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="edit = false">取消</el-button>
        <el-button type="primary" @click="editUser">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>

</template>
  
<script setup lang="ts">
  import { ref,reactive } from 'vue'
  import { getReaderInfo,updateUser } from '@/api/reader'
  import useAccountStore from '@/store/modules/account';
  import { ElMessage } from 'element-plus'

  const accountStore = useAccountStore()

  const size = "large"
  const info = reactive({data: {
    userNumber:  '',
    username: '',
    age: '',
    sex: '',
    address: '',
    phone: '',
    id: ''
  }})

  const update = async () => {
    try {
      info.data = (await getReaderInfo(Number(accountStore.userNumber))).data
      if (info.data.userNumber == null || info.data.username == null || info.data.age == null || 
        info.data.sex == null || info.data.address == null || 
        info.data.phone == null || info.data.id == null) {
          accountStore.isInfoComplete = false
      } else {
        accountStore.isInfoComplete = true
      }
      console.log(info.data)
    } catch(err) {
      console.log(err)
    }
  }

  update()

  const variable = ref({
    userNumber: '',
    name: '',
    age: '',
    sex: '',
    address: '',
    phone: '',
    id: ''
  })
  const labelWidth = '140px'
  const edit = ref(false)
  const editWindow = (index: number) => {
    variable.value.userNumber = info.data.userNumber
    variable.value.name = info.data.username
    variable.value.age = info.data.age
    variable.value.sex = info.data.sex
    variable.value.address = info.data.address
    variable.value.phone = info.data.phone
    variable.value.id = info.data.id
    edit.value = true
  }
  const editUser = () => {
    if (variable.value.userNumber == '' || variable.value.name == '' || variable.value.age == '' || 
      variable.value.sex == '' || variable.value.address == '' || 
      variable.value.phone == '' || variable.value.id == ''
    ) {
      ElMessage.error('请填写完整信息')
      return
    }
    if (variable.value.sex != '男' && variable.value.sex != '女') {
      ElMessage.error('请填写正确的性别')
      return
    }
    if (variable.value.id.length != 18) {
      ElMessage.error('请填写正确的身份证号')
      return
    }
    updateUser(
      variable.value.userNumber,
      variable.value.name,
      Number(variable.value.age),
      variable.value.sex,
      variable.value.address,
      variable.value.phone,
      variable.value.id
    ).then(res => {
      update()
      ElMessage.success('修改成功')
    }).catch(err => {
      ElMessage.error('网络原因,修改失败')
    })
    edit.value = false
  }

</script>
  
<style scoped>
  
</style>