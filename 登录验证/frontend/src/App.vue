<template>
  <div id="app">
    <header class="header">
      <div class="header-content">
        <div class="logo">🔐 登录验证</div>
        <nav class="nav-links">
          <router-link to="/">首页</router-link>
        </nav>
        <div class="user-info" v-if="isLoggedIn">
          <span>{{ user?.nickname }}</span>
          <button class="btn btn-secondary" @click="handleLogout">退出</button>
        </div>
        <router-link to="/login" v-else class="btn btn-primary">登录</router-link>
      </div>
    </header>
    <main class="container">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getCurrentUser } from './api/auth'

const router = useRouter()
const user = ref(null)
const isLoggedIn = computed(() => !!localStorage.getItem('token'))

const initUser = async () => {
  if (localStorage.getItem('token')) {
    try {
      user.value = await getCurrentUser()
    } catch (error) {
      localStorage.removeItem('token')
    }
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  user.value = null
  router.push('/login')
}

onMounted(() => {
  initUser()
})
</script>