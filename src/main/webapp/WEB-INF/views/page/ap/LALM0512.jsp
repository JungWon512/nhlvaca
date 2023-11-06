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
 * 2. 파  일  명   : LALM0512
 * 3. 파일명(한글) : 경매낙찰내역 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.13   이지호   최초작성
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
     var userId = App_userId;
     //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
     var mv_RunMode = 0;
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
 //        fn_setCodeBox("maco_yn", "MACO_YN", 1, true);
         
         fn_Init(); 
         
         /******************************
          * 폼변경시 클리어 이벤트
          ******************************/   
         fn_setClearFromFrm("frm_Search","#mainGrid"); 
         
         
         /******************************
          * 중도매인검색 팝업
          ******************************/
         $("#v_sra_mwmnnm").on("keydown", function(e){     	
             if(e.keyCode == 13){
             	if(fn_isNull($("#v_sra_mwmnnm").val())){
             		MessagePopup('OK','중도매인 명을 입력하세요.');
                 }else {
                 	var data = new Object();
                    data['sra_mwmnnm'] = $("#v_sra_mwmnnm").val();
                   	fn_CallMwmnnmPopup(data,true,function(result){
	                     	if(result){
	                             $("#v_trmn_amnno").val(result.TRMN_AMNNO);
	                             $("#v_sra_mwmnnm").val(result.SRA_MWMNNM);
	                     	}
	                     }); 
                 }
              }else if(e.keyCode != 13){
             	 $("#v_trmn_amnno").val('');
              }
         });         
         
         $("#pb_searchFhs").on('click',function(e){
             e.preventDefault();
             this.blur();
            	fn_CallMwmnnmPopup(null,false,function(result){
	            	if(result){
	                    $("#v_trmn_amnno").val(result.TRMN_AMNNO);
	                    $("#v_sra_mwmnnm").val(result.SRA_MWMNNM);
	            	}
	            });
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
        if(mv_RunMode == 0 || mv_RunMode == 1) {
        	fn_InitFrm('frm_Search');
        }     
        
        setRowStatus = "";
                       
//        $( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());
    	$( "#auc_st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
        $( "#auc_ed_dt" ).datepicker().datepicker("setDate", fn_getToday());        
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
		if(fn_isNull($( "#auc_st_dt" ).val())){
			MessagePopup('OK','경매시작일자를 선택하세요.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}      
		if(!fn_isDate($( "#auc_st_dt" ).val())){
			MessagePopup('OK','경매시작일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}
		if(fn_isNull($( "#auc_ed_dt" ).val())){
			MessagePopup('OK','경매종료일자를 선택하세요.',function(){
				$( "#auc_ed_dt" ).focus();
			});
			return;
		}      
		if(!fn_isDate($( "#auc_ed_dt" ).val())){
			MessagePopup('OK','경매종료일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_ed_dt" ).focus();
			});
			return;
		}      
        var results = sendAjaxFrm("frm_Search", "/LALM0512_selList", "POST");        
        var result;
        
        $("#mainGrid").jqGrid("clearGridData", true);
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        mv_RunMode = 2;
        fn_CreateGrid(result); 
                
    }

  //***************************************
  //* function   : 중도매인 팝업
  //* paramater  : p_param(object), p_flg(단건 리턴여부)
  //* result     : gridRowData
  //***************************************
  function fn_CallMmFhsPopup(p_param,p_flg,callback){
  	var pgid = 'LALM0215P';
  	var menu_id = $("#menu_info").attr("menu_id");
  	
  	if(p_flg){
  		var result;
  		var resultData = sendAjax(p_param, "/LALM0215P_selList", "POST");  
        
  		if(resultData.status != RETURN_SUCCESS){
              showErrorMessage(resultData,'NOTFOUND');
          }else{      
              result = setDecrypt(resultData);
          }
          if(result != null && result.length == 1){
        	    callback(result[0]);
          }else {
        	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
                callback(result);
            });
          }
  	}else {
  		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
  	        callback(result);
  	    });
  	}
  }    
  

  /*------------------------------------------------------------------------------
   * 1. 함 수 명    : 출력 함수
   * 2. 입 력 변 수 : N/A
   * 3. 출 력 변 수 : N/A
   ------------------------------------------------------------------------------*/
  function fn_Print(){
  	var TitleData = new Object();
  	TitleData.title = "경매낙찰내역";
  	TitleData.sub_title = "";
  	TitleData.unit="";
  	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_st_dt').val() + ' ~ ' + $('#auc_ed_dt').val() +']'
   							  +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + '/ 중도매인 : ' + $("#v_sra_mwmnnm").val() + ']';
  	
  	if(na_bzplc != '8808990659008' && na_bzplc != '8808990656236'){   // 경주 : 8808990659008 테스트: 8808990643625
  		ReportPopup('LALM0512R0_1',TitleData, 'mainGrid', 'H');
  	}else{
  		ReportPopup('LALM0512R0',TitleData, 'mainGrid', 'H');
  		
  	}
  	
   }
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
   		fn_ExcelDownlad('mainGrid', '경매낙찰내역');

    } 
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        	/*                            1          2         3        4        5           6            7        8         9        10       11	   12	   13 		14			15      16 */
        	var searchResultColNames = ["중도매인", "중도매인명", "주소", "휴대폰번호", "조합원", "중도매인<br>생년월일", "경매일자", "경매대상", "경매번호", "귀표번호", "성별", "등록번호", "중량", "예정가", "낙찰단가", "낙찰가","H농가식별번호","H농가이름","H실명번호"];        
	        var searchResultColModel = [						 
						                {name:"TRMN_AMNNO",     		index:"TRMN_AMNNO",     		width:30, align:'center'},
						                {name:"SRA_MWMNNM",     		index:"SRA_MWMNNM",     		width:30, align:'center'},
						                {name:"ADR",  					index:"ADR",  					width:100, align:'left'},
										{name:"CUS_MPNO",      			index:"CUS_MPNO",      			width:50, align:'center'},
						                {name:"MACO_YN",				index:"MACO_YN",				width:30, align:'center'},
						                {name:"CUS_RLNO",      			index:"CUS_RLNO",      			width:30, align:'center'},
						                {name:"AUC_DT", 				index:"AUC_DT", 				width:30, align:'center'},
						                {name:"AUC_OBJ_DSC",         	index:"AUC_OBJ_DSC",         	width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						                {name:"AUC_PRG_SQ",             index:"AUC_PRG_SQ",             width:30, align:'center'},
						                {name:"SRA_INDV_AMNNO",         index:"SRA_INDV_AMNNO",         width:60, align:'center'},
						                {name:"INDV_SEX_C",             index:"INDV_SEX_C",             width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						                {name:"SRA_INDV_BRDSRA_RG_NO",  index:"SRA_INDV_BRDSRA_RG_NO",  width:30, align:'center'},
						                {name:"COW_SOG_WT",             index:"COW_SOG_WT",             width:30, align:'right'},
						                {name:"LOWS_SBID_LMT_AM",       index:"LOWS_SBID_LMT_AM",       width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SBID_UPR",           index:"SRA_SBID_UPR",           width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SBID_AM",            index:"SRA_SBID_AM",            width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:30, align:'right',hidden : true},
						                {name:"FTSNM",            index:"FTSNM",            width:30, align:'right',hidden : true},
						                {name:"FRLNO",            index:"FRLNO",            width:30, align:'right',hidden : true}
						                ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
        });
        
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No"); 
        //footer        
        var gridDatatemp = $('#mainGrid').getRowData();
        //합 
        var tot_cnt_cow	         = 0;
        var tot_tot_sra_am       = 0;  
        
        $.each(gridDatatemp,function(i){
        	//합계
            tot_cnt_cow++;   
            tot_tot_sra_am      += parseInt(gridDatatemp[i].SRA_SBID_AM);
        }); 
        
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["TRMN_AMNNO"            ,"합 계"                  ,1 ,"String" ]
                      ,["AUC_OBJ_DSC"	        ,"건 수"       	         ,1 ,"String"] 
                      ,["AUC_PRG_SQ"            ,tot_cnt_cow             ,1 ,"Integer"] 
                      ,["SRA_SBID_AM"           ,tot_tot_sra_am          ,1 ,"Integer"] 
		           ] 
         ];
  
         fn_setGridFooter('mainGrid', arr);   
         
         //소계 추가
         
             // View Grid
             var data3 = new Array();
             var dataItem = new Object();
             var I_TRMN_AMNNO            = "";
             var l_SRA_SBID_UPR          = 0;
             var l_SRA_SBID_AM           = 0;

             if(data != null){
             $.each(data, function(i){
                 if(i != 0 && I_TRMN_AMNNO != data[i].TRMN_AMNNO) {
                     dataItem = new Object();
                     dataItem['TRMN_AMNNO']   = "소계";
                     dataItem['SRA_SBID_UPR'] = l_SRA_SBID_UPR;
                     dataItem['SRA_SBID_AM']  = l_SRA_SBID_AM;
                     
                     I_TRMN_AMNNO            = "";
                     l_SRA_SBID_UPR            = 0;
                     l_SRA_SBID_AM             = 0;
                     
                     data3.push(dataItem);
                 }
                 
                 data3.push(data[i]);
                 I_TRMN_AMNNO    = data[i].TRMN_AMNNO;
                 l_SRA_SBID_UPR  = parseInt(l_SRA_SBID_UPR) + parseInt(data[i].SRA_SBID_UPR);
                 l_SRA_SBID_AM   = parseInt(l_SRA_SBID_AM) + parseInt(data[i].SRA_SBID_AM);
                 
             });
             
             dataItem = new Object();
             dataItem['TRMN_AMNNO']      = "소계";
             dataItem['SRA_SBID_UPR']    = l_SRA_SBID_UPR;
             dataItem['SRA_SBID_AM']     = l_SRA_SBID_AM;
             data3.push(dataItem);
             
             }
             
             var rowNoValue3 = 0;     
             if(data3 != null){
                 rowNoValue3 = data3.length;
             }
             
             //
             /*                            1          2         3        4        5           6            7        8         9        10       11     12      13       14          15      16 */
             var searchResultColNames = ["중도매인", "중도매인명", "주소", "휴대폰번호", "조합원", "중도매인<br>생년월일", "경매일자", "경매대상", "경매번호", "귀표번호", "성별", "등록번호", "중량", "예정가", "낙찰단가", "낙찰가","H농가식별번호","H농가이름","H실명번호"];        
             var searchResultColModel = [                         
                                         {name:"TRMN_AMNNO",             index:"TRMN_AMNNO",             width:30, align:'center'},
                                         {name:"SRA_MWMNNM",             index:"SRA_MWMNNM",             width:30, align:'center'},
                                         {name:"ADR",                    index:"ADR",                    width:100, align:'left'},
                                         {name:"CUS_MPNO",               index:"CUS_MPNO",               width:50, align:'center'},
                                         {name:"MACO_YN",                index:"MACO_YN",                width:30, align:'center'},
                                         {name:"CUS_RLNO",               index:"CUS_RLNO",               width:30, align:'center'},
                                         {name:"AUC_DT",                 index:"AUC_DT",                 width:30, align:'center'},
                                         {name:"AUC_OBJ_DSC",            index:"AUC_OBJ_DSC",            width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                         {name:"AUC_PRG_SQ",             index:"AUC_PRG_SQ",             width:30, align:'center'},
                                         {name:"SRA_INDV_AMNNO",         index:"SRA_INDV_AMNNO",         width:60, align:'center'},
                                         {name:"INDV_SEX_C",             index:"INDV_SEX_C",             width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                         {name:"SRA_INDV_BRDSRA_RG_NO",  index:"SRA_INDV_BRDSRA_RG_NO",  width:30, align:'center'},
                                         {name:"COW_SOG_WT",             index:"COW_SOG_WT",             width:30, align:'right'},
                                         {name:"LOWS_SBID_LMT_AM",       index:"LOWS_SBID_LMT_AM",       width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                         {name:"SRA_SBID_UPR",           index:"SRA_SBID_UPR",           width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                         {name:"SRA_SBID_AM",            index:"SRA_SBID_AM",            width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                         {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:30, align:'right',hidden : true},
                                         {name:"FTSNM",            index:"FTSNM",            width:30, align:'right',hidden : true},
                                         {name:"FRLNO",            index:"FRLNO",            width:30, align:'right',hidden : true}
                                         ];
             
         $("#mainGrid_1").jqGrid("GridUnload");
                 
         $("#mainGrid_1").jqGrid({
             datatype:    "local",
             data:        data3,
             height:      500,
             rowNum:      rowNoValue3,
             resizeing:   true,
             autowidth:   false,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             footerrow: true,
             userDataOnFooter: true,
             colNames: searchResultColNames,
             colModel: searchResultColModel, 
             gridComplete:function(rowid,status, e){
                 var rows = $("#mainGrid_1").getDataIDs();
                 for(var i = 0; i < rows.length; i++) {
                     var status = $("#mainGrid_1").getCell(rows[i], "TRMN_AMNNO");
                     if(status == "소계") {
                         $("#mainGrid_1").jqGrid("setRowData", rows[i], false, {background:"skyblue"});
                     }
                 }
              },
         });
         
         //행번호
         $("#mainGrid_1").jqGrid("setLabel", "rn","No"); 
         //footer        
         var gridDatatemp = $('#mainGrid_1').getRowData();
         //합 
         var tot_cnt_cow          = 0;
         var tot_tot_sra_am       = 0;  
         
         $.each(gridDatatemp ,function(i){
             //합계
             var status = gridDatatemp[i].TRMN_AMNNO;
             if(status != "소계") {
                 tot_cnt_cow++;   
                 tot_tot_sra_am += parseInt(gridDatatemp[i].SRA_SBID_AM);
             }
         }); 
         
         var arr = [
                    [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                        ["TRMN_AMNNO"            ,"합 계"                  ,1 ,"String" ]
                       ,["AUC_OBJ_DSC"           ,"건 수"                   ,1 ,"String"] 
                       ,["AUC_PRG_SQ"            ,tot_cnt_cow             ,1 ,"Integer"] 
                       ,["SRA_SBID_AM"           ,tot_tot_sra_am          ,1 ,"Integer"] 
                    ] 
          ];
   
          fn_setGridFooter('mainGrid_1', arr);                
             
         }
    
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
  
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
                            <col width="70">
                            <col width="150">
                            <col width="70">
                            <col width="250">                          
                            <col width="70">     
                            <col width="220"> 
                            <col width="60">     
                            <col width="150">  
                            <col width="70">     
                            <col width="150">                                                                                
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
                                        <div class="cell"><input type="text" class="date" id="auc_st_dt"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" class="date" id="auc_ed_dt"></div>
                                    </div>
                                </td>
                                <th scope="row">중도매인</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:60px;">
                                             <input disabled="disabled" type="text" id="v_trmn_amnno">                                             
                                         </div>
                                         <div class="cell pl3" style="width:100px;">
                                             <input enabled="enabled" type="text" id="v_sra_mwmnnm">                                             
                                         </div>                                         
                                         <div class="cell pl3">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                     </div>
                                </td>                                  
                                
                                 <th scope="row">조합원</th>
                                <td>
                                    <select id="v_maco_yn">
                                    	<option value="">전체</option>
                                    	<option value="0">비조합원</option>
                                    	<option value="1">조합원</option>
                                    </select>
                                </td>
                                <th scope="row">관외구분</th>
                                <td>                                
                                    <select id="cb_jrdwo_dsc">
                                    	<option value="">전체</option>
                                    	<option value="1">관내</option>
                                    	<option value="2">관외</option>
                                    </select>
                                </td>
                                <td></td>
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
            <div class="listTable rsp_v" style="display:none">
                <table id="mainGrid" style="width:1807px;">
                </table>
            </div>
            <div class="listTable rsp_v">  
                <table id="mainGrid_1" style="width:1807px;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>