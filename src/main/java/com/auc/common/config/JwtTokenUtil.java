package com.auc.common.config;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.auc.common.vo.JwtUser;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtTokenUtil implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8250897625474163657L;
	public static final long JWT_TOJEN_VALIDITY = 10 * 60; 
	
	@Value("${jwt.secret}")
	private String secret;
	
	//retrieve username from jwt token
    public String getUsernameFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);   
    }

    //retrieve expiration date from jwt token
    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }

    //for retrieveing any information from token we will need the secret key
    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
    }
    
  //for retrieveing any information from token we will need the secret key
    public Claims getAllClaimsFromTokenClaim(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
    }
    
    

    //check if the token has expired
    public Boolean isTokenExpired(String token) {
    	try {
            final Date expiration = getExpirationDateFromToken(token);
            return expiration.before(new Date());    		
    	}catch (ExpiredJwtException e) {
			return true;
		}
    }

    //generate token for user
    public String generateToken(JwtUser userDetails) {
        Map<String, Object> claims = new HashMap<>();
        //return doGenerateToken(claims, userDetails.getUsername());
        return doGenerateToken(claims, userDetails);
    }

    //while creating the token -
//1. Define  claims of the token, like Issuer, Expiration, Subject, and the ID
//2. Sign the JWT using the HS512 algorithm and secret key.
//3. According to JWS Compact Serialization(https://tools.ietf.org/html/draft-ietf-jose-json-web-signature-41#section-3.1)
//   compaction of the JWT to a URL-safe string
    private String doGenerateToken(Map<String, Object> claims, JwtUser userDetails) {
    	
    	claims.put("userId", userDetails.getUsername());
    	claims.put("password", userDetails.getPassword());
    	claims.put("eno", userDetails.getUserEno());
    	claims.put("userCusName", userDetails.getUserCusName());
    	claims.put("na_bzplc", userDetails.getNa_bzplc());
    	claims.put("security", userDetails.getSecurity());
    	claims.put("apl_ed_dtm", userDetails.getApl_ed_dtm());
    	claims.put("na_bzplnm", userDetails.getNa_bzplnm());
    	claims.put("grp_c", userDetails.getGrp_c());
    	
    	return Jwts.builder().setClaims(claims).setSubject(userDetails.getUsername()).setIssuedAt(new Date(System.currentTimeMillis()))
    			.setExpiration(createExpiredDate())
            .signWith(SignatureAlgorithm.HS512, secret).compact();
    }
    private String doGenerateTokenRefresh(Map<String, Object> claims, JwtUser userDetails) {
    	
    	claims.put("userId", userDetails.getUsername());
    	claims.put("password", userDetails.getPassword());
    	claims.put("eno", userDetails.getUserEno());
    	claims.put("userCusName", userDetails.getUserCusName());
    	claims.put("na_bzplc", userDetails.getNa_bzplc());
    	claims.put("security", userDetails.getSecurity());
    	claims.put("apl_ed_dtm", userDetails.getApl_ed_dtm());
    	claims.put("na_bzplnm", userDetails.getNa_bzplnm());
    	claims.put("grp_c", userDetails.getGrp_c());

    	return Jwts.builder().setClaims(claims).setSubject(userDetails.getUsername()).setIssuedAt(new Date(System.currentTimeMillis()))
    			.setExpiration(createExpiredDateRefresh())
            .signWith(SignatureAlgorithm.HS512, secret).compact();
    }

    //validate token
    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = getUsernameFromToken(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
    
    
    
    public String getSubject(String token) {
    	return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody().getSubject();
    	
    }
    
    public Boolean validateTokenIntor(String token) {
    	try {
    		Jws<Claims> claims = Jwts.parser().setSigningKey(secret) .parseClaimsJws(token);
    		if(claims.getBody().getExpiration().before(new Date())) {
    			return false;
    		}
    		return true;
    	}catch(JwtException | IllegalArgumentException e) {
    		return false;
    	}
    }
    
    /***
     * 2022.09.21 세션시간 이슈로 인하여 만료시간 토큰생성시점 + 8시간으로 수정
     * @return
     */
    private Date createExpiredDate() {
		Date date = new Date();
		date.setMinutes(date.getMinutes()+10);
		return date;
	}

	public String generateTokenRefresh(JwtUser userDetails) {
		// TODO Auto-generated method stub
        Map<String, Object> claims = new HashMap<>();
        //return doGenerateToken(claims, userDetails.getUsername());
        return doGenerateTokenRefresh(claims, userDetails);
	}
    
    
    private Date createExpiredDateRefresh() {
		Date date = new Date();
		date.setHours(date.getHours()+2);
		/*		Calendar calendar = Calendar.getInstance();
				calendar.set(calendar.get(Calendar.YEAR)
							, calendar.get(Calendar.MONTH)
							, calendar.get(Calendar.DATE)
							, 23
							, 59
							, 59);
				date = calendar.getTime();
		*/
		return date;
	}

	
}
