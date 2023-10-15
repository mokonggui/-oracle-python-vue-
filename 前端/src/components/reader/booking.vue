<template>
  <el-tabs type="border-card" class="demo-tabs">
    <el-tab-pane>
      <template #label>
        <span class="custom-tabs-label">
          <el-icon><Check /></el-icon>
          <span>已借阅图书</span>
        </span>
      </template>

      <el-table :data="reactiveBorrows.data" style="width: 100%">
        <el-table-column prop="borrowId" label="借阅编号" width="80" />
        <el-table-column prop="userNumber" label="学号" width="80" />
        <el-table-column prop="borrowDate" label="借阅日期" width="140" />
        <el-table-column prop="price" label="图书价格" width="80" />
        <el-table-column prop="days" label="借阅天数" width="80" />
        <el-table-column prop="status" label="借阅状态" width="80" />
        <el-table-column prop="bookId" label="图书编号" width="80" />
        <el-table-column prop="sum" label="借阅数量" width="80" />
        <el-table-column fixed="right" label="操作" width="180">
          <template #default="scope">
            <el-button line size="small" :icon="Close" @click.prevent="repaidWindow(scope.$index)" disabled
              >归还图书</el-button>
          </template>
        </el-table-column>
      </el-table>

    </el-tab-pane>

    <el-tab-pane label="管理员">
      <template #label>
        <span class="custom-tabs-label">
          <el-icon><Message /></el-icon>
          <span>已预约图书</span>
        </span>
      </template>

      <el-table :data="reservationBook.data" style="width: 100%">
        <el-table-column prop="reservationId" label="预约单号" width="80" />
        <el-table-column prop="userNumber" label="学号" width="80" />
        <el-table-column prop="bookId" label="图书编号" width="80" />
        <el-table-column prop="orderDate" label="订单时间" width="140" />
        <el-table-column prop="reservationDate" label="预约时间" width="140" />
        <el-table-column prop="reservationNum" label="预约数量" width="80" />
        <el-table-column fixed="right" label="操作" width="180">
          <template #default="scope">
            <el-button line size="small" :icon="Close" @click.prevent="cancelReservationWindow(scope.$index)"
              >取消预约</el-button>
          </template>
        </el-table-column>
      </el-table>

    </el-tab-pane>
  </el-tabs>

  <el-dialog
    v-model="repaid"
    title="提示"
    width="30%"
    draggable
    style="text-align: center;"
  >
    <el-form>
      <el-form-item label="归还书籍数量" :label-width="labelWidth">
        <el-input type="number" v-model="repaidNum" autocomplete="off" />
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="repaid = false">取消</el-button>
        <el-button type="primary" @click="repaidBook">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>

  <el-dialog
    v-model="cancelReservation"
    title="提示"
    width="30%"
    draggable
  >
    <span>确定取消该预约？</span>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="cancelReservation = false">取消</el-button>
        <el-button type="primary" @click="cancelReservationBook">
          确定
        </el-button>
      </span>
    </template>
  </el-dialog>

</template>
  
<script setup lang="ts">
  import { reactive,ref } from 'vue';
  import { getUserBorrow,returnBook,getUserReservation,cancelBooking } from '@/api/book'
  import { Close } from '@element-plus/icons-vue'
  import useAccountStore from '@/store/modules/account';
  import { ElMessage } from 'element-plus'

  const accountStore = useAccountStore();

  const reactiveBorrows = reactive({data: [{
    borrowId: '',
    userNumber: '',
    borrowDate: '',
    price: '',
    days: '',
    status: '',
    bookId: '',
    sum: ''
  }]})

  const reservationBook = reactive({data: [{
    reservationId: '',
    userNumber: '',
    bookId: '',
    orderDate: '',
    reservationDate: '',
    reservationNum : '',
  }]})

  const update = async () => {
    try {
      reactiveBorrows.data = (await getUserBorrow(Number(accountStore.userNumber))).data
      reservationBook.data = (await getUserReservation(Number(accountStore.userNumber))).data
    } catch(err) {
      console.log(err)
    }
  }

  update()

  const labelWidth = '100px'
  const repaidNum = ref(1)
  const repaid = ref(false)
  const repaidId = ref('')
  const repaidIndex = ref(0)
  const repaidWindow = (index: number) => {
    repaidId.value = reactiveBorrows.data[index].borrowId
    repaidIndex.value = index
    repaidNum.value = 1
    repaid.value = true
  }

  const repaidBook = () => {
    if (repaidNum.value.toString() == '' || repaidNum.value <= 0 ||
      repaidNum.value > Number(reactiveBorrows.data[repaidIndex.value].sum)
    ) {
      ElMessage.error('请填写正确的归还数量')
      return
    }
    returnBook(repaidId.value, repaidNum.value).then(res => {
      ElMessage.success('归还成功')
      update()
    }).catch(err => {
      ElMessage.error('网络原因,归还失败')
    })
    repaid.value = false
  }

  
  const cancelReservation = ref(false)
  const cancelReservationId = ref('')
  const cancelReservationWindow = (index: number) => {
    cancelReservationId.value = reservationBook.data[index].reservationId
    cancelReservation.value = true
  }

  const cancelReservationBook = () => {
    cancelBooking(Number(cancelReservationId.value)).then(res => {
      ElMessage.success('取消预约成功')
      update()
    }).catch(err => {
      ElMessage.error('网络原因,取消预约失败')
    })
    cancelReservation.value = false
  }
  
</script>
  
<style scoped>
.dialog-footer button:first-child {
  margin-right: 10px;
} 
</style>