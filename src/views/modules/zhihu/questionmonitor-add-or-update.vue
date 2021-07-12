<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="问题id" prop="questionId">
        <el-input v-model="dataForm.questionId" placeholder="问题id"></el-input>
      </el-form-item>
      <el-form-item label="问题url" prop="url">
        <el-input v-model="dataForm.url" placeholder="问题url"></el-input>
      </el-form-item>
      <el-form-item label="问题标题" prop="questionTitle">
        <el-input v-model="dataForm.questionTitle" placeholder="问题标题"></el-input>
      </el-form-item>
      <el-form-item label="数据采集时间" prop="collectTime">
        <el-input v-model="dataForm.collectTime" placeholder="数据采集时间"></el-input>
      </el-form-item>
      <el-form-item label="关注数量" prop="followerNum">
        <el-input v-model="dataForm.followerNum" placeholder="关注数量"></el-input>
      </el-form-item>
      <el-form-item label="浏览量" prop="pageViewNum">
        <el-input v-model="dataForm.pageViewNum" placeholder="浏览量"></el-input>
      </el-form-item>
      <el-form-item label="回答数量" prop="answerTotal">
        <el-input v-model="dataForm.answerTotal" placeholder="回答数量"></el-input>
      </el-form-item>
      <el-form-item label="" prop="questionType">
        <el-input v-model="dataForm.questionType" placeholder=""></el-input>
      </el-form-item>
      <el-form-item label="采集频率" prop="collectFrequency">
        <el-input v-model="dataForm.collectFrequency" placeholder="采集频率"></el-input>
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
        collectTime: '',
        followerNum: '',
        pageViewNum: '',
        answerTotal: '',
        questionType: '',
        collectFrequency: ''
      },
      dataRule: {
        questionId: [
          {required: true, message: '问题id不能为空', trigger: 'blur'}
        ],
        url: [
          {required: true, message: '问题url不能为空', trigger: 'blur'}
        ],
        questionTitle: [
          {required: true, message: '问题标题不能为空', trigger: 'blur'}
        ],
        collectTime: [
          {required: true, message: '数据采集时间不能为空', trigger: 'blur'}
        ],
        followerNum: [
          {required: true, message: '关注数量不能为空', trigger: 'blur'}
        ],
        pageViewNum: [
          {required: true, message: '浏览量不能为空', trigger: 'blur'}
        ],
        answerTotal: [
          {required: true, message: '回答数量不能为空', trigger: 'blur'}
        ],
        questionType: [
          {required: true, message: '不能为空', trigger: 'blur'}
        ],
        collectFrequency: [
          {required: true, message: '采集频率不能为空', trigger: 'blur'}
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
            url: this.$http.adornUrl(`/zhihu/questionmonitor/info/${this.dataForm.id}`),
            method: 'get',
            params: this.$http.adornParams()
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm.questionId = data.questionMonitor.questionId
              this.dataForm.url = data.questionMonitor.url
              this.dataForm.questionTitle = data.questionMonitor.questionTitle
              this.dataForm.collectTime = data.questionMonitor.collectTime
              this.dataForm.followerNum = data.questionMonitor.followerNum
              this.dataForm.pageViewNum = data.questionMonitor.pageViewNum
              this.dataForm.answerTotal = data.questionMonitor.answerTotal
              this.dataForm.questionType = data.questionMonitor.questionType
              this.dataForm.collectFrequency = data.questionMonitor.collectFrequency
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
            url: this.$http.adornUrl(`/zhihu/questionmonitor/${!this.dataForm.id ? 'save' : 'update'}`),
            method: 'post',
            data: this.$http.adornData({
              'id': this.dataForm.id || undefined,
              'questionId': this.dataForm.questionId,
              'url': this.dataForm.url,
              'questionTitle': this.dataForm.questionTitle,
              'collectTime': this.dataForm.collectTime,
              'followerNum': this.dataForm.followerNum,
              'pageViewNum': this.dataForm.pageViewNum,
              'answerTotal': this.dataForm.answerTotal,
              'questionType': this.dataForm.questionType,
              'collectFrequency': this.dataForm.collectFrequency
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
