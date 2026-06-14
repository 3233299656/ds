<template>
  <div class="countdown-timer">
    <div class="timer-label">限时特惠</div>
    <div class="timer-display">
      <div class="time-block">
        <span class="time-value">{{ padZero(hours) }}</span>
        <span class="time-unit">时</span>
      </div>
      <span class="separator">:</span>
      <div class="time-block">
        <span class="time-value">{{ padZero(minutes) }}</span>
        <span class="time-unit">分</span>
      </div>
      <span class="separator">:</span>
      <div class="time-block">
        <span class="time-value">{{ padZero(seconds) }}</span>
        <span class="time-unit">秒</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  endTime: {
    type: String,
    required: true
  }
})

const hours = ref(0)
const minutes = ref(0)
const seconds = ref(0)
let timer = null

const padZero = (num) => {
  return String(num).padStart(2, '0')
}

const updateCountdown = () => {
  const end = new Date(props.endTime).getTime()
  const now = Date.now()
  const diff = end - now
  
  if (diff <= 0) {
    hours.value = 0
    minutes.value = 0
    seconds.value = 0
    if (timer) {
      clearInterval(timer)
    }
    return
  }
  
  hours.value = Math.floor(diff / (1000 * 60 * 60))
  minutes.value = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  seconds.value = Math.floor((diff % (1000 * 60)) / 1000)
}

onMounted(() => {
  updateCountdown()
  timer = setInterval(updateCountdown, 1000)
})

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
  }
})
</script>

<style scoped>
.countdown-timer {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  margin-top: 20px;
}

.timer-label {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  margin-bottom: 12px;
}

.timer-display {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.time-block {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 12px 16px;
  min-width: 60px;
}

.time-value {
  display: block;
  font-size: 28px;
  font-weight: bold;
  color: white;
}

.time-unit {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
}

.separator {
  font-size: 24px;
  color: white;
  font-weight: bold;
}
</style>