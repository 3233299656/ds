package com.shop.repository;

import com.shop.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.sql2o.Sql2o;

import java.util.Optional;

@Repository
public class UserRepository {

    @Autowired
    private Sql2o sql2o;

    public Optional<User> findByUsername(String username) {
        try (var con = sql2o.open()) {
            var user = con.createQuery("SELECT * FROM users WHERE username = :username")
                    .addParameter("username", username)
                    .executeAndFetchFirst(User.class);
            return Optional.ofNullable(user);
        }
    }

    public Optional<User> findById(Long id) {
        try (var con = sql2o.open()) {
            var user = con.createQuery("SELECT * FROM users WHERE id = :id")
                    .addParameter("id", id)
                    .executeAndFetchFirst(User.class);
            return Optional.ofNullable(user);
        }
    }

    public Long save(User user) {
        try (var con = sql2o.open()) {
            return con.createQuery(
                    "INSERT INTO users (username, password, nickname, created_at) " +
                    "VALUES (:username, :password, :nickname, datetime('now', 'localtime'))")
                    .bind(user)
                    .executeUpdate()
                    .getKey(Long.class);
        }
    }
}