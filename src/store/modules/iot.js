import { defineStore } from 'pinia'

// 轻量占位：前端状态缓存，后续可扩展为实时数据/告警列表
export const useIotStore = defineStore('iot', {
  state: () => ({
    sensors: [],
    alarms: [],
    quota: {}
  }),
  actions: {
    setSensors(list = []) {
      this.sensors = list
    },
    setAlarms(list = []) {
      this.alarms = list
    },
    setQuota(sensorId, quota) {
      this.quota = { ...this.quota, [sensorId]: quota }
    }
  }
})


