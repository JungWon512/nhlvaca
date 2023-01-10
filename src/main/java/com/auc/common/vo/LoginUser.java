package com.auc.common.vo;

import java.io.Serializable;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class LoginUser implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private String id;
	private String name;
	private String eno;
	
	
	public LoginUser() {
		super();
	}

	public LoginUser(String id, String name, String eno) {
		super();
		this.id = id;
		this.name = name;
		this.eno = eno;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEno() {
		return eno;
	}

	public void setEno(String eno) {
		this.eno = eno;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public void setClear() {
		this.id = null;
		this.name = null;
		this.eno = null;
	}

	@Override
	public String toString() {
		return "LoginUser [id=" + id + ", name=" + name + ", eno=" + eno + "]";
	}
	
		
}
