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
 * 2. 파  일  명   : LALM0516
 * 3. 파일명(한글) : 기간별 경매 참여 내역 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.14   이지호   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     //var na_bzplc = App_na_bzplc;
     var userId = App_userId;
     //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
     var mv_RunMode = 0;
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
         fn_setCodeBox("cb_sel_sts_dsc", "SEL_STS_DSC", 1, true, "전체");         
         
 //        fn_setCodeBox("maco_yn", "MACO_YN", 1, true);        
         fn_Init();      
 
          /******************************
           * 폼변경시 클리어 이벤트
           ******************************/   
          fn_setClearFromFrm("frm_Search","#mainGrid");             

         	
 	         /******************************
 	          * 농가검색 팝업/ 중도매인검색
 	          ******************************/
 	         $("#ftsnm").on("keydown", function(e){
 	             if(e.keyCode == 13){
 	             	if(fn_isNull($("#ftsnm").val())){
 	             		if ($( "input[name='srch_con']:checked" ).val() == '1'){
 	             			MessagePopup('OK','출하주 명을 입력하세요.');
 	                     return;
 	             		} else {
 	             			MessagePopup('OK','중도매인 명을 입력하세요.');
 	             		}
 	                 }else {
 	                 	var data = new Object();
 	                     data['sra_mwmnnm'] = $("#ftsnm").val();
 	                    if ($( "input[name='srch_con']:checked" ).val() == '1'){
	 	                     fn_CallFtsnmPopup(data,true,function(result){
	 	                     	if(result){
	 	                             $("#fhs_id_no").val(result.FHS_ID_NO);
	 	                             $("#ftsnm").val(result.FTSNM);
	 	                     	}
	 	                     });
 	                    } else {
 	                    	fn_CallMwmnnmPopup(data,true,function(result){
		 	                     	if(result){
		 	                             $("#fhs_id_no").val(result.TRMN_AMNNO);
		 	                             $("#ftsnm").val(result.SRA_MWMNNM);
		 	                     	}
		 	                     });  	
 	                    }
 	                 }
 	              }else if(e.keyCode != 13){
 	             	 $("#fhs_id_no").val('');
 	              }
 	         }); 
 	         
 	         $("#pb_searchFhs").on('click',function(e){
 	             e.preventDefault();
 	             this.blur();
 	             if ($( "input[name='srch_con']:checked" ).val() == '1'){
 		            fn_CallFtsnmPopup(null,false,function(result){
 		            	if(result){
 		                    $("#fhs_id_no").val(result.FHS_ID_NO);
 		                    $("#ftsnm").val(result.FTSNM);
 		            	}
 		            });
 	             } else {
 	            	fn_CallMwmnnmPopup(null,false,function(result){
 		            	if(result){
 		                    $("#fhs_id_no").val(result.TRMN_AMNNO);
 		                    $("#ftsnm").val(result.SRA_MWMNNM);
 		            	}
 		            }); 
 	             }
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
    	$( "#auc_st_dt" ).datepicker().datepicker("setDate", fn_getToday());
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
		

 		if ($( "input[name='srch_con']:checked" ).val() == '1'){
 			
 	        var results = sendAjaxFrm("frm_Search", "/LALM0516_selFhsList", "POST");        
 		} else {
 	        var results = sendAjaxFrm("frm_Search", "/LALM0516_selMwmnList", "POST");        
 		}
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

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
   		fn_ExcelDownlad('mainGrid', '기간별 참여자 내역');

    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "기간별 경매 참여내역";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매대상 : ' + $('#cb_auc_obj_dsc option:selected').text()  + ' / 경매일자: '+ $('#auc_st_dt').val() + '~' + $('#auc_ed_dt').val() +' / 진행상태 : ' + $('#cb_sel_sts_dsc').val() + '/ 조합원 : ' + $('#cb_maco_yn').val() + ' / 이름 : '+ $('#ftsnm').val() +']';
    	
    	ReportPopup('LALM0516R',TitleData, 'mainGrid', 'V');
    		
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
        
        	/*                            1              2            3         4           5           6         7      8           9       	 10    */
        	var searchResultColNames = [  "이름"     , "농가코드"   , "식별구분" , "전화번호"   , "휴대번호"  , "주소" , "회원구분", "두수"     , "중량(kg)", "응찰하한가"
                                        , "낙찰단가"  , "낙찰가격"   , "계좌번호" , "수수료"  
                                        ];      
	        var searchResultColModel = [						 
						                {name:"NM",             index:"NM",              width:60, align:'center'},
						                {name:"FHS_ID_NO",      index:"FHS_ID_NO",       width:60, align:'center'},
						                {name:"CUS_RLNO",       index:"CUS_RLNO",        width:60, align:'center'},
						                {name:"OHSE_TELNO",     index:"OHSE_TELNO",      width:60, align:'center'},
						                {name:"CUS_MPNO",       index:"CUS_MPNO",        width:60, align:'center'},
						                {name:"DONG",           index:"DONG",            width:150, align:'left'},
						                {name:"MACO_YN",        index:"MACO_YN",         width:60, align:'center'},
						                {name:"CNT_COW",        index:"CNT_COW",         width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						                {name:"TOT_COW_SOG_WT", index:"TOT_COW_SOG_WT",  width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						                {name:"TOT_LOWS_AM",    index:"TOT_LOWS_AM",     width:60, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						                {name:"TOT_UPR_AM",     index:"TOT_UPR_AM",      width:60, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						                {name:"TOT_SRA_AM",     index:"TOT_SRA_AM",      width:60, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						                {name:"SRA_FARM_ACNO",  index:"SRA_FARM_ACNO",   width:60, align:'center'},
						                {name:"SRA_SEL_FEE",    index:"SRA_SEL_FEE",     width:60, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
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
        
        //\출하자일경우 농가코드보여주고 수수료는 숨김, 중도매인은 농가코드 숨김 수수료 보여줌
        if ($( "input[name='srch_con']:checked" ).val() == '1'){
            $("#mainGrid").jqGrid("hideCol","SRA_SEL_FEE");
            $("#mainGrid").jqGrid("showCol","FHS_ID_NO");
        }else {
            $("#mainGrid").jqGrid("showCol","SRA_SEL_FEE");
            $("#mainGrid").jqGrid("hideCol","FHS_ID_NO");
        }        
        
 
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No"); 
        //footer        
        var gridDatatemp = $('#mainGrid').getRowData();
        
        //합 
        var tot_cnt_cow	         = 0;
        var tot_tot_cow_sog_wt   = 0; 
        var tot_tot_lows_am      = 0; 
        var tot_tot_upr_am       = 0; 
        var tot_tot_sra_am       = 0;  
            
        $.each(gridDatatemp,function(i){
        	//합계
            tot_cnt_cow	        += parseInt(gridDatatemp[i].CNT_COW);   
            tot_tot_cow_sog_wt  += parseInt(gridDatatemp[i].TOT_COW_SOG_WT);
            tot_tot_lows_am     += parseInt(gridDatatemp[i].TOT_LOWS_AM)
            tot_tot_upr_am      += parseInt(gridDatatemp[i].TOT_UPR_AM);
            tot_tot_sra_am      += parseInt(gridDatatemp[i].TOT_SRA_AM);
        }); 
        
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["NM"                    ,"합 계"                  ,1 ,"String" ]
                      ,["CNT_COW"	            ,tot_cnt_cow	         ,1 ,"Integer"] 
                      ,["TOT_COW_SOG_WT"        ,tot_tot_cow_sog_wt      ,1 ,"Integer"] 
                      ,["TOT_LOWS_AM"           ,tot_tot_lows_am         ,1 ,"Integer"] 
                      ,["TOT_UPR_AM"            ,tot_tot_upr_am          ,1 ,"Integer"] 
                      ,["TOT_SRA_AM"            ,tot_tot_sra_am          ,1 ,"Integer"] 
		           ] 
         ];
  
         fn_setGridFooter('mainGrid', arr);         
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    // 버튼클릭 이벤트
    $(document).ready(function() {
    	
    	//경매마감 버튼클릭 이벤트
    	$(document).on("click", "button[name='btn_Ddl']", function() {
    		event.preventDefault();
    		fn_SaveDdl();
        });
    	   	
    });
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 종료
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
                            <col width="100"> 
                            <col width="60">     
                            <col width="100">   
                            <col width="150">                                                                                                                                                          
                            <col width="40"> 
                            <col width="40">
                            <col width="200">
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
                                <th scope="row">진행상태</th>
                                <td>
                                    <select id="cb_sel_sts_dsc"></select>
                                </td>   
                                <th scope="row">조합원</th>
                                <td>
                                    <select id="cb_maco_yn">
                                    	<option value="">전체</option>
                                    	<option value="0">비조합원</option>
                                    	<option value="1">조합원</option>
                                    </select>
                                </td>
                                <td id="radio" class="radio" colspan='2'>
                                    <input type="radio" name="srch_con" id="cb_fhs"  value="1"><label for="cb_fhs">출하자</label>
                                    <input type="radio" name="srch_con" id="cb_mmwn" value="2"><label for="cb_mmwn">중도매인</label>
                                </td>   
                                <th scope="row">이름</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:250px;">
                                             <input disabled="disabled" type="text" id="fhs_id_no">                                             
                                         </div>
                                         <div class="cell pl2" style="width:350px;">
                                             <input type="text" id="ftsnm">
                                         </div>
                                         <div class="cell pl2">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
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