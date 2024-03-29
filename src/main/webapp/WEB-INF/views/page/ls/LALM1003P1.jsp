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
	div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_AUC_OBJ_DSC]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_FHS_ID_NO]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_FTSNM]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_AUC_PRG_SQ]{
	    color: #ff0000;
	}
</style>
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
                            <th class="tb_dot">경매대상구분</th>
                            <td>
                                <select id="auc_obj_dsc"></select>
                            </td>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th class="tb_dot">접수일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="rc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th colspan="2"><input type="file" title="파일첨부" onchange="excelExport(event);"/></th>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
		<div class="fl_R">
		    <button class="tb_btn" id="pb_delRow">행 삭제</button>
		    <button class="tb_btn" id="pb_allVaildChk">데이터 검증</button>
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
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC",1, true); 

    	var param = new Object();
    	param.auc_obj_dsc = pageInfo.param.auc_obj_dsc;
    	param.auc_dt = pageInfo.param.auc_dt.replaceAll('-','');
   	 	var results = sendAjax(param, "/Common_selAucQcn", "POST");
   	 	var result = null;
       
        if(results.status == RETURN_SUCCESS) {
        	result = setDecrypt(results);
        	if(result.length < 1){
            	MessagePopup("OK", '경매일('+$('#auc_dt').val()+')에 경매차수가 없습니다.',function(){
                    pageInfo.returnValue = false;         
            		parent.$("#pop_result_" + pageInfo.popup_info.PGID ).val(true).trigger('change');
            	});
                return;            		
        	}
        }else{
        	MessagePopup("OK", '경매일('+$('#auc_dt').val()+')에 경매차수가 없습니다.',function(){
                pageInfo.returnValue = false;                         
        		parent.$("#pop_result_" + pageInfo.popup_info.PGID ).val(true).trigger('change');
        	});
            return;            	
        }
        
        if(pageInfo.param){
        	if(pageInfo.param.auc_obj_dsc != '0'){
        		$('#auc_obj_dsc').attr('disabled',true);
            	$('#auc_obj_dsc').val(pageInfo.param.auc_obj_dsc);
        	}else{
        		$('#auc_obj_dsc').attr('disabled',false);
            	$('#auc_obj_dsc').val(1);        		
        	}
        	$('#auc_dt').val(pageInfo.param.auc_dt);
        	$('#auc_dt').attr('disabled',true);
        }
        
        $( ".date" ).datepicker();
    	$('#rc_dt').val(fn_getToday());

    	//s: 이벤트
    	$('#pb_allVaildChk').click((e)=>{
    		e.preventDefault();
    		e.stopPropagation();

    		var aucDt = $('#auc_dt').val();
    		var rcDt = $('#rc_dt').val();
	        gridSaveRow('grd_MmInsSogCow');
    	 	var rowData = $('#grd_MmInsSogCow').getRowData();
	        
	        if (rowData.length == 0) {
	           MessagePopup("OK", '조회된 데이터가 없습니다.');
	           return false;
	        }
	        var param = {list : rowData,auc_obj_dsc : $('#auc_obj_dsc').val() ,auc_dt : aucDt.replaceAll('-','') ,rc_dt: rcDt.replaceAll('-','')};
	        
			var result = sendAjax(param, '/LALM1003P1_selEtcVaild', 'POST');
	        if(result.status != RETURN_SUCCESS){
				showErrorMessage(result);
				return;
			} else {
				var decList = setDecrypt(result);	 
      			fn_CreateGrid(decList);
      			$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
					if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR') == '1'){
	             	    $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
	             	    if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_AUC_PRG_SQ') == '1'){
	             	    	var aucPrgSq = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'AUC_PRG_SQ');
	                 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'AUC_PRG_SQ', aucPrgSq,{background:"rgb(255 0 0)"});             	        	
						}
						if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_FHS_ID_NO') == '1'){
							var fhsIdNo = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FHS_ID_NO');
							$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO', fhsIdNo, {background:"rgb(255 0 0)"});
						}
					}
					var rmkCntn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'RMK_CNTN');
      				if(rmkCntn.length > 30){
      					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'RMK_CNTN', rmkCntn ,{background:"rgb(255 0 0)"});      
                  	  	$('#grd_MmInsSogCow').jqGrid('setCell', rowid,'CHK_VAILD_ERR','1');      	    		 
					}
				});
	         }
    	});
    	
    	$('#auc_obj_dsc').change(()=>{
            fn_CreateGrid();
        	$('input[type=file]').val('');    		
    	});
    	
    	$('#pb_delRow').click(()=>{
    		var selRowIds = $("#grd_MmInsSogCow").jqGrid("getGridParam", "selrow");
			$("#grd_MmInsSogCow").jqGrid("delRowData", selRowIds);
    		var data = $('#grd_MmInsSogCow').jqGrid('getRowData');

			$("#grd_MmInsSogCow").jqGrid("clearGridData", true);
            fn_CreateGrid(data);

  			$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
				if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR') == '1'){					
					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
             	    if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_AUC_PRG_SQ') == '1'){
             	    	var aucPrgSq = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'AUC_PRG_SQ');
                 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'AUC_PRG_SQ', aucPrgSq, {background:"rgb(255 0 0)"});             	        	
					}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_FHS_ID_NO') == '1'){
						var fhsIdNo = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FHS_ID_NO');
                 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO', fhsIdNo, {background:"rgb(255 0 0)"});             	        	
					}else{
						$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"#ff0000",color:"#000"});
					}
				}else {
	       	         $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '*');
	    	         $("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)",color:""});
	    	 	}
			});
    	});
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
        
        if(pageInfo.param){
        	$('#auc_obj_dsc').val(pageInfo.param.auc_obj_dsc);
        	$('#auc_dt').val(pageInfo.param.auc_dt);
        }
    	$('#rc_dt').val(fn_getToday());
    	$('input[type=file]').val('');
    	$('#pb_allSyncIndv').attr('disabled',true);
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
    	 	2.농가번호 체크후 세이브
    	 **/
     	var rowData = $('#grd_MmInsSogCow').getRowData();
    
		var booleanRequierd = rowData.some((o,i)=>{
			if(o.CHK_ERR_FHS_ID_NO == 1 || fn_isNull(o.FARM_AMNNO)){
				MessagePopup('OK','농가 데이터를 확인해주세요.');
    			return true;
   			}
			if(fn_isNull(o.FTSNM) || fn_isNull($.trim(o.FHS_ID_NO)) || fn_isNull(o.AUC_PRG_SQ) || fn_isNull(o.AUC_OBJ_DSC) ){    			 
				MessagePopup('OK','필수입력값을 확인해주세요.');
				return true;
    		 }else if(o.RMK_CNTN.length > 30){    			 
				MessagePopup('OK','비고의 값을 확인해주세요.<br/>[경매번호 : '+o.AUC_PRG_SQ+' 최대길이:30자]');
				return true;    			 
    		 }
    		 return rowData.some((cur,j)=>{ 
    		 	if(cur.AUC_PRG_SQ == o.AUC_PRG_SQ && i != j){
         			MessagePopup("OK", '중복된 경매번호['+cur.AUC_PRG_SQ+']가 있습니다.');
	    		 	return true ;
    		 	}
    		 });
    	});
        
    	if(booleanRequierd) return;
	
    	var aucDt = $('#auc_dt').val();
    	var rcDt = $('#rc_dt').val();    	

		if(parseInt(fn_dateToData(aucDt)) < parseInt(fn_dateToData(rcDt))) {
    		MessagePopup("OK", "접수일자는 경매일자 보다 클수 없습니다.",function(){$("#rc_dt").focus();});    		
			return;
    	}

        gridSaveRow('grd_MmInsSogCow');
            
        if (rowData.length == 0) {
           MessagePopup("OK", '조회된 데이터가 없습니다.');
           return false;
        }
        var param = {list : rowData,auc_obj_dsc : $('#auc_obj_dsc').val() ,auc_dt : aucDt.replaceAll('-','') ,rc_dt: rcDt.replaceAll('-','')};
        
        var result = sendAjax(param, '/LALM1003P1_insEtc', 'POST');	       
         if(result.status != RETURN_SUCCESS){
        	 showErrorMessage(result);
        	 return;
         } else {
        	 var decResult = setDecrypt(result);
        	 MessagePopup('OK',"저장되었습니다.",function(){
            	 fn_Init();
                 pageInfo.returnValue = true;
                 var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                 parentInput.val(true).trigger('change');        		 
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
        
        const searchResultColNames = ["", "* 경매번호","* 경매대상","* 농가식별번호","* 농가명","접수일자"
                                   ,"성별","구제역백신<br/>접종일","중량","예정가","비고"
								   , "Err Yn", "경매번호 ErrYn", "농가식별번호 ErrYn", "농장관리번호"
                                  ];

        const searchResultColModel = [
									 {name:"_STATUS_",             index:"_STATUS_",             width:10,  align:'center'},
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:100, sortable: false,align:'left', editable: true, formatter:'integer', formatoptions:{thousandsSeparator:''}},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:80,  sortable: false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:80,  sortable: false, align:'center'},
                                     {name:"FTSNM",                index:"FTSNM",                width:75,  sortable: false, align:'center'},
                                     {name:"RC_DT",                index:"RC_DT",                width:70,  sortable: false, align:'center', formatter:'gridDateFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable: false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"VACN_DT",              index:"FMD_V_DT",             width:70,  sortable: false, align:'center', formatter:'gridDateFormat'},
                                     {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:70,  sortable: false, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",     index:"LOWS_SBID_LMT_AM",     width:70,  sortable: false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable: false, align:'left'},
									 {name:"CHK_VAILD_ERR",	       index:"CHK_VAILD_ERR",      	 width:90,  sortable: false, align:'left', hidden : true},
									 {name:"CHK_ERR_AUC_PRG_SQ",   index:"CHK_ERR_AUC_PRG_SQ",   width:90,  sortable: false, align:'left', hidden : true},
									 {name:"CHK_ERR_FHS_ID_NO",	   index:"CHK_ERR_FHS_ID_NO",    width:90,  sortable: false, align:'left', hidden : true},
									 {name:"FARM_AMNNO",	   	   index:"FARM_AMNNO",    		 width:90,  sortable: false, align:'left', hidden : true},
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
            cellEdit:    true,
            cellsubmit:  "clientArray", 
            rownumWidth:40,
            sortable : false,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            afterRestoreCell  : function(rowid, value, iRow, iCol){
            	var colModel = $("#grd_MmInsSogCow").jqGrid("getGridParam", "colModel");            	
            	cellname = colModel[iCol].name;
            	// if(cellname =='TRPCS_PY_YN'){
            	// 	var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
            	// 	if(trpcs_py_yn =='1'){
                // 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_TRPCS');
            	// 	}
            	// }
            	if(cellname =='FTSNM'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
            		//fn_popFstNm(rowid);
            	}
            },
            afterSaveCell : function(rowid, cellname, value, iRow, iCol){
            	// if(cellname =='TRPCS_PY_YN'){
            	// 	var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
            	// 	if(trpcs_py_yn =='1'){
                // 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_TRPCS');
            	// 	}
            	// }
            	if(cellname =='FTSNM'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
            		//fn_popFstNm(rowid);
            	}
            },
            afterEditCell : function(rowid, cellname, value, iRow, iCol){
                $("select[id='"+iRow+"_"+cellname+"']").on('blur',function(e){
                    $("#grd_MmInsSogCow").jqGrid("saveCell", rowid, iCol);
                });
                $("input[id='"+iRow+"_"+cellname+"']").on('blur',function(e){
                    $("#grd_MmInsSogCow").jqGrid("saveCell", rowid, iCol);
                }).on('keydown',function(e){
                	var chkVaildErr = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR');
                	// if(chkVaildErr != '1'){
					// 	e.preventDefault();
                	// }
                	// if(cellname =='SRA_TRPCS'){
                    //     //e.preventDefault();
                	// 	var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
                	// 	if(trpcs_py_yn =='1'){
                	// 		$(this).val('');
                	// 	}
                	// }
					if(cellname =='AUC_PRG_SQ') {

					}
                }).on('focusout',function(e){
                    $("#grd_MmInsSogCow").jqGrid("saveCell", rowid, iCol);
                }).on("input", function(){
                	$(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
                }).on("focus",function(){
                	if($(this).val() == 0){
                		$(this).val(null) ;
                	}
                });
            }
        });
        //가로스크롤 있는경우 추가
        $("#grd_MmInsSogCow .jqgfirstrow td:last-child").width($("#grd_MmInsSogCow .jqgfirstrow td:last-child").width() - 17);
        
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
        };
        reader.readAsBinaryString(input.files[0]);
    }
    
    function handleExcelDataAll(sheet){
    	/** TODO :
			1.경매차수 생성 체크
			2.접수일자, 경매일자비교
			3.경매대상 동일한지 체크
		**/
        var Obj = XLSX.utils.sheet_to_json(sheet,{header:1,raw:true});
        
        var ExcelList = new Array();
    	Obj.forEach(function(item,idx){
    		if(idx != 0 && item.length > 0){
    			var ExcelData = new Object();

				ExcelData['AUC_OBJ_DSC'          ] = item[0 ]  ?? ''; // 경매대상구분코드
				ExcelData['AUC_PRG_SQ'           ] = item[1 ]  ?? ''; // 경매번호
				ExcelData['FTSNM'          		 ] = item[2 ]  ?? ''; // 농가명(출하자명)
				ExcelData['RC_DT'          		 ] = item[3 ]  ?? ''; // 접수일자
				ExcelData['INDV_SEX_C'           ] = item[4 ] ?? '';  // 성별
				ExcelData['VACN_DT'              ] = item[5 ] ?? '';  // 구제역백신접종일
				ExcelData['COW_SOG_WT'           ] = item[6 ] ?? '';  // 중량
				ExcelData['LOWS_SBID_LMT_AM'     ] = item[7 ] ?? ''; // 예정가
				ExcelData['RMK_CNTN'             ] = item[8 ] ?? ''; // 비고

    			if($('#auc_obj_dsc').val() == ExcelData['AUC_OBJ_DSC']) ExcelList.push(ExcelData);
    		}
    	});
    	if(ExcelList.length > 0){
    		fn_CreateGrid(ExcelList);
    	}else{
    		MessagePopup('OK','업로드 가능한 개체목록이 없습니다.');
    		return;
    	}
    }
</script>
</html>









