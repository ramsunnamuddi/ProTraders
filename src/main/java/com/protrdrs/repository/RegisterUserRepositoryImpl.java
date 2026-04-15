package com.protrdrs.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

@Repository
public class RegisterUserRepositoryImpl {

    @PersistenceContext
    private EntityManager entityManager;

    public String registerUser(String sponsorId, String position, String fullName,
                             String mobileNumber, String email, String password) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("register_user");
        query.registerStoredProcedureParameter("sponsor_id", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("position", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("full_name", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("mobile_number", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("email", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("password", String.class, jakarta.persistence.ParameterMode.IN);        
        query.registerStoredProcedureParameter("role", String.class, jakarta.persistence.ParameterMode.IN);
        query.registerStoredProcedureParameter("p_customer_id", String.class, jakarta.persistence.ParameterMode.OUT);

        query.setParameter("sponsor_id", sponsorId);
        query.setParameter("position", position);
        query.setParameter("full_name", fullName);
        query.setParameter("mobile_number", mobileNumber);
        query.setParameter("email", email);
        query.setParameter("password", password);
        query.setParameter("role", "USER");
        

        query.execute();
        return (String) query.getOutputParameterValue("p_customer_id");
    }
}

