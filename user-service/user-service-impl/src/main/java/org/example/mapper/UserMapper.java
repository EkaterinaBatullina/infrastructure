package org.example.mapper;

import org.example.dto.request.UserRequest;
import org.example.dto.response.UserResponse;
import org.example.model.UserEntity;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

//@Mapper(componentModel = "spring", builder = @Builder(disableBuilder = true))
@Mapper(componentModel = "spring")
public interface UserMapper {

//    @Mapping(source = "username", target = "username")
//    @Mapping(source = "email", target = "email")
//    @Mapping(source = "password", target = "password")
//    @Mapping(source = "role", target = "role")
    UserEntity toEntity(UserRequest userRequest);

    UserResponse toResponse(UserEntity userEntity);

}

