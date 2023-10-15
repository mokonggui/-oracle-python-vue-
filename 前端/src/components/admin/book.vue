<template>
  <div class="box">
    <span class="item">查询图书：</span>
    <el-input v-model="input" placeholder="请输入图书名称" class="item" />
    <el-button type="primary" @click="searchBook" class="item">
      确定
    </el-button>
    <el-button type="success" round @click="addWindow">添加图书</el-button>
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
        <el-button line size="small" :icon="Edit" @click.prevent="editWindow(scope.$index)"
          >编辑</el-button>
        <el-button line size="small" :icon="Delete" @click.prevent="removeWindow(scope.$index)"
          >删除</el-button>
      </template>
    </el-table-column>
  </el-table>

  <el-dialog v-model="edit" title="修改图书信息" style="text-align: center;" draggable>
    <el-form :model="variable">
      <el-form-item label="图书名称" :label-width="labelWidth">
        <el-input v-model="variable.bookName" autocomplete="off" />
      </el-form-item>
      <el-form-item label="作者" :label-width="labelWidth">
        <el-input v-model="variable.author" autocomplete="off" />
      </el-form-item>
      <el-form-item label="出版社" :label-width="labelWidth">
        <el-input v-model="variable.publish" autocomplete="off" />
      </el-form-item>
      <el-form-item label="价格" :label-width="labelWidth">
        <el-input type="number" v-model="variable.price" autocomplete="off" />
      </el-form-item>
      <el-form-item label="库存" :label-width="labelWidth">
        <el-input type="number" v-model="variable.stock" autocomplete="off" />
      </el-form-item>
      <el-form-item label="分类" :label-width="labelWidth">
        <el-input v-model="variable.category" autocomplete="off" />
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="edit = false">取消</el-button>
        <el-button type="primary" @click="editBook">
          确定
        </el-button>
      </span>
    
    </el-form>
  </el-dialog>

  <el-dialog v-model="add" title="添加图书信息" style="text-align: center;" draggable>
    <el-form :model="variable">
      <el-form-item label="图书名称" :label-width="labelWidth">
        <el-input v-model="variable.bookName" autocomplete="off" />
      </el-form-item>
      <el-form-item label="作者" :label-width="labelWidth">
        <el-input v-model="variable.author" autocomplete="off" />
      </el-form-item>
      <el-form-item label="出版社" :label-width="labelWidth">
        <el-input v-model="variable.publish" autocomplete="off" />
      </el-form-item>
      <el-form-item label="价格" :label-width="labelWidth">
        <el-input type="number" v-model="variable.price" autocomplete="off" />
      </el-form-item>
      <el-form-item label="数量" :label-width="labelWidth">
        <el-input type="number" v-model="variable.stock" autocomplete="off" />
      </el-form-item>
      <el-form-item label="分类" :label-width="labelWidth">
        <el-input v-model="variable.category" autocomplete="off" />
      </el-form-item>
      
      <span class="dialog-footer">
        <el-button @click="add = false">取消</el-button>
        <el-button type="primary" @click="addNewBook">
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
    <span>确定删除该图书的全部信息？</span>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="remove = false">取消</el-button>
        <el-button type="primary" @click="removeBook">
          确定
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>
  
<script setup lang="ts">
  import { ref,reactive } from "vue";
  import { addBook,deleteBook,updateBook,getBook } from '@/api/book'
  import { ElMessage } from 'element-plus'
  import { Delete,Edit, } from '@element-plus/icons-vue'

  let books = [{
    bookId: '',
    bookName: '',
    author: '',
    publish: '',
    price: '',
    stock: '',
    category: ''
  }]
  let reactiveBooks = reactive({data: books})

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

  const variable = reactive({
    bookName: '',
    author: '',
    publish: '',
    price: '',
    stock: '',
    category: ''
  })
  const labelWidth = '140px'
  const edit = ref(false)
  const editId = ref('')
  const editWindow = (index: number) => {
    editId.value = reactiveBooks.data[index].bookId
    variable.bookName = reactiveBooks.data[index].bookName
    variable.author = reactiveBooks.data[index].author
    variable.publish = reactiveBooks.data[index].publish
    variable.price = reactiveBooks.data[index].price
    variable.stock = reactiveBooks.data[index].stock
    variable.category = reactiveBooks.data[index].category
    edit.value = true
  }
  const editBook = () => {
    if (variable.bookName == '' || variable.author == '' || 
      variable.publish == '' || variable.price == '' || 
      variable.stock == '' || variable.category == ''
    ) {
      ElMessage.error('请填写完整信息')
      return
    }
    updateBook(Number(editId.value),
      variable.bookName,
      variable.author,
      variable.publish,
      Number(variable.price),
      Number(variable.stock),
      variable.category
    ).then(res => {
      update()
      ElMessage.success('修改成功')
    }).catch(err => {
      console.log(err)
      ElMessage.error('网络原因,修改失败')
    })
    edit.value = false
  }


  const add = ref(false)
  const addWindow = () => {
    variable.bookName = ''
    variable.author = ''
    variable.publish = ''
    variable.price = ''
    variable.stock = ''
    variable.category = ''
    add.value = true
  }
  const addNewBook = () => {
    if (variable.bookName == '' || variable.author == '' || 
      variable.publish == '' || variable.price == '' || 
      variable.stock == '' || variable.category == ''
    ) {
      ElMessage.error('请填写完整信息')
      return
    }
    addBook(variable.bookName,
      variable.author,
      variable.publish,
      Number(variable.price),
      Number(variable.stock),
      variable.category).then(res => {
      update()
      ElMessage.success('添加成功')
    }).catch(err => {
      console.log(err)
      ElMessage.error('网络原因,添加失败')
    })
    add.value = false
  }



  const remove = ref(false)
  const removeId = ref('')
  const removeWindow = (index: number) => {
    removeId.value = reactiveBooks.data[index].bookId
    remove.value = true
  }
  const removeBook = () => {
    deleteBook(Number(removeId.value)).then(res => {
      update()
      ElMessage.success('删除成功')
    }).catch(err => {
      ElMessage.error('网络原因,删除失败')
    })
    remove.value = false
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