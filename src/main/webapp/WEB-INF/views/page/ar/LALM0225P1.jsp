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
<style type="text/css">
	div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_AUC_DT]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_SRA_INDV_AMNNO]
	{
	    color: #ff0000;
	}
</style>
    <div class="pop_warp">
   		<div class="tab_box clearfix" style="">
			<!--  //버튼 모두 우측정렬 -->
			<label id="msg_Sbid"style="font-size: 12px; color: #cb7726; font: message-box;">
				※엑셀업로드후 저장시 수정된 항목은 U로 표시됩니다..<br/>
				※저장되지않은 경매일의 귀표번호는 붉은색으로 따로 표시되며 따로 저장되지않습니다.
			</label>
		</div>
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
                        <col width="95">
                        <col width="*">
                        <col width="75">
                        <col width="*">
                        <col width="75">
                        <col width="*">
                        <col width="120">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th colspan="2"><input type="file" title="파일첨부" onchange="excelExport(event);"/></th>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>

        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
        </div>
        
        <div class="listTable mb0">           
            <table id="grd_MmInsSogCow">
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
<script type="text/javascript">
	var chkAddRow = false;
	//var chkSraIndvIf = true;
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    $(document).ready(function(){
        fn_Init();
        fn_CreateGrid();                

    	//s: 이벤트
        
    	//e: 이벤트
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_CreateGrid();
    }

    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 /** TODO:
			1.excel 파일내 동일한 경매번호 있는지
    	 	2.ajax 동일한 귀표번호 + 경매번호 출장우 중복여부 CHECK
    	 	3.귀표번호가 개체테이블에 없을시 인터페이스 연동후 귀표번호 없을시 귀표번호가 올바르지 않습니다 호출 INSERT	LALM9519A0	selIndvHstIntf PARAM 귀표번호
    	 	4. 농가번호 체크후 농가 없을시 인터페이스 연동후 INSERT LALM9519A0	selIndvHstFhsIntf 
    	 **/
		gridSaveRow('grd_MmInsSogCow');
     	var rowData = $('#grd_MmInsSogCow').getRowData();
    
		var booleanRequierd = rowData.some((o,i)=>{
    	});
        
    	if(booleanRequierd) return;
    	
            
        if (rowData.length == 0) {
           MessagePopup("OK", '조회된 데이터가 없습니다.');
           return false;
        }
        
        var param = {list : rowData};
        
        var result = sendAjax(param, '/LALM0225P1_updDnaYn', 'POST');	       
         if(result.status != RETURN_SUCCESS){
        	 showErrorMessage(result);
        	 return;
         } else {
        	 var decResult = setDecrypt(result);
        	 fn_CreateGrid(decResult);
  			$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
				if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR') == '1'){
					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-');
					$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(255 0 0)",color:"rgb(0 0 0)"});
				}else{
					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', 'U');		
					$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)",color:""});		
				}
			});
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
        }else{
        	data = [];
        }
        
        var searchResultColNames = ["","*경매일자","농가번호","농장번호","출하자명","주소","*바코드","성별","KPN","어미바코드","분석기관","최종감정결과","에러체크용"];
        
        var searchResultColModel = [
        							 {name:"_STATUS_",              index:"_STATUS_",            width:10,  align:'center'},
                                     {name:"AUC_DT",               index:"AUC_DT",               width:60,  align:'left'  , sortable : false, editable:false ,formatter:'gridDateFormat'},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:50,  align:'center', sortable : false },
                                     {name:"FARM_AMNNO",           index:"FARM_AMNNO",           width:50,  align:'center', sortable : false },
                                     {name:"FTSNM",                index:"FTSNM",                width:60,  align:'center', sortable : false, editable:false },
                                     {name:"ADDR",                 index:"ADDR",                 width:100,  align:'center', sortable : false, editable:false },
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:90, align:'center', sortable : false, editable: false , editoptions:{maxlength:"15"}},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:20,  align:'center', sortable : false, editable:false },
                                     {name:"KPN_NO",               index:"KPN_NO",               width:20,  align:'center', sortable : false, editable:false },
                                     {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:100,  align:'center', sortable : false, editable:false },
                                     {name:"ANALY_ORGAN",          index:"ANALY_ORGAN",          width:50,  align:'center', sortable : false, editable:false },
                                     {name:"DNA_JUG_RESULT",       index:"DNA_JUG_RESULT",       width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},                                
                                     {name:"CHK_VAILD_ERR",	       index:"CHK_VAILD_ERR",      	 width:90,  align:'left'  , sortable : false, hidden : true},
                                     
                                     ];

        $("#grd_MmInsSogCow").jqGrid("GridUnload");
                
        $("#grd_MmInsSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      430,
            rowNum:      rowNoValue,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            cellEdit:    false,
            cellsubmit:  "clientArray", 
            rownumWidth:40,
            sortable : false,
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        //가로스크롤 있는경우 추가
        $("#grd_MmInsSogCow .jqgfirstrow td:last-child").width($("#grd_MmInsSogCow .jqgfirstrow td:last-child").width() - 17);
        
    }
    
    function excelExport(event){
    	//excelExportCommon(event, handleExcelDataAll);
    	excelExportCommon(event, handleExcelDataAll);
    }
    
    function excelExportCommon(event, callback){
        var input = event.target;        
        var reader = new FileReader();        
        reader.onload = function(){
            var fileData = reader.result;
            var wb = XLSX.read(fileData, {cellText:true,cellDates:true,dateNF: 'yyyymmdd',type:'binary'});            
            var firstSheetName = wb.SheetNames[0];
            callback(wb.Sheets[firstSheetName]);
        };
        reader.readAsBinaryString(input.files[0]);
    }
    
    function handleExcelDataAll(sheet){
    	/** TODO :
			1.경매차수 생성 체크
			2.접수일자, 경매일자비교
			3.경매대상 동일한지 체크
		**/
        var Obj = XLSX.utils.sheet_to_json(sheet,{raw:false,header:1});
        
        var ExcelList = new Array();
    	Obj.forEach(function(item,idx){
    		if(idx != 0 && item.length > 0){
    			var ExcelData = new Object();
    			
    			ExcelData['AUC_DT'] = item[0]?item[0].replaceAll(/[^0-9]/g,''):''; // 경매일
    			ExcelData['FHS_ID_NO'] = item[1]?item[1].split('-')[0]:''; // 농가번호                
    			ExcelData['FARM_AMNNO'] = item[1 ]?item[1].split('-')[1]:''; // 농장번호                  
    			ExcelData['FTSNM'] = item[2 ]??''; // 농가명            
    			ExcelData['ADDR'] = item[3 ]??''; // 주소          
    			ExcelData['SRA_INDV_AMNNO'] = item[4 ]??''; // 바코드
    			ExcelData['INDV_SEX_C'] = item[5 ]??''; // 성별                
    			ExcelData['KPN_NO'] = item[6 ]??'0'; // KPN 번호         
    			ExcelData['MCOW_SRA_INDV_AMNNO'] = item[7 ]??''; // 어미개체번호              
    			ExcelData['ANALY_ORGAN'] = item[8 ]??''; // 분석기관          
    			ExcelData['DNA_JUG_RESULT'] = item[9 ]=='일치'?'1':'3'; // 친자검사결과             
    			
    			ExcelList.push(ExcelData);
    		}
    	});
    	console.log(ExcelList);
    	if(ExcelList.length > 0){
    		fn_CreateGrid(ExcelList);
    	}else{
    		MessagePopup('OK','업로드 가능한 개체목록이 없습니다.');
    		return;
    	}
    	
     	
    }
</script>
</html>









