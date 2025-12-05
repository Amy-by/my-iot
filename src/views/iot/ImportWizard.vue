<template>
  <div class="app-container">
    <el-card>
      <template #header>批量导入传感器（占位）</template>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        description="上传 Excel 后调用后端导入接口；当前为占位流程，未调用真实接口。"
        class="mb-16"
      />
      <el-upload
        drag
        :auto-upload="false"
        :on-change="onFileChange"
        :limit="1"
        accept=".xls,.xlsx"
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">拖拽或点击上传 Excel</div>
      </el-upload>
      <div class="mt-16">
        <el-button type="primary" :loading="uploading" :disabled="!file" @click="submit">提交导入</el-button>
        <span v-if="file" class="ml-8">已选择：{{ file.name }}</span>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { importSensors } from '@/api/iot/import'

const file = ref(null)
const uploading = ref(false)

const onFileChange = (uploadFile) => {
  file.value = uploadFile.raw
}

const submit = async () => {
  if (!file.value) return
  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', file.value)
    await importSensors(formData)
  } catch (e) {
    // 后端未接入时忽略错误
  } finally {
    uploading.value = false
  }
}
</script>

<style scoped>
.mb-16 {
  margin-bottom: 16px;
}
.mt-16 {
  margin-top: 16px;
}
.ml-8 {
  margin-left: 8px;
}
</style>

