package com.mlm.custprgm.srvc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;

@Service
public class AuthService {

   /* @Autowired
    private SessionRepository sessionRepository;

    @Autowired
    private AuditSessionRepository auditSessionRepository;

    public String login(String username, String password, HttpServletRequest request) {
        if (sessionRepository.existsByUsername(username)) {
            return "DUPLICATE";
        }

        if (authenticateUser(username, password)) {
            Session session = new Session();
            session.setSessionId(UUID.randomUUID().toString());
            session.setUsername(username);
            session.setIpAddress(request.getRemoteAddr());
            session.setLoggedInTime(LocalDateTime.now());
            session.setLastUpdatedTime(LocalDateTime.now());
            sessionRepository.save(session);
            return "SUCCESS";
        }
        return "FAILED";
    }

    public String validateSession(HttpServletRequest request) {
        String username = getUsernameFromSession(request);
        if (username == null) {
            return "INVALID";
        }

        Session session = sessionRepository.findByUsername(username);
        if (session == null) {
            return "INVALID";
        }

        if (Duration.between(session.getLastUpdatedTime(), LocalDateTime.now()).toMinutes() > 60) {
            logout(request);
            return "EXPIRED";
        }

        session.setLastUpdatedTime(LocalDateTime.now());
        sessionRepository.save(session);
        return "VALID";
    }

    public String logout(HttpServlet request) {
        String username = getUsernameFromSession(request);
        if (username != null) {
            Session session = sessionRepository.findByUsername(username);
            if (session != null) {
                AuditSession audit = new AuditSession(session);
                auditSessionRepository.save(audit);
                sessionRepository.delete(session);
            }
        }
        return "LOGGED_OUT";
    }

    private String getUsernameFromSession(HttpServletRequest request) {
        return (String) request.getSession().getAttribute("username");
    }

    private boolean authenticateUser(String username, String password) {
        return "admin".equals(username) && "password".equals(password); // Replace with DB check
    }*/
}

