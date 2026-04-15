package com.protrdrs.model;

import java.math.BigDecimal;
import java.util.List;

public class BinaryBonusResponseDTO {
    private List<BinaryBonusResultDTO> data;
    private BigDecimal totalAmount;

    // Constructors
    public BinaryBonusResponseDTO() {}
    public BinaryBonusResponseDTO(List<BinaryBonusResultDTO> data, BigDecimal  totalAmount) {
        this.data = data;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public List<BinaryBonusResultDTO> getData() {
        return data;
    }

    public void setData(List<BinaryBonusResultDTO> data) {
        this.data = data;
    }

    public BigDecimal  getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal  totalAmount) {
        this.totalAmount = totalAmount;
    }
}

