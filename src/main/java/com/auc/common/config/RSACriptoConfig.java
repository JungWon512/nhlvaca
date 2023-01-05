package com.auc.common.config;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class RSACriptoConfig {
	
	private static Logger log = LoggerFactory.getLogger(RSACriptoConfig.class);

	public String decryptRsa(PrivateKey privateKey, String encodeValue) {
		
		String decryptvalue = "";
		
		try {
			
			Cipher cipher = Cipher.getInstance("RSA");			
			byte[] encrpytedBytes = hexToByteArray(encodeValue);			
			cipher.init(cipher.DECRYPT_MODE, privateKey);			
			byte[] decryptedBytes = cipher.doFinal(encrpytedBytes);
			decryptvalue = new String(decryptedBytes, "UTF-8");			
		}catch(RuntimeException | NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException | UnsupportedEncodingException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
		
		return decryptvalue;
	}
	
	public static byte[] hexToByteArray(String hex) {
		
		if(hex == null || hex.length() % 2 != 0) {
			return new byte[] {};
		}
		
		byte[] bytes = new byte[hex.length() / 2];
		
		for(int i = 0; i < hex.length(); i +=2) {
			
			byte value = (byte)Integer.parseInt(hex.substring(i, i +2), 16);
			bytes[(int)Math.floorDiv(i, 2)] = value;
		}
		
		return bytes;
	}

	public String byteArrayToHex(byte[] ba) {
		if(ba == null || ba.length == 0) return null;
		StringBuffer sb = new StringBuffer();
		String hexNumber = "";
		
		for(int x = 0 ; x< ba.length;x++) {
			hexNumber = "0"+Integer.toHexString(0xff & ba[x]);
			sb.append(hexNumber.substring(hexNumber.length()-2));
		}
		
		return sb.toString();
	}


	public PrivateKey StringToPrivateKey(String str) {
		PrivateKey privateKey = null;
		try {
			PKCS8EncodedKeySpec rkeySpec = new PKCS8EncodedKeySpec(hexToByteArray(str));
			KeyFactory rKeyFactory = KeyFactory.getInstance("RSA");
			privateKey = rKeyFactory.generatePrivate(rkeySpec);
		}catch (RuntimeException | NoSuchAlgorithmException | InvalidKeySpecException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
		return privateKey;
	}


	public PublicKey StringToPublicKey(String str) {
		PublicKey publicKey = null;
		try {
			X509EncodedKeySpec pKeySpec = new X509EncodedKeySpec(this.hexToByteArray(str));
			KeyFactory pKeyFactory = KeyFactory.getInstance("RSA");
			publicKey = pKeyFactory.generatePublic(pKeySpec);
		}catch (RuntimeException | NoSuchAlgorithmException | InvalidKeySpecException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
		return publicKey;
	}
	
	
	
		
	
	
}
