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
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_SRA_INDV_AMNNO]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_FHS_ID_NO]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_FARM_AMNNO]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_FTSNM]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_PPGCOW_FEE_DSC]
	,div[id$=grd_MmInsSogCow].ui-jqgrid .ui-jqgrid-labels div[id=jqgh_grd_MmInsSogCow_PRNY_JUG_YN]
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
			<!--
		    <button class="tb_btn" id="pb_addRow">행 추가</button>
		    -->
		    <button class="tb_btn" id="pb_delRow">행 삭제</button>
		    <button class="tb_btn" id="pb_allVaildChk">데이터 검증</button>
		    <button class="tb_btn" id="pb_allSyncIndv">개체 연계</button>
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
    	//경매대상 변경시 그리드 초기화 및 파일 데이터 초기화
    	$('#pb_allSyncIndv').click((e)=>{
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
	        
        	var booleanChk = rowData.some((o,i)=>{
        		if(o.CHK_VAILD_ERR == 1){
     	           	MessagePopup("OK", '데이터 검증후 개체연계 부탁드립니다.');
        			return true;
       			}else{
       				return false;
       			}
        	});
        	if(booleanChk) return;
	        
	        
	        var param = {list : rowData,auc_obj_dsc : $('#auc_obj_dsc').val() ,auc_dt : aucDt.replaceAll('-','') ,rc_dt: rcDt.replaceAll('-','')};
	        
	        var result = sendAjaxAsync(param, '/LALM1003P3_selIndvSync', 'POST',function(result){	        	
	        	 showErrorMessage(result);
	        },function(result){
	        	 var decResult = setDecrypt(result);
     			 fn_CreateGrid(decResult);
     			 $('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
             	 	if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_INF_ERR') == '1'){
						$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
						$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"#ff0000",color:"#000"});
           	 		}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '0' || $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '0'){
						$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
						if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '0'){
	           	 			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'SRA_INDV_AMNNO'),{background:"rgb(255 0 0)"});							
						}
						if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '0'){
	           	 			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO', $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FHS_ID_NO'),{background:"rgb(255 0 0)"});
	           	 			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO', $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FARM_AMNNO'),{background:"rgb(255 0 0)"});
	           	 			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM', $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FTSNM'),{background:"rgb(255 0 0)"});							
						}
	    	 		}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '1' && $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '1'){
						$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '*');
						$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)",color:""});
	        	 	}else{
            	         $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
          				$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"",color:""});
            	 	}      				
     			 });
	        	
	        });

	        function sendAjaxAsync(objData, sendUrl, methodType,errCallBack,succCallBack){
	            var encrypt = setEncrypt(objData);                    
	            var result;
	            $.ajax({
	                url: sendUrl,
	                type: methodType,
	                dataType:'json',
	                async: true,
	                headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
	                data:{
	                       data : encrypt.toString()
	                },
	                beforeSend:function(){
	                	setTimeout(showLodingImg,0);
	                },
	                success:function(data) {
	                	result = data;    
	                	if(succCallBack instanceof Function) succCallBack(result);   
	                },
	                error:function(response){
	                	if(response.status == 404){
	                        result = "";
	                    }else {
	                        result = JSON.parse(response.responseText); 
	                    }
	                	if(errCallBack instanceof Function) errCallBack(result);
	                },
	                complete:function(data){
						localStorage.setItem("nhlvaca_token", (getCookie('token')||localStorage.getItem('nhlvaca_token')));
						setTimeout(hideLodingImg,0);
	                }
	            });         
	            return result;
	        }
    	});

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
	        
			var result = sendAjax(param, '/LALM1003P3_selSogCowVaild', 'POST');
	        if(result.status != RETURN_SUCCESS){
				showErrorMessage(result);
				return;
			} else {
				var decList = setDecrypt(result);	        	 
      			fn_CreateGrid(decList);
      			var errCnt=0;
      			$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
					if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR') == '1'){
	             	 	errCnt++;
	             	    $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
	             	    if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_AUC_PRG_SQ') == '1'){
	             	    	var aucPrgSq = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'AUC_PRG_SQ');
	                 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'AUC_PRG_SQ', aucPrgSq,{background:"rgb(255 0 0)"});             	        	
						}
	             	    if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_SRA_INDV_AMNNO') =='1'){
	             	    	var sraIndvAmnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'SRA_INDV_AMNNO');
	                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', sraIndvAmnno,{background:"rgb(255 0 0)"});             	        	
						}
					}
					var rmkCntn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'RMK_CNTN');
      				if(rmkCntn.length > 30){
      					errCnt++;
      					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'RMK_CNTN', rmkCntn ,{background:"rgb(255 0 0)"});      
                  	  	$('#grd_MmInsSogCow').jqGrid('setCell',rowid,'CHK_VAILD_ERR','1');      	    		 
					}
      				//2023.06.22 엑셀업로드시 번식우가 아니면서 임신구분값이 5가 아닌경우 에러로 표기
					var ppgcowFeeDsc = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'PPGCOW_FEE_DSC');
					var aucObjDsc = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'AUC_OBJ_DSC');
      				if(ppgcowFeeDsc != '5' && aucObjDsc !='3'){
      					errCnt++;
      					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'PPGCOW_FEE_DSC', ppgcowFeeDsc ,{background:"rgb(255 0 0)"});      
                  	  	$('#grd_MmInsSogCow').jqGrid('setCell',rowid,'CHK_VAILD_ERR','1');
      				 }
      				//인공수정일자 날짜확인
					var afism_mod_dt = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'AFISM_MOD_DT');
      				if(aucObjDsc =='3' && !fn_isNull(afism_mod_dt) && !fn_isDate(afism_mod_dt)){
      					errCnt++;
      					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '-',{background:"rgb(255 0 0)"});
                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'AFISM_MOD_DT', afism_mod_dt ,{background:"rgb(255 0 0)"});      
                  	  	$('#grd_MmInsSogCow').jqGrid('setCell',rowid,'CHK_VAILD_ERR','1');      	    		 
					}
				});
    			if(errCnt==0) $('#pb_allSyncIndv').attr('disabled',false);
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
                 	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'AUC_PRG_SQ', aucPrgSq,{background:"rgb(255 0 0)"});             	        	
					}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_ERR_SRA_INDV_AMNNO') =='1'){
             	    	var sraIndvAmnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'SRA_INDV_AMNNO');
                  	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', sraIndvAmnno,{background:"rgb(255 0 0)"});             	        	
					}else{
						$("#grd_MmInsSogCow").setRowData(rowid,false,{background:"#ff0000",color:"#000"});
					}
				}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '0'){
					$("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
					$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM', "",{background:"#ff0000",color:"#000"});
  	 			}else if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '1' && $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '1'){
	       	         $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '*');
	    	         $("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)",color:""});
	    	 	}
			});
    	});
        $("#pb_addRow").click(()=>{
        	
        	var booleanChk = $('#grd_MmInsSogCow').getRowData().some((o,i)=>{
        		if(o.CHK_IF_SRA_INDV != 1 || o.CHK_IF_FHS != 1){
        			return true;
       			}else{
       				return false;
       			}
        	});
        	if(booleanChk) return;
        	chkAddRow = true;
        	
        	var data = $('#grd_MmInsSogCow').jqGrid('getRowData');
        	var len = data.length;
        	var tempRow = new Object();
        	tempRow.AUC_OBJ_DSC=$('#auc_obj_dsc').val();
        	tempRow.PPGCOW_FEE_DSC=5;
        	tempRow.TRPCS_PY_YN = '0';
        	tempRow.BRCL_ISP_CTFW_SMT_YN = '0';
        	tempRow.RMHN_YN = '0';
        	tempRow.MT12_OVR_YN = '0';
        	tempRow.AFISM_MOD_CTFW_SMT_YN = '0';
        	tempRow.PRNY_JUG_YN = '0';
        	tempRow.PRNY_YN = '0';
        	tempRow.NCSS_JUG_YN = '0';
        	tempRow.NCSS_YN = '0';
        	tempRow.DNA_YN = '3';
        	tempRow.DNA_YN_CHK = '0';
        	tempRow.SRA_INDV_AMNNO = '';
        	
        	tempRow.VACN_DT = '';
        	tempRow.BOVINE_DT = '';
        	tempRow.BRCL_ISP_DT = '';
        	tempRow.AFISM_MOD_DT = '';
        	
        	tempRow.AUC_PRG_SQ= Number($('#grd_MmInsSogCow').jqGrid('getCell',len,'AUC_PRG_SQ')) +1;
        	
        	if(len==0){
        		tempRow.AUC_PRG_SQ = len+1;
        		var results = sendAjax({auc_dt : pageInfo.param.auc_dt.replaceAll('-','')}, "/LALM1004_selPrgSq", "POST");
        		var result;
        		  
        		if(results.status == RETURN_SUCCESS) {
        			result = setDecrypt(results);
        			if(result.length > 0) {
						//$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
						tempRow.AUC_PRG_SQ = result[0]["AUC_PRG_SQ"];
                 	}
        		}else {
                    showErrorMessage(results);
                    return;
                }        		
        	}        	
        	
        	$("#grd_MmInsSogCow").jqGrid("addRowData", len+1, tempRow, 'last');
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
    	 	2.ajax 동일한 귀표번호 + 경매번호 출장우 중복여부 CHECK
    	 	3.귀표번호가 개체테이블에 없을시 인터페이스 연동후 귀표번호 없을시 귀표번호가 올바르지 않습니다 호출 INSERT	LALM9519A0	selIndvHstIntf PARAM 귀표번호
    	 	4. 농가번호 체크후 농가 없을시 인터페이스 연동후 INSERT LALM9519A0	selIndvHstFhsIntf 
    	 **/
     	var rowData = $('#grd_MmInsSogCow').getRowData();
    
		var booleanRequierd = rowData.some((o,i)=>{
			if(o.CHK_IF_SRA_INDV != 1 || o.CHK_IF_FHS != 1){
				MessagePopup('OK','농가,개체번호 데이터를 확인해주세요.');
    			return true;
   			}
			if(fn_isNull(o.FTSNM) || fn_isNull(o.FARM_AMNNO) || fn_isNull($.trim(o.FHS_ID_NO)) || fn_isNull(o.AUC_PRG_SQ) || fn_isNull(o.AUC_OBJ_DSC) || fn_isNull(o.PPGCOW_FEE_DSC) || fn_isNull(o.SRA_INDV_AMNNO) ){    			 
				MessagePopup('OK','필수입력값을 확인해주세요.');
				return true;
    		 }else if(o.SRA_INDV_AMNNO.replace("-", "").length != 15 || o.SRA_INDV_AMNNO.substr(0,3) != '410'){    			 
				MessagePopup('OK','개체관리번호의 값을 확인해주세요.');
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
    		 	if(cur.SRA_INDV_AMNNO == o.SRA_INDV_AMNNO && i != j){
         			MessagePopup("OK", '중복된 귀표번호['+cur.SRA_INDV_AMNNO+']가 있습니다.');
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
        
        var result = sendAjax(param, '/LALM1003P3_insSogCow', 'POST');	       
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
   	function gridSchboxFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<input style="margin-left:1px;" type="button" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popFstNm(\'' + rowid + '\')" value="찾기" />';
	} 
   	function gridSchboxFormatSraIndvAmnno(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<input style="margin-left:1px;" type="button" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSraIndvAmnno(\'' + rowid + '\')" value="조회" />';
	} 
    
    function fn_popFstNm(rowid){
    	//$('#grd_MmInsSogCow').editCell(0,3,false);

		var errCnt=0;
		$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
			var chkVaild = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR');
			if(chkVaild == '1' || chkVaild == ''){
				errCnt++;
			}
		});
		if(errCnt > 0) {
			MessagePopup("OK", '데이터검증을 완료후 개체조회가 가능합니다.');		
			return;	
		}
    	var ftsnm = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FTSNM');
		if(!fn_isNull(ftsnm)) {
        	//fn_CallFtsnmPopup(true);
     		var data = new Object();
            data['flag'] = '2';
            data['sra_fhsnm'] = ftsnm;

            fn_CallFhsPopup(data, false, function(fhsData){
            	if(fhsData){
            		var sendObj = new Object();
            		fhsData.ZIP = fhsData.SRA_FHS_FZIP.trim() + '-' + fhsData.SRA_FHS_RZIP.trim();
            		fhsData.TELNO = fhsData.SRA_FHS_ATEL.trim() + '-' + fhsData.SRA_FHS_HTEL.trim() + '-' + fhsData.SRA_FHS_STEL.trim();
            		fhsData.MPNO = result.SRA_FHS_REP_MPSVNO.trim() + '-' + result.SRA_FHS_REP_MPHNO.trim() + '-' + result.SRA_FHS_REP_MPSQNO.trim();

            		$("#grd_MmInsSogCow").jqGrid('setCell', rowid, 'FHS_ID_NO', fhsData.FHS_ID_NO);
            		$("#grd_MmInsSogCow").jqGrid('setCell', rowid, 'FARM_AMNNO', fhsData.FARM_AMNNO);
            		$("#grd_MmInsSogCow").jqGrid('setCell', rowid, 'FTSNM', fhsData.SRA_FHSNM);
            		var resultsTmpIndv = sendAjax(fhsData, "/LALM1003P3_insFhs", "POST");
            		var result;
            		if(results.status == RETURN_SUCCESS) {            			
            		}else {
                        showErrorMessage(results);
                        return;
                    }            		
            	}
            });
        }
		
		if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '1' && $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '1'){
	        $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '*');
	        $("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)"});
		}else{
	        $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
		}
    }
    
    function fn_popSraIndvAmnno(rowid){
    	//$('#grd_MmInsSogCow').editCell(0,5,false);
		var p_sra_indv_amnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'SRA_INDV_AMNNO');
		var mcow_sra_indv_amnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'MCOW_SRA_INDV_AMNNO');

		var errCnt=0;
		$('#grd_MmInsSogCow').getDataIDs().forEach((rowid,i)=>{
			var chkVaild = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_VAILD_ERR');
			if(chkVaild == '1' || chkVaild == ''){
				errCnt++;
			}
		});
		if(errCnt > 0) {
			MessagePopup("OK", '데이터검증을 완료후 개체조회가 가능합니다.');		
			return;	
		}
		
		
		if(fn_isNull(p_sra_indv_amnno)){
			MessagePopup("OK", '귀표번호를 입력해주세요.');
			return;
		}else if(p_sra_indv_amnno.length < '15') {
			MessagePopup("OK", '귀표번호 15자리모두 입력해주시기 바랍니다.');
			return;			
		}
				
		fn_CallIndvInfSrch(p_sra_indv_amnno,rowid);
		//// 브루셀라검사 조회
        fn_CallBrclIspSrch(p_sra_indv_amnno,rowid);
		// EPD
        fn_CallGeneBredrInfSrch(p_sra_indv_amnno,rowid);
		// 어미소 EPD
        if(!fn_isNull(mcow_sra_indv_amnno)){
        	fn_CallGeneBredrInfSrch(mcow_sra_indv_amnno,rowid,true);
        }
		// 친자확인
        fn_CallLsPtntInfSrch(p_sra_indv_amnno,rowid);
    }
	
  	//**************************************
 	//function  : fn_CallIndvInfSrch(개체정보검색 전 셋팅) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
	function fn_CallIndvInfSrch(p_sra_indv_amnno,rowid) {
		
 		if(p_sra_indv_amnno.replace("-", "").length == 15) {
 			var param = new Object();
 			param.re_indv_no = p_sra_indv_amnno;
        	var resultsTmpIndv = sendAjax(param, "/LALM1004_selTmpIndvAmnnoPgm", "POST");   
        	var resultTmpIndv;
        	
            if(resultsTmpIndv.status == RETURN_SUCCESS) {
            	resultTmpIndv = setDecrypt(resultsTmpIndv);
            	
            	if(resultTmpIndv.length == 1) {
            		fn_CallIndvInfSrchPopup(true, p_sra_indv_amnno,rowid);
            	}
            } else {
	           	if(p_sra_indv_amnno.replace("-", "").length == 15) {
	           		// 개체 인터페이스 호출
	           		fn_popInfHstPopup(true,p_sra_indv_amnno,rowid);
	           	}
            }
            
        } else {
        	fn_CallIndvInfSrchPopup(true, p_sra_indv_amnno,rowid);
		}
 		
	}
	
	//**************************************
 	//function  : fn_CallIndvInfSrchPopup(개체정보검색팝업 호출) 
 	//paramater : p_param(true, false), p_sra_indv_amnno(sra_indv_amnno Value)
 	// result   : N/A
 	//**************************************
	function fn_CallIndvInfSrchPopup(p_param, p_sra_indv_amnno,rowid) {
		var checkBoolean = p_param;
 		var data = new Object();
 		
 		if(!p_param) {
 			data = null;
 		} else {
 			data['sra_indv_amnno'] = p_sra_indv_amnno;
 		}
 		
 		fn_CallMmIndvPopup(data,p_param,function(result) {
        	if(result) {             
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_SRS_DSC', result.SRA_SRS_DSC);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', result.SRA_INDV_AMNNO);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO', result.FHS_ID_NO);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO', result.FARM_AMNNO);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM', fn_xxsDecode(result.FTSNM));
        	    
       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_PDMNM', fn_xxsDecode(result.FTSNM));
       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_PD_RGNNM', fn_xxsDecode(result.DONGUP));

       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'MCOW_SRA_INDV_AMNNO', result.MCOW_SRA_INDV_AMNNO);
       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SOG_NA_TRPL_C', result.NA_TRPL_C);
	        	$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_SRA_INDV', 1);
                fn_CallIndvInfSrchSet(p_sra_indv_amnno,rowid);
	        	
             }
        });
 	}
	
	//**************************************
 	//function  : fn_CallIndvInfSrchSet(개체정보검색 팝업 후 세팅) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_CallIndvInfSrchSet(p_sra_indv_amnno,rowid) {
 		var fhs_id_no = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FHS_ID_NO');
 		var farm_amnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FARM_AMNNO');
 		var resultsFhsIdNo = sendAjax({fhs_id_no: fhs_id_no,farm_amnno: farm_amnno}, "/LALM1004_selFhsIdNo", "POST");        
        var resultFhsIdNo;
        
        if(resultsFhsIdNo.status == RETURN_SUCCESS) {
        	resultFhsIdNo = setDecrypt(resultsFhsIdNo);
        	if(resultFhsIdNo.length == 1) {
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO', resultFhsIdNo[0].FHS_ID_NO);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO', resultFhsIdNo[0].FARM_AMNNO);
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM', fn_xxsDecode(resultFhsIdNo[0].FTSNM));
        	    
       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_PDMNM', fn_xxsDecode(resultFhsIdNo[0].FTSNM));
       			$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_PD_RGNNM', fn_xxsDecode(resultFhsIdNo[0].DONGUP));      			
        		                
             	$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 1);
                //fn_FtsnmModify(p_sra_indv_amnno,rowid);
        	}else if(resultFhsIdNo.length > 1){
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO');
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO');
        	    //$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM', "중복농가");
             	$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
        		
        	}else{
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO');
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO');
        	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FTSNM');
             	$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
        		
        	}
        }

		
		if($('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_SRA_INDV') == '1' && $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'CHK_IF_FHS') == '1'){
	        $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_', '*');
	        $("#grd_MmInsSogCow").setRowData(rowid,false,{background:"rgb(253 241 187)"});
		}else{
	        $("#grd_MmInsSogCow").jqGrid('setCell', rowid, '_STATUS_');
		}        
		fn_FtsnmModify(p_sra_indv_amnno,rowid);
 	}
    
 	//**************************************
 	//function  : fn_FtsnmModify(출하주 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_FtsnmModify(p_sra_indv_amnno,rowid) {

		//var newSraIndvAmnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'SRA_INDV_AMNNO');
		//var farmAmnno = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FARM_AMNNO');
		//var fhsIdNo = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FHS_ID_NO');
		var ftsnm = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'FTSNM');	
   		if($("#auc_obj_dsc").val() == "3" && ftsnm != "" && App_na_bzplc == "8808990643625") {
   			var srchData = new Object();
   	    	
   			//인공수정KPN정보       
   	        srchData["ctgrm_cd"]  = "2900";
   	        srchData["SRA_INDV_AMNNO"] = p_sra_indv_amnno;
   	        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
   	        var result;
   	        
   	        if(results.status != RETURN_SUCCESS){
   	            showErrorMessage(results,'NOTFOUND');
   	            return;
   	        }else{
   	            result = setDecrypt(results);
   	         	$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'MOD_KPN_NO', $.trim(result.SRA_KPN_NO));
   	        }   			
      	}
 	}
 	
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }else{
        	data = [];
        }
        
        const searchResultColNames = ["* 경매번호","* 경매대상","* 출하자코드","* 출하자","조합원<br/>여부","관내외<br>구분","생산자","접수일자","진행상태"
                                   ,"낙찰자명","참가<br/>번호","* 개체번호","성별","구제역백신<br/>접종여부","구제역백신<br/>접종일","중량","예정가","낙찰단가","낙찰가","비고"
                                  ];

        const searchResultColModel = [
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:80,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:80,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:80,  sortable:false, align:'center'},
                                     {name:"FTSNM",                index:"FTSNM",                width:75,  sortable:false, align:'center'},
                                     {name:"MACO_YN",              index:"MACO_YN",              width:65,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC",            index:"JRDWO_DSC",            width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"SRA_PDMNM",            index:"SRA_PDMNM",            width:80,  sortable:false, align:'center'},
                                     {name:"RC_DT",                index:"RC_DT",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"SEL_STS_DSC",          index:"SEL_STS_DSC",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     {name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:80,  sortable:false, align:'center'},
                                     {name:"LVST_AUC_PTC_MN_NO",   index:"LVST_AUC_PTC_MN_NO",   width:40,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"VACN_DT_YN",           index:"FMD_V_YN",             width:70,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"VACN_DT",              index:"FMD_V_DT",             width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:70,  sortable:false, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_E",           index:"SRA_SBID_E",           width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",         index:"SRA_SBID_UPR",         width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",          index:"SRA_SBID_AM",          width:70,  sortable:false, align:'right' , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"NOTE",                 index:"NOTE",                 width:150,  sortable:false, align:'center'},
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
            	if(cellname =='TRPCS_PY_YN'){
            		var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
            		if(trpcs_py_yn =='1'){
                	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_TRPCS');
            		}
            	}
            	if(cellname =='FTSNM'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO' );
            		//fn_popFstNm(rowid);
            	}
            	if(cellname =='SRA_INDV_AMNNO'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_SRA_INDV', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO' );
            		//fn_popSraIndvAmnno(rowid);
            	}
            },
            afterSaveCell : function(rowid, cellname, value, iRow, iCol){
            	if(cellname =='TRPCS_PY_YN'){
            		var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
            		if(trpcs_py_yn =='1'){
                	    $('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'SRA_TRPCS');
            		}
            	}
            	if(cellname =='FTSNM'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO' );
            		//fn_popFstNm(rowid);
            	}
            	if(cellname =='SRA_INDV_AMNNO'){
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_FHS', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'CHK_IF_SRA_INDV', 0);
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FHS_ID_NO'  );
     	        	//$('#grd_MmInsSogCow').jqGrid('setCell', rowid, 'FARM_AMNNO' );
            		//fn_popSraIndvAmnno(rowid);
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
                	if(chkVaildErr != '1'){
						e.preventDefault();
                	}
                	if(cellname =='SRA_TRPCS'){
                        //e.preventDefault();
                		var trpcs_py_yn = $('#grd_MmInsSogCow').jqGrid('getCell',rowid,'TRPCS_PY_YN');
                		if(trpcs_py_yn =='1'){
                			$(this).val('');
                		}
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
				ExcelData['FHS_ID_NO'          	 ] = item[2 ]  ?? ''; // 출하자코드
				ExcelData['FTSNM'          		 ] = item[3 ]  ?? ''; // 출하자명
				ExcelData['MACO_YN'          	 ] = item[4 ]  ?? ''; // 조합원여부
				ExcelData['JRDWO_DSC'          	 ] = item[5 ]  ?? ''; // 관내외구분
				ExcelData['SRA_PDMNM'          	 ] = item[6 ]  ?? ''; // 생산자명
				ExcelData['RC_DT'          		 ] = item[7 ]  ?? ''; // 접수일자
				ExcelData['SEL_STS_DSC'          ] = item[8 ]  ?? ''; // 진행상태
				ExcelData['SRA_MWMNNM'           ] = item[9 ]  ?? ''; // 낙찰자명
				ExcelData['LVST_AUC_PTC_MN_NO'   ] = item[10 ] ?? ''; // 참가번호
				ExcelData['SRA_INDV_AMNNO'       ] = item[11 ] ?? ''; // 개체번호
				ExcelData['INDV_SEX_C'           ] = item[12 ] ?? ''; // 성별
				ExcelData['VACN_DT_YN'           ] = item[13 ] ?? ''; // 구제역백신접종여부
				ExcelData['VACN_DT'              ] = item[14 ] ?? ''; // 구제역백신접종일
				ExcelData['COW_SOG_WT'           ] = item[15 ] ?? ''; // 중량
				ExcelData['SRA_SBID_E'           ] = item[16 ] ?? ''; // 예정가
				ExcelData['SRA_SBID_UPR'         ] = item[17 ] ?? ''; // 낙찰단가
				ExcelData['SRA_SBID_AM'          ] = item[18 ] ?? ''; // 낙찰가
				ExcelData['NOTE'                 ] = item[19 ] ?? ''; // 비고

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









