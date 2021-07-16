<template>
  <el-dialog
    :title="'订单详情'"
    :close-on-click-modal="false"
    :visible.sync="visible"
    :data="dataList"
    border
    v-loading="dataListLoading">
    <el-tag>订单详细信息</el-tag>
    <div :model="dataForm" :rules="dataRule" ref="dataForm">
      <el-row>
        <el-col :span="6" class="table-cell-title">订单编号</el-col>
        <el-col :span="6" class="table-cell-title">订单状态</el-col>
        <el-col :span="6" class="table-cell-title">订单金额</el-col>
        <el-col :span="6" class="table-cell-title">支付方式</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.orderId}}</el-col>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.orderState}}</el-col>
        <el-col :span="6" class="total-price" style="color: #00a0e9">{{dataForm.orderAmount}}</el-col>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.payWay}}</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell-title">用户编号</el-col>
        <el-col :span="6" class="table-cell-title">用户姓名</el-col>
        <el-col :span="6" class="table-cell-title">用户电话</el-col>
        <el-col :span="6" class="table-cell-title">用户地址</el-col>
      </el-row>
      <el-row>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.userId}}</el-col>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.userName}}</el-col>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.userTel}}</el-col>
        <el-col :span="6" class="table-cell" style="color: #00a0e9">{{dataForm.userAddress}}</el-col>
      </el-row>
    </div>
    <el-tag>包含商品</el-tag>
    <el-table
      :data="dataList"
      border
      v-loading="dataListLoading"
      style="width: 100%;">

      <el-table-column
        prop="goodsLogo"
        header-align="center"
        align="center"
        label="商品图片">
        <template slot-scope="scope">
          <img v-if="scope.row.goodsLogo" :src="scope.row.goodsLogo" width="100" height="100" class="head_pic"/>
        </template>
      </el-table-column>
      <el-table-column
        prop="goodsName"
        header-align="center"
        align="center"
        label="商品名称">
      </el-table-column>
      <el-table-column
        prop="goodsNumber"
        header-align="center"
        align="center"
        label="商品数量">
      </el-table-column>
      <el-table-column
        prop="goodsPrice"
        header-align="center"
        align="center"
        label="商品单价">
      </el-table-column>


    </el-table>
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
      },
      dataForm2: {
        key: ''
      },
      dataList: [],
      dataListLoading: false,
      dataListSelections: []
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
            url: this.$http.adornUrl(`/shop/orderitem/list/`),
            method: 'get',
            params: this.$http.adornParams({
              'orderId': id
            })
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataList = data.page.list
            } else {
              this.dataList = []
            }
            this.total()
            this.dataListLoading = false
          })
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
            this.total()
          })
        }
      })
    },
    total(){
      for (let item of this.dataList) {
        this.dataForm.orderAmount += item.goodsPrice * item.goodsNumber
      }
    }
  }
}
</script>
