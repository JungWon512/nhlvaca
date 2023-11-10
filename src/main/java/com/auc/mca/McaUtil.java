package com.auc.mca;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.auc.common.exception.CusException;

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
		} catch (RuntimeException | IOException e) {
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
		        
	        	Object resultObj = json.getJSONObject("response").getJSONObject("body").getJSONObject("items").get("item");		        		
		        if(resultObj instanceof JSONObject) {
		        	JSONObject jItem = (JSONObject) resultObj; 
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
		        }else if(resultObj instanceof JSONArray){
		        	JSONArray jArr = (JSONArray) resultObj; 
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
	        }	        
		} catch (RuntimeException | IOException e) {
			log.debug("openData 접종정보 연계 중 오류가 발생하였습니다.",e);
			nodeList = null;
        } catch (Exception e) {
        	log.debug("openData 이동정보 연계 중 오류가 발생하였습니다.",e);
        	nodeList =null;
        	//throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } finally {
            if (conn!= null) conn.disconnect();
        }
		return nodeList;
	}

	//종축개량 API_TEST
	public String callApiAiakV2(String barcode) {
		BufferedReader br = null;
		HttpURLConnection con = null;
		String result = "";
		
        try {
			//String tempUrl = "http://api.aiak.or.kr/v1/hims/detailInfo?barcode="+barcode;	
			//if(!port.isEmpty()) {
			//  	tempUrl = "http://api.aiak.or.kr:"+port+"/v1/hims/detailInfo?barcode="+barcode;
			//}
        	String tempUrl = "http://api.aiak.or.kr:9080/v1/hims/detailInfo?barcode="+barcode;
            log.info("callApiAiak tempUrl code : "+tempUrl);
        	URL url = new URL(tempUrl);
            //URL url = new URL("http","api.aiak.or.kr/","9080");
            //if("0".equals(sslFlag)) this.SSLVaildBypass();
            con = (HttpURLConnection) url.openConnection();
            con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
            con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
            con.setRequestMethod("GET");
            con.setRequestProperty("apikey", "KAIA_API8b749c8d2c44700f64f564b5dfd5869a6bbda33c927da182cd515be02b2b0b77");
            con.setDoOutput(false);            

            StringBuilder sb = new StringBuilder();
            log.info("callApiAiak resp code : "+con.getResponseCode());
            log.info("callApiAiak call URL : "+ url.toString());
            log.info("callApiAiak res URL: "+con.getURL());
            if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
                String line;
                while ((line = br.	readLine()) != null) {
                    sb.append(line).append("\n");
                }
                log.info("callApiAiak : "+sb.toString());
                //return sb.toString();
                result = sb.toString();
            } else {
                log.error(con.getResponseMessage());
            }
        }
        catch (Exception e) {
            log.error("Exception - https://aiak.or.kr 테스트 : ",e);
            //return e.getMessage();
        } finally {
        	try {
                if(con != null)con.disconnect();
                if(br !=null) br.close();
        	}
        	catch(Exception e) {
                log.error("Exception - https://aiak.or.kr 테스트 : ",e);
                //return e.getMessage();
        	}
		}
        return result;
	}

	public Map<String,Object> callApiAiakMap(String barcode) {
		Map<String, Object> result = new HashMap<String, Object>();
		String apiResult = this.callApiAiakV2(barcode);
		if(!apiResult.isEmpty()) {
			JSONObject jObj = new JSONObject(apiResult);
			if(jObj != null) {
				JSONObject resultSt  = jObj.getJSONObject("resultStatus");
				if("OK".equals(resultSt.get("code"))) {
					JSONObject resultVal  = jObj.getJSONObject("resultValue");
					JSONArray posterityInfo = resultVal.getJSONArray("posterity_info");
					JSONArray siblingInfo = resultVal.getJSONArray("sibling_info");
					JSONObject detailInfo  = resultVal.getJSONObject("detail_info");
					JSONObject bloodInfo  = resultVal.getJSONObject("pedigree_info");

					List<Map<String, Object>> sibInfo = new ArrayList<>(); //형매 리스트
					List<Map<String, Object>> postInfo = new ArrayList<>(); //후대 리스트
					
					result.put("SRA_INDV_AMNNO", "410"+barcode);					
					if(detailInfo.has("bv")) {
						String balBb = detailInfo.getString("bv");
						result.put("EPD_GRD_1", balBb.substring(0, 1)); //냉도체중
						result.put("EPD_VAL_1", balBb.substring(1, 10));
						result.put("EPD_GRD_2", balBb.substring(10, 11)); //배최장근단면적
						result.put("EPD_VAL_2", balBb.substring(11, 20));
						result.put("EPD_GRD_3", balBb.substring(20, 21)); //등지방두께
						result.put("EPD_VAL_3", balBb.substring(21, 30));
						result.put("EPD_GRD_4", balBb.substring(30, 31)); //근내지방도
						result.put("EPD_VAL_4", balBb.substring(31, 40));						
					}
					
					//개체식별번호
					if(bloodInfo.has("sire_barcode")) result.put("FCOW_SRA_INDV_AMNNO", bloodInfo.getString("sire_barcode")); //부
					if(bloodInfo.has("dam_barcode")) result.put("MCOW_SRA_INDV_AMNNO", bloodInfo.getString("dam_barcode")); //모
					if(bloodInfo.has("pgs_barcode")) result.put("GRFCOW_SRA_INDV_AMNNO", bloodInfo.getString("pgs_barcode")); //조부
					if(bloodInfo.has("pgd_barcode")) result.put("GRMCOW_SRA_INDV_AMNNO", bloodInfo.getString("pgd_barcode")); //조모
					if(bloodInfo.has("mgs_barcode")) result.put("MTGRFCOW_SRA_INDV_AMNNO", bloodInfo.getString("mgs_barcode")); //외조부
					if(bloodInfo.has("mgd_barcode")) result.put("MTGRMCOW_SRA_INDV_AMNNO", bloodInfo.getString("mgd_barcode")); //외조모

					//KPN 번호
					if(bloodInfo.has("sire_name")) result.put("FCOW_KPN_NO", bloodInfo.getString("sire_name"));
					if(bloodInfo.has("pgs_name")) result.put("GRFCOW_KPN_NO", bloodInfo.getString("pgs_name"));
					if(bloodInfo.has("mgs_name")) result.put("MTGRFCOW_KPN_NO", bloodInfo.getString("mgs_name"));
					
					//형매정보 저장
					if(!siblingInfo.isEmpty()) {
						siblingInfo.forEach(item ->{
							if(item instanceof JSONObject) {
								Map<String, Object> map = new HashMap<String, Object>();
								JSONObject obj = (JSONObject) item;
								map.put("SRA_INDV_AMNNO", "410"+barcode);
								map.put("SIB_SRA_INDV_AMNNO", "410"+obj.get("barcode"));								
								map.put("BIRTH", obj.get("birthdate"));
								map.put("RG_DSC", obj.get("reggu"));
								map.put("INDV_SEX_C", obj.get("sex"));
								Map<String,Object> butcherInfo= this.callApiOpenDataCattle((String)obj.get("barcode"));
                        
								map.put("METRB_BBDY_WT", butcherInfo.get("BUTCHERY_WEIGHT"));
								map.put("MIF_BTC_DT", butcherInfo.get("BUTCHERY_YMD"));
								map.put("METRB_METQLT_GRD", butcherInfo.get("Q_GRADE_NM"));
								sibInfo.add(map);
							}
						});					
					}
					result.put("sibInfo", sibInfo);
					
					//후대정보 저장
					if(!posterityInfo.isEmpty()) {
						posterityInfo.forEach(item ->{
							if(item instanceof JSONObject) {
								Map<String, Object> map = new HashMap<String, Object>();
								JSONObject obj = (JSONObject) item;
								map.put("SRA_INDV_AMNNO", "410"+barcode);
								map.put("POST_SRA_INDV_AMNNO", "410"+obj.get("barcode"));
								map.put("BIRTH", obj.get("birthdate"));
								map.put("RG_DSC", obj.get("reggu"));
								map.put("INDV_SEX_C", obj.get("sex"));
								map.put("KPN_NO", obj.get("sire_name"));
								Map<String,Object> butcherInfo= this.callApiOpenDataCattle((String)obj.get("barcode"));

								map.put("METRB_BBDY_WT", butcherInfo.get("BUTCHERY_WEIGHT"));
								map.put("MIF_BTC_DT", butcherInfo.get("BUTCHERY_YMD"));
								map.put("METRB_METQLT_GRD", butcherInfo.get("Q_GRADE_NM"));
								postInfo.add(map);
							}
						});					
					}
					result.put("postInfo", postInfo);
					
				}
			}
		}
		log.debug("retun Data",result);
		return result;
	}


	//종축개량 API_TEST
	public Map<String,Object> callApiOpenDataCattle(String barcode) {
		BufferedReader br = null;
		HttpURLConnection con = null;
		Map<String,Object> result = new HashMap<String, Object>();
		String response = "";
		String openDataApiKey = "0OhBU7ZCGIobDVKDeBJDpmDRqK3IRNF6jlf%2FJB2diFAf%2FfR2czYO9A4UTGcsOwppV6W2HVUeho%2FFPwXoL6DwqA%3D%3D";
		//"Z5HnEP8ghGMEUD0ukiBNifYlBV6%2BwI7hxE8hlLI71yY3IirWjvlVwaGsbjRcTWhIzVisaI3%2Fyb4cDhdoa%2BYRcg%3D%3D";
		//"Z5HnEP8ghGMEUD0ukiBNifYlBV6%2BwI7hxE8hlLI71yY3IirWjvlVwaGsbjRcTWhIzVisaI3%2Fyb4cDhdoa%2BYRcg%3D%3D"
        try {        	
    		String tempUrl = "http://data.ekape.or.kr/openapi-data/service/user/mtrace/breeding/cattle";
    		tempUrl += "?cattleNo="+ barcode;
			tempUrl += "&serviceKey="+openDataApiKey;    			
    	
			log.info("callApiOpenDataCattle tempUrl code : "+tempUrl);
        	URL url = new URL(tempUrl);
            con = (HttpURLConnection) url.openConnection();
            con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
            con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
            con.setRequestMethod("GET");
            con.setDoOutput(false);            

            StringBuilder sb = new StringBuilder();
            log.info("callApiOpenDataCattle resp code : "+con.getResponseCode());
            log.info("callApiOpenDataCattle call URL : "+ url.toString());
            log.info("callApiOpenDataCattle res URL: "+con.getURL());
            if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
                String line;
                while ((line = br.	readLine()) != null) {
                    sb.append(line).append("\n");
                }
                log.info("callApiOpenDataCattle : "+sb.toString());                
                response = sb.toString();
                
            } else {
                log.error(con.getResponseMessage());
            }
        }
        catch (Exception e) {
        	log.error("Exception - 공공데이터 쇠고기이력정보 테스트 : ",e);
        } finally {
        	try {
                if(con != null)con.disconnect();
                if(br !=null) br.close();

                //정상 수신시 XML 데이터 형변환
                if(!response.isEmpty()) {
        	        JSONObject json = XML.toJSONObject(response);
        	        
        	        if(json != null && json.has("response")  && json.getJSONObject("response").has("body") && json.getJSONObject("response").getJSONObject("body").has("items")) {
        	        	Object resultObj = json.getJSONObject("response").getJSONObject("body").getJSONObject("items").get("item");
        		        if(resultObj instanceof JSONObject) {
        		        	JSONObject jItem = (JSONObject) resultObj; 
        		        	
        	        		result.put("CATTLE_NO", jItem.get("cattleNo"));
        	        		if(jItem.has("butcheryWeight")) result.put("BUTCHERY_WEIGHT", jItem.get("butcheryWeight"));
        	        		if(jItem.has("butcheryYmd")) result.put("BUTCHERY_YMD", jItem.get("butcheryYmd"));
        	        		if(jItem.has("qgradeNm")) result.put("Q_GRADE_NM", jItem.get("qgradeNm"));
        		        }
        	        }                	
                }
        	}
        	catch(Exception e) {
                log.error("Exception - 공공데이터 쇠고기이력정보 테스트 : ",e);
        	}
		}
        return result;
	}
}
