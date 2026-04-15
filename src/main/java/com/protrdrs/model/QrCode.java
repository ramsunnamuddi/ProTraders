package com.protrdrs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "qr_codes")
public class QrCode {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String filename;

    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] fileData;

    private String data;

    private LocalDateTime uploadedAt = LocalDateTime.now();

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public byte[] getFileData() { return fileData; }
    public void setFileData(byte[] fileData) { this.fileData = fileData; }

    public String getData() { return data; }
    public void setData(String data) { this.data = data; }

    public LocalDateTime getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(LocalDateTime uploadedAt) { this.uploadedAt = uploadedAt; }
}
