<template>
  <el-tabs type="border-card" class="demo-tabs">
    <el-tab-pane>
      <template #label>
        <span class="custom-tabs-label">
          <el-icon><User /></el-icon>
          <span>用户</span>
        </span>
      </template>

      <el-table :data="reactiveUsers.data" style="width: 100%">
        <el-table-column prop="userNumber" label="学号" width="80" />
        <el-table-column prop="name" label="姓名" width="60" />
        <el-table-column prop="age" label="年龄" width="60" />
        <el-table-column prop="sex" label="性别" width="60" />
        <el-table-column prop="address" label="居住地址" width="160" />
        <el-table-column prop="phone" label="联系方式" width="140" />
        <el-table-column prop="id" label="身份证号" width="180" />
        <el-table-column fixed="right" label="操作" width="180">
          <template #default="scope">
            <el-button line size="small" :icon="Edit" @click.prevent="editWindow(scope.$index)"
              >编辑</el-button>
            <el-button line size="small" :icon="Delete" @click.prevent="removeWindow(scope.$index)"
              >删除</el-button>
          </template>
        </el-table-column>
      </el-table>

    </el-tab-pane>

    <el-tab-pane label="管理员">
      <template #label>
        <span class="custom-tabs-label">
          <el-icon><UserFilled /></el-icon>
          <span>管理员</span>
        </span>
      </template>

      <el-table :data="admins.data" style="width: 100%">
        <el-table-column prop="adminNumber" label="工号" width="90" />
        <el-table-column prop="name" label="姓名" width="90" />
        <el-table-column prop="age" label="年龄" width="90" />
        <el-table-column prop="sex" label="性别" width="90" />
        <el-table-column prop="phone" label="联系方式" width="140" />
        <el-table-column prop="id" label="身份证号" width="180" />
        <el-table-column fixed="right" label="操作" width="180">
          <template #default="scope">
            <el-button line size="small" :icon="Edit" disabled
              >编辑</el-button>
            <el-button line size="small" :icon="Delete" disabled
              >删除</el-button>
          </template>
        </el-table-column>
      </el-table> 

    </el-tab-pane>
  </el-tabs>

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
      
      <span class="dialog-footer">
        <el-button @click="edit = false">取消</el-button>
        <el-button type="primary" @click="editUser">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>

  <el-dialog
    v-model="remove"
    title="提示"
    width="30%"
    draggable
  >
    <span>确定删除该用户的全部信息？</span>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="remove = false">取消</el-button>
        <el-button type="primary" @click="removeUser">
          确定
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>
  
<script setup lang="ts">
  import { ref, reactive } from 'vue';
  import { getUser } from '@/api/reader';
  import { Delete,Edit, } from '@element-plus/icons-vue'
  import { deleteUser,updateUser } from '@/api/reader'
  import { ElMessage } from 'element-plus'
  import { getAdmin } from '@/api/admin'

  let users = [{
    userNumber: '',
    name: '',
    age: '',
    sex: '',
    address: '',
    phone: '',
    id: ''
  }]
  let reactiveUsers = reactive({data: users})
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
      users = (await getUser()).data
      reactiveUsers.data = users
      admins.data = (await getAdmin()).data
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
  const editId = ref('')
  const editWindow = (index: number) => {
    editId.value = reactiveUsers.data[index].userNumber
    variable.value.userNumber = reactiveUsers.data[index].userNumber
    variable.value.name = reactiveUsers.data[index].name
    variable.value.age = reactiveUsers.data[index].age
    variable.value.sex = reactiveUsers.data[index].sex
    variable.value.address = reactiveUsers.data[index].address
    variable.value.phone = reactiveUsers.data[index].phone
    variable.value.id = reactiveUsers.data[index].id
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


  const remove = ref(false)
  const removeId = ref('')
  const removeWindow = (index: number) => {
    removeId.value = reactiveUsers.data[index].userNumber
    remove.value = true
  }
  const removeUser = () => {
    deleteUser(removeId.value).then(res => {
      update()
      ElMessage.success('删除成功')
    }).catch(err => {
      ElMessage.error('网络原因,删除失败')
    })
    remove.value = false
  }
  
</script>
  
<style scoped>
.demo-tabs > .el-tabs__content {
  padding: 32px;
  color: #6b778c;
  font-size: 32px;
  font-weight: 600;
}
.demo-tabs .custom-tabs-label .el-icon {
  vertical-align: middle;
}
.demo-tabs .custom-tabs-label span {
  vertical-align: middle;
  margin-left: 4px;
}
</style>