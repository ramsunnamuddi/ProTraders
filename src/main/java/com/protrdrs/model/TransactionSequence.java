package com.protrdrs.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "transaction_sequence")
public class TransactionSequence {

    @Id
    @Column(name = "transaction_type", nullable = false)
    private String transactionType;

    @Column(name = "current_value", nullable = false)
    private int currentValue;

    // Getters and Setters
    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public int getCurrentValue() {
        return currentValue;
    }

    public void setCurrentValue(int currentValue) {
        this.currentValue = currentValue;
    }
}
