package org.example.repository;

import lombok.RequiredArgsConstructor;
import lombok.val;
import org.example.model.UserEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.*;

@Repository
@RequiredArgsConstructor
public class UserRepositoryImpl implements UserRepository {
    private final JdbcTemplate jdbcTemplate;
    private final static String SQL_GET_BY_ID = "SELECT * FROM \"user\" WHERE id = ?";
    private final static String SQL_GET_ALL = "SELECT * FROM \"user\"";
    private final static String SQL_INSERT_USER = "INSERT INTO \"user\" (username, email, password, role) VALUES (?, ?, ?, ?)";
    private final static String SQL_UPDATE_USER = "UPDATE \"user\" SET username = ?, email = ?, password = ?, role = ? WHERE id = ?";
    private final static String SQL_DELETE_USER = "DELETE FROM \"user\" WHERE id = ?";

    private RowMapper<UserEntity> rowMapper = (rs, rowNum) -> UserEntity.builder()
            .uuid(rs.getObject("id", UUID.class))
            .username(rs.getString("username"))
            .email(rs.getString("email"))
            .password(rs.getString("password"))
            .role(rs.getString("role"))
            .build();

    @Override
    public Optional<UserEntity> findById(UUID uuid) {
        try (val stream = jdbcTemplate.queryForStream(SQL_GET_BY_ID, rowMapper, uuid)) {
            return stream.findAny();
        }
    }

    @Override
    public Set<UserEntity> findAll() {
        return new HashSet<>(jdbcTemplate.query(SQL_GET_ALL, rowMapper));
    }

    @Override
    public void save(UserEntity userEntity) {
        jdbcTemplate.update(SQL_INSERT_USER,
                userEntity.getUsername(),
                userEntity.getEmail(),
                userEntity.getPassword(),
                userEntity.getRole());
    }

    @Override
    public void update(UserEntity userEntity) {
        jdbcTemplate.update(SQL_UPDATE_USER,
                userEntity.getUsername(),
                userEntity.getEmail(),
                userEntity.getPassword(),
                userEntity.getRole(),
                userEntity.getUuid());
    }

    @Override
    public void deleteById(UUID uuid) {
        jdbcTemplate.update(SQL_DELETE_USER, uuid);
    }
}