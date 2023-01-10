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
 * 2. 파  일  명   : LALM0220
 * 3. 파일명(한글) : 수송내역 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.11   이지호   최초작성
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
         
         fn_Init();  
         
         /******************************
          * 폼변경시 클리어 이벤트
          ******************************/   
         fn_setClearFromFrm("frm_Search","#mainGrid");              
         
         /******************************
          * 중도매인검색 팝업
          ******************************/
         $("#vhc_drv_caffnm").keypress(function(e){        	
             if(e.keyCode == 13){
             	if(fn_isNull($("#vhc_drv_caffnm").val())){
             		MessagePopup('OK','수송자 명을 입력하세요.');
                 }else {
                 	var data = new Object();
                 	
                    data['vhc_drv_caffnm']      = $("#vhc_drv_caffnm").val();
                    
                    fn_CallCaffnmPopup(data,true,function(result){
	                     	if(result){
	                             $("#vhc_shrt_c").val(result.VHC_SHRT_C);
	                             $("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);
	                     	}
	                     }); 
                 }
              }else {
             	 $("#vhc_drv_caffnm").val('');
              }
         }); 
         
         $("#pb_searchMwmn").on('click',function(e){
             e.preventDefault();
             this.blur();
          	    var data = new Object();          	    
                data['vhc_drv_caffnm']           = $("#vhc_drv_caffnm").val();   
                fn_CallCaffnmPopup(data,false,function(result){
	            	if(result){
	            		$("#vhc_shrt_c").val(result.VHC_SHRT_C);
	            		$("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);	
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
                
        
        $( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());
        
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
		if(!fn_isDate($( "#auc_dt" ).val())){
			MessagePopup('OK','경매시작일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}        
        var results = sendAjaxFrm("frm_Search", "/LALM0220_selList", "POST");        
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
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "경매시장 수송내역";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    	
    	ReportPopup('LALM0220R0',TitleData, 'mainGrid', 'V'); 
   
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
   		fn_ExcelDownlad('mainGrid', '수송내역조회');

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
        
        	/*                           ㅖ 1       2         3 }수송자그룹     ( 4     5         6          7         8         9)축주그룹   */
        	var searchResultColNames = ["성명", "수송자전화번호", "차주휴대폰번호", "성명", "주소", "휴대폰번호", "집전화번호", "경매대상", "귀표번호", "성별", "경매순번", "체중(kg)", "축주비고", "출장우내역비고","출하자코드"];        
	        var searchResultColModel = [						 
						                {name:"VHC_DRV_CAFFNM",  index:"VHC_DRV_CAFFNM",     width:40, align:'center'},
						                {name:"DRV_CAFF_TELNO",  index:"DRV_CAFF_TELNO",     width:60, align:'center'},
						                {name:"BRWR_MPNO",       index:"BRWR_MPNO",          width:60, align:'center'},
						                {name:"FTSNM",   		 index:"FTSNM",      		 width:40, align:'center'},
						                {name:"ADR",             index:"ADR",                width:120, align:'left'},
						                {name:"CUS_MPNO",        index:"CUS_MPNO",           width:60, align:'center'},
						                {name:"OHSE_TELNO",      index:"OHSE_TELNO",         width:60, align:'center'},
						                {name:"AUC_OBJ_DSC",     index:"AUC_OBJ_DSC",        width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						                {name:"SRA_INDV_AMNNO",  index:"SRA_INDV_AMNNO",     width:80, align:'center'},
						                {name:"INDV_SEX_C",      index:"INDV_SEX_C",         width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						                {name:"AUC_PRG_SQ",      index:"AUC_PRG_SQ",         width:40, align:'center'},
						                {name:"COW_SOG_WT",      index:"COW_SOG_WT",         width:50, align:'right'},
						                {name:"RMK_CNTN",        index:"RMK_CNTN",           width:70, align:'left'},
						                {name:"RMK_CNTN2",       index:"RMK_CNTN2",          width:70, align:'left'},							                
						                {name:"FHS_ID_NO",       index:"FHS_ID_NO",          width:70, align:'left'}							                
						                ];
           
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
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

      $("#mainGrid").jqGrid("setGroupHeaders", {
      useColSpanStyle:true,
      groupHeaders:[
    	{startColumnName:"VHC_DRV_CAFFNM", numberOfColumns: 3, titleText: '수송자'},
    	{startColumnName:"FTSNM", numberOfColumns: 9, titleText: '축주'}]
     }); 
      
      //행번호
      $("#mainGrid").jqGrid("setLabel", "rn","No"); 
      //footer        
      var gridDatatemp = $('#mainGrid').getRowData();
      
      //합 
      var tot_cnt_cow	         = 0;
      
      $.each(gridDatatemp,function(i){
      	//합계
    	  tot_cnt_cow++;
      }); 
      
      var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                     ["VHC_DRV_CAFFNM"        ,"총 두 수"                ,1 ,"String" ]
                    ,["DRV_CAFF_TELNO"	      ,tot_cnt_cow	           ,1 ,"Integer"] 
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
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="50">
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
                                <th scope="row">수송자</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:100px;" >
                                             <input disabled="disabled" type="text" id="vhc_shrt_c">                                             
                                         </div>                                                                              
                                         <div class="cell pl3" style="width:28px;">
                                             <button id="pb_searchMwmn" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                         <div class="cell">
                                             <input enabled="enabled" type="text" id="vhc_drv_caffnm">                                             
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