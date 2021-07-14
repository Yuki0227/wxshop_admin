<template>
  <el-dialog
    :title="!dataForm.catTwoId ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
    <el-form-item label="上级ID" prop="parentId">
      <el-input v-model="dataForm.parentId" placeholder="上级ID"></el-input>
    </el-form-item>
    <el-form-item label="类别名称" prop="catName">
      <el-input v-model="dataForm.catName" placeholder="类别名称"></el-input>
    </el-form-item>
    <el-form-item label="类别图标" prop="catLogo">
      <el-input v-model="dataForm.catLogo" placeholder="类别图标"></el-input>
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
          catTwoId: 0,
          parentId: '',
          catName: '',
          catLogo: ''
        },
        dataRule: {
          parentId: [
            { required: true, message: '上级ID不能为空', trigger: 'blur' }
          ],
          catName: [
            { required: true, message: '类别名称不能为空', trigger: 'blur' }
          ],
          catLogo: [
            { required: true, message: '类别图标不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.catTwoId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.catTwoId) {
            this.$http({
              url: this.$http.adornUrl(`/shop/goodscategory/info/${this.dataForm.catTwoId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.parentId = data.goodsCategory.parentId
                this.dataForm.catName = data.goodsCategory.catName
                this.dataForm.catLogo = data.goodsCategory.catLogo
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
              url: this.$http.adornUrl(`/shop/goodscategory/${!this.dataForm.catTwoId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'catTwoId': this.dataForm.catTwoId || undefined,
                'parentId': this.dataForm.parentId,
                'catName': this.dataForm.catName,
                'catLogo': this.dataForm.catLogo
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
