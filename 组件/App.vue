<template>
  <div id="app">
    <h1>Vue组件演示</h1>
    
    <!-- ProductCard 组件演示 -->
    <section>
      <h2>ProductCard 商品卡片</h2>
      <div class="product-grid">
        <ProductCard
          v-for="product in products"
          :key="product.id"
          :product="product"
          @click="showDetail"
          @add="addToCart"
        />
      </div>
    </section>
    
    <!-- ProductDetail 组件演示 -->
    <section v-if="selectedProduct">
      <h2>ProductDetail 商品详情</h2>
      <ProductDetail
        :product="selectedProduct"
        @back="selectedProduct = null"
      />
    </section>
    
    <!-- CountdownTimer 组件演示 -->
    <section>
      <h2>CountdownTimer 倒计时组件</h2>
      <CountdownTimer :end-time="flashSaleEnd" />
    </section>
    
    <!-- PromotionTag 组件演示 -->
    <section>
      <h2>PromotionTag 促销标签组件</h2>
      <div class="tag-demo">
        <span>折扣标签：</span>
        <PromotionTag :discount="30" type="discount" />
        <PromotionTag :discount="20" type="discount" />
        <PromotionTag :discount="50" type="discount" />
      </div>
      <div class="tag-demo">
        <span>其他标签：</span>
        <PromotionTag :discount="'HOT'" type="hot" />
        <PromotionTag :discount="'NEW'" type="new" />
        <PromotionTag :discount="'FLASH'" type="flash" />
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ProductCard from './ProductCard.vue'
import ProductDetail from './ProductDetail.vue'
import PromotionTag from './PromotionTag.vue'
import CountdownTimer from './CountdownTimer.vue'

const products = ref([
  {
    id: 1,
    name: 'iPhone 15 Pro',
    price: 7999,
    stock: 100,
    description: '苹果最新款手机，A17 Pro芯片，钛金属设计',
    category: '手机',
    discount: 10
  },
  {
    id: 2,
    name: 'MacBook Pro 14',
    price: 14999,
    stock: 50,
    description: 'M3 Pro芯片，专业级笔记本电脑',
    category: '电脑'
  },
  {
    id: 3,
    name: 'AirPods Pro 2',
    price: 1899,
    stock: 200,
    description: '主动降噪，空间音频',
    category: '耳机',
    discount: 15
  },
  {
    id: 4,
    name: 'iPad Pro 12.9',
    price: 8999,
    stock: 80,
    description: 'M2芯片，Liquid Retina XDR显示屏',
    category: '平板'
  },
  {
    id: 5,
    name: '华为Mate 60 Pro',
    price: 6999,
    stock: 100,
    description: '麒麟9000S，卫星通话',
    category: '手机',
    flashSale: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString()
  },
  {
    id: 6,
    name: '索尼WH-1000XM5',
    price: 2699,
    stock: 180,
    description: '旗舰降噪耳机，30小时续航',
    category: '耳机',
    discount: 20
  }
])

const selectedProduct = ref(null)

const flashSaleEnd = new Date(Date.now() + 3 * 60 * 60 * 1000).toISOString()

const showDetail = (product) => {
  selectedProduct.value = product
}

const addToCart = (product) => {
  alert(`已将 ${product.name} 加入购物车`)
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: #f5f5f5;
  padding: 30px;
}

#app {
  max-width: 1200px;
  margin: 0 auto;
}

h1 {
  font-size: 32px;
  margin-bottom: 30px;
  color: #333;
}

section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

section h2 {
  font-size: 18px;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.tag-demo {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.tag-demo span:first-child {
  color: #666;
  font-size: 14px;
}
</style>