package com.auc.main.controller;

import java.awt.Color;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CriptoConfig;
import com.auc.common.util.BReqData;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.ResolverMap;
import com.auc.main.service.CommonService;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class CommonController {
	
	private static Logger log = LoggerFactory.getLogger(CommonController.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CriptoConfig criptoConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	CommonService commonService;
	
	@Value("${log.file.path}")
    private String logFilePath;
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/excelDownload", method=RequestMethod.POST)
	public String excelDownload(@RequestBody BReqData reqData, HttpServletRequest req, HttpServletResponse res) throws Exception{				
		
		short FONT_SIZE = 10;
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("colModel", reqData.getParamDataList("colModel"));
		param.put("gridData", reqData.getParamDataList("gridData"));
		param.put("title", reqData.getParamDataVal("title"));
		param.put("footer", reqData.getParamDataList("footer"));

		List<HashMap<String, Object>> colModelList = (List<HashMap<String, Object>>) param.get("colModel");
		List<HashMap<String, Object>> gridDataList = (List<HashMap<String, Object>>) param.get("gridData");
		List<HashMap<String, Object>> footerList = (List<HashMap<String, Object>>) param.get("footer");
		String title = StringUtils.NULL(param.get("title"));
		
		if(colModelList == null) {
			colModelList = new ArrayList<HashMap<String, Object>>();
		}
		if(gridDataList == null) {
			gridDataList = new ArrayList<HashMap<String, Object>>();
		}
		if(footerList == null) {
			footerList = new ArrayList<HashMap<String, Object>>();
		}
		
		//jqGrid RowValue 삭제
		HashMap<String, Object> ckMap = null;		
		for(int q = 0; q < colModelList.size(); q++) {
			ckMap = new HashMap<String, Object>();			
			ckMap = colModelList.get(q);
			if(ckMap.containsKey("name")) {
				if("rn".equals(ckMap.get("name"))) {
					colModelList.remove(q);
					break;
				}
			}
		}
		
		XSSFWorkbook xsWB = null;
		
		int colModelLength = colModelList.size();
		int gridDataLength = gridDataList.size();
		int footerLength = footerList.size();
		
		try {
			
			xsWB = new XSSFWorkbook();
	        XSSFSheet xsSheet = xsWB.createSheet(title);
	        xsSheet.setDefaultColumnWidth(12);
	        
	        // Font 지정
	        XSSFFont xshFont = xsWB.createFont();
	        xshFont.setFontHeightInPoints(FONT_SIZE);
	        xshFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
	        XSSFFont xsdFont = xsWB.createFont();
	        xsdFont.setFontHeightInPoints(FONT_SIZE);
	        
	        // Header 스타일 지정
	        XSSFCellStyle xshCS = xsWB.createCellStyle();
	        xshCS.setFillForegroundColor(new XSSFColor(new Color(203, 208, 229)));
	        xshCS.setFillForegroundColor(new XSSFColor(new Color(203, 208, 229)));
	        xshCS.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
	        xshCS.setAlignment(HorizontalAlignment.CENTER);
	        xshCS.setVerticalAlignment(VerticalAlignment.CENTER);
	        xshCS.setFont(xshFont);
	        xshCS.setWrapText(true);
	        
	        // Header 데이터 적용 및 Body 스타일 설정
	        XSSFRow xsRow = xsSheet.createRow(0);
	        XSSFCell xsCell = xsRow.createCell(0);
	        xsCell.setCellStyle(xshCS);
	        xsCell.setCellValue("NO");
			xsSheet.setColumnWidth(0, 40 * 35);
			XSSFCellStyle[] xsdCSs = new XSSFCellStyle[colModelLength]; // 셀스타일 Array
			XSSFDataFormat xsDFormat = xsWB.createDataFormat();
			
	    	for (int i=0; i<colModelLength; i++) {
	    		if(colModelList.get(i).containsKey("width")) {
	    			xsSheet.setColumnWidth(i + 1, 40 * (Integer.parseInt(StringUtils.NULL(colModelList.get(i).get("width"), "0"))));
	    		}else {
	    			xsSheet.setColumnWidth(i + 1, 40 * 0);
	    		}
	    		
	    		xsCell = xsRow.createCell(i + 1);
	    		xsCell.setCellStyle(xshCS);
	    		if(colModelList.get(i).containsKey("label")) {
	    			xsCell.setCellValue(StringUtils.NULL(colModelList.get(i).get("label")));
	    		}else {
	    			xsCell.setCellValue("");
	    		}
				
	    		xsdCSs[i] = xsWB.createCellStyle();
	    		xsdCSs[i].setVerticalAlignment(VerticalAlignment.CENTER);
	    		xsdCSs[i].setFont(xsdFont);
				if (colModelList.get(i).containsKey("align") && "center".equals(colModelList.get(i).get("align")))
					xsdCSs[i].setAlignment(HorizontalAlignment.CENTER);
	 			else if (colModelList.get(i).containsKey("right") && "right".equals(colModelList.get(i).get("align")))
	 				xsdCSs[i].setAlignment(HorizontalAlignment.RIGHT);
	 			else if(colModelList.get(i).containsKey("left") && "lfet".equals(colModelList.get(i).get("align")))
	 				xsdCSs[i].setAlignment(HorizontalAlignment.LEFT);
	    	}
	    	
	    	// Body 데이터 적용
	    	for (int i=0; i<gridDataLength; i++) {
	    		xsRow = xsSheet.createRow(i + 1);
	    		xsRow.createCell(0).setCellStyle(xsdCSs[0]);
	    		xsRow.createCell(0).setCellValue(String.valueOf(i + 1));
				
				for (int j=0; j<colModelLength; j++) {
					xsCell = xsRow.createCell(j + 1);

					if (colModelList.get(j).containsKey("formatter") && "integer".equals(colModelList.get(j).get("formatter")) || "number".equals(colModelList.get(j).get("formatter"))) {
	    				xsdCSs[j].setDataFormat(xsDFormat.getFormat("#,##0"));
	    				if(colModelList.get(j).containsKey("name")) {	    					
	    					if(gridDataList.get(i).get(colModelList.get(j).get("name")).toString().trim().length() != 0) {
		    					xsCell.setCellType(XSSFCell.CELL_TYPE_NUMERIC);
		    					xsCell.setCellValue(Double.valueOf(StringUtils.NULL(gridDataList.get(i).get(colModelList.get(j).get("name")), "0")));
		    				}else {
		    					xsCell.setCellType(XSSFCell.CELL_TYPE_NUMERIC);
		    					xsCell.setCellValue("");
		    				}
	    				}
	    			}else {
	    				xsCell.setCellType(XSSFCell.CELL_TYPE_STRING);
	    				if(colModelList.get(j).containsKey("name")) {
	    					xsCell.setCellValue(StringUtils.NULL(gridDataList.get(i).get(colModelList.get(j).get("name"))));
	    				}else {
	    					xsCell.setCellValue("");
	    				}
	    				
	    			}
	    			
	    			xsCell.setCellStyle(xsdCSs[j]);
	    		}
	        }

    		xsRow = xsSheet.createRow(gridDataLength+1);
    		xsRow.createCell(0).setCellStyle(xsdCSs[0]);
    		
    		int chkColIndex = 0;
			
	    	for (int i=0; i<footerLength; i++) {
	    		//if(footerList.get(i).containsKey("width")) {
	    		//	xsSheet.setColumnWidth(chkColIndex + 1, 40 * (Integer.parseInt(StringUtils.NULL(footerList.get(i).get("width"), "0"))));
	    		//}else {
	    		//	xsSheet.setColumnWidth(chkColIndex + 1, 40 * 0);
	    		//}
	    		xsCell = xsRow.createCell(chkColIndex + 1);
	    		//xsCell.setCellStyle(xshCS);
	    		if(footerList.get(i).containsKey("label")) {
	    			xsCell.setCellValue(StringUtils.NULL(footerList.get(i).get("label")));
	    		}else {
	    			xsCell.setCellValue("");
	    		}
				
	    		xsdCSs[i] = xsWB.createCellStyle();
	    		xsdCSs[i].setVerticalAlignment(VerticalAlignment.CENTER);
	    		//xsdCSs[i].setFont(xsdFont);
				if (footerList.get(i).containsKey("align") && "center".equals(footerList.get(i).get("align")))
					xsdCSs[i].setAlignment(HorizontalAlignment.CENTER);
	 			else if (footerList.get(i).containsKey("right") && "right".equals(footerList.get(i).get("align")))
	 				xsdCSs[i].setAlignment(HorizontalAlignment.RIGHT);
	 			else if(footerList.get(i).containsKey("left") && "lfet".equals(footerList.get(i).get("align")))
	 				xsdCSs[i].setAlignment(HorizontalAlignment.LEFT);

	    		String cellColSpan = (String) footerList.get(i).get("colspan");     
	    		int tempVal = Integer.valueOf(cellColSpan);
				xsSheet.addMergedRegion(new CellRangeAddress(xsRow.getRowNum(), xsRow.getRowNum(), chkColIndex+1, chkColIndex+=tempVal));
	    	}
    					
			String filename = title;
			res.reset();			
			res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			res.addHeader("Content-Disposition", "attachment;filename=\""+URLEncoder.encode(filename, "UTF-8") + ".xlsx\"");
			
			xsWB.write(res.getOutputStream());
			res.getOutputStream().flush();
			
		}catch(RuntimeException | IOException e){
			log.info("동작중 오류가 발생하였습니다.");
			log.info("",e);
		}		 
		
		return "success";
	}
		
	@ResponseBody
	@RequestMapping(value="/Common_selAucDt", method=RequestMethod.POST)
	public Map<String, Object> Common_selAucDt(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		Map<String, Object> result = commonService.Common_selAucDt(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(result); 	
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/Common_selVet", method=RequestMethod.POST)
	public Map<String, Object> Common_selVet(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = commonService.Common_selVet(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/Common_selAucQcn", method=RequestMethod.POST)
	public Map<String, Object> Common_selAucQcn(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = commonService.Common_selAucQcn(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/Common_selBack", method=RequestMethod.POST)
	public Map<String, Object> Common_selBack(ResolverMap rMap) throws Exception{	
		List<Map<String, Object>> reList = commonService.Common_selBack(convertConfig.conMapWithoutXxs(rMap));				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/Common_insBack", method=RequestMethod.POST)
	public Map<String, Object> Common_insBack(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = commonService.Common_insBack(convertConfig.conMapWithoutXxs(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/Common_updBack", method=RequestMethod.POST)
	public Map<String, Object> Common_updBack(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = commonService.Common_updBack(convertConfig.conMapWithoutXxs(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/Common_delBack", method=RequestMethod.POST)
	public Map<String, Object> Common_delBack(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = commonService.Common_delBack(convertConfig.conMapWithoutXxs(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/co/Common_selLogFile", method=RequestMethod.POST)
	public Map<String, Object> Common_selLogFile(ResolverMap rMap) throws Exception{
		
		ObjectMapper mapper = new ObjectMapper();	
		Map<String, Object> map = mapper.readValue(rMap.get("data").toString(), HashMap.class);
		
		
		
		long preEndPoint = map.get("preEndPoint") == null ? 0 : Long.parseLong(map.get("preEndPoint")+"");
		
		StringBuilder log = new StringBuilder();
		long startPoint = 0;
		long endPoint = 0;
		
		RandomAccessFile file = null;
		
		try{
			 file = new RandomAccessFile(logFilePath, "r");
			 endPoint = file.length();
			 
			 startPoint =  preEndPoint > 0 ? preEndPoint : endPoint < 2000 ? 0 : endPoint - 2000;
			 
			 file.seek(startPoint);
			 
			 String str;
			 
			 while ((str = file.readLine()) != null) {
			 			log.append(str);
			 			log.append("\n");
			 			endPoint = file.getFilePointer();
			 			file.seek(endPoint);
			 }
		
		}catch (FileNotFoundException fnfe) {
				log.append("file does not exist.");
		}catch (Exception e) {
				log.append("Sorry. An error has occurred.");
		} finally {
				try {file.close();} catch (Exception e) {}
		}
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("log", URLEncoder.encode(new String(log.toString().getBytes("ISO-8859-1"), "UTF-8"),"UTF-8").replaceAll("\\+", "%20"));
		inMap.put("endPoint", endPoint);		
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
        Map<String, Object> reMap = new HashMap<String, Object>();	
        
        //JSON으로 변경
        JSONObject jsonObject = commonFunc.convertMaptoJson(inMap);
        String encript = criptoConfig.encript(jsonObject.toString());
        //조회 결과가 0건일 경우 201 리턴
        if(inMap == null || inMap.isEmpty()) {
        	reMap.put("status", 201);
        	reMap.put("code", "C001");
        	reMap.put("message", "조회된내역이 없습니다.");
        }else {
        	reMap.put("status", 200);
        	reMap.put("code", "C000");
        	reMap.put("message", "");
        }
        reMap.put("data", encript);  		
  		return reMap;
	}

	
	@ResponseBody
	@RequestMapping(value="/insDownloadLog", method= {RequestMethod.POST,RequestMethod.GET})
	public Map<String, Object> Common_insLog(HttpServletRequest request, ResolverMap rMap) throws Exception{
		Map<String, Object> inMap = convertConfig.conMapWithoutXxs(rMap);
		String ipAdr = request.getHeader("X-FORWARDED-FOR") != null ? request.getHeader("X-FORWARDED-FOR") : request.getRemoteAddr();
		String temp = (String) inMap.get("apvrqr_rsnctt");
		
		StringBuilder stringBuilder = new StringBuilder(500);
		int nCnt = 0;
		for(char ch:temp.toCharArray()){
			nCnt += String.valueOf(ch).getBytes("EUC-KR").length;
			if(nCnt > 1000) break;
			stringBuilder.append(ch);
		}
		
		inMap.put("ipadr", ipAdr);
		inMap.put("apvrqr_rsnctt", stringBuilder.toString());
		Map<String, Object> reList = commonService.Common_insDownloadLog(inMap);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(reList);
		return reMap;
	}	

}
