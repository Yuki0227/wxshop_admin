<template>
  <el-dialog
    :title="!dataForm.sid ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
    <el-form-item label="商品id" prop="goodsId">
      <el-input v-model="dataForm.goodsId" placeholder="商品id"></el-input>
    </el-form-item>
    <el-form-item label="图片路径" prop="imageSrc">
      <el-input v-model="dataForm.imageSrc" placeholder="图片路径"></el-input>
    </el-form-item>
    <el-form-item label="导航链接" prop="navigatorUrl">
      <el-input v-model="dataForm.navigatorUrl" placeholder="导航链接"></el-input>
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
          sid: 0,
          goodsId: '',
          imageSrc: '',
          navigatorUrl: ''
        },
        dataRule: {
          goodsId: [
            { required: true, message: '商品id不能为空', trigger: 'blur' }
          ],
          imageSrc: [
            { required: true, message: '图片路径不能为空', trigger: 'blur' }
          ],
          navigatorUrl: [
            { required: true, message: '导航链接不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.sid = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.sid) {
            this.$http({
              url: this.$http.adornUrl(`/shop/swiper/info/${this.dataForm.sid}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.goodsId = data.swiper.goodsId
                this.dataForm.imageSrc = data.swiper.imageSrc
                this.dataForm.navigatorUrl = data.swiper.navigatorUrl
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
              url: this.$http.adornUrl(`/shop/swiper/${!this.dataForm.sid ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'sid': this.dataForm.sid || undefined,
                'goodsId': this.dataForm.goodsId,
                'imageSrc': this.dataForm.imageSrc,
                'navigatorUrl': this.dataForm.navigatorUrl
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
