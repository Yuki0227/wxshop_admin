<template>
  <el-dialog
    :title="!dataForm.goodsId ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
    <el-form-item label="商品名称" prop="goodsName">
      <el-input v-model="dataForm.goodsName" placeholder="商品名称"></el-input>
    </el-form-item>
    <el-form-item label="商品价格" prop="goodsPrice">
      <el-input v-model="dataForm.goodsPrice" placeholder="商品价格"></el-input>
    </el-form-item>
    <el-form-item label="商品数量" prop="goodsNumber">
      <el-input v-model="dataForm.goodsNumber" placeholder="商品数量"></el-input>
    </el-form-item>
    <el-form-item label="商品质量" prop="goodsWeight">
      <el-input v-model="dataForm.goodsWeight" placeholder="商品质量"></el-input>
    </el-form-item>
    <el-form-item label="商品图标" prop="goodsLogo">
      <el-upload
        class="avatar-uploader"
        :action="url"
        :show-file-list="false"
        :on-success="handleAvatarSuccess"
        :before-upload="beforeAvatarUpload">
        <img v-if="dataForm.goodsLogo" :src="dataForm.goodsLogo" class="avatar" alt="商品图标">
        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
      </el-upload>
    </el-form-item>
      <el-form-item label="热门数" prop="hotNumber">
        <el-input v-model="dataForm.hotNumber" placeholder="热门数"></el-input>
      </el-form-item>
      <el-form-item label="类别ID" prop="catTwoId">
        <el-input v-model="dataForm.catTwoId" placeholder="二级类别"></el-input>
      </el-form-item>

      <el-form-item label="商品介绍" prop="goodsIntroduce">
        <template>
          <div>
            <!-- 图片上传组件辅助-->
            <el-upload
              class="img-uploader"
              :action="url"
              :show-file-list="false"
              :on-success="uploadSuccess"
              :on-error="uploadError"
              :before-upload="beforeUpload">
            </el-upload>
            <quill-editor
              v-model="dataForm.goodsIntroduce"
              ref="myQuillEditor"
              :options="editorOption"
              :style="{ height: '200px',width: '100%' }"
              @change="onEditorChange($event)"
            >
            </quill-editor>
          </div>
        </template>
      </el-form-item>
      <el-form-item label="" prop="">
      </el-form-item>
      <el-form-item label="" prop="">
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
          goodsId: 0,
          goodsName: '',
          goodsPrice: '',
          goodsNumber: '',
          goodsWeight: '',
          goodsLogo: '',
          hotNumber: '',
          catOneId: '',
          catTwoId: '',
          goodsIntroduce: null
        },
        url: '',
        dataRule: {
          goodsName: [
            { required: true, message: '商品名称不能为空', trigger: 'blur' }
          ],
          goodsPrice: [
            { required: true, message: '商品价格不能为空', trigger: 'blur' }
          ],
          goodsNumber: [
            { required: true, message: '商品数量不能为空', trigger: 'blur' }
          ],
          goodsWeight: [
            { required: true, message: '商品质量不能为空', trigger: 'blur' }
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
        this.dataForm.goodsId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.goodsId) {
            this.$http({
              url: this.$http.adornUrl(`/shop/goods/info/${this.dataForm.goodsId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.goodsName = data.goods.goodsName
                this.dataForm.goodsPrice = data.goods.goodsPrice
                this.dataForm.goodsNumber = data.goods.goodsNumber
                this.dataForm.goodsWeight = data.goods.goodsWeight
                this.dataForm.goodsLogo = data.goods.goodsLogo
                this.dataForm.hotNumber = data.goods.hotNumber
                this.dataForm.catOneId = data.goods.catOneId
                this.dataForm.catTwoId = data.goods.catTwoId
                this.dataForm.goodsIntroduce = data.goods.goodsIntroduce
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
              url: this.$http.adornUrl(`/shop/goods/${!this.dataForm.goodsId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'goodsId': this.dataForm.goodsId || undefined,
                'goodsName': this.dataForm.goodsName,
                'goodsPrice': this.dataForm.goodsPrice,
                'goodsNumber': this.dataForm.goodsNumber,
                'goodsWeight': this.dataForm.goodsWeight,
                'goodsLogo': this.dataForm.goodsLogo,
                'hotNumber': this.dataForm.hotNumber,
                'catOneId': this.dataForm.catOneId,
                'catTwoId': this.dataForm.catTwoId,
                'goodsIntroduce': this.dataForm.goodsIntroduce
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
        this.dataForm.goodsLogo = file.response.url// URL.createObjectURL(file.raw);
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
