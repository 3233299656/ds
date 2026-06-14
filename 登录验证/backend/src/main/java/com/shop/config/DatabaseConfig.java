package com.shop.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.sql2o.Sql2o;
import org.sqlite.SQLiteDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.Statement;

@Configuration
public class DatabaseConfig {

    @Value("${spring.datasource.url}")
    private String url;

    @Bean
    public DataSource dataSource() {
        SQLiteDataSource dataSource = new SQLiteDataSource();
        dataSource.setUrl(url);
        initDatabase(dataSource);
        return dataSource;
    }

    @Bean
    public Sql2o sql2o(DataSource dataSource) {
        return new Sql2o(dataSource);
    }

    private void initDatabase(DataSource dataSource) {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {

            stmt.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT UNIQUE NOT NULL,
                    password TEXT NOT NULL,
                    nickname TEXT,
                    created_at TEXT
                )
            """);

            initSampleData(stmt);

        } catch (Exception e) {
            throw new RuntimeException("初始化数据库失败", e);
        }
    }

    private void initSampleData(Statement stmt) throws Exception {
        var rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        if (rs.next() && rs.getInt(1) > 0) {
            return;
        }

        stmt.execute("INSERT INTO users (username, password, nickname) VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '管理员')");
        stmt.execute("INSERT INTO users (username, password, nickname) VALUES ('test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '测试用户')");
    }
}