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
 * 2. 파  일  명   : LALM0115
 * 3. 파일명(한글) : 실시간 조회
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
     var setRowStatus = "";
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);       
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
    	        
        var results = sendAjaxFrm("frm_Search", "/LALM0115_selList", "POST");        
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
   		fn_ExcelDownlad('mainGrid', '수송자관리');

    }   
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "수송자 조회";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[수송자명 : ' + $('#vhc_drv_caffnm').val() +']';
    	
    	ReportPopup('LALM0115R',TitleData, 'mainGrid', 'V');
    		
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
        	var searchResultColNames = ["차량<br>단축코드", "경제통합<br>거래처코드", "차주명", "수송자<br>전화번호", "차량번호", "수송자명", "차량<br>구분코드", "차주<br>자택전화번호", "차주<br>휴대전화번호", "적재중량", "차량톤수", "적재가능용적", "차종코드", "수송<br>여부", "방역일자", "교육이수<br>여부"];        
	        var searchResultColModel = [						 
						                {name:"VHC_SHRT_C",        index:"VHC_SHRT_C",           width:30, align:'center'},
						                {name:"NA_TRPL_C",         index:"NA_TRPL_C",            width:50, align:'center'},
						                {name:"VHC_DRV_CAFFNM",    index:"VHC_DRV_CAFFNM",       width:30, align:'center'},
						                {name:"DRV_CAFF_TELNO",    index:"DRV_CAFF_TELNO",       width:40, align:'center'},
						                {name:"VHCNO",             index:"VHCNO",                width:40, align:'center'},
						                {name:"BRWRNM",            index:"BRWRNM",               width:40, align:'center'},
						                {name:"VHC_DSC",           index:"VHC_DSC",              width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("VHC_DSC", 1)}},
						                {name:"BRWR_TELNO",        index:"BRWR_TELNO",           width:40, align:'center'},
						                {name:"BRWR_MPNO",         index:"BRWR_MPNO",            width:40, align:'center'},
						                {name:"SRA_LOAD_WT",       index:"SRA_LOAD_WT",          width:30, align:'right', formatter:'number', formatoptions:{decimalPlaces:3,thousandsSeparator:','}},
						                {name:"SRA_VHC_TNCN",      index:"SRA_VHC_TNCN",         width:30, align:'right', formatter:'number', formatoptions:{decimalPlaces:3,thousandsSeparator:','}},
						                {name:"SRA_LOAD_PSB_BULK", index:"SRA_LOAD_PSB_BULK",    width:30, align:'right', formatter:'number', formatoptions:{decimalPlaces:3,thousandsSeparator:','}},
						                {name:"CARTP_C",           index:"CARTP_C",              width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("CARTP_C", 1)}},
						                {name:"LVST_TRPT_YN",      index:"LVST_TRPT_YN",         width:30, align:'center'},
						                {name:"PVEP_DT",           index:"PVEP_DT",              width:30, align:'center'},
						                {name:"EDU_CPL_YN",        index:"EDU_CPL_YN",           width:30, align:'center'}        
	                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
        
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: true, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
        });
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No");          
        
//        $("#mainGrid").jqGrid("setGroupHeaders", {
//            useColSpanStyle:true,
//            groupHeaders:[
//          	{startColumnName:"차주명", numberOfColumns: 3, titleText: 'aaaa'}]
//           });
        
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
                            <col width="80">
                            <col width="*">
                            <col width="800">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">수송자명</th>
                                <td>
                                    <div class="cellBox">
                                        <input type="text" id="vhc_drv_caffnm">
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