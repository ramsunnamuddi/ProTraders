package com.protrdrs.repository;

import com.protrdrs.model.QrCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface QrCodeRepository extends JpaRepository<QrCode, Long> {
    Optional<QrCode> findByFilename(String filename);
    
    @Query(value = "SELECT * FROM qr_codes ORDER BY uploaded_at DESC LIMIT 1", nativeQuery = true)
    Optional<QrCode> findLatestQrCode();
}

