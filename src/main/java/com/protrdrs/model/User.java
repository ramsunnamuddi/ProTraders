package com.protrdrs.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @Column(name="people_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long peopleId;

    @Column(name="customer_id",unique = true, nullable = false)
    private String customerId;

    @Column(name="password_hash",nullable = false)
    private String password;
    
    @Column(name="role",nullable = true)
    private String role;

    // Getters and Setters
    public Long getPeopleId() {
        return peopleId;
    }

    public void setPeopleId(Long peopleId) {
        this.peopleId = peopleId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
