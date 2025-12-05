<template>
  <div class="app-container">
    <el-card>
      <template #header>传感器详情（占位）</template>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        description="待接入后端接口与实时/历史数据；当前为占位视图。"
        class="mb-16"
      />
      <el-descriptions :column="2" border>
        <el-descriptions-item label="IMEI">{{ sensor.sensorId }}</el-descriptions-item>
        <el-descriptions-item label="区域">{{ sensor.area }}</el-descriptions-item>
        <el-descriptions-item label="安装位置">{{ sensor.installationLocation }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="sensor.status === '报警' ? 'danger' : 'success'">{{ sensor.status }}</el-tag>
        </el-descriptions-item>
      </el-descriptions>
      <el-divider />
      <h4>实时数据</h4>
      <el-space class="mb-12">
        <span>烟雾浓度：{{ sensor.smoke }}%</span>
        <span>温度：{{ sensor.temp }}℃</span>
        <span>电量：{{ sensor.battery }}%</span>
      </el-space>
      <el-divider />
      <h4>参数配置（示例）</h4>
      <el-form :model="configForm" label-width="140px" class="config-form">
        <el-form-item label="烟雾阈值（%）">
          <el-input-number v-model="configForm.smokeThreshold" :min="0" :max="200" />
        </el-form-item>
        <el-form-item label="温度上限（℃）">
          <el-input-number v-model="configForm.tempUpperLimit" :min="-20" :max="70" />
        </el-form-item>
        <el-form-item label="正常上报间隔（秒）">
          <el-input-number v-model="configForm.normalWorkInterval" :min="30" :max="86400" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="submitting" @click="submitConfig">提交占位</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { configSensor, getSensorParams } from '@/api/iot/sensor'

const sensor = ref({
  sensorId: '869149040980562',
  area: '示例区域',
  installationLocation: '示例位置',
  status: '在线',
  smoke: 0,
  temp: 24,
  battery: 90
})

const configForm = ref({
  smokeThreshold: 100,
  tempUpperLimit: 50,
  normalWorkInterval: 86400
})

const submitting = ref(false)

const submitConfig = async () => {
  submitting.value = true
  try {
    await configSensor({
      sensorId: sensor.value.sensorId,
      configParams: { ...configForm.value }
    })
  } catch (e) {
    // 后端未接入时忽略错误
  } finally {
    submitting.value = false
  }
}

const loadParams = async () => {
  try {
    const res = await getSensorParams(sensor.value.sensorId)
    if (res && res.data) {
      configForm.value = {
        smokeThreshold: res.data.smokeThreshold ?? configForm.value.smokeThreshold,
        tempUpperLimit: res.data.tempUpperLimit ?? configForm.value.tempUpperLimit,
        normalWorkInterval: res.data.normalWorkInterval ?? configForm.value.normalWorkInterval
      }
    }
  } catch (e) {
    // 保留默认示例
  }
}

loadParams()
</script>

<style scoped>
.mb-16 {
  margin-bottom: 16px;
}
.mb-12 {
  margin-bottom: 12px;
}
.config-form {
  max-width: 480px;
}
</style>

