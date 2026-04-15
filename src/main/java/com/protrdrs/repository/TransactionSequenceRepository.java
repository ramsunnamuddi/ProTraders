package com.protrdrs.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.protrdrs.model.TransactionSequence;
@Repository
public interface TransactionSequenceRepository extends JpaRepository<TransactionSequence, String> {

    @Modifying
    @Transactional
    @Query("UPDATE TransactionSequence t SET t.currentValue = t.currentValue + 1 WHERE t.transactionType = :transactionType")
    void incrementSequence(@Param("transactionType") String transactionType);

    @Query("SELECT t.currentValue FROM TransactionSequence t WHERE t.transactionType = :transactionType")
    int getCurrentSequence(@Param("transactionType") String transactionType);
}

