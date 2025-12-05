<template>
  <div class="app-container">
    <el-card>
      <template #header>实时报警监控（占位）</template>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        description="等待 WebSocket/Netty 接入，当前显示示例报警列表。"
        class="mb-16"
      />
      <div class="mb-12">
        <el-space>
          <el-tag type="success">WebSocket：待接入</el-tag>
          <el-button type="primary" :loading="loading" @click="loadData">刷新示例</el-button>
        </el-space>
      </div>
      <el-table :data="alarms" border size="small">
        <el-table-column prop="sensorId" label="IMEI" min-width="160" />
        <el-table-column prop="location" label="位置" min-width="120" />
        <el-table-column prop="alarmType" label="报警类型" min-width="120">
          <template #default="{ row }">
            <el-tag :type="row.alarmType === '火灾' ? 'danger' : 'warning'">{{ row.alarmType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="value" label="触发值" min-width="120" />
        <el-table-column prop="time" label="时间" min-width="160" />
        <el-table-column label="操作" min-width="140">
          <template #default>
            <el-button size="small" type="primary" text>处理</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { listAlarms } from '@/api/iot/alarm'

const loading = ref(false)
const alarms = ref([
  { sensorId: '869149040980562', location: '示例位置', alarmType: '火灾', value: '烟雾120%', time: '2025-01-01 12:00:00' }
])

const loadData = async () => {
  loading.value = true
  try {
    const res = await listAlarms({})
    if (res && res.rows) {
      alarms.value = res.rows
    }
  } catch (e) {
    // 保留示例数据
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.mb-16 {
  margin-bottom: 16px;
}
.mb-12 {
  margin-bottom: 12px;
}
</style>

