package com.protrdrs.security;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class FilterConfig {

    @Bean
    public FilterRegistrationBean<Filter> disableErrorPageFilter() {
        FilterRegistrationBean<Filter> registration = new FilterRegistrationBean<>();
        registration.setFilter((request, response, chain) -> {
            chain.doFilter(request, response); // ✅ Pass through filter chain without modifying
        });
        registration.setEnabled(false); // ✅ Disable the filter registration
        return registration;
    }
}
