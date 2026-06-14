/**
 * 主应用模块
 * 演示异步请求的使用
 */

import { mockService } from './mock.js';

class App {
  constructor() {
    this.productListEl = document.getElementById('product-list');
    this.cartListEl = document.getElementById('cart-list');
    this.orderListEl = document.getElementById('order-list');
    this.init();
  }

  async init() {
    await this.loadProducts();
    await this.loadCart();
    await this.loadOrders();
  }

  async loadProducts() {
    try {
      this.productListEl.innerHTML = '<div class="loading">加载中...</div>';
      
      const response = await mockService.getProducts();
      const products = response.data;
      
      this.productListEl.innerHTML = products.map(product => `
        <div class="product-card">
          <h3>${product.name}</h3>
          <p class="price">¥${product.price}</p>
          <p style="font-size: 12px; color: #666; margin-bottom: 12px;">${product.description}</p>
          <p style="font-size: 12px; color: #999; margin-bottom: 12px;">库存：${product.stock}</p>
          <button onclick="app.addToCart(${product.id})">加入购物车</button>
        </div>
      `).join('');
    } catch (error) {
      this.productListEl.innerHTML = `<div>加载失败: ${error.message}</div>`;
    }
  }

  async loadCart() {
    try {
      this.cartListEl.innerHTML = '<div class="loading">加载中...</div>';
      
      const response = await mockService.getCart();
      const cartItems = response.data;
      
      if (cartItems.length === 0) {
        this.cartListEl.innerHTML = '<div>购物车为空</div>';
        return;
      }
      
      const total = cartItems.reduce((sum, item) => sum + item.productPrice * item.quantity, 0);
      
      this.cartListEl.innerHTML = `
        ${cartItems.map(item => `
          <div class="cart-item">
            <span>${item.productName}</span>
            <span>¥${item.productPrice} × ${item.quantity}</span>
          </div>
        `).join('')}
        <div style="padding: 12px; font-weight: bold; color: #ff4757;">
          总计：¥${total}
        </div>
      `;
    } catch (error) {
      this.cartListEl.innerHTML = `<div>加载失败: ${error.message}</div>`;
    }
  }

  async loadOrders() {
    try {
      this.orderListEl.innerHTML = '<div class="loading">加载中...</div>';
      
      const response = await mockService.getOrders();
      const orders = response.data;
      
      if (orders.length === 0) {
        this.orderListEl.innerHTML = '<div>暂无订单</div>';
        return;
      }
      
      this.orderListEl.innerHTML = orders.map(order => `
        <div class="order-card">
          <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
            <span>订单号：${order.orderNo}</span>
            <span class="order-status" style="padding: 4px 12px; border-radius: 20px; font-size: 12px; ${this.getStatusStyle(order.status)}">
              ${this.getStatusText(order.status)}
            </span>
          </div>
          <div style="margin-bottom: 8px;">
            <span>收货人：${order.receiverName} ${order.receiverPhone}</span>
          </div>
          <div style="margin-bottom: 8px;">
            <span>地址：${order.receiverAddress}</span>
          </div>
          <div style="display: flex; justify-content: space-between;">
            <span>金额：¥${order.totalAmount}</span>
            <span style="font-size: 12px; color: #999;">${order.createdAt}</span>
          </div>
        </div>
      `).join('');
    } catch (error) {
      this.orderListEl.innerHTML = `<div>加载失败: ${error.message}</div>`;
    }
  }

  async addToCart(productId) {
    try {
      await mockService.addToCart(productId, 1);
      await this.loadCart();
      alert('已添加到购物车');
    } catch (error) {
      alert('添加失败: ' + error.message);
    }
  }

  getStatusText(status) {
    const map = {
      pending: '待付款',
      paid: '已付款',
      shipped: '已发货',
      completed: '已完成',
      cancelled: '已取消'
    };
    return map[status] || status;
  }

  getStatusStyle(status) {
    const map = {
      pending: 'background: #fff3cd; color: #856404;',
      paid: 'background: #d1ecf1; color: #0c5460;',
      shipped: 'background: #d4edda; color: #155724;',
      completed: 'background: #d4edda; color: #155724;',
      cancelled: 'background: #f8d7da; color: #721c24;'
    };
    return map[status] || '';
  }
}

const app = new App();

window.app = app;