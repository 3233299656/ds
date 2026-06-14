<template>
  <span class="promotion-tag" :class="tagClass">
    {{ tagText }}
  </span>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  discount: {
    type: Number,
    required: true
  },
  type: {
    type: String,
    default: 'discount'
  }
})

const tagText = computed(() => {
  if (props.type === 'discount') {
    return `${props.discount}% OFF`
  }
  return props.discount.toString()
})

const tagClass = computed(() => {
  if (props.type === 'discount') {
    return 'discount'
  }
  return props.type
})
</script>

<style scoped>
.promotion-tag {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  color: white;
}

.promotion-tag.discount {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
}

.promotion-tag.hot {
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
}

.promotion-tag.new {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
}

.promotion-tag.flash {
  background: linear-gradient(135deg, #e67e22 0%, #f39c12 100%);
}
</style>