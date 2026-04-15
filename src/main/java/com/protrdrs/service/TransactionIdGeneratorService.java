package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.protrdrs.repository.TransactionSequenceRepository;

import java.text.SimpleDateFormat;
import java.util.Date;

@Service
public class TransactionIdGeneratorService {

    @Autowired
    private TransactionSequenceRepository sequenceRepository;

    @Transactional
    public String generateTransactionId(String transactionType) {
        // Step 1: Increment the sequence
        sequenceRepository.incrementSequence(transactionType);

        // Step 2: Get the new sequence value
        int nextValue = sequenceRepository.getCurrentSequence(transactionType);

        // Step 3: Format the transaction ID
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String formattedSequence = String.format("%06d", nextValue);

        // Step 4: Generate the final ID
        return transactionType + "-" + date + "-" + formattedSequence;
    }
}

