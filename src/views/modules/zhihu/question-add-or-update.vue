<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="" prop="questionId">
        <el-input v-model="dataForm.questionId" placeholder=""></el-input>
      </el-form-item>
      <el-form-item label="" prop="url">
        <el-input v-model="dataForm.url" placeholder=""></el-input>
      </el-form-item>
      <el-form-item label="" prop="questionTitle">
        <el-input v-model="dataForm.questionTitle" placeholder=""></el-input>
      </el-form-item>
      <el-form-item label="问题类型" prop="questionType">
        <el-input v-model="dataForm.questionType" placeholder="问题类型"></el-input>
      </el-form-item>
      <el-form-item label="是否开启监控" prop="openMonitor">
        <el-input v-model="dataForm.openMonitor" placeholder="是否开启监控"></el-input>
      </el-form-item>
      <el-form-item label="采集频率" prop="collectFrequency">
        <el-input v-model="dataForm.collectFrequency" placeholder="采集频率"></el-input>
      </el-form-item>
      <el-form-item label="是否置顶" prop="isTop">
        <el-input v-model="dataForm.isTop" placeholder="是否置顶"></el-input>
      </el-form-item>
      <el-form-item label="是否关注" prop="isFollower">
        <el-input v-model="dataForm.isFollower" placeholder="是否关注"></el-input>
      </el-form-item>
      <el-form-item label="是否已回答" prop="answered">
        <el-input v-model="dataForm.answered" placeholder="是否已回答"></el-input>
      </el-form-item>
      <el-form-item label="备注信息" prop="remark">
        <el-input v-model="dataForm.remark" placeholder="备注信息"></el-input>
      </el-form-item>
      <el-form-item label="" prop="createTime">
        <el-input v-model="dataForm.createTime" placeholder=""></el-input>
      </el-form-item>
      <el-form-item label="" prop="updateTime">
        <el-input v-model="dataForm.updateTime" placeholder=""></el-input>
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
        id: 0,
        questionId: '',
        url: '',
        questionTitle: '',
        questionType: '',
        openMonitor: '',
        collectFrequency: '',
        isTop: '',
        isFollower: '',
        answered: '',
        remark: '',
        createTime: '',
        updateTime: ''
      },
      dataRule: {
        questionId: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ],
        url: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ],
        questionTitle: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ],
        questionType: [
          {required: true, message: '问题类型不能为空', trigger: 'blur'}
        ],
        openMonitor: [
          {required: true, message: '是否开启监控不能为空', trigger: 'blur'}
        ],
        collectFrequency: [
          {required: true, message: '采集频率不能为空', trigger: 'blur'}
        ],
        isTop: [
          {required: true, message: '是否置顶不能为空', trigger: 'blur'}
        ],
        isFollower: [
          {required: true, message: '是否关注不能为空', trigger: 'blur'}
        ],
        answered: [
          {required: true, message: '是否已回答不能为空', trigger: 'blur'}
        ],
        remark: [
          {required: true, message: '备注信息不能为空', trigger: 'blur'}
        ],
        createTime: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ],
        updateTime: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ]
      }
    }
  },
  methods: {
    init(id) {
      this.dataForm.id = id || 0
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.id) {
          this.$http({
            url: this.$http.adornUrl(`/zhihu/question/info/${this.dataForm.id}`),
            method: 'get',
            params: this.$http.adornParams()
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm.questionId = data.question.questionId
              this.dataForm.url = data.question.url
              this.dataForm.questionTitle = data.question.questionTitle
              this.dataForm.questionType = data.question.questionType
              this.dataForm.openMonitor = data.question.openMonitor
              this.dataForm.collectFrequency = data.question.collectFrequency
              this.dataForm.isTop = data.question.isTop
              this.dataForm.isFollower = data.question.isFollower
              this.dataForm.answered = data.question.answered
              this.dataForm.remark = data.question.remark
              this.dataForm.createTime = data.question.createTime
              this.dataForm.updateTime = data.question.updateTime
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
            url: this.$http.adornUrl(`/zhihu/question/${!this.dataForm.id ? 'save' : 'update'}`),
            method: 'post',
            data: this.$http.adornData({
              'id': this.dataForm.id || undefined,
              'questionId': this.dataForm.questionId,
              'url': this.dataForm.url,
              'questionTitle': this.dataForm.questionTitle,
              'questionType': this.dataForm.questionType,
              'openMonitor': this.dataForm.openMonitor,
              'collectFrequency': this.dataForm.collectFrequency,
              'isTop': this.dataForm.isTop,
              'isFollower': this.dataForm.isFollower,
              'answered': this.dataForm.answered,
              'remark': this.dataForm.remark,
              'createTime': this.dataForm.createTime,
              'updateTime': this.dataForm.updateTime
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
