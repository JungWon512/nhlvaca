package com.auc.common.vo;

import java.io.Serializable;

public class JwtResponse implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5489562268116423537L;
	
    private final String jwttoken;
    private int status;
    private String key;
    private String iv;
    private String userId;
    private String eno;
    private String na_bzplc;
    private String security;
    private String na_bzplnm;
    private String usrnm;
    private String grp_c;
    private String strg_dt;
    private String strg_yn;
    
    public JwtResponse(String jwttoken) {
        this.jwttoken = jwttoken;
    }
    
    public JwtResponse(String jwttoken, int status, String key, String iv, String userId, String eno, String na_bzplc, String security, String na_bzplnm, String usrnm, String grp_c, String strg_dt, String strg_yn) {
        this.jwttoken  = jwttoken;
        this.status    = status;
        this.key       = key;
        this.iv        = iv;
        this.userId    = userId;
        this.eno       = eno;
        this.na_bzplc  = na_bzplc;
        this.security  = security;
        this.na_bzplnm = na_bzplnm;
        this.usrnm     = usrnm;
        this.grp_c     = grp_c;
        this.strg_dt   = strg_dt;
        this.strg_yn   = strg_yn;
    }

    public String getToken() {
        return this.jwttoken;
    }
    
    public int getStatus() {
        return this.status;
    }
    
    public String getKey() {
        return this.key;
    }
    
    public String getIv() {
        return this.iv;
    }

	public String getUserId() {
		return this.userId;
	}

	public String getEno() {
		return this.eno;
	}

	public String getNa_bzplc() {
		return this.na_bzplc;
	}
	
	public String getNa_bzplnm() {
		return this.na_bzplnm;
	}
	
	public String getUsrnm() {
		return this.usrnm;
	}
	
	public String getGrp_c() {
		return this.grp_c;
	}
	
	public String getStrg_dt() {
		return this.strg_dt;
	}
	public String getStrg_yn() {
		return this.strg_yn;
	}
	
	public String getSecurity() {
		return this.security;
	}
    
}
