import request from '@/utils/request'

// 额度查询
export function getQuota(sensorId) {
  return request({
    url: '/api/notification/quota',
    method: 'get',
    params: { sensorId }
  })
}

// 额度调整
export function updateQuota(data) {
  return request({
    url: '/api/notification/updateQuota',
    method: 'post',
    data
  })
}


