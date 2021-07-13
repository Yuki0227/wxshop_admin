<template>
  <el-dialog
    :title="订单详情"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-container>
      <el-aside width="200px">订单状态</el-aside>
      <el-main v-model="dataForm.orderState"></el-main>
    </el-container>
    <el-container>
      <el-aside width="200px">支付方式</el-aside>
      <el-main>{{ dataForm.payWay }}</el-main>
    </el-container>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">返回</el-button>

    </span>
  </el-dialog>
</template>

<style>

.el-aside {
  background-color: #D3DCE6;
  color: #333;
  text-align: center;
  line-height: 60px;
}

.el-main {
  background-color: #E9EEF3;
  color: #333;
  text-align: center;
  line-height: 60px;
}

body > .el-container {
  margin-bottom: 40px;
}


</style>


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
    }
  }
}
</script>
