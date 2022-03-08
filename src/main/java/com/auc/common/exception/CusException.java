package com.auc.common.exception;

import java.io.Serializable;

public class CusException extends Exception implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private ErrorCode errorCode;
	private String message;
	
	public CusException(ErrorCode errorCode) {
		super(errorCode.getMessage());
		this.errorCode = errorCode;
	}
	
	public CusException(ErrorCode errorCode, String message) {
		super(message);
		this.errorCode = errorCode;
		this.message   = message;
	}
	
	public ErrorCode getErrorCode() {
		return this.errorCode;
	}
	
	public String getMessage() {
		return this.message;
	}
	

}
