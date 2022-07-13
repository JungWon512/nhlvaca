<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>


<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0313
 * 3. 파일명(한글) : 응찰가수기입력 입력
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.21   유성제   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     var na_bzplc = App_na_bzplc;
     
     $(document).ready(function(){
    	fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2);
    	
    	/******************************
          * 중도매인검색 팝업
          ******************************/       
        $("#sra_mwmnnm").on("keydown", function(e){         
            if(e.keyCode != 13) {
                 $("#trmn_amnno").val('');
                 $("#lvst_auc_ptc_mn_no").val(''); 
                 $("#v_trmn_amnno").val('');
            } else  if(e.keyCode == 13) {
                if(fn_isNull($("#sra_mwmnnm").val())){
                    MessagePopup('OK','응찰자 명을 입력하세요.');
                    return;
                }else {
                     var data = new Object();
                     data['auc_obj_dsc']      = $("#cb_auc_obj_dsc").val();
                     data['auc_dt']           = fn_dateToData($("#auc_dt").val());
                     data['sra_mwmnnm']       = $("#sra_mwmnnm").val();
                     fn_CallMwmnnmNoPopup(data,true,function(result){
                         if(result){
                             $("#trmn_amnno").val(result.TRMN_AMNNO);
                             $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
                             $("#sra_mwmnnm").val(result.SRA_MWMNNM);
                         }
                     });
                }
            }
        });         
         
         $("#pb_searchMwmn").on('click',function(e){
             e.preventDefault();
             this.blur();
                var data = new Object();                
                data['auc_dt']           = fn_dateToData($("#auc_dt").val());   
                data['auc_obj_dsc']      = $("#cb_auc_obj_dsc").val();                  
                fn_CallMwmnnmNoPopup(data,false,function(result){
                    if(result){
                        $("#trmn_amnno").val(result.TRMN_AMNNO);
                        $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
                        $("#sra_mwmnnm").val(result.SRA_MWMNNM);
                    }
                });
         }); 
    	
        fn_Init();      
        
        //프로그램ID 대문자 변환
        $("#de_pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
        });
        
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
        fn_InitFrm('frm_Search');
        fn_DisableFrm('frm_Search', false);
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        
        // 경매대상 초기화면 '송아지' 설정(세종공주: 8808990656588 경주: 8808990659008)
        if(na_bzplc == "8808990656588" || na_bzplc == "8808990659008") {
        	$("#cb_auc_obj_dsc").val("0");        
        } else {
        	$("#cb_auc_obj_dsc").val("1");
        }
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        
        if($('#trmn_amnno').val() =='' || $('#lvst_auc_ptc_mn_no').val() =='' || $('#sra_mwmnnm').val() ==''){
        	MessagePopup('OK','응찰자를 입력하세요.',function(){$('#sra_mwmnnm').focus();});
        	return;
        }
        
    	var results = sendAjaxFrm("frm_Search", "/LALM0313_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        mv_RunMode = 2;
        fn_CreateGrid(result);
        fn_DisableFrm('frm_Search', true);
                
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 
    	 MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
             if(res){
            	 gridSaveRow("mainGrid");
            	 var tmpSaveObject = $.grep($("#mainGrid").jqGrid('getRowData'), function(obj){
            		return obj._STATUS_ == "*";
            	 });
                 
                 if(tmpSaveObject.length > 0) {
                     var srchData      = new Object();
                     var result        = null;
                     
				    var insDataObj = new Object();
				    insDataObj['data'] = tmpSaveObject;                     
                             
                     result = sendAjax(insDataObj, "/LALM0313_insList", "POST");
                     
                     if(result.status == RETURN_SUCCESS){
                         MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                        	 fn_Search();
                         });
                     }else {
                         showErrorMessage(result);
                         return;
                     } 
                 } else {
                     MessagePopup("OK", "변경된 내역이 없습니다.");
                     return;
                 }
                 
                    
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });          	 
    	 

//          gridSaveRow("mainGrid");
		 
//  		var insData  = $("#mainGrid").getRowData();
// 	    var insDataObj = new Object();
// 	    var icnt = 0;
// 	    insDataObj['data'] = insData;
 		
// 	    $.each(insData, function(i){	 
// 	        if(insData[i]._STATUS_ == '*'){
// 	        	icnt++;
// 	    	}
// 	    });	   
// 	    if(icnt < 1){
// 	    	MessagePopup("OK", "변경된 내역이 없습니다.");
// 	    	return
// 	    } else {    		
// 		    var results = sendAjax(insDataObj, "/LALM0313_insList", "POST");
			
// 		    if(results.status != RETURN_SUCCESS){
// 	            showErrorMessage(results);
// 	            return;
// 	        }
// 	    }

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
	        
	        var searchResultColNames = ["", "경매대상", "경매번호", "귀표번호", "생년월일", "성별", "KPN", "계대", "산차", "어미귀표번호", "어미구분", "중량", "응찰하한가", "코드", "번호", "성명",
	         "입찰가", "경매일자", "원표번호"];      
	        var searchResultColModel = [	
	        							{name:"_STATUS_",                 index:"_STATUS_",                  width:5,  align:'center'},
	            						{name:"AUC_OBJ_DSC",              index:"AUC_OBJ_DSC",               width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
							            {name:"AUC_PRG_SQ",               index:"AUC_PRG_SQ",                width:30, align:'center'},
							            {name:"SRA_INDV_AMNNO",           index:"SRA_INDV_AMNNO",            width:50, align:'center'},
							            {name:"BIRTH",                    index:"BIRTH",                     width:30, align:'center'},
							            {name:"INDV_SEX_C",               index:"INDV_SEX_C",                width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
							            {name:"KPN_NO",                   index:"KPN_NO",                    width:30, align:'center'},
							            {name:"SRA_INDV_PASG_QCN",        index:"SRA_INDV_PASG_QCN",         width:30, align:'center'},
							            {name:"MATIME",                   index:"MATIME",                    width:30, align:'center'},
							            {name:"MCOW_SRA_INDV_AMNNO",      index:"MCOW_SRA_INDV_AMNNO",       width:50, align:'center'},
							            {name:"MCOW_DSC",                 index:"MCOW_DSC",                  width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
							            {name:"COW_SOG_WT",               index:"COW_SOG_WT",                width:30, align:'center'},
							            {name:"LOWS_SBID_LMT_AM_EX",      index:"LOWS_SBID_LMT_AM_EX",       width:30, align:'center'},
							            {name:"TRMN_AMNNO",               index:"TRMN_AMNNO",                width:35, align:'center'},
							            {name:"LVST_AUC_PTC_MN_NO",       index:"LVST_AUC_PTC_MN_NO",        width:30, align:'center'},
							            {name:"SRA_MWMNNM",               index:"SRA_MWMNNM",                width:45, align:'center'},
//						                {name:"POPSCH",                   index:"POPSCH",                    width:15, align:'center', sortable: false, formatter :gridCboxFormat },							            
// 							            {name:"ATDR_AM",                  index:"ATDR_AM",                   width:35, align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
// 	                                    	 editoptions:{
// 	                                             dataInit:function(e){$(e).addClass('number');},
// 	                                             maxlength:"4"	                                             
// 	                                          }
						                
//							            },   
// 							            {name:"ATDR_AM",                  index:"ATDR_AM",                   width:45, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
 	                                    {name:"ATDR_AM",                  index:"ATDR_AM",          width:50,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
 	                                    	 editoptions:{
 	                                             dataInit:function(e){$(e).addClass('grid_number');},
 	                                             maxlength:"5"
 	                                             
 	                                          }
 	                                     }, 							            
							            {name:"AUC_DT",                   index:"AUC_DT",                    width:30,  align:'center', hidden:true},
							            {name:"OSLP_NO",                  index:"OSLP_NO",                   width:30,  align:'center', hidden:true},
	    								];

	        $("#mainGrid").jqGrid("GridUnload");
	                
	        $("#mainGrid").jqGrid({
				datatype:    "local",
				data:        data,
				height:      520,
				rowNum:      rowNoValue,
	            cellEdit:    true,				
				resizeing:   true,
				autowidth:   true,
				shrinkToFit: false,
				rownumbers:  true,
				rownumWidth: 10,
	            cellsubmit:  "clientArray",
	            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  
	            	
// 	            	$("#mainGrid").jqGrid("setCell", rowid, 'ATDR_AM', '');
	            	
                	$("#"+rowid+"_"+cellname).on('blur',function(e){
                		$("#mainGrid").jqGrid("saveCell", iRow, iCol);
                		
                		if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                            return;
                        }else {
                            if($(this).val() != value){
                                $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                            }
                        }
                	}).on('keydown',function(e){
                		var code = e.keyCode || e.which;
                        if(code == 13 && cellname == 'ATDR_AM'){
                        	e.preventDefault();
                        	$("#mainGrid").jqGrid("saveCell", iRow, iCol);
                            
                            if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                                return;
                            }else {                          	
                                if($(this).val() != value){
                                    $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                                }
                            }
                            var reccnt = $("#mainGrid").getGridParam("reccount");
                            if(reccnt > iRow){
                            	setTimeout("$('#mainGrid').editCell(" + (iRow + 1) + "," + iCol + ", true);", 100);
                            }
                        }                        
                    });

	                    
	                                 
	            },				
				colNames: searchResultColNames,
				colModel: searchResultColModel,	            
 	        });

	      $("#mainGrid").jqGrid("setGroupHeaders", {
	      useColSpanStyle:true,
	      groupHeaders:[
	    	{startColumnName:"TRMN_AMNNO", numberOfColumns: 4, titleText: '중도매인(참가번호)'}]
	     }); 
	      //행번호
	      $("#mainGrid").jqGrid("setLabel", "rn","No"); 	      
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	function gridCboxFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<button class="tb_btn srch" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch(\'' + gid + '\',\'' + rowid + '\',\'' + colkey + '\')";return false;"><i class="fa fa-search"></i></button>';
	} 
    

    function fn_popSearch(gid, rowid, colkey){

	  	var sel_data  = $("#mainGrid").jqGrid("getRowData", rowid);
	  	var sub_data  = new Object();  
	
	    /******************************
	     * 중도매인검색 팝업
	     ******************************/
   	    var data = new Object();          	    
        data['auc_dt']           = $("#auc_dt").val();   
        data['auc_obj_dsc']      = $("#cb_auc_obj_dsc").val();
               
  	    fn_CallMwmnnmNoPopup(data,false,function(result){
         	if(result){
         		$("#mainGrid").jqGrid("setCell", rowid, 14, result.TRMN_AMNNO);
  	            $("#mainGrid").jqGrid("setCell", rowid, 15, result.LVST_AUC_PTC_MN_NO); 
  	            $("#mainGrid").jqGrid("setCell", rowid, 16, result.SRA_MWMNNM);  

         		$("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);
         	}
         });
//   	   var v_trmn_amnno = sub_data.TRMN_AMNNO.val();
// 	   var v_selrow = $("#mainGrid").getGridParam('selrow');
// 	   fn_GridPpgcowFeeDscChange(v_selrow, v_trmn_amnno);
	}   
    
	function gridTextFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<input class="number" style="margin-right:1px;" type="text" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onkeydown="fn_onKeyDown(\'' + gid + '\',\'' + rowid + '\',\'' + colkey + '\')"  />';
	}    
    
    function fn_onKeyDown(gid, rowid, colkey){
    	console.log($("#mainGrid").jqGrid("getRowData", rowid).ATDR_AM);
    	$("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);	  	
	}     
        
</script>
<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">                            
                          
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="cb_auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
                                <th scope="row">응찰자코드/참가번호/응찰자</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:60px;">
                                             <input disabled="disabled" type="text" id="trmn_amnno">                                             
                                         </div>
                                         <div class="cell pl3" style="width:100px;">
                                             <input disabled="disabled" type="text" id="lvst_auc_ptc_mn_no">                                             
                                         </div>    
                                         <div class="cell pl3" style="width:10px;">
                                             <button id="pb_searchMwmn" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                         <div class="cell pl3">
                                             <input enabled="enabled" type="text" id="sra_mwmnnm">                                             
                                         </div>                                                                              
                                     </div>
                                </td>                                 
                                
                                                            
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v">
                <table id="mainGrid" style="width:1807px;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>