package com.auc.mca;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.AccessControlList;
import com.amazonaws.services.s3.model.AmazonS3Exception;
import com.amazonaws.services.s3.model.BucketCrossOriginConfiguration;
import com.amazonaws.services.s3.model.CORSRule;
import com.amazonaws.services.s3.model.GroupGrantee;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.Permission;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.util.Base64;
import com.amazonaws.util.IOUtils;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;

@Component
public class McaUtil {

	private static Logger log = LoggerFactory.getLogger(McaUtil.class);
	
	@Autowired
    TradeMcaMsgDataController tradeMcaMsgDataController;
	
    public Map<String, Object> tradeMcaMsg(String ctgrm_cd, Map<String, Object> map) throws Exception{
    	Map<String, Object> reMap = new HashMap<String, Object>();
    	log.info(" ################# McaUtil : START #################");
        reMap = tradeMcaMsgDataController.tradeMcaMsg(ctgrm_cd, changeKeyUpper(map));
        log.info(" ################# McaUtil : END ###################\n" + reMap.toString());
        return reMap;
    }

	public Map<String, Object> tradeMcaMsgTmp(String ctgrm_cd, Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
        reMap = tradeMcaMsgDataController.tradeMcaMsgTmp(ctgrm_cd, map);
        return reMap;
	}
    
    public Map<String, Object> changeKeyUpper(Map<String, Object> map){
    	Map<String, Object> reMap = new HashMap<String, Object>();
    	 //키 대문자로 변환
	    Set<String> set = map.keySet();
	    Iterator<String> e = set.iterator();
	    while(e.hasNext()){
	        String key = e.next();
	        Object value = (Object) map.get(key);
	        reMap.put(key.toUpperCase(), value);
	    }
    	return reMap;
    }
    
    public Map<String, Object> changeKeyLower(Map<String, Object> map){
    	Map<String, Object> reMap = new HashMap<String, Object>();
    	 //키 대문자로 변환
	    Set<String> set = map.keySet();
	    Iterator<String> e = set.iterator();
	    while(e.hasNext()){
	        String key = e.next();
	        Object value = (Object) map.get(key);
	        reMap.put(key.toLowerCase(), value);
	    }
    	return reMap;
    }

	/**
	 * @methodName    : getOpenDataApi
	 * @author        : Jung JungWon
	 * @param map 
	 * @throws CusException 
	 * @date          : 2022.11.02
	 * @Comments      : 
	 */
	public Map<String, Object> getOpenDataApi(Map<String, Object> map) throws CusException {
		// TODO Auto-generated method stub

		Map<String, Object> nodeMap      = new HashMap<String, Object>();
		String sendUrl = "http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch";
		sendUrl += "?serviceKey=" + "7vHI8ukF3BjfpQW8MPs9KtxNwzonZYSbYq6MVPIKshJNeQHkLqxsqd1ru5btfLgIFuLRCzCLJDLYkHp%2FvI6y0A%3D%3D";
		sendUrl += "&traceNo=" + map.get("trace_no");//  "002125769192";
		//sendUrl += "&optionNo=" + map.get("option_no");//"7"; 브루셀라
        HttpURLConnection conn = null;
		log.debug("sendUrl: " + sendUrl);
		try {
			StringBuilder urlBuilder = new StringBuilder(sendUrl);
	        URL url = new URL(urlBuilder.toString());
				
			
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(1000);
			conn.setReadTimeout(1000);
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        log.debug("Response code: " + conn.getResponseCode());
	        BufferedReader rd = null;
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <=300 ) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			}else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
	        
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        log.debug(sb.toString());
	        JSONObject json = XML.toJSONObject(sb.toString());
	        
	        if(json != null && json.getJSONObject("response") != null && json.getJSONObject("response").getJSONObject("body") !=null
	        		&& json.getJSONObject("response").getJSONObject("body").getJSONObject("items") != null) {
		        JSONArray jArr = json.getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONArray("item");
		        for(Object item : jArr) {
		        	JSONObject jItem = (JSONObject) item;
		        	String infoType = jItem.get("infoType").toString();
		        	if("5,6,7".indexOf(infoType)> -1) {
		        		Iterator<String> it =jItem.keySet().iterator();
		        		while(it.hasNext()) {
		        			String key = (String) it.next();
			        		nodeMap.put(key, jItem.get(key));			        			
		        		}
		        		
		        	}
		        }	        	
	        }	        
		} catch (JSONException e) {
			log.debug("openData 접종정보 연계 중 오류가 발생하였습니다.",e);
			nodeMap = null;
        } catch (RuntimeException e) {
        	log.debug("openData 접종정보 연계 중 오류가 발생하였습니다.",e);
			nodeMap = null;
        } catch (Exception e) {
        	log.debug("openData 접종정보 연계 중 오류가 발생하였습니다.",e);
			nodeMap = null;
        } finally {
            if (conn!= null) conn.disconnect();
        }
		return nodeMap;
	}

	public List<Map<String, Object>> getOpenDataApiCattleMove(Map<String, Object> map) throws CusException {
		// TODO Auto-generated method stub

		List<Map<String, Object>> nodeList      = new ArrayList<>();
		String sendUrl = "http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch";
		sendUrl += "?serviceKey=" + "7vHI8ukF3BjfpQW8MPs9KtxNwzonZYSbYq6MVPIKshJNeQHkLqxsqd1ru5btfLgIFuLRCzCLJDLYkHp%2FvI6y0A%3D%3D";
		sendUrl += "&traceNo=" + map.get("trace_no");//  "410002125769192";
		sendUrl += "&optionNo=2"; //"2"; 이동정보
		
        HttpURLConnection conn = null;
		log.debug("sendUrl: " + sendUrl);
		try {
			StringBuilder urlBuilder = new StringBuilder(sendUrl);
	        URL url = new URL(urlBuilder.toString());
				
			
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(1000);
			conn.setReadTimeout(1000);
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        log.debug("Response code: " + conn.getResponseCode());
	        BufferedReader rd = null;
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <=300 ) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			}else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
	        
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        log.debug(sb.toString());
	        JSONObject json = XML.toJSONObject(sb.toString());
	        
	        if(json != null && json.getJSONObject("response") != null && json.getJSONObject("response").getJSONObject("body") !=null
	        		&& json.getJSONObject("response").getJSONObject("body").getJSONObject("items") != null) {
		        JSONArray jArr = json.getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONArray("item");
		        for(Object item : jArr) {
		        	JSONObject jItem = (JSONObject) item;
	        		Iterator<String> it =jItem.keySet().iterator();
	        		HashMap<String,Object> nodeMap = new HashMap<String, Object>();
	        		while(it.hasNext()) {
	        			String key = (String) it.next();
		        		nodeMap.put(key, jItem.get(key));
	        		}
	        		nodeMap.put("SRA_INDV_AMNNO", map.get("trace_no"));	
	        		nodeMap.put("FARM_ADDR", nodeMap.get("farmAddr"));	
	        		nodeMap.put("FARMER_NM", nodeMap.get("farmerNm"));	
	        		nodeMap.put("REG_TYPE", nodeMap.get("regType"));	
	        		nodeMap.put("REG_YMD", nodeMap.get("regYmd"));	
	        		nodeMap.put("FARM_NO", nodeMap.get("farmNo"));	
	        		nodeList.add(nodeMap);
		        }	        	
	        }	        
		}catch (Exception e) {
        	log.debug("openData 이동정보 연계 중 오류가 발생하였습니다.",e);
        	nodeList =null;
        	//throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } finally {
            if (conn!= null) conn.disconnect();
        }
		return nodeList;
	}
}
