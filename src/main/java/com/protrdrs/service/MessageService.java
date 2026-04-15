package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import java.util.Locale;

@Service
public class MessageService {

    @Autowired
    private MessageSource messageSource;

    public String getMessage(String code) {
        // Locale can be dynamic or default to English
        return messageSource.getMessage(code, null, Locale.ENGLISH);
    }
}
