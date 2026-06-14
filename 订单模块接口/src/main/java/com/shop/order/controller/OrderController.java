package com.shop.order.controller;

import com.shop.order.common.Result;
import com.shop.order.dto.OrderCreateDTO;
import com.shop.order.dto.OrderStatusDTO;
import com.shop.order.entity.Order;
import com.shop.order.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    public ResponseEntity<Result<Order>> createOrder(@Valid @RequestBody OrderCreateDTO dto) {
        Order order = orderService.createOrder(1L, dto);
        return ResponseEntity.ok(Result.ok(order));
    }

    @GetMapping
    public ResponseEntity<Result<List<Order>>> getOrders(
            @RequestParam(defaultValue = "1") Long userId) {
        List<Order> orders = orderService.getOrdersByUserId(userId);
        return ResponseEntity.ok(Result.ok(orders));
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<Result<Order>> getOrder(@PathVariable Long orderId) {
        Order order = orderService.getOrderById(orderId);
        return ResponseEntity.ok(Result.ok(order));
    }

    @PutMapping("/{orderId}/status")
    public ResponseEntity<Result<Void>> updateOrderStatus(
            @PathVariable Long orderId,
            @RequestBody OrderStatusDTO dto) {
        orderService.updateOrderStatus(orderId, dto.getStatus());
        return ResponseEntity.ok(Result.ok(null));
    }
}