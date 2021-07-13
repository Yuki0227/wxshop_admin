<template>
  <el-dialog
    :title="!dataForm.orderId ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="用户地址" prop="userAddress">
        <el-input v-model="dataForm.userAddress" placeholder="用户地址"></el-input>
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
        orderId: 0,
        orderState: '',
        payWay: '',
        orderAmount: '',
        userId: '',
        userName: '',
        userTel: '',
        userAddress: ''
      },
      dataRule: {
        orderState: [
          {required: true, message: '订单状态：0->待付款；1->待发货；2->已发货；3->已完成；4->已关闭；5->无效订单不能为空', trigger: 'blur'}
        ],
        orderAmount: [
          {required: true, message: '订单金额不能为空', trigger: 'blur'}
        ],
        userId: [
          {required: true, message: '用户ID不能为空', trigger: 'blur'}
        ],
        userName: [
          {required: true, message: '用户名不能为空', trigger: 'blur'}
        ],
        userTel: [
          {required: true, message: '用户电话不能为空', trigger: 'blur'}
        ],
        userAddress: [
          {required: true, message: '用户地址不能为空', trigger: 'blur'}
        ]
      }
    }
  },
  methods: {
    init(id) {
      this.dataForm.orderId = id || 0
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.orderId) {
          this.$http({
            url: this.$http.adornUrl(`/shop/orders/info/${this.dataForm.orderId}`),
            method: 'get',
            params: this.$http.adornParams()
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm.orderState = data.orders.orderState
              this.dataForm.payWay = data.orders.payWay
              this.dataForm.orderAmount = data.orders.orderAmount
              this.dataForm.userId = data.orders.userId
              this.dataForm.userName = data.orders.userName
              this.dataForm.userTel = data.orders.userTel
              this.dataForm.userAddress = data.orders.userAddress
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
            url: this.$http.adornUrl(`/shop/orders/${!this.dataForm.orderId ? 'save' : 'update'}`),
            method: 'post',
            data: this.$http.adornData({
              'orderId': this.dataForm.orderId || undefined,
              'orderState': this.dataForm.orderState,
              'payWay': this.dataForm.payWay,
              'orderAmount': this.dataForm.orderAmount,
              'userId': this.dataForm.userId,
              'userName': this.dataForm.userName,
              'userTel': this.dataForm.userTel,
              'userAddress': this.dataForm.userAddress
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
