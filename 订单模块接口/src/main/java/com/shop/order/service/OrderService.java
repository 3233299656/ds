package com.shop.order.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shop.order.dto.OrderCreateDTO;
import com.shop.order.entity.Order;
import com.shop.order.entity.OrderItem;
import com.shop.order.mapper.OrderItemMapper;
import com.shop.order.mapper.OrderMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
public class OrderService extends ServiceImpl<OrderMapper, Order> {

    private final OrderItemMapper orderItemMapper;

    public OrderService(OrderItemMapper orderItemMapper) {
        this.orderItemMapper = orderItemMapper;
    }

    @Transactional
    public Order createOrder(Long userId, OrderCreateDTO dto) {
        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setStatus("pending");
        order.setReceiverName(dto.getReceiverName());
        order.setReceiverPhone(dto.getReceiverPhone());
        order.setReceiverAddress(dto.getReceiverAddress());
        order.setRemark(dto.getRemark());
        order.setCreatedAt(LocalDateTime.now());

        double totalAmount = 0;
        for (OrderCreateDTO.OrderItemDTO item : dto.getItems()) {
            double subtotal = 100.0 * item.getQuantity();
            totalAmount += subtotal;
        }
        order.setTotalAmount(totalAmount);

        save(order);

        for (OrderCreateDTO.OrderItemDTO item : dto.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(order.getId());
            orderItem.setProductId(item.getProductId());
            orderItem.setProductName("商品" + item.getProductId());
            orderItem.setProductPrice(100.0);
            orderItem.setQuantity(item.getQuantity());
            orderItem.setSubtotal(100.0 * item.getQuantity());
            orderItemMapper.insert(orderItem);
        }

        return order;
    }

    public List<Order> getOrdersByUserId(Long userId) {
        return baseMapper.selectByUserId(userId);
    }

    public Order getOrderById(Long orderId) {
        return getById(orderId);
    }

    @Transactional
    public void updateOrderStatus(Long orderId, String status) {
        Order order = getById(orderId);
        if (order != null) {
            order.setStatus(status);
            updateById(order);
        }
    }

    private String generateOrderNo() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String random = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return timestamp + random;
    }
}