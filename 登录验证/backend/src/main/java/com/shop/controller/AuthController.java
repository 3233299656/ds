package com.shop.controller;

import com.shop.common.ApiResponse;
import com.shop.dto.LoginRequest;
import com.shop.dto.LoginResponse;
import com.shop.model.User;
import com.shop.security.LoginUser;
import com.shop.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request));
    }

    @GetMapping("/me")
    public ApiResponse<User> getCurrentUser(@AuthenticationPrincipal LoginUser user) {
        return ApiResponse.ok(authService.getCurrentUser(user.getUserId()));
    }
}