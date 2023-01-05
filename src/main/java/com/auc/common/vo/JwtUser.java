package com.auc.common.vo;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;

@Component
public class JwtUser implements UserDetails{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String password;
	private String eno;
	private String username;
	private String na_bzplc;
	private String security;
	private String apl_ed_dtm;
	private String grp_c;
	private String na_bzplnm;
	private String strg_dt;
	private String strg_yn;
	
	public JwtUser() {super();}
	
	public JwtUser(Claims claims) {
		this.userId     = (String)claims.get("userId");
		this.password   = (String)claims.get("password");
		this.eno        = (String)claims.get("eno");
		this.username   = (String)claims.get("userCusName");
		this.na_bzplc   = (String)claims.get("na_bzplc");
		this.security   = (String)claims.get("security");
		this.apl_ed_dtm = (String)claims.get("apl_ed_dtm");
		this.grp_c      = (String)claims.get("grp_c");
		this.na_bzplnm  = (String)claims.get("na_bzplnm");
	}
	
	public JwtUser(String userId, String password, String eno, String username, String na_bzplc, String na_bzplnm, String grp_c, String strg_dt, String strg_yn) {
		this.userId   = userId;
		this.password = password;
		this.eno      = eno;
		this.username = username;
		this.na_bzplc = na_bzplc;
		this.grp_c     = grp_c;
		this.na_bzplnm = na_bzplnm;
		this.strg_dt   = strg_dt;
		this.strg_yn   = strg_yn;
	}

	public String getPassword() {
		return this.password;
	}

	public String getUsername() {
		return this.userId;
	}
	
	public String getUserCusName() {
		return this.username;
	}
	
	public String getUserEno() {
		return this.eno;		
	}	
	
	public String getNa_bzplc() {
		return this.na_bzplc;		
	}	
	
	public String getSecurity() {
		return this.security;		
	}
	
	public String getApl_ed_dtm() {
		return this.apl_ed_dtm;		
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
	
	public String getNa_bzplnm() {
		return this.na_bzplnm;		
	}	
	
	public void setSecurity(String security) {
		this.security = security;
	}
	public void setApl_ed_dtm(String apl_ed_dtm) {
		this.apl_ed_dtm = apl_ed_dtm;
	}

	@Override
	public String toString() {
		return "jwtUser [userId=" + userId + ", password=" + password + ", eno=" + eno + ", username=" + username + ", na_bzplc=" + na_bzplc + ", na_bzplnm=" + na_bzplnm
				+ ", security=" + security + ", grp_c=" + grp_c + ", strg_dt=" + strg_dt + ", apl_ed_dtm=" + apl_ed_dtm + "]";
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}



}
