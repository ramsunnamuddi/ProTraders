package com.protrdrs.service;

import com.protrdrs.model.QrCode;
import com.protrdrs.repository.QrCodeRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class QrCodeService {

	@Autowired
    private QrCodeRepository qrCodeRepository;


    public QrCode storeFile(MultipartFile file, String data) throws IOException {
        QrCode qrCode = new QrCode();
        qrCode.setFilename(file.getOriginalFilename());
        qrCode.setFileData(file.getBytes());
        qrCode.setData(data);
        return qrCodeRepository.save(qrCode);
    }
    
    public Optional<QrCode> getFile() {
        return qrCodeRepository.findLatestQrCode();
    }
    
    public Optional<QrCode> getFile(Long id) {
        return qrCodeRepository.findById(id);
    }

    public Optional<QrCode> getFileByFilename(String filename) {
        return qrCodeRepository.findByFilename(filename);
    }
    
    public List<QrCode> getAllFiles() {
        return qrCodeRepository.findAll();
    }
    
    public  Map<String, Object> deleteById(Long id) {

	    Optional<QrCode> qrOptional = qrCodeRepository.findById(id);
	    Map<String, Object> response = new HashMap<>();
	    if (qrOptional.isPresent()) {
	        QrCode qrCode = qrOptional.get();
	        qrCodeRepository.deleteById(id);
	        response.put("eC", "0");
	        response.put("eM", qrCode.getFilename()+" deleted successfully");
	    } else {
	    	 response.put("eC", "-1");
		     response.put("eM", "Unable to delete the file ");
	    }
	    return response;
    }
}
