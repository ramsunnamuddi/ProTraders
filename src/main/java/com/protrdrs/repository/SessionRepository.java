package com.protrdrs.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.protrdrs.model.SessionInfo;

@Repository
public interface SessionRepository extends JpaRepository<SessionInfo, String> {

    @Query(value = "SELECT COUNT(*) FROM session_info WHERE session_id = ?1 AND people_id = ?2 AND login_datetime >= NOW() - INTERVAL 1 HOUR", nativeQuery = true)
    Integer checkValidSession(String sessionId, String peopleId);
}

