package com.auc.common.exception;

import java.sql.SQLException;
import java.util.concurrent.TimeoutException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.transaction.TransactionException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ErrorHandler {
	
	private static Logger log = LoggerFactory.getLogger(ErrorHandler .class);

	/**
     * 지원하지 않은 HTTP method 호출 할 경우 발생
     */
	
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    protected ResponseEntity<ErrorResponse> handleHttpRequestMethodNotSupportedException(HttpServletRequest reqeust, HttpRequestMethodNotSupportedException e) {
        log.error("handleHttpRequestMethodNotSupportedException", e);
        final ErrorResponse response = ErrorResponse.of(ErrorCode.METHOD_NOT_ALLOWED);
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @ExceptionHandler(ServletException.class)
 	public ResponseEntity<ErrorResponse> handler(HttpServletRequest reqeust, ServletException e) {
    	log.info("ServletException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    /**/
    @ExceptionHandler(RuntimeException.class)
 	public ResponseEntity<ErrorResponse> handler(HttpServletRequest reqeust, RuntimeException e) {
    	log.info("RunTimeException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    @ExceptionHandler(CusException.class)
 	public ResponseEntity<ErrorResponse> CusExceptionHandler(HttpServletRequest reqeust, CusException e) {
    	log.info("CusRuntimeException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(e.getErrorCode(), e.getMessage());
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    
    @ExceptionHandler(DataAccessException.class)
 	public ResponseEntity<ErrorResponse> DataAccessExceptionHandler(HttpServletRequest reqeust, DataAccessException e) {
    	log.info("DataAccessException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    
    @ExceptionHandler(TransactionException.class)
 	public ResponseEntity<ErrorResponse> TransactionExceptionHandler(HttpServletRequest reqeust, TransactionException e) {
    	log.info("TransactionException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    
    @ExceptionHandler(TimeoutException.class)
 	public ResponseEntity<ErrorResponse> TimeoutExceptionHandler(HttpServletRequest reqeust, TimeoutException e) {
    	log.info("TimeoutException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    
    @ExceptionHandler(SQLException.class)
 	public ResponseEntity<ErrorResponse> SQLExceptionHandler(HttpServletRequest reqeust, SQLException e) {
    	log.info("SqlException ##############", e);
    	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
 		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
 	}
    
    //BadSqlGrammarException
    @ExceptionHandler(BadSqlGrammarException.class)
  	public ResponseEntity<ErrorResponse> BadSqlGrammarException(HttpServletRequest reqeust, SQLException e) {
     	log.info("BadSqlGrammarException ##############", e);
     	final ErrorResponse response = ErrorResponse.of(ErrorCode.SERVICE_FAILED);
  		return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
  	}
    
}
