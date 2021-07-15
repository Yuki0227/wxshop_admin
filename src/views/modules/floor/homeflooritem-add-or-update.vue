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
      <el-upload
        class="avatar-uploader"
        :action="url"
        :show-file-list="false"
        :on-success="handleAvatarSuccess"
        :before-upload="beforeAvatarUpload">
        <img v-if="dataForm.imageSrc" :src="dataForm.imageSrc" class="avatar" alt="图片">
        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
      </el-upload>
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

<style>

/*avatar 为商品LOGO信息*/
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>

<script>
  const toolbarOptions = [
    ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
    [{'header': 1}, {'header': 2}],               // custom button values
    [{'list': 'ordered'}, {'list': 'bullet'}],
    [{'indent': '-1'}, {'indent': '+1'}],          // outdent/indent
    [{'direction': 'rtl'}],                         // text direction
    [{'size': ['small', false, 'large', 'huge']}],  // custom dropdown
    [{'header': [1, 2, 3, 4, 5, 6, false]}],
    [{'color': []}, {'background': []}],          // dropdown with defaults from theme
    [{'font': []}],
    [{'align': []}],
    ['link', 'image'],
    ['clean']

  ]
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
        url: '',
        dataRule: {
          floorId: [
            { required: true, message: '楼层ID不能为空', trigger: 'blur' }
          ],
          name: [
            { required: true, message: '楼层项名称不能为空', trigger: 'blur' }
          ],
          imageSrc: [
            { required: true, message: '图片不能为空', trigger: 'blur' }
          ]
        },
        quillUpdateImg: false, // 根据图片上传状态来确定是否显示loading动画，刚开始是false,不显示
        content: null,
        editorOption: {
          placeholder: '',
          theme: 'snow',  // or 'bubble'
          modules: {
            toolbar: {
              container: toolbarOptions,
              handlers: {
                'image': function (value) {
                  if (value) {
                    // 触发input框选择图片文件
                    document.querySelector('.img-uploader input').click()
                  } else {
                    this.quill.format('image', false)
                  }
                }
              }
            }
          }
        }
      }
    },
    methods: {
      init (id) {
        this.url = this.$http.adornUrl(`/sys/oss/upload?token=${this.$cookie.get('token')}`)
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
      },
      handleAvatarSuccess(res, file) {
        this.dataForm.imageSrc = file.response.url// URL.createObjectURL(file.raw);
      },
      beforeAvatarUpload(file) {
        const isJPG = file.type === 'image/jpeg';
        const isLt2M = file.size / 1024 / 1024 < 2;

        if (!isJPG) {
          this.$message.error('上传头像图片只能是 JPG 格式!');
        }
        if (!isLt2M) {
          this.$message.error('上传头像图片大小不能超过 2MB!');
        }
        return isJPG && isLt2M;
      },
      onEditorChange ({editor, html, text}) { // 内容改变事件
        console.log('---内容改变事件---')
        this.content = html
        console.log(html)
        // console.log(this.url)
      },
      // 富文本图片上传前
      beforeUpload () {
        // 显示loading动画
        this.quillUpdateImg = true
      },

      uploadSuccess (res, file) {
        // res为图片服务器返回的数据
        // 获取富文本组件实例
        console.log(res)
        let quill = this.$refs.myQuillEditor.quill
        // 如果上传成功
        if (res.code == 0) {
          // 获取光标所在位置
          console.log(quill.getSelection())
          let length = quill.getSelection().index
          // 插入图片  res.url为服务器返回的图片地址
          quill.insertEmbed(length, 'image', res.url)
          // 调整光标到最后
          quill.setSelection(length + 1)
        } else {
          this.$message.error('图片插入失败')
        }
        // loading动画消失
        this.quillUpdateImg = false
      },
      // 富文本图片上传失败
      uploadError (res) {
        // loading动画消失
        this.quillUpdateImg = false
        this.$message.error('图片插入失败' + res.message)
      }
    }
  }
</script>
