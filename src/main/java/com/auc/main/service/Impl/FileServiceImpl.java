package com.auc.main.service.Impl;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.auc.lalm.ar.service.Impl.LALM0215ServiceImpl;
import com.auc.main.service.FileService;

@Service("FileService")
public class FileServiceImpl implements FileService{
	private static Logger log = LoggerFactory.getLogger(FileServiceImpl.class);
	
	@Value("${img.path}")
	private String filePath;
	
	@Override
	public List<Map<String, Object>> fileUpload(List<MultipartFile> fileList) throws Exception {		
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		try {
			for (MultipartFile file : fileList) {
				Map<String, Object> tmpMap = new HashMap<>();
				
				String originFileName = UUID.randomUUID().toString();
//				String originFileName = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("\\")+1);
				
				File oFile = new File(filePath + originFileName);
				file.transferTo(oFile);
				
				// 파일 원본 파라미터 저장
				tmpMap.put("originFileName", originFileName);
				tmpMap.put("originFileSize", file.getBytes());
				tmpMap.put("originFileType", file.getContentType());
				tmpMap.put("originFilePath", filePath);
				
				returnList.add(tmpMap);
				
				// thumbnail image 사이즈 256cm * 512cm
//				String thumbNailName = "thumb_" + originFileName;
				
//				String tPath = oFile.getParent() + File.separator + "t_" + oFile.getName();
//				File tFile = new File(tPath);

//				File tFile = new File(filePath + thumbNailName);
				
//				double ratio = 2; // 이미지 축소 비율
				
//				BufferedImage oImage  = oFile.canRead() ? ImageIO.read(oFile) : null; // 원본이미지
				
//				int tWidth = (int) (oImage.getWidth() / ratio); // 생성할 썸네일 이미지의 너비
//				int tHeight = (int) (oImage.getHeight() / ratio); // 생성할 썸네일 이미지의 높이
				
//				BufferedImage tImage  = new BufferedImage(tWidth, tHeight, BufferedImage.TYPE_4BYTE_ABGR); // 썸네일이미지
				
//				Graphics2D graphic = tImage.createGraphics();
				
//				Image image = oImage.getScaledInstance(tWidth, tHeight, Image.SCALE_SMOOTH);
				
//				graphic.drawImage(image, 0, 0, tWidth, tHeight, null);
				
//				graphic.dispose(); // 리소스 해제
				
//				ImageIO.write(tImage, "png", tFile);
				
				// 썸네일 파라미터 저장
//				if (tFile.exists()) {
//					tmpMap.put("originFileName", thumbNailName);
//					tmpMap.put("originFileSize", Files.size(Paths.get(thumbNailName)));
//					tmpMap.put("originFileType", file.getContentType());
//					tmpMap.put("originFilePath", filePath);
//					
//					returnList.add(tmpMap);					
//				}
			}
			
		} catch (IOException e) {
			log.error("e : fileUpload ",e);
		}
		
		return returnList;
	}
}
