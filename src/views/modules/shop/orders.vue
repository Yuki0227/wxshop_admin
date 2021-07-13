<template>
  <div class="mod-config">
    <el-form :inline="true" :model="dataForm" @keyup.enter.native="getDataList()">
      <el-form-item>
        <el-button v-if="isAuth('shop:orders:save')" type="primary" @click="addOrUpdateHandle()">新增</el-button>
        <el-button v-if="isAuth('shop:orders:delete')" type="danger" @click="deleteHandle()" :disabled="dataListSelections.length <= 0">批量删除</el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="dataList"
      border
      v-loading="dataListLoading"
      @selection-change="selectionChangeHandle"
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="status"
        header-align="center"
        align="center"
        label="订单状态">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.orderState === 0" size="small" type="warning">待付款</el-tag>
          <el-tag v-else-if="scope.row.orderState === 1" size="small">待发货</el-tag>
          <el-tag v-else-if="scope.row.orderState === 2" size="small">已发货</el-tag>
          <el-tag v-else-if="scope.row.orderState === 3" size="small" type="success">已完成</el-tag>
          <el-tag v-else-if="scope.row.orderState === 4" size="small" type="info">已关闭</el-tag>
          <el-tag v-else size="small" type="danger">无效订单</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="payWay"
        header-align="center"
        align="center"
        label="支付方式">
      </el-table-column>
      <el-table-column
        prop="orderAmount"
        header-align="center"
        align="center"
        label="订单金额">
      </el-table-column>
      <el-table-column
        fixed="right"
        header-align="center"
        align="center"
        width="150"
        label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="checkOrderDetailHandle(scope.row.orderId)">查看详情</el-button>
          <el-button type="text" size="small" @click="addOrUpdateHandle(scope.row.orderId)">修改</el-button>
          <el-button type="text" size="small" @click="deleteHandle(scope.row.orderId)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="sizeChangeHandle"
      @current-change="currentChangeHandle"
      :current-page="pageIndex"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      :total="totalPage"
      layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <!-- 弹窗, 新增 / 修改 -->
    <add-or-update v-if="addOrUpdateVisible" ref="addOrUpdate" @refreshDataList="getDataList"></add-or-update>
    <!-- 弹窗, 查看详情-->
    <check-order-detail v-if="checkOrderDetailVisible" ref="checkOrderDetail"
                        @refreshDataList="getDataList"></check-order-detail>
  </div>
</template>

<script>
import CheckOrderDetail from './orders-detail'
import AddOrUpdate from './orders-add-or-update'

  export default {
    data () {
      return {
        dataForm: {
          key: ''
        },
        dataList: [],
        pageIndex: 1,
        pageSize: 10,
        totalPage: 0,
        dataListLoading: false,
        dataListSelections: [],
        addOrUpdateVisible: false,
        checkOrderDetailVisible: false
      }
    },
    components: {
      AddOrUpdate,
      CheckOrderDetail
    },
    activated () {
      this.getDataList()
    },
    methods: {
      // 获取数据列表
      getDataList () {
        this.dataListLoading = true
        this.$http({
          url: this.$http.adornUrl('/shop/orders/list'),
          method: 'get',
          params: this.$http.adornParams({
            'page': this.pageIndex,
            'limit': this.pageSize,
            'key': this.dataForm.key
          })
        }).then(({data}) => {
          if (data && data.code === 0) {
            this.dataList = data.page.list
            this.totalPage = data.page.totalCount
          } else {
            this.dataList = []
            this.totalPage = 0
          }
          this.dataListLoading = false
        })
      },
      // 每页数
      sizeChangeHandle (val) {
        this.pageSize = val
        this.pageIndex = 1
        this.getDataList()
      },
      // 当前页
      currentChangeHandle (val) {
        this.pageIndex = val
        this.getDataList()
      },
      // 多选
      selectionChangeHandle (val) {
        this.dataListSelections = val
      },
      // 新增 / 修改
      addOrUpdateHandle (id) {
        this.addOrUpdateVisible = true
        this.$nextTick(() => {
          this.$refs.addOrUpdate.init(id)
        })
      },
      // 查看详情
      checkOrderDetailHandle(id) {
        this.checkOrderDetailVisible = true
        this.$nextTick(() => {
          this.$refs.checkOrderDetail.init(id)
        })
      },
      // 删除
      deleteHandle(id) {
        var ids = id ? [id] : this.dataListSelections.map(item => {
          return item.orderId
        })
        this.$confirm(`确定对[id=${ids.join(',')}]进行[${id ? '删除' : '批量删除'}]操作?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: this.$http.adornUrl('/shop/orders/delete'),
            method: 'post',
            data: this.$http.adornData(ids, false)
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.$message({
                message: '操作成功',
                type: 'success',
                duration: 1500,
                onClose: () => {
                  this.getDataList()
                }
              })
            } else {
              this.$message.error(data.msg)
            }
          })
        })
      }
    }
  }
</script>
