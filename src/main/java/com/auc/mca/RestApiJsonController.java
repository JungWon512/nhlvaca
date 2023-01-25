package com.auc.mca;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.http.HttpStatus;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.google.gson.Gson;

@Controller
public class RestApiJsonController {
	
	private static Logger logger = LoggerFactory.getLogger(RestApiJsonController.class);
	String ctrn_cd = "";//거래코드
    String responseBody = "";
    
	@Value("${mca.ip}")
	private String mcaIp;
    
	//전문 보내고 받기
    public Map<String, Object> mcaSendMsg(String ctgrm_cd, int io_all_yn, String ccls_cd, String data) throws Exception {      
    	responseBody = "";
        //보낸메시지
        String sendMsg = setSendMsg(ctgrm_cd, io_all_yn, ccls_cd, data);
        //전문보내기
        sendPostJson(sendMsg);
        //받은메시지
        String recvMsg = responseBody;
        logger.info(recvMsg);
        Map<String, Object> map = new HashMap<String, Object>();
        //받은메시지를 map에 담기
        if(recvMsg.length()>0) {
            map = getMapFromJsonObject(recvMsg,ctgrm_cd);
        }else {
            map.put("jsonHeader", "Error");
            map.put("dataCnt", "0");
            map.put("jsonList", null);
        }
        return map;
    }
    
    //전문 전체(header + body)
    public String setSendMsg(String ctgrm_cd, int io_all_yn, String ccls_cd, String data) throws Exception {
        String header = setSndHeader(ctgrm_cd, ccls_cd, io_all_yn);        
        StringBuffer str = new StringBuffer();
        str.append("{");
        str.append(header);
        str.append(",");
        str.append("\"data\":{");
        str.append(data);
        str.append("}");
        str.append("}");        
        logger.info("mca sendMsg >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" + str);
        return str.toString();
    }
    
  //전문 header
    public String setSndHeader(String ctgrm_cd, String ccls_cd, int io_all_yn) throws Exception {
        
        String cspr_cd = "I";
        if("0210".equals(ccls_cd)) {
            cspr_cd = "O";
        }
        setData(ctgrm_cd);
        
        String ctgrm_chsnb= "";//전문 추적번호
        Calendar calendar = Calendar.getInstance();
        Date calcDate = calendar.getTime();
        String ccrt_date = new SimpleDateFormat("yyyyMMdd").format(calcDate);
        String ccrt_time = new SimpleDateFormat("HHmmss").format(calcDate);
        String ctgrm_trnsm_datetime = new SimpleDateFormat("yyyyMMddHHmmss").format(calcDate);
        
        Random r = new Random();
        r.setSeed(new Date().getTime());                
        ctgrm_chsnb = "00FD68_" + String.format("%08d", r.nextInt(99999999));
         
        StringBuffer sb = new StringBuffer();
        sb.append("\"header\":{");
        sb.append("\"CSTX\":\"\\u0002\"");
        sb.append(",\"CTGRM_CD\":\"" + ctgrm_cd + "\"");
        sb.append(",\"CTGRM_CHSNB\":\"" + ctgrm_chsnb + "\"");
        sb.append(",\"CCRT_DATE\":\"" + ccrt_date + "\"");
        sb.append(",\"CCRT_TIME\":\"" + ccrt_time + "\"");
        sb.append(",\"CORG_CD\":\"NHAH\"");
        sb.append(",\"CBSN_CD\":\"FD68\"");
        sb.append(",\"CCLS_CD\":\"" + ccls_cd + "\"");
        sb.append(",\"CTRN_CD\":\"" + ctrn_cd + "\"");
        sb.append(",\"CSPR_CD\":\"" + cspr_cd + "\"");
        sb.append(",\"CTGRM_TRNSM_DATETIME\":\"" + ctgrm_trnsm_datetime + "\"");
        sb.append(",\"CTGRM_RSP_CD\":\"0000\"");
        if("1400".equals(ctgrm_cd) || //개체정보
           "4600".equals(ctgrm_cd) || //개체정보
           "1700".equals(ctgrm_cd) || //수수료정보
           "1800".equals(ctgrm_cd) || //불량거래인
           "2500".equals(ctgrm_cd) || //공통코드
           "3300".equals(ctgrm_cd) || //KPN정보
           "3400".equals(ctgrm_cd) || //거래처(산정위원_수의사)
           "2200".equals(ctgrm_cd) || //개체이력조회
           "4700".equals(ctgrm_cd) //개체이력조회
		){    
        	if(io_all_yn == 1) { //전체여부
        		sb.append(",\"CRSRVD\":\"                       1\"");
        	}else {
        		sb.append(",\"CRSRVD\":\"                       0\"");
        	}
        }else {
        	sb.append(",\"CRSRVD\":\"                        \"");
        }
        sb.append("}");
        
        logger.info("mca Header >>>>>>>>>>>>>>>>>>>>>>>> " + sb);
        return sb.toString();
    }
    
  //리턴 받은 전문에서 header, data 가져오기
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public Map<String, Object> getMapFromJsonObject(String jsonObj,String ctgrm_cd) throws JSONException{
        
        Map<String, Object> map = new HashMap<String, Object>();
        
        Gson gson = new Gson();
        
        Map<String, Object> jsonObject = new HashMap<String, Object>();
        jsonObject = gson.fromJson(jsonObj,  jsonObject.getClass());
          
        Map<String, Object> jsonHeader = (Map)jsonObject.get("header");
        Map<String, Object> jsonData = (Map)jsonObject.get("data");
        List<Map<String, Object>> jsonList = null;
        if(jsonData.containsKey("RPT_DATA")) {
            jsonList = (List)jsonData.get("RPT_DATA");
        }
        
        int cnt = 0;
        
        if(jsonData.containsKey("IO_ROW_CNT")) {        	
        	if("4600".equals(ctgrm_cd) || "5200".equals(ctgrm_cd)) {
        		cnt  = Integer.valueOf((String)jsonData.getOrDefault("IO_ROW_CNT","0"));
        	}else {
            	cnt  = (int)(double)jsonData.get("IO_ROW_CNT");        		
        	}
        }
        
        logger.info("mca receive >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+jsonObj);
        logger.info("mca receive data to map >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        logger.info("jsonHeader : " + jsonHeader.toString());
        logger.info("dataCnt : "    + cnt);
        logger.info("jsonData : "   + jsonData.toString());
        logger.info("mca receive data to map <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        
        map.put("jsonHeader", jsonHeader);
        map.put("dataCnt", cnt);
        map.put("jsonData", jsonData);
       	map.put("jsonList", jsonList);
        
        return map;
    }
    
  //전문전송
    public boolean sendPostJson(String jsonValue) throws Exception{

    	URL url = new URL(mcaIp);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();

        boolean result = true;
        try {
            logger.debug("REST API START");
            
            byte[] sendData = jsonValue.getBytes("UTF-8");

            con.setDoOutput(true);
            con.setRequestMethod("POST");
            con.setRequestProperty("Cache-Control", "no-cache");
            con.setRequestProperty("Pragma", "no-cache");
            con.setRequestProperty("Content-Type", "application/json");
            con.setRequestProperty("Accept-Charset", "UTF-8");
            con.setRequestProperty("Content-Length", String.valueOf(sendData.length));
            con.setConnectTimeout(5000);//서버 접속시 연결시간
            con.setReadTimeout(30000);//Read시 연결시간
            con.getOutputStream().write(sendData);
            con.getOutputStream().flush();
            con.connect();

            int responseCode = con.getResponseCode();
            String responseMessage = con.getResponseMessage();

            logger.debug("REST API responseCode : " + responseCode);
            logger.debug("REST API responseMessage : " + responseMessage);
            
            if(con.getResponseCode() == 301 || con.getResponseCode() == 302 || con.getResponseCode() == 307) // 300번대 응답은 redirect
            {
//                String location = con.getHeaderField("Location");
//                con.disconnect();
//                return doJson(new URL(location), param, json, charset);
            }else {
                StringBuffer sb = new StringBuffer();
                BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
                for(String line; (line = reader.readLine()) != null; )
                {
                    sb.append(line).append("\n");
                }
                responseBody = sb.toString();
            }
            
            con.disconnect();
            
            logger.debug("REST API END"); 
            
        } catch (RuntimeException e) {
            throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } catch (Exception e) {
        	logger.debug(e.getMessage());
            throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } finally {
            if (con!= null) con.disconnect();
        }
        
        return result;
    }
    
    //전문유형코드별 설정
    public void setData(String ctgrm_cd) {
    	
    	if("1200".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0012";
        }else if("1300".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0013";
        }else if("1400".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0014";
        }else if("1500".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0015";
        }else if("1600".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0016";
        }else if("1700".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0017";
        }else if("1800".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0018";
        }else if("1900".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0019";
        }else if("2000".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0020";
        }else if("2100".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0021";
        }else if("2200".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0022";
        }else if("2300".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0023";
        }else if("2400".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0024";
        }else if("2500".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0025";
        }else if("2600".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0026";
        }else if("2700".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0027";
        }else if("2800".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0028";
        }else if("2900".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0029";
        }else if("3000".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0030";
        }else if("3100".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0031";
        }else if("3200".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0032";
        }else if("3300".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0033";
        }else if("3400".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0034";
        }else if("3500".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0035";
        }else if("3600".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0036";
        }else if("3700".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0037";
        }else if("3800".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0038";
        }else if("3900".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0039";
        }else if("4000".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0040";
        }else if("4100".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0041";
        }else if("4200".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0042";
        }else if("4300".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0043";
        }else if("4500".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0045";
        }else if("4600".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0046";
        }else if("4700".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0047";
        }else if("4900".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0049";
        }else if("5100".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0051";
        }else if("5200".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0052";
        }else if("5300".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0053";
        }else if("5400".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0054";
        }else if("5500".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0055";
        }else if("5600".equals(ctgrm_cd)) {
            ctrn_cd = "IFLM0056";
        }
    }
	
	/**
	 * DynamicLink 생성
	 * @param params
	 * @return
	 * @throws CusException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> createShortLinkMap (final Map<String, Object> params) throws CusException, IOException {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String makeUrl = "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCE1O0S6Kzz4GQKIShVIiL9Nuuwpa2vHUY";
		URL url = new URL(makeUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		
		try {
			final String link = ObjectUtils.isEmpty(params.get("TARGET_LINK")) ? "https://www.xn--o39an74b9ldx9g.kr" : params.get("TARGET_LINK").toString();
			
			final StringBuffer dynamicLink = new StringBuffer();
			dynamicLink.append("https://nhauction.page.link/?link=https://nhauction.page.link/dp");		// 고정
			dynamicLink.append("?urlParam=");					
			dynamicLink.append(URLEncoder.encode(link, "UTF-8"));			// 이동할 링크 url ( URL Encodin 필요 )
			dynamicLink.append("&ofl=");						
			dynamicLink.append(URLEncoder.encode(link, "UTF-8"));			// 안드로이드, IOS외의 플랫폼에서 사용 할 링크 url ( URL Encodin 필요 )
			dynamicLink.append("&apn=com.nh.cowauction");					// 링크를 여는 데 사용할 Android 앱의 패키지 이름
			dynamicLink.append("&ibi=com.nh.cow.auction");					// 링크를 여는 데 사용할 iOS 앱의 번들 ID
			dynamicLink.append("&isi=1588847718");							// 앱이 설치되지 않았을 때 사용자를 App Store로 보내는 데 사용되는 앱의 App Store ID
			dynamicLink.append("&efr=1");									// Dynamic Link가 열렸을 때 앱 미리보기 페이지를 건너뛰고 대신 앱이나 스토어로 리디렉션(IOS)
			dynamicLink.append("&st=NH 가축시장");							// Dynamic Link를 공유할 때 사용할 제목
			dynamicLink.append("&sd=간편하고 스마트하게 경매하는 방법");	// Dynamic Link를 공유할 때 사용할 설명
			dynamicLink.append("&si=https://www.xn--o39an74b9ldx9g.kr/static/images/guide/new_mo_banner.jpg");	// 링크와 관련된 이미지의 URL( 300X200 이상, 300KB 미만 )
			
			final JSONObject jsonObject = new JSONObject();
			jsonObject.put("longDynamicLink", dynamicLink.toString());
			byte[] sendData = jsonObject.toString().getBytes("UTF-8");
			
			con.setDoOutput(true);
			con.setRequestMethod("POST");
			con.setRequestProperty("Cache-Control", "no-cache");
			con.setRequestProperty("Pragma", "no-cache");
			con.setRequestProperty("Content-Type", "application/json");
			con.setRequestProperty("Accept-Charset", "UTF-8");
			con.setRequestProperty("Content-Length", String.valueOf(sendData.length));
			con.setConnectTimeout(1000);//서버 접속시 연결시간
			con.setReadTimeout(5000);//Read시 연결시간
			con.getOutputStream().write(sendData);
			con.getOutputStream().flush();
			con.connect();
			
			int responseCode = con.getResponseCode();
			String responseMessage = con.getResponseMessage();
			
			logger.debug("REST API responseCode : " + responseCode);
			logger.debug("REST API responseMessage : " + responseMessage);
			
			if(con.getResponseCode() == HttpStatus.SC_OK) {
				StringBuffer sb = new StringBuffer();
				BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
				for(String line; (line = reader.readLine()) != null;)
				{
					sb.append(line).append("\n");
				}
				responseBody = sb.toString();
				Gson gson = new Gson();
				rtnMap = gson.fromJson(responseBody, rtnMap.getClass());
			}
			
			con.disconnect();
			logger.debug("REST API END"); 
		}
		catch (RuntimeException e) {
			logger.error(e.getMessage());
		}
		catch (Exception e) {
			logger.error(e.getMessage());
		}
		finally {
			if (con!= null) con.disconnect();
		}
		return rtnMap;
	}
	/**
	 * 
	 * DynamicLink 생성
	 * @param params
	 * @return
	 * @throws CusException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public String createShortLink (final String targetLink) throws CusException, IOException {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String makeUrl = "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCE1O0S6Kzz4GQKIShVIiL9Nuuwpa2vHUY";
		URL url = new URL(makeUrl);
		HttpURLConnection con = null;
		String shortLink = "";

		try {
			HostnameVerifier hv = new HostnameVerifier() {
				@Override
				public boolean verify(String arg0, SSLSession arg1) {
					return true;
				}
			};
			TrustManager[] trustAllCerts = new TrustManager[] {
				new X509TrustManager() {
					@Override
					public X509Certificate[] getAcceptedIssuers() {
						return null;
					}
					
					@Override
					public void checkServerTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {return;}
					
					@Override
					public void checkClientTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {return;}
				}
			};
			
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
			HttpsURLConnection.setDefaultHostnameVerifier(hv);
			
			con = (HttpURLConnection) url.openConnection();
			
			final StringBuffer dynamicLink = new StringBuffer();
			dynamicLink.append("https://nhauction.page.link/?link=https://nhauction.page.link/dp");		// 고정
			dynamicLink.append("?urlParam=");					
			dynamicLink.append(URLEncoder.encode(targetLink, "UTF-8"));		// 이동할 링크 url ( URL Encodin 필요 )
			dynamicLink.append("&ofl=");						
			dynamicLink.append(URLEncoder.encode(targetLink, "UTF-8"));		// 안드로이드, IOS외의 플랫폼에서 사용 할 링크 url ( URL Encodin 필요 )
			dynamicLink.append("&apn=com.nh.cowauction");					// 링크를 여는 데 사용할 Android 앱의 패키지 이름
			dynamicLink.append("&ibi=com.nh.cow.auction");					// 링크를 여는 데 사용할 iOS 앱의 번들 ID
			dynamicLink.append("&isi=1588847718");							// 앱이 설치되지 않았을 때 사용자를 App Store로 보내는 데 사용되는 앱의 App Store ID
			dynamicLink.append("&efr=1");									// Dynamic Link가 열렸을 때 앱 미리보기 페이지를 건너뛰고 대신 앱이나 스토어로 리디렉션(IOS)
			dynamicLink.append("&st=NH 가축시장");							// Dynamic Link를 공유할 때 사용할 제목
			dynamicLink.append("&sd=간편하고 스마트하게 경매하는 방법");	// Dynamic Link를 공유할 때 사용할 설명
			dynamicLink.append("&si=https://www.xn--o39an74b9ldx9g.kr/static/images/guide/new_mo_banner.jpg");	// 링크와 관련된 이미지의 URL( 300X200 이상, 300KB 미만 )
			
			final JSONObject jsonObject = new JSONObject();
			jsonObject.put("longDynamicLink", dynamicLink.toString());
			byte[] sendData = jsonObject.toString().getBytes("UTF-8");
			
			con.setDoOutput(true);
			con.setRequestMethod("POST");
			con.setRequestProperty("Cache-Control", "no-cache");
			con.setRequestProperty("Pragma", "no-cache");
			con.setRequestProperty("Content-Type", "application/json");
			con.setRequestProperty("Accept-Charset", "UTF-8");
			con.setRequestProperty("Content-Length", String.valueOf(sendData.length));
			con.setConnectTimeout(1000);//서버 접속시 연결시간
			con.setReadTimeout(5000);//Read시 연결시간
			con.getOutputStream().write(sendData);
			con.getOutputStream().flush();
			con.connect();
			
			int responseCode = con.getResponseCode();
			String responseMessage = con.getResponseMessage();
			
			logger.debug("REST API responseCode : " + responseCode);
			logger.debug("REST API responseMessage : " + responseMessage);
			
			if(con.getResponseCode() == HttpStatus.SC_OK) {
				StringBuffer sb = new StringBuffer();
				BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
				for(String line; (line = reader.readLine()) != null;)
				{
					sb.append(line).append("\n");
				}
				responseBody = sb.toString();
				Gson gson = new Gson();
				rtnMap = gson.fromJson(responseBody, rtnMap.getClass());
			}
			
			shortLink = rtnMap.getOrDefault("shortLink", targetLink).toString();
			
			con.disconnect();
			logger.debug("REST API END"); 
		}
		catch (RuntimeException e) {
			logger.error(e.getMessage());
			return targetLink;
		}
		catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return targetLink;
		}
		finally {
			if (con!= null) con.disconnect();
		}
		
		return shortLink;
	}
	
}

