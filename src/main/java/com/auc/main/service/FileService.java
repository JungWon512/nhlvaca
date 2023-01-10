package com.auc.main.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {

	List<Map<String, Object>> fileUpload(List<MultipartFile> fileList) throws Exception;
}
