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
	
	@Value("${bucket.endPoint}")
	private String endPoint;
	
	@Value("${bucket.regionName}")
	private String regionName;
	
	@Value("${bucket.accessKey}")
	private String accessKey;
	
	@Value("${bucket.secretKey}")
	private String secretKey;
	
	@Value("${bucket.bucketName}")
	private String bucketName;
	
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
    
	public List<Map<String, Object>> LALM0215_selImgList(Map<String, Object> map) throws IOException {
		List<Map<String, Object>> reList = new ArrayList<>();

		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
												 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
												 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
												 .build();

		// top level folders and files in the bucket
		try {
			ListObjectsRequest listObjectsRequest = new ListObjectsRequest().withBucketName(bucketName)
																			.withDelimiter("/")
																			.withMaxKeys(300);

			ObjectListing objectListing = s3.listObjects(listObjectsRequest);

			for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
				Map<String, Object> reMap = new HashMap<>();
				S3Object s3Object = s3.getObject(bucketName, objectSummary.getKey());
				S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
				byte[] sourceBytes = IOUtils.toByteArray(s3ObjectInputStream);
				reMap.put("fileNm", objectSummary.getKey()); 
				reMap.put("fileSize", objectSummary.getSize()); 
				reMap.put("fileExt", objectSummary.getKey().substring(objectSummary.getKey().lastIndexOf(".")+1)); 
				reMap.put("fileImg","data:image/png;base64," + Base64.encodeAsString(sourceBytes)); 

				s3ObjectInputStream.close();
				reList.add(reMap);
			}
			
		}
		catch (AmazonS3Exception e) {
			e.printStackTrace();
		}
		catch(SdkClientException e) {
			e.printStackTrace();
		}
		
		return reList;
	}
	
	public Map<String, Object> LALM0215_selImg(Map<String, Object> map) {
		Map<String, Object> reMap = new HashMap<>();

		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
												 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
												 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
												 .build();

		String objectName = "433b5d89-b8e0-4701-a23d-ba27dc8bbe0e" + ".png";

		// download object
		try {
			S3Object s3Object = s3.getObject(bucketName, objectName);
			S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
			
			byte[] sourceBytes = IOUtils.toByteArray(s3ObjectInputStream);
	
			reMap.put("data","data:image/png;base64," + Base64.encodeAsString(sourceBytes)); 
	
			s3ObjectInputStream.close();
		}
		catch (AmazonS3Exception e) {
			e.printStackTrace();
		}
		catch(SdkClientException e) {
			e.printStackTrace();
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		
		return reMap;
	}
	
	/**
	 * MultipartFile 이미지 네이버 클라우드 업로드 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0215_insImgList(Map<String, Object> paramMap) {
		final Map<String, Object> reMap = new HashMap<>();
		try {
			// S3 client
			final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
													 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
													 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
													 .build();
			
			// ACL 설정 : 파일마다 읽기 권한을 설정
			final AccessControlList accessControlList = new AccessControlList();
			accessControlList.grantPermission(GroupGrantee.AllUsers, Permission.Read);
			
			// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS 세팅이 필요
			final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT, CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
			final CORSRule rule = new CORSRule().withId("CORSRule")
												.withAllowedMethods(methodRule)
												.withAllowedHeaders(Arrays.asList(new String[] { "*" }))
												.withAllowedOrigins(Arrays.asList(new String[] { "*" }))
												.withMaxAgeSeconds(3000);
	
			final List<CORSRule> rules = Arrays.asList(rule);
	
			s3.setBucketCrossOriginConfiguration(bucketName, new BucketCrossOriginConfiguration().withRules(rules));
			
			final String folderName = paramMap.get("na_bzplc") + "/" + paramMap.get("sra_indv_amnno") + "/";
			List<MultipartFile> files = (List<MultipartFile>)paramMap.get("files");
			
			for (MultipartFile file : files) {
				// upload parameter file
				String objectName = UUID.randomUUID().toString() + ".png";
				
				ObjectMetadata objectMetadata = new ObjectMetadata();
				objectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
				objectMetadata.setContentLength(file.getBytes().length);
				PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, folderName + objectName, file.getInputStream(), objectMetadata);
				putObjectRequest.setAccessControlList(accessControlList);
				
				s3.putObject(putObjectRequest);
			}

//			this.LALM0215_selImgList(reMap);
		}
		catch (AmazonS3Exception e) {
			e.printStackTrace();
		}
		catch(SdkClientException e) {
			e.printStackTrace();
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		
		return reMap;
	}
	
	
	public Map<String, Object> LALM0215_delImgList(Map<String, Object> map) {
		Map<String, Object> reMap = new HashMap<>();
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
												 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
												 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
												 .build();

		String key = map.get("imgid").toString();
		try {
			s3.deleteObject(bucketName, key);
		
		} catch (AmazonS3Exception e) {
		    e.printStackTrace();
		} catch(SdkClientException e) {
		    e.printStackTrace();
		}
		
		return reMap;
	}
	
	/**
	 * Base64 인코딩 이미지 클라우드 업로드
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> imgUploadPrc(Map<String, Object> map) {
		final List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		
		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
												 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
												 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
												 .build();
		
		// ACL 설정 : 파일마다 읽기 권한을 설정
		final AccessControlList accessControlList = new AccessControlList();
		accessControlList.grantPermission(GroupGrantee.AllUsers, Permission.Read);
		
		// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS 세팅이 필요
		final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT, CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
		final CORSRule rule = new CORSRule().withId("CORSRule")
											.withAllowedMethods(methodRule)
											.withAllowedHeaders(Arrays.asList(new String[] { "*" }))
											.withAllowedOrigins(Arrays.asList(new String[] { "*" }))
											.withMaxAgeSeconds(3000);

		final List<CORSRule> rules = Arrays.asList(rule);

		s3.setBucketCrossOriginConfiguration(bucketName, new BucketCrossOriginConfiguration().withRules(rules));
		
		final String naBzplc = map.get("na_bzplc").toString();
		final String aucDt = map.get("auc_dt").toString();
		final String sraIndvAmnno = map.get("sra_indv_amnno").toString();
		final String filePath = naBzplc + "/" + sraIndvAmnno + "/";
		final String fileExtNm = ".png";
		
		final List<String> files = (List<String>)map.get("files");
		
		if (ObjectUtils.isEmpty(files)) return null;
		
		for (String file : files) {
			boolean isSuccess = true;
			String fileNm = "";

			// origin 파일이 없는 경우 or 값이 data:image로 시작하지 않는 경우 pass
			if (ObjectUtils.isEmpty(file)
			|| !file.startsWith("data:image")) continue;

			fileNm = UUID.randomUUID().toString();

			String[] base64Arr = file.split(",");
			byte[] imgByte = Base64.decode(base64Arr[1]);
			InputStream bis = new ByteArrayInputStream(imgByte);

			ObjectMetadata bjectMetadata = new ObjectMetadata();
			bjectMetadata.setContentLength(imgByte.length);
			bjectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
			PutObjectRequest oriPutObjectRequest = new PutObjectRequest(bucketName, filePath + fileNm + fileExtNm, bis, bjectMetadata);

			try {
				oriPutObjectRequest.setAccessControlList(accessControlList);
				s3.putObject(oriPutObjectRequest);
			}
			catch (AmazonS3Exception e) {
				e.printStackTrace();
				isSuccess = false;
			}
			catch(SdkClientException e) {
				e.printStackTrace();
				isSuccess = false;
			}
			
			if (isSuccess) {
				Map<String, Object> rtn = new HashMap<String, Object>();
				rtn.put("na_bzplc", naBzplc);
				rtn.put("auc_dt", aucDt);
				rtn.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				rtn.put("oslp_no", map.get("oslp_no"));
				rtn.put("led_sqno", map.get("led_sqno"));
				rtn.put("sra_indv_amnno", sraIndvAmnno);
				rtn.put("file_path", filePath);
				rtn.put("file_nm", fileNm);
				rtn.put("file_ext_nm", fileExtNm);
				rtnList.add(rtn);
			}
		}
		
		return rtnList;
	}

}
