package com.protrdrs.model;

public class UserRegisterRequest {
    private String sponsorId;
    private String position;
    private String fullName;
    private String mobileNumber;
    private String email;
    private String password;

    // Getter and Setter Methods
    public String getSponsorId() { return sponsorId; }
    public void setSponsorId(String sponsorId) { this.sponsorId = sponsorId; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}


