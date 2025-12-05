import request from '@/utils/request'

// 批量导入传感器（Excel）
export function importSensors(formData) {
  return request({
    url: '/api/iot/device/batchImport',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: formData
  })
}


