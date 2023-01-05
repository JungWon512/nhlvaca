package com.auc.common.exception;

public class ErrorResponse {

	private String message;
	private String code;
	private int status;
	private String detail;
	
	public ErrorResponse() {
		super();
	}

	public ErrorResponse(ErrorCode code) {
        this.message = code.getMessage();
        this.status = code.getStatus();
        this.code = code.getCode();
        this.detail = code.getDetail();
    }

	public static ErrorResponse of(ErrorCode code) {		
		 return new ErrorResponse(code);
	}
	
	public static ErrorResponse of(ErrorCode code, String message) {
		 code.setMessage(message);
		 return new ErrorResponse(code);
	}
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	@Override
	public String toString() {
		return "ErrorResponse [message=" + message + ", code=" + code + ", status=" + status + ", detail=" + detail;
	}
	
	
}
