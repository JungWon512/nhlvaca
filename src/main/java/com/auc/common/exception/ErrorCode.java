package com.auc.common.exception;

public enum ErrorCode {
	/*****************************************************************/
	/** STATUS 200 :  정상                                          **/
	/** STATUS 201 :  조회 및 저장 내역 없음(NOTFOUND 키워드로 페스)**/
	/** STATUS 202 :  전송실패                                      **/
	/** STATUS 203 :  ---                                           **/
	/** STATUS 204 :  TOKEN 에러                                    **/
	/** STATUS 205 :  CONTROLLER 에러                               **/
	/*****************************************************************/
	
	
	//token
    NOT_LOGIN(204, "T001", "로그인이 되어있지 않습니다."),
    EXPIERD_TOKEN(204, "T002", "만료된 사용자입니다."),
    INVALID_TOKEN(204, "T003", "부정확한 사용자입니다."),
    UNABLE_TOKEN(204, "T004", "알수없는 사용자입니다."), 
    EXPIERD_SESSION(204,"T005","세션이 만료되었습니다."),
    EXPIERD_REFRESH(204,"T006","접속 정보가 만료되었습니다.<br/>다시 로그인 하세요."),
    //controller
    INVALID_INPUT_VALUE(205 , "C001", "적합하지 않은 문자열입니다."),
    METHOD_NOT_ALLOWED(205  , "C002", "허용되지 않습니다."),
    HANDLE_ACCESS_DENIED(205, "C006", "권한이 존재하지 않습니다."),
    
    SERVICE_FAILED(205, "C007", "서버 수행중 오류가 발생하였습니다."),
    
    CUSTOM_ERROR(205, "C999", "")    ;
	private int status;
	private String code;
	private String message;
	private String detail;

	ErrorCode(int status, String code, String message) {
		this.status = status;
		this.message = message;
		this.code = code;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}
}
