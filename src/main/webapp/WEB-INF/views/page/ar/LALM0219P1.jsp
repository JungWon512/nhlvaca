<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>
<script src="/js/xlsx.full.min.js"></script>
<script src="/js/FileSaver.min.js"></script>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body>
    <div class="pop_warp">
        <div class="tab_box btn_area clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow" >검색조건</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="70">
                        <col width="*">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" name="auc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th colspan="2"><input type="file" title="파일첨부" name='file' onchange="excelExport(event);"/></th>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="resultBox tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
        </div>
        
        <div class="listTable mb0">           
            <table id="grd_Excel">
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
<script type="text/javascript">
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    var excelList = [];
    $(document).ready(function(){
        fn_CreateGrid();
    	if(pageInfo.param){
    		$('#auc_dt').val(pageInfo.param.auc_dt);
    		$('#auc_dt').attr('readonly','true');
    	}
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
        //그리드 초기화
        fn_CreateGrid();
        //폼 초기화
        //fn_InitFrm('frm_Search');
        $('[name=file]').val('')
        $('.resultBox .tab_list p.dot_allow').text('검색결과');
        excelList = [];
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save (){
    	 if(excelList.length <= 0){
    		 MessagePopup("OK", "엑셀파일을 업로드해주세요.");
    		 return;
    	 }
    	 var param = {auc_dt:$('#auc_dt').val()?.replaceAll('-',''),grid_data:excelList};
    	 var result = sendAjax(param, '/LALM0219P1_updExcelUpload', 'post');

         if(result.status == RETURN_SUCCESS){
             MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
            	 var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
            	 parentInput.val(true).trigger('change');
            	 //parent.PopupClose("#popupPage_"+pgid);
             });
         }else {
            showErrorMessage(result);
            return;
         } 
    }  
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = [ "경매번호", "경매대상", "출하주", "생산자", "귀표번호", "등록우 구분", "생년월일","월령", "성별", "KPN", "계대", "산차", "어미귀표번호", "어미구분", "번식우구분", "주소", "고능력여부", "비고내용", "접수일자", "등록일시","원표번호" ];        
		var searchResultColModel = [	
		            {name:"AUC_PRG_SQ"          ,   	index:"AUC_PRG_SQ"          ,   		width:70,  align:'center'},
		            {name:"AUC_OBJ_DSC"         ,   	index:"AUC_OBJ_DSC"         ,   		width:70, align:'center'},
		            {name:"FTSNM"               ,   	index:"FTSNM"               ,   		width:70, align:'center' },
		            {name:"SRA_PDMNM"           ,   	index:"SRA_PDMNM"           ,   		width:70, align:'center' },
		            {name:"SRA_INDV_AMNNO"      ,   	index:"SRA_INDV_AMNNO"      ,   		width:150, align:'center' },
		            {name:"RG_DSC"              ,   	index:"RG_DSC"              ,   		width:70, align:'center'},
		            {name:"BIRTH"               ,   	index:"BIRTH"               ,   		width:70, align:'center' },
		            {name:"MTCN"             	,   	index:"MTCN"	            ,   		width:70, align:'center' },
		            {name:"INDV_SEX_C"          ,   	index:"INDV_SEX_C"          ,   		width:70, align:'center' },
		            {name:"KPN_NO"              ,   	index:"KPN_NO"              ,   		width:70, align:'center' },
		            {name:"SRA_INDV_PASG_QCN"   ,   	index:"SRA_INDV_PASG_QCN"   ,   		width:70, align:'center' },
		            {name:"MATIME"              ,   	index:"MATIME"              ,   		width:70, align:'center' },
		            {name:"MCOW_SRA_INDV_AMNNO" ,   	index:"MCOW_SRA_INDV_AMNNO" ,   		width:150, align:'center' },
		            {name:"MCOW_DSC"            ,   	index:"MCOW_DSC"            ,   		width:70, align:'center'},
		            {name:"PPGCOW_FEE_DSC"      ,   	index:"PPGCOW_FEE_DSC"      ,   		width:100, align:'center'},
		            {name:"ADDR"                ,   	index:"ADDR"                ,   		width:200,align:'left' },
		            {name:"EPD_YN"              ,   	index:"EPD_YN"              ,   		width:70, align:'center'},
		            {name:"RMK_CNTN"            ,   	index:"RMK_CNTN"            ,   		width:200, align:'left' },
		            {name:"RC_DT"               ,   	index:"RC_DT"               ,   		width:70, align:'center' },
		            {name:"LSCHG_DTM"           ,   	index:"LSCHG_DTM"           ,   		width:70, align:'center' },
		            {name:"OSLP_NO"             ,   	index:"OSLP_NO"             ,   		width:70, align:'center' }
            ];

        $("#grd_Excel").jqGrid("GridUnload");
                
        $("#grd_Excel").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
        });
        //가로스크롤 있는경우 추가
        $("#grd_Excel .jqgfirstrow td:last-child").width($("#grd_Excel .jqgfirstrow td:last-child").width() - 17);
        
    }
    
    function excelExport(event){
    	excelExportCommon(event, handleExcelDataAll);
    }
    
    function excelExportCommon(event, callback){
        var input = event.target;        
        var reader = new FileReader();        
        reader.onload = function(){
            var fileData = reader.result;
            var wb = XLSX.read(fileData, {type:'binary'});
            var sheetNameList = wb.SheetNames;
            var firstSheetName = sheetNameList[0];
            var firstSheet = wb.Sheets[firstSheetName];
            callback(firstSheet);
//             wb.SheetNames.forEach(function(sheetName){
//                 var rowObj = XLSX.utils.sheet_to_json(wb.Sheets[sheetName]);
//                 console.log(JSON.stringify(rowObj));
//             });
        };
        reader.readAsBinaryString(input.files[0]);
    }
    
    function handleExcelDataAll(sheet){
        var Obj = XLSX.utils.sheet_to_json(sheet,{header:1,raw:true});
        
        //var ExcelList = new Array();
    	Obj.forEach(function(item,idx){
    		if(idx != 0 && item.length > 0){
    			var ExcelData = new Object();
    			
    			ExcelData['AUC_PRG_SQ'] = item[2 ]; /* 경매번호 */
    			ExcelData['AUC_OBJ_DSC'] = item[3 ]; /* 경매대상 */
    			ExcelData['FTSNM'] = item[4 ]; /* 출하주 */
    			ExcelData['SRA_PDMNM'] = item[5 ]; /* 생산자 */
    			ExcelData['SRA_INDV_AMNNO'] = item[6]; /* 귀표번호 */
    			ExcelData['RG_DSC'] = item[7 ]; /* 등록우 구분 */
    			ExcelData['BIRTH'] = item[8 ]; /* 생년월일 */
    			ExcelData['MTCN'] = item[9 ]; /* 월령 */
    			ExcelData['INDV_SEX_C'] = item[10]; /* 성별 */
    			ExcelData['KPN_NO'] = item[11]; /* KPN */
    			ExcelData['SRA_INDV_PASG_QCN'] = item[12]; /* 계대 */
    			ExcelData['MATIME'] = item[13]; /* 산차 */
    			ExcelData['MCOW_SRA_INDV_AMNNO'] = item[14]; /* 어미귀표번호 */
    			ExcelData['MCOW_DSC'] = item[15]; /* 어미구분 */
    			ExcelData['PPGCOW_FEE_DSC'] = item[16]; /* 번식우구분 */
    			ExcelData['ADDR'] = item[17]; /* 주소 */
    			ExcelData['EPD_YN'] = item[18]; /* 고능력여부 */
    			ExcelData['RMK_CNTN'] = item[19]; /* 비고내용 */
    			ExcelData['RC_DT'] = item[20]; /* 접수일자 */
    			ExcelData['LSCHG_DTM'] = item[21]; /* 등록일시 */
    			ExcelData['OSLP_NO'] = item[22]; /* 원표번호 */
    			excelList.push(ExcelData);
    		}
    	});
    	excelList.forEach((obj)=>{
    		Object.keys(obj).forEach((key)=>{
    			var temp = obj[key];
    			if(typeof temp == 'string'){
    				if(key == 'MCOW_SRA_INDV_AMNNO' || key =='SRA_INDV_AMNNO'){
    					obj[key] = obj[key].replaceAll('-','');
    				}
    				obj[key] = obj[key].trim();
    			}
    		});
   		});
    	$('.resultBox .tab_list p.dot_allow').text('검색결과 총 건수 :'+excelList.length);
    	    	
    	fn_CreateGrid(excelList); 
    }
</script>
</html>