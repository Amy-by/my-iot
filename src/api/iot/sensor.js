import request from '@/utils/request'

// 设备列表（占位：后端接口就绪后接入）
export function listSensors(query) {
  return request({
    url: '/api/device/sensor/list',
    method: 'get',
    params: query
  })
}

// 设备参数查询
export function getSensorParams(sensorId) {
  return request({
    url: '/api/device/sensor/params',
    method: 'get',
    params: { sensorId }
  })
}

// 配置下发
export function configSensor(data) {
  return request({
    url: '/api/sensor/config',
    method: 'post',
    data
  })
}


