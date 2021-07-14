<template>
  <el-dialog
    :title="'订单详情'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <div :model="dataForm" :rules="dataRule" ref="dataForm">
      <el-row>
        <el-col :span="6" class="table-cell-title">订单编号</el-col>
        <el-col :span="6" class="table-cell-title">订单状态</el-col>
        <el-col :span="6" class="table-cell-title">订单金额</el-col>
        <el-col :span="6" class="table-cell-title">支付方式</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell">{{dataForm.orderId}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.orderState}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.orderAmount}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.payWay}}</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell-title">用户编号</el-col>
        <el-col :span="6" class="table-cell-title">用户姓名</el-col>
        <el-col :span="6" class="table-cell-title">用户电话</el-col>
        <el-col :span="6" class="table-cell-title">用户地址</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell">{{dataForm.userId}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.userName}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.userTel}}</el-col>
        <el-col :span="6" class="table-cell">{{dataForm.userAddress}}</el-col>
      </el-row>
    </div>
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm">

    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">返回</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data () {
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
      }

    }
  },
  methods: {
    init (id) {
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
    }
  }
}
</script>
