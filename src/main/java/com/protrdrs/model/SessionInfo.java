package com.protrdrs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "session_info")
public class SessionInfo {

    @Id
    @Column(name = "session_id", length = 16, nullable = false)
    private String sessionId;

    @Column(name = "peopleId", nullable = false)
    private String peopleId;

    @Column(name = "ip_address", length = 45, nullable = false) // IPv6 max length = 45
    private String ipAddress;

    @Column(name = "login_datetime", nullable = false)
    private LocalDateTime loginDatetime;

    // ✅ Constructors
    public SessionInfo() {}

    public SessionInfo(String sessionId, String peopleId, String ipAddress, LocalDateTime loginDatetime) {
        this.sessionId = sessionId;
        this.peopleId = peopleId;
        this.ipAddress = ipAddress;
        this.loginDatetime = loginDatetime;
    }

    // ✅ Getters and Setters
    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getPeopleId() {
        return peopleId;
    }

    public void setPeopleId(String peopleId) {
        this.peopleId = peopleId;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public LocalDateTime getLoginDatetime() {
        return loginDatetime;
    }

    public void setLoginDatetime(LocalDateTime loginDatetime) {
        this.loginDatetime = loginDatetime;
    }

    @Override
    public String toString() {
        return "SessionInfo{" +
                "sessionId='" + sessionId + '\'' +
                ", peopleId='" + peopleId + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", loginDatetime=" + loginDatetime +
                '}';
    }
}

