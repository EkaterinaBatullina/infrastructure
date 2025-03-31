package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.dto.request.UserRequest;
import org.example.dto.response.UserResponse;
import org.example.exception.UserNotFoundException;
import org.example.mapper.UserMapper;
import org.example.model.UserEntity;
import org.example.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BaseUserService implements UserService {

    private final UserRepository repository;

    private final UserMapper mapper;

    @Override
    public UserResponse getById(UUID uuid) {
        return mapper.toResponse(
                repository.findById(uuid)
                        .orElseThrow(() -> new UserNotFoundException(uuid))
        );
    }

    @Override
    public Set<UserResponse> getAll() {
        return repository.findAll().stream()
                .map(mapper::toResponse)
                .collect(Collectors.toSet());
    }

    @Override
    public UUID create(UserRequest userRequest) {
        UserEntity userEntity = mapper.toEntity(userRequest);
        System.out.println(userRequest.username() + "SEEE");
        System.out.println(userEntity.getUsername() + "EEEE");
        repository.save(userEntity);
        return userEntity.getUuid();
    }

    @Override
    public void delete(UUID uuid) {
        repository.deleteById(uuid);
    }

    @Override
    public void update(UUID uuid, UserRequest userRequest) {
        UserEntity userEntity = repository.findById(uuid)
                .orElseThrow(() -> new UserNotFoundException(uuid));
        System.out.println(userEntity.getUuid() + " !!!!!!");
        userEntity = userEntity.builder()
                .uuid(uuid)
                .username(userRequest.username())
                .email(userRequest.email())
                .password(userRequest.password())
                .role(userRequest.password())
                .build();
        repository.update(userEntity);
    }

    @Override
    public void patch(UUID uuid, UserRequest userRequest) {
        UserEntity userEntity = repository.findById(uuid)
                .orElseThrow(() -> new UserNotFoundException(uuid));
        userEntity = userEntity.builder()
                .uuid(uuid)
                .username(userRequest.username() != null ? userRequest.username() : userEntity.getUsername())
                .email(userRequest.email() != null ? userRequest.email() : userEntity.getEmail())
                .password(userRequest.password() != null ? userRequest.password() : userEntity.getPassword())
                .role(userRequest.role() != null ? userRequest.role() : userEntity.getRole())
                .build();
        repository.update(userEntity);
    }
}