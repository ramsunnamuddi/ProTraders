package com.protrdrs.model;

public class TotalTeamDTO {
	private String fullname;
	private String customerId;
	private String position;
	
	public TotalTeamDTO(String customerId,String  fullname, String  position) {
        this.customerId = customerId;
        this.fullname=fullname;
        this.position=position;
    }
	
	// Getter for fullname
    public String getFullname() {
        return fullname;
    }

    // Setter for fullname
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    // Getter for customerId
    public String getCustomerId() {
        return customerId;
    }

    // Setter for customerId
    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }
    
    // Getter for customerId
    public String getPosition() {
        return position;
    }

    // Setter for customerId
    public void setPosition(String position) {
        this.position = position;
    }
}
