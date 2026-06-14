/**
 * 模拟数据模块
 * 提供模拟商品、购物车、订单数据
 */

const mockProducts = [
  { id: 1, name: 'iPhone 15 Pro', price: 7999, stock: 100, description: '苹果最新款手机' },
  { id: 2, name: 'MacBook Pro 14', price: 14999, stock: 50, description: 'M3 Pro芯片笔记本' },
  { id: 3, name: 'AirPods Pro 2', price: 1899, stock: 200, description: '主动降噪耳机' },
  { id: 4, name: 'iPad Pro', price: 8999, stock: 80, description: 'M2芯片平板' },
  { id: 5, name: 'Apple Watch Ultra', price: 6499, stock: 120, description: '专业运动手表' },
  { id: 6, name: '小米14 Ultra', price: 5999, stock: 150, description: '徕卡影像旗舰' },
  { id: 7, name: '华为Mate 60 Pro', price: 6999, stock: 100, description: '麒麟9000S芯片' },
  { id: 8, name: '索尼WH-1000XM5', price: 2699, stock: 180, description: '旗舰降噪耳机' }
];

const mockCart = [
  { id: 1, productId: 1, productName: 'iPhone 15 Pro', productPrice: 7999, quantity: 1 },
  { id: 2, productId: 3, productName: 'AirPods Pro 2', productPrice: 1899, quantity: 2 }
];

const mockOrders = [
  {
    id: 1,
    orderNo: '20260614103000ABC1',
    totalAmount: 9898,
    status: 'pending',
    receiverName: '张三',
    receiverPhone: '13800138000',
    receiverAddress: '北京市朝阳区xxx街道',
    createdAt: '2026-06-14 10:30:00',
    items: [
      { productName: 'iPhone 15 Pro', price: 7999, quantity: 1 },
      { productName: 'AirPods Pro 2', price: 1899, quantity: 1 }
    ]
  },
  {
    id: 2,
    orderNo: '20260613152000DEF2',
    totalAmount: 14999,
    status: 'paid',
    receiverName: '李四',
    receiverPhone: '13900139000',
    receiverAddress: '上海市浦东新区xxx路',
    createdAt: '2026-06-13 15:20:00',
    items: [
      { productName: 'MacBook Pro 14', price: 14999, quantity: 1 }
    ]
  }
];

class MockService {
  getProducts(keyword = '') {
    return new Promise(resolve => {
      setTimeout(() => {
        const filtered = mockProducts.filter(p => 
          p.name.toLowerCase().includes(keyword.toLowerCase()) ||
          p.description.toLowerCase().includes(keyword.toLowerCase())
        );
        resolve({ code: 200, message: 'success', data: filtered });
      }, 500);
    });
  }

  getCart() {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve({ code: 200, message: 'success', data: mockCart });
      }, 300);
    });
  }

  addToCart(productId, quantity = 1) {
    return new Promise(resolve => {
      setTimeout(() => {
        const product = mockProducts.find(p => p.id === productId);
        if (product) {
          const existing = mockCart.find(c => c.productId === productId);
          if (existing) {
            existing.quantity += quantity;
          } else {
            mockCart.push({
              id: mockCart.length + 1,
              productId: product.id,
              productName: product.name,
              productPrice: product.price,
              quantity: quantity
            });
          }
          resolve({ code: 200, message: 'success', data: null });
        } else {
          resolve({ code: 400, message: '商品不存在', data: null });
        }
      }, 300);
    });
  }

  getOrders(status = '') {
    return new Promise(resolve => {
      setTimeout(() => {
        const filtered = status ? mockOrders.filter(o => o.status === status) : mockOrders;
        resolve({ code: 200, message: 'success', data: filtered });
      }, 400);
    });
  }
}

const mockService = new MockService();

export { mockProducts, mockCart, mockOrders, MockService, mockService };