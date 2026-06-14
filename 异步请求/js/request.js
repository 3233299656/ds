/**
 * 异步请求工具类
 * 使用 fetch API 封装
 */

class Request {
  constructor(baseURL = '') {
    this.baseURL = baseURL;
  }

  async get(url, params = {}) {
    const queryString = Object.keys(params)
      .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
      .join('&');
    
    const fullUrl = queryString ? `${this.baseURL}${url}?${queryString}` : `${this.baseURL}${url}`;
    
    const response = await fetch(fullUrl, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
      }
    });
    
    return this._handleResponse(response);
  }

  async post(url, data = {}) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
      },
      body: JSON.stringify(data)
    });
    
    return this._handleResponse(response);
  }

  async put(url, data = {}) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
      },
      body: JSON.stringify(data)
    });
    
    return this._handleResponse(response);
  }

  async delete(url) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
      }
    });
    
    return this._handleResponse(response);
  }

  async _handleResponse(response) {
    const text = await response.text();
    let data;
    
    try {
      data = JSON.parse(text);
    } catch {
      data = { code: response.status, message: text };
    }
    
    if (response.status === 401) {
      localStorage.removeItem('token');
      throw new Error('登录已过期');
    }
    
    if (data.code !== 200) {
      throw new Error(data.message || '请求失败');
    }
    
    return data.data;
  }
}

const request = new Request('/api');

export default request;
export { Request };