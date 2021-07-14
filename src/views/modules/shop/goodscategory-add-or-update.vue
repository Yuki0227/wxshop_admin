<template>
  <el-dialog
    :title="!dataForm.catId ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
    <el-form-item label="联系商品表" prop="catOneId">
      <el-input v-model="dataForm.catOneId" placeholder="联系商品表"></el-input>
    </el-form-item>
    <el-form-item label="级别ID" prop="levelId">
      <el-input v-model="dataForm.levelId" placeholder="级别ID"></el-input>
    </el-form-item>
    <el-form-item label="类别名称" prop="catName">
      <el-input v-model="dataForm.catName" placeholder="类别名称"></el-input>
    </el-form-item>
    <el-form-item label="类别图标" prop="catLogo">
      <el-input v-model="dataForm.catLogo" placeholder="类别图标"></el-input>
    </el-form-item>
    <el-form-item label="商品数量" prop="catGoodsNumber">
      <el-input v-model="dataForm.catGoodsNumber" placeholder="商品数量"></el-input>
    </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
  export default {
    data () {
      return {
        visible: false,
        dataForm: {
          catId: 0,
          catOneId: '',
          levelId: '',
          catName: '',
          catLogo: '',
          catGoodsNumber: ''
        },
        dataRule: {
          catOneId: [
            { required: true, message: '联系商品表不能为空', trigger: 'blur' }
          ],
          levelId: [
            { required: true, message: '级别ID不能为空', trigger: 'blur' }
          ],
          catName: [
            { required: true, message: '类别名称不能为空', trigger: 'blur' }
          ],
          catLogo: [
            { required: true, message: '类别图标不能为空', trigger: 'blur' }
          ],
          catGoodsNumber: [
            { required: true, message: '商品数量不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.catId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.catId) {
            this.$http({
              url: this.$http.adornUrl(`/shop/goodscategory/info/${this.dataForm.catId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.catOneId = data.goodsCategory.catOneId
                this.dataForm.levelId = data.goodsCategory.levelId
                this.dataForm.catName = data.goodsCategory.catName
                this.dataForm.catLogo = data.goodsCategory.catLogo
                this.dataForm.catGoodsNumber = data.goodsCategory.catGoodsNumber
              }
            })
          }
        })
      },
      // 表单提交
      dataFormSubmit () {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.$http({
              url: this.$http.adornUrl(`/shop/goodscategory/${!this.dataForm.catId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'catId': this.dataForm.catId || undefined,
                'catOneId': this.dataForm.catOneId,
                'levelId': this.dataForm.levelId,
                'catName': this.dataForm.catName,
                'catLogo': this.dataForm.catLogo,
                'catGoodsNumber': this.dataForm.catGoodsNumber
              })
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500,
                  onClose: () => {
                    this.visible = false
                    this.$emit('refreshDataList')
                  }
                })
              } else {
                this.$message.error(data.msg)
              }
            })
          }
        })
      }
    }
  }
</script>
