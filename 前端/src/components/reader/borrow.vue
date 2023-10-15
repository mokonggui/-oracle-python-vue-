<template>
  <div class="box">
    <span class="item">查询图书：</span>
    <el-input v-model="input" placeholder="请输入图书名称" class="item" />
    <el-button type="primary" @click="searchBook" class="item">
      确定
    </el-button>
  </div>
  
  <el-table :data="reactiveBooks.data" style="width: 100%">
    <el-table-column prop="bookId" label="图书编号" width="90" />
    <el-table-column prop="bookName" label="图书名称" width="90" />
    <el-table-column prop="author" label="作者" width="90" />
    <el-table-column prop="publish" label="出版社" width="180" />
    <el-table-column prop="price" label="价格" width="90" />
    <el-table-column prop="stock" label="库存" width="90" />
    <el-table-column prop="category" label="分类" width="90" />
    <el-table-column fixed="right" label="操作" width="180">
      <template #default="scope">
        <el-button line size="small" :icon="Check" @click.prevent="borrowWindow(scope.$index)"
          >借阅
        </el-button>
        <el-button line size="small" :icon="Calendar" @click.prevent="bookingWindow(scope.$index)"
          >预约
        </el-button>
      </template>
    </el-table-column>
  </el-table>

  <el-dialog v-model="borrow" title="借阅图书" style="text-align: center;width: 300px;" draggable>
    <el-form :model="variable">
      <el-form-item label="借阅数量" :label-width="labelWidth">
        <el-input type="number" v-model="variable.borrowNum" autocomplete="off" style="width: 180px;"/>
      </el-form-item>
      <el-form-item label="借阅天数" :label-width="labelWidth">
        <el-input type="number" v-model="variable.borrowDays" autocomplete="off" style="width: 180px;"/>
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="borrow = false">取消</el-button>
        <el-button type="primary" @click="borrowBooks">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>

  <el-dialog v-model="booking" title="预约图书" style="text-align: center;width: 300px;" draggable>
    <el-form >
      <el-form-item label="预约数量" :label-width="labelWidth">
        <el-input type="number" v-model="bookingNum" autocomplete="off" style="width: 180px;"/>
      </el-form-item>
      <el-form-item label="预约时间" :label-width="labelWidth">
        <div class="block" >
          <el-date-picker 
            v-model="bookingDate"
            type="date"
            placeholder="选择一个日期"
            :size="size"
            style="width: 180px;"
          />
        </div>
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="booking = false">取消</el-button>
        <el-button type="primary" @click="bookingBook">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>
</template>
  
<script setup lang="ts">
  import { reactive,ref } from 'vue'
  import { getBook,borrowBook,reservationBook } from '@/api/book'
  import { Check,Calendar } from '@element-plus/icons-vue'
  import { ElMessage } from 'element-plus'
  import useAccountStore from '@/store/modules/account';

  const accountStore = useAccountStore();
  let books = [{
    bookId: '',
    bookName: '',
    author: '',
    publish: '',
    price: '',
    stock: '',
    category: ''
  }]
  let reactiveBooks = reactive({data: [{
    bookId: '',
    bookName: '',
    author: '',
    publish: '',
    price: '',
    stock: '',
    category: ''
  }]})

  const input = ref('')
  const searchBook = () => {

    reactiveBooks.data = reactive(books.filter(item => {
      if (input.value == '') {
        return item
      }
      return item.bookName.indexOf(input.value) != -1
    }))
  }
  const update = async () => {
    try {
      books = (await getBook()).data
      reactiveBooks.data = books
      searchBook()
    } catch(err) {
      console.log(err)
    }
  }
  update()

  const labelWidth = '70px'
  const borrow = ref(false)
  const borrowId = ref('')
  const variable = reactive({
    borrowNum: '',
    borrowDays: ''
  })
  const borrowWindow = (index: number) => {
    borrowId.value = reactiveBooks.data[index].bookId
    variable.borrowNum = ''
    variable.borrowDays = ''
    borrow.value = true
  }
  const borrowBooks = () => {
    if (variable.borrowNum == '' || variable.borrowDays == '' ||
        Number(variable.borrowNum) <= 0 || Number(variable.borrowDays) <= 0) {
      ElMessage.error('请填写正确的数据')
      return
    }
    borrowBook(Number(borrowId.value), 
      Number(accountStore.userNumber), 
      Number(variable.borrowNum), 
      Number(variable.borrowDays)
    ).then(res => {
      if (res.data == 'ok'){
        ElMessage.success('借阅成功')
        update()
      } else {
        ElMessage.error('借阅失败,库存不足')
      }
    }).catch(err => {
      ElMessage.error('网络原因,借阅失败')
    })
    borrow.value = false
  }

  const formatDate = (date: Date) => [
    date.getFullYear(),
    (date.getMonth() + 1).toString().padStart(2, '0'),
    (date.getDate()).toString().padStart(2, '0'),
  ].join('-')

  const size = 'default'
  const booking = ref(false)
  const bookingNum = ref(1)
  const bookingDate = ref<Date>()
  const bookingId = ref(0)
  const bookingIndex = ref(0)
  const bookingWindow = (index: number) => {
    bookingNum.value = 1
    bookingId.value = Number(reactiveBooks.data[index].bookId)
    bookingIndex.value = index
    booking.value = true
  }
  const bookingBook = () => {
    if (bookingNum.value.toString() == '' || bookingNum.value <= 0 ||
        typeof bookingDate.value === "undefined" || 
        bookingDate.value == null) {
      ElMessage.error('请填写正确的数据')
      return
    }
    reservationBook(Number(accountStore.userNumber), 
      bookingId.value, 
      formatDate(bookingDate.value),
      bookingNum.value
    ).then(res => {
      if (res.data == 'ok'){
        ElMessage.success('预约成功')
        update()
      } else {
        ElMessage.error('预约失败,库存不足')
      }
    }).catch(err => {
      ElMessage.error('网络原因,预约失败')
    })
    booking.value = false
  }
</script>
  
<style scoped>
.box {
  display: flex;
  margin-top: 30px;
  margin-bottom: 30px;
}

.item {
  margin-left: 10px;
  margin-right: 10px;
  height: 30px;
  max-width: 200px;
}
.dialog-footer button:first-child {
  margin-right: 10px;
}
</style>