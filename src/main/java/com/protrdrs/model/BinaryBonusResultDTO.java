package com.protrdrs.model;

import java.math.BigDecimal;

public class BinaryBonusResultDTO {

    private Integer peopleId;
    private Integer descendantId;
    private String customerId;
    private Integer binaryPosition;
    private BigDecimal binaryBonus;
    private String binaryStatus;

    // Constructor
    public BinaryBonusResultDTO(Integer peopleId, Integer descendantId, String customerId,Integer binaryPosition, BigDecimal binaryBonus, String binaryStatus) {
        this.peopleId = peopleId;
        this.descendantId = descendantId;
        this.customerId = customerId;
        this.binaryPosition=binaryPosition;
        this.binaryBonus=binaryBonus;
    }
    
    public String getBinaryStatus() {
		return binaryStatus;
	}

	public void setBinaryStatus(String binaryStatus) {
		this.binaryStatus = binaryStatus;
	}

	public Integer getPeopleId() {
        return peopleId;
    }

    public void setPeopleId(Integer peopleId) {
        this.peopleId = peopleId;
    }

    // Getter and Setter for descendantId
    public Integer getDescendantId() {
        return descendantId;
    }

    public void setDescendantId(Integer descendantId) {
        this.descendantId = descendantId;
    }

    // Getter and Setter for customerId
    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    // Getter and Setter for binaryPosition
    public Integer getBinaryPosition() {
        return binaryPosition;
    }

    public void setBinaryPosition(Integer binaryPosition) {
        this.binaryPosition = binaryPosition;
    }

    // Getter and Setter for binaryBonus
    public BigDecimal getBinaryBonus() {
        return binaryBonus;
    }

    public void setBinaryBonus(BigDecimal binaryBonus) {
        this.binaryBonus = binaryBonus;
    }
    
    
    
    
}

