<template>
  <div class="product-detail" v-if="product">
    <div class="detail-header">
      <button class="back-btn" @click="$emit('back')">← 返回</button>
    </div>
    
    <div class="detail-content">
      <div class="detail-image">
        <span v-if="!product.image">📦</span>
        <img v-else :src="product.image" :alt="product.name" />
      </div>
      
      <div class="detail-info">
        <h1>{{ product.name }}</h1>
        <div class="price-row">
          <span class="price">¥{{ formatPrice(product.price) }}</span>
          <PromotionTag v-if="product.discount" :discount="product.discount" />
        </div>
        <p class="description">{{ product.description }}</p>
        
        <div class="specs">
          <div class="spec-item">
            <span class="label">库存：</span>
            <span>{{ product.stock }} 件</span>
          </div>
          <div class="spec-item">
            <span class="label">分类：</span>
            <span>{{ product.category }}</span>
          </div>
        </div>
        
        <div class="quantity-control">
          <span class="label">数量：</span>
          <button class="qty-btn" @click="decrease">-</button>
          <span class="qty-value">{{ quantity }}</span>
          <button class="qty-btn" @click="increase">+</button>
        </div>
        
        <div class="actions">
          <button class="btn btn-primary" @click="addToCart">加入购物车</button>
          <button class="btn btn-secondary" @click="buyNow">立即购买</button>
        </div>
      </div>
    </div>
    
    <CountdownTimer v-if="product.flashSale" :end-time="product.flashSale" />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PromotionTag from './PromotionTag.vue'
import CountdownTimer from './CountdownTimer.vue'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

defineEmits(['back', 'add', 'buy'])

const quantity = ref(1)

const formatPrice = (price) => {
  return typeof price === 'number' ? price.toFixed(2) : '0.00'
}

const decrease = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

const increase = () => {
  if (quantity.value < props.product.stock) {
    quantity.value++
  }
}

const addToCart = () => {
  console.log('添加到购物车:', props.product, '数量:', quantity.value)
}

const buyNow = () => {
  console.log('立即购买:', props.product, '数量:', quantity.value)
}
</script>

<style scoped>
.product-detail {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
}

.detail-header {
  margin-bottom: 20px;
}

.back-btn {
  padding: 10px 20px;
  background: #f5f5f5;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
}

.back-btn:hover {
  background: #eee;
}

.detail-content {
  display: flex;
  gap: 30px;
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.detail-image {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 80px;
}

.detail-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 12px;
}

.detail-info {
  flex: 1;
}

.detail-info h1 {
  font-size: 24px;
  margin: 0 0 16px 0;
  color: #333;
}

.price-row {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 16px;
}

.price {
  font-size: 32px;
  font-weight: bold;
  color: #ff4757;
}

.description {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin: 0 0 20px 0;
}

.specs {
  margin-bottom: 20px;
}

.spec-item {
  display: flex;
  margin-bottom: 8px;
  font-size: 14px;
}

.label {
  color: #999;
  width: 60px;
}

.quantity-control {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 24px;
}

.qty-btn {
  width: 36px;
  height: 36px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 6px;
  font-size: 18px;
  cursor: pointer;
}

.qty-btn:hover {
  background: #f5f5f5;
}

.qty-value {
  font-size: 18px;
  font-weight: 600;
  min-width: 40px;
  text-align: center;
}

.actions {
  display: flex;
  gap: 15px;
}

.btn {
  flex: 1;
  padding: 14px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: #ff4757;
  color: white;
}

.btn-secondary:hover {
  background: #ff3344;
}

@media (max-width: 768px) {
  .detail-content {
    flex-direction: column;
  }
  
  .detail-image {
    width: 100%;
    height: 250px;
  }
}
</style>