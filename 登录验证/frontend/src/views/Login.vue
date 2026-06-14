<template>
  <div class="login-page">
    <div class="form-card">
      <h2 class="form-title">用户登录</h2>
      
      <div v-if="error" class="alert alert-error">{{ error }}</div>
      
      <div class="form-group">
        <label>用户名</label>
        <input v-model="form.username" type="text" placeholder="请输入用户名" />
      </div>
      
      <div class="form-group">
        <label>密码</label>
        <input v-model="form.password" type="password" placeholder="请输入密码" />
      </div>
      
      <button class="btn btn-primary" style="width: 100%;" @click="handleLogin">
        登录
      </button>
      
      <p style="text-align: center; margin-top: 15px; color: #666;">
        测试账号：admin / 123456
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api/auth'

const router = useRouter()
const form = ref({ username: '', password: '' })
const error = ref('')

const handleLogin = async () => {
  if (!form.value.username || !form.value.password) {
    error.value = '请输入用户名和密码'
    return
  }
  
  try {
    const result = await login(form.value.username, form.value.password)
    localStorage.setItem('token', result.token)
    router.push('/')
  } catch (err) {
    error.value = err.message || '登录失败'
  }
}
</script>