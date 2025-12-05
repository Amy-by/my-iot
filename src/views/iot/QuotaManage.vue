<template>
  <div class="app-container">
    <el-card>
      <template #header>通知额度管理（占位）</template>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        description="后端额度接口接入后可查询/调整额度，当前为占位表单。"
        class="mb-16"
      />
      <el-form :model="form" label-width="140px" class="quota-form">
        <el-form-item label="传感器 IMEI">
          <el-input v-model="form.sensorId" placeholder="输入传感器 IMEI" />
        </el-form-item>
        <el-form-item label="免费语音条数">
          <el-input-number v-model="form.freeVoiceCount" :min="0" />
        </el-form-item>
        <el-form-item label="免费短信条数">
          <el-input-number v-model="form.freeSmsCount" :min="0" />
        </el-form-item>
        <el-form-item label="余额（元）">
          <el-input-number v-model="form.balance" :min="0" :step="0.1" />
        </el-form-item>
        <el-form-item>
          <el-space>
            <el-button type="primary" :loading="loading" @click="loadQuota">查询</el-button>
            <el-button type="success" :loading="saving" @click="saveQuota">调整</el-button>
          </el-space>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { getQuota, updateQuota } from '@/api/iot/notification'

const loading = ref(false)
const saving = ref(false)
const form = ref({
  sensorId: '869149040980562',
  freeVoiceCount: 10,
  freeSmsCount: 20,
  balance: 0
})

const loadQuota = async () => {
  loading.value = true
  try {
    const res = await getQuota(form.value.sensorId)
    if (res && res.data) {
      form.value.freeVoiceCount = res.data.freeVoiceCount ?? form.value.freeVoiceCount
      form.value.freeSmsCount = res.data.freeSmsCount ?? form.value.freeSmsCount
      form.value.balance = res.data.balance ?? form.value.balance
    }
  } catch (e) {
    // 保留默认示例
  } finally {
    loading.value = false
  }
}

const saveQuota = async () => {
  saving.value = true
  try {
    await updateQuota({ ...form.value })
  } catch (e) {
    // 后端未接入时忽略
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.mb-16 {
  margin-bottom: 16px;
}
.quota-form {
  max-width: 420px;
}
</style>

