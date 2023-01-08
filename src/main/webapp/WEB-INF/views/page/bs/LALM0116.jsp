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
 * 2. 파  일  명   : LALM0116
 * 3. 파일명(한글) : KPN 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.27   이지호   최초작성
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
     var userId = App_userId
     //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
     var mv_RunMode = 0;
     var setRowStatus = "";
     
     $(document).ready(function(){
    	   
         fn_Init();      
        
         /******************************
          * 폼변경시 클리어 이벤트
          ******************************/   
         fn_setClearFromFrm("frm_Search","#mainGrid");            
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
        if(mv_RunMode == 0 || mv_RunMode == 1) {
        	fn_InitFrm('frm_Search');
        }     
        
        setRowStatus = "";              
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	        
        var results = sendAjaxFrm("frm_Search", "/LALM0116_selList", "POST");        
        var result;
        
     	//그리드 초기화
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
   		fn_ExcelDownlad('mainGrid', 'KPN관리');

    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "KPN 조회";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[KPN조회 : ' + $('#kpn_no').val() +']';
    	
    	ReportPopup('LALM0116R',TitleData, 'mainGrid', 'V');
    		
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
        
        	/*                               1                  2               3            4            5          6             7               8        		   9     		 10     	11     	 12          13         14           15         16*/
        	var searchResultColNames = ["KPN", "등급", "생년월일", "냉도체중(kg)", "배최장근면적", "근내지방도", "거래단가", "비고내용"];        
	        var searchResultColModel = [						 
						                {name:"KPN_NO",       		 index:"KPN_NO",           	  width:30, align:'center'},
						                {name:"GRD",        		 index:"GRD",            	  width:30, align:'center'},
						                {name:"BIRTH",    			 index:"BIRTH",      		  width:30, align:'center'},
						                {name:"SRA_WGH",    		 index:"SRA_WGH",      		  width:30, align:'right'},
						                {name:"PEAR_LONS_MSCL_AREA", index:"PEAR_LONS_MSCL_AREA", width:30, align:'right'},
						                {name:"MCIN_GRSDR",          index:"MCIN_GRSDR",          width:30, align:'right'},
						                {name:"SRA_TR_UPR",          index:"SRA_TR_UPR",          width:30, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"RMK_CNTN",        	 index:"RMK_CNTN",            width:100, align:'left'}       
	                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
        
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 1,    
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
	      //행번호
	      $("#mainGrid").jqGrid("setLabel", "rn","No"); 	
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 시작
    ////////////////////////////////////////////////////////////////////////////////

    
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
                            <col width="50">
								<col width="250">
								<col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">KPN</th>
                                <td>
                                    <input type="text" id="kpn_no">
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