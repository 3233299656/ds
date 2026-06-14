package com.shop.order.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.shop.order.mapper")
public class MyBatisPlusConfig {
}