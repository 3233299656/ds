<template>
  <div class="product-card" @click="$emit('click', product)">
    <div class="product-image">
      <span v-if="!product.image">📦</span>
      <img v-else :src="product.image" :alt="product.name" />
    </div>
    <div class="product-info">
      <h3 class="product-name">{{ product.name }}</h3>
      <p class="product-price">¥{{ formatPrice(product.price) }}</p>
      <p class="product-desc">{{ product.description }}</p>
      <div class="product-meta">
        <span class="stock">库存：{{ product.stock }}</span>
      </div>
    </div>
    <PromotionTag v-if="product.discount" :discount="product.discount" />
    <button class="add-btn" @click.stop="$emit('add', product)">加入购物车</button>
  </div>
</template>

<script setup>
import PromotionTag from './PromotionTag.vue'

defineProps({
  product: {
    type: Object,
    required: true
  }
})

defineEmits(['click', 'add'])

const formatPrice = (price) => {
  return typeof price === 'number' ? price.toFixed(2) : '0.00'
}
</script>

<style scoped>
.product-card {
  background: #ffffff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  position: relative;
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.product-image {
  width: 100%;
  height: 180px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48px;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-info {
  padding: 16px;
}

.product-name {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 8px 0;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-price {
  font-size: 20px;
  font-weight: bold;
  color: #ff4757;
  margin: 0 0 8px 0;
}

.product-desc {
  font-size: 13px;
  color: #666;
  margin: 0 0 8px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-meta {
  display: flex;
  gap: 15px;
}

.stock {
  font-size: 12px;
  color: #999;
}

.add-btn {
  width: calc(100% - 32px);
  margin: 0 16px 16px;
  padding: 10px;
  border: none;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.add-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}
</style>