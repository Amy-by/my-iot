<template>
  <div class="app-container">
    <el-card>
      <template #header>传感器列表（占位）</template>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        description="后端接口完成后，可点击刷新拉取真实数据；当前展示示例数据。"
        class="mb-16"
      />
      <div class="mb-12">
        <el-space>
          <el-input v-model="query.sensorId" placeholder="IMEI" clearable />
          <el-button type="primary" :loading="loading" @click="loadData">刷新</el-button>
        </el-space>
      </div>
      <el-table :data="list" border size="small" style="width: 100%">
        <el-table-column prop="sensorId" label="IMEI" min-width="160" />
        <el-table-column prop="area" label="区域" min-width="120" />
        <el-table-column prop="status" label="状态" min-width="100">
          <template #default="{ row }">
            <el-tag :type="statusTag(row.status)">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="smoke" label="烟雾(%)" min-width="100" />
        <el-table-column prop="temp" label="温度(℃)" min-width="100" />
        <el-table-column prop="battery" label="电量(%)" min-width="100" />
        <el-table-column label="操作" min-width="120">
          <template #default>
            <el-button type="primary" text size="small">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { listSensors } from '@/api/iot/sensor'

const loading = ref(false)
const list = ref([
  { sensorId: '869149040980562', area: '示例区域', status: '离线', smoke: 0, temp: 24, battery: 90 }
])
const query = ref({ sensorId: '' })

const statusTag = (status) => {
  if (status === '报警') return 'danger'
  if (status === '在线') return 'success'
  return 'info'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await listSensors(query.value)
    if (res && res.rows) {
      list.value = res.rows
    }
  } catch (e) {
    // 保持示例数据，避免空表
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

