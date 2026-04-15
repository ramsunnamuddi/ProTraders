package com.protrdrs.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.protrdrs.model.ReferralLink;

public interface ReferralLinkRepository extends JpaRepository<ReferralLink, Long> {
}