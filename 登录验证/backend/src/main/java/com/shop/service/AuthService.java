package com.shop.service;

import com.shop.common.BusinessException;
import com.shop.dto.LoginRequest;
import com.shop.dto.LoginResponse;
import com.shop.model.User;
import com.shop.repository.UserRepository;
import com.shop.security.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        var user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new BusinessException(401, "用户名或密码错误"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException(401, "用户名或密码错误");
        }

        String token = jwtTokenUtil.generateToken(user.getId(), user.getUsername());
        return new LoginResponse(token, new LoginResponse.UserVO(
                user.getId(), user.getUsername(), user.getNickname()));
    }

    public User getCurrentUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(404, "用户不存在"));
    }
}