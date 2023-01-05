package com.auc.common.config;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class CriptoConfig {
	
	private static Logger log = LoggerFactory.getLogger(CriptoConfig.class);
	
	
	@Value("${cript.key}")
    private String key;
	@Value("${cript.iv}")
    private String iv;
    
    private String text;
    private String enText;
    
    
    public void setText(String text) {
    	this.text = text;
    }
    
    public String getEnText() throws Exception {    	
    	try {
			enText = encript(text);
		} catch (RuntimeException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
    	
    	return this.enText;
    }
	

	public Key getAESKey()  {		
	    
		//String iv;
	    Key keySpec=null;
	    //iv = key.substring(0, 16);
	    byte[] keyBytes = new byte[16];
	    byte[] b;
		try {
			b = key.getBytes("UTF-8");

		    int len = b.length;
		    if (len > keyBytes.length) {
		       len = keyBytes.length;   
		    }

		    System.arraycopy(b, 0, keyBytes, 0, len);
		    keySpec = new SecretKeySpec(keyBytes, "AES");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	    return keySpec;
	}
	
	// 암호화
	public String encript(String str) {
	    String enStr ="";
		try {
			Key keySpec = getAESKey();
		    Cipher c;
			c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
		    byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		    enStr = new String(Base64.encodeBase64(encrypted));
		} catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | InvalidAlgorithmParameterException | UnsupportedEncodingException | IllegalBlockSizeException | BadPaddingException e) {
			// TODO Auto-generated catch block
			log.info("Encript Exception");
			enStr="";
		}

	    return enStr;
	    
	}
    

	public String decrypt(String text){
		
			Key keySpec;
			String decStr = "";
			try {
				keySpec = getAESKey();			
			    Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			    c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
			    byte[] byteStr = Base64.decodeBase64(text.getBytes("UTF-8"));
			    decStr = new String(c.doFinal(byteStr), "UTF-8");
		    
			} catch (RuntimeException | BadPaddingException | NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | InvalidAlgorithmParameterException | UnsupportedEncodingException | IllegalBlockSizeException e) {
				log.info("동작중 오류가 발생하였습니다.");
				decStr="";
			}
		
			return decStr;
	}
	
	
    
}
