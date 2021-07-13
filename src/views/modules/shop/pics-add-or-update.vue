<template>
  <el-dialog
    :title="!dataForm.picsId ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="商品id" prop="goodsId">
        <el-input v-model="dataForm.goodsId" placeholder="商品id"></el-input>
      </el-form-item>
      <el-form-item label="图片链接" prop="picsUrl">
        <el-input v-model="dataForm.picsUrl" placeholder="图片链接"></el-input>
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
  data() {
    return {
      visible: false,
      dataForm: {
        goodsId: '',
        picsId: 0,
        picsUrl: ''
      },
      dataRule: {
        goodsId: [
          {required: true, message: '商品id不能为空', trigger: 'blur'}
        ],
        picsUrl: [
          {required: true, message: '图片链接不能为空', trigger: 'blur'}
        ]
      }
    }
  },
  methods: {
    init(id) {
      this.dataForm.picsId = id || 0
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.picsId) {
          this.$http({
            url: this.$http.adornUrl(`/shop/pics/info/${this.dataForm.picsId}`),
            method: 'get',
            params: this.$http.adornParams()
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm.goodsId = data.pics.goodsId
              this.dataForm.picsUrl = data.pics.picsUrl
            }
          })
        }
      })
    },
    // 表单提交
    dataFormSubmit() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$http({
            url: this.$http.adornUrl(`/shop/pics/${!this.dataForm.picsId ? 'save' : 'update'}`),
            method: 'post',
            data: this.$http.adornData({
              'goodsId': this.dataForm.goodsId,
              'picsId': this.dataForm.picsId || undefined,
              'picsUrl': this.dataForm.picsUrl
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
