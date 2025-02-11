package com.spring.javaGroupS2.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaGroupS2.dao.PaymentDAO;

@Service
public class PaymentServiceImpl implements PaymentService {

	@Autowired
	PaymentDAO paymentDAO;
	
	
}
