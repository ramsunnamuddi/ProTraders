package com.protrdrs.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.protrdrs.model.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    @Query("SELECT u.password FROM User u WHERE u.customerId = :customerId and u.role=:role")
    Optional<String> findPasswordByCustomerId(@Param("customerId") String customerId, @Param("role") String role);
    
    @Query("SELECT u.password FROM User u WHERE u.peopleId = :peopleId and u.role='USER' ")
    Optional<String> findPasswordByPeopleId(@Param("peopleId") Long peopleId);
    
    List<User> findAllByRole(String role);
}
