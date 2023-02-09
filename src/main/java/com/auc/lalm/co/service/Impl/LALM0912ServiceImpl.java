package com.auc.lalm.co.service.Impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
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
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.Permission;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.util.Base64;
import com.amazonaws.util.IOUtils;
import com.auc.common.util.StringUtils;
import com.auc.lalm.co.service.LALM0912Service;

@Service("LALM0912Service")
public class LALM0912ServiceImpl implements LALM0912Service{

	@Autowired
	LALM0912Mapper lalm0912Mapper;	
	
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

	@Override
	public Map<String, Object> LALM0912_selData(Map<String, Object> map) throws Exception {
		
		Map<String, Object> outMap = lalm0912Mapper.LALM0912_selData(map);
		return outMap;
		
	}
	
	@Override
	public Map<String, Object> LALM0912_insWmc(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int insertNum = 0;
		insertNum = insertNum + lalm0912Mapper.LALM0912_insWmc(map);
		insertNum = insertNum + lalm0912Mapper.LALM0912_insEnvEst(map);
		insertNum = insertNum + lalm0912Mapper.LALM0912_updBzloc(map);
		reMap.put("insertNum", insertNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0912_updWmc(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		updateNum = updateNum + lalm0912Mapper.LALM0912_updWmc(map);
		updateNum = updateNum + lalm0912Mapper.LALM0912_updEnvEst(map);
		updateNum = updateNum + lalm0912Mapper.LALM0912_updBzloc(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> LALM0912_delWmc(Map<String, Object> map) throws Exception {	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int deleteNum = 0;
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delWmc(map);
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delEnvEst(map);
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delBzloc(map);
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0912_updSealImg(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		updateNum = updateNum + lalm0912Mapper.LALM0912_updSealImg(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0912_selSealImg(Map<String, Object> map) throws Exception {
		
		Map<String, Object> outMap = lalm0912Mapper.LALM0912_selSealImg(map);
		return outMap;
		
	}
	
	@Override
	public Map<String, Object> LALM0912_updLogoImg(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		this.LALM0912_insImgList(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	
	/**
	 * MultipartFile 이미지 네이버 클라우드 업로드 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0912_insImgList(Map<String, Object> map) {
		final Map<String, Object> rtnMap = new HashMap<>();
		
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
		final String filePath = "logo/";
		final String fileExtNm = ".png";
		
		final List<String> files = (List<String>)map.get("logo_img_flnm");
		
		if (ObjectUtils.isEmpty(files)) return null;
		
		for (String file : files) {
			boolean isSuccess = true;
			String fileNm = naBzplc;

			// origin 파일이 없는 경우 or 값이 data:image로 시작하지 않는 경우 pass
			if (ObjectUtils.isEmpty(file)
			|| !file.startsWith("data:image")) continue;

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
				rtnMap.put("na_bzplc", naBzplc);
			}
		}
		
		return rtnMap;
	}
	
	
	public List<Map<String, Object>> lalm0912_logoImgList() throws SQLException, IOException {
		List<Map<String, Object>> reList = new ArrayList<>();
		
		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
		    .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
		    .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
		    .build();
	
		// top level folders and files in the bucket
		try {
		    String filePath = "logo/";
		    
		    ObjectListing objectListing = s3.listObjects(bucketName, filePath);
	
		    for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
		    	Map<String, Object> reMap = new HashMap<>();
			    S3Object s3Object = s3.getObject(bucketName, objectSummary.getKey());
			    S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
			    byte[] sourceBytes = IOUtils.toByteArray(s3ObjectInputStream);
			    reMap.put("file_nm", objectSummary.getKey());
			    reMap.put("file_src","data:image/png;base64," + Base64.encodeAsString(sourceBytes)); 
			    
				s3ObjectInputStream.close();
			    reList.add(reMap);
		    }
		} catch (AmazonS3Exception e) {
		    e.printStackTrace();
		} catch(SdkClientException e) {
		    e.printStackTrace();
		}
		
		return reList;
	}

	@Override
	public Map<String, Object> LALM0912_selLogoImg(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


}
