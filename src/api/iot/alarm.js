import request from '@/utils/request'

// 报警列表
export function listAlarms(query) {
  return request({
    url: '/api/alarm/list',
    method: 'get',
    params: query
  })
}

// 报警确认/消音
export function ackAlarm(data) {
  return request({
    url: '/api/alarm/ack',
    method: 'post',
    data
  })
}


