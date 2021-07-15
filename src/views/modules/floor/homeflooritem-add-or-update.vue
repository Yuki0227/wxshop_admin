<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
    <el-form-item label="楼层ID" prop="floorId">
      <el-input v-model="dataForm.floorId" placeholder="楼层ID"></el-input>
    </el-form-item>
    <el-form-item label="楼层项名称" prop="name">
      <el-input v-model="dataForm.name" placeholder="楼层项名称"></el-input>
    </el-form-item>
    <el-form-item label="图片" prop="imageSrc">
      <el-input v-model="dataForm.imageSrc" placeholder="图片"></el-input>
    </el-form-item>
    <el-form-item label="图片宽度" prop="imageWidth">
      <el-input v-model="dataForm.imageWidth" placeholder="图片宽度"></el-input>
    </el-form-item>
    <el-form-item label="打开方式" prop="openType">
      <el-input v-model="dataForm.openType" placeholder="打开方式"></el-input>
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
          id: 0,
          floorId: '',
          name: '',
          imageSrc: '',
          imageWidth: '',
          openType: '',
          navigatorUrl: ''
        },
        dataRule: {
          floorId: [
            { required: true, message: '楼层ID不能为空', trigger: 'blur' }
          ],
          name: [
            { required: true, message: '楼层项名称不能为空', trigger: 'blur' }
          ],
          imageSrc: [
            { required: true, message: '图片不能为空', trigger: 'blur' }
          ],
          imageWidth: [
            { required: true, message: '图片宽度不能为空', trigger: 'blur' }
          ],
          openType: [
            { required: true, message: '打开方式不能为空', trigger: 'blur' }
          ],
          navigatorUrl: [
            { required: true, message: '导航链接不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.id = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.id) {
            this.$http({
              url: this.$http.adornUrl(`/floor/homeflooritem/info/${this.dataForm.id}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.floorId = data.homeFloorItem.floorId
                this.dataForm.name = data.homeFloorItem.name
                this.dataForm.imageSrc = data.homeFloorItem.imageSrc
                this.dataForm.imageWidth = data.homeFloorItem.imageWidth
                this.dataForm.openType = data.homeFloorItem.openType
                this.dataForm.navigatorUrl = data.homeFloorItem.navigatorUrl
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
              url: this.$http.adornUrl(`/floor/homeflooritem/${!this.dataForm.id ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'id': this.dataForm.id || undefined,
                'floorId': this.dataForm.floorId,
                'name': this.dataForm.name,
                'imageSrc': this.dataForm.imageSrc,
                'imageWidth': this.dataForm.imageWidth,
                'openType': this.dataForm.openType,
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
