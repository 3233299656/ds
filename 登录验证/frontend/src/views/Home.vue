<template>
  <div class="home-page">
    <h1>登录成功！</h1>
    <p style="margin: 20px 0;">欢迎回来，{{ user?.nickname || user?.username }}</p>
    <p style="color: #666;">您已成功通过 JWT 验证</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getCurrentUser } from '../api/auth'

const user = ref(null)

onMounted(async () => {
  try {
    user.value = await getCurrentUser()
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
})
</script>