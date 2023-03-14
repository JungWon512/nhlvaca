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
                        <col width="85">
                        <col width="120">
                        <col width="*"> 
                        <col width="*">                        
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">거래처구분</th>
                            <td>
                                <select id="na_trpl_c">
                                    <option value="0">거래처코드</option>
                                    <option value="1">거래처명</option>
                                </select>
                            </td>                               
                            <td>
                                <input type="text" id="clntnm"/>
                            </td>   
                            <td></td>                 
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
        
        <div class="listTable">           
            <table id="grd_BmTrpl">
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
    $(document).ready(function(){
    	
    	//그리드 초기화
        fn_CreateGrid();
    	        
        //프로그램ID 대문자 변환
//         $("#clntnm").bind("keydown", function(e){
//         	if($("#na_trpl_c").val() == '0'){
//                 if(e.key === '.' || e.key === '-' || e.key >= 0 && e.key <= 9){
//                 	return true;
//                 }
//         		return false;
//             }else{
            	
//             }
//         });
        
        
        $("#na_trpl_c").bind('change',function(e){
            e.preventDefault();
        });
        
       	// enter로 조회
		$('#clntnm').on('keydown',function(e){
			if(e.keyCode==13){
				 fn_Search();
		    	return;
			}
		});
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmTrpl");       
            
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_BmTrpl").jqGrid("clearGridData", true);
         //폼 초기화
         fn_InitFrm('frm_Search');
         
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){   
      	 if(fn_isNull( $('#clntnm').val() )){
 			MessagePopup('OK', '검색정보를 입력해주세요.', function(){
		 				$( "#clntnm" ).focus();
		 			});
		 			return;
		 	 }
    	     	 
        //정합성체크
        var srchData = new Object();
        
        srchData["ctgrm_cd"]  = "2600";
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["na_trpl_c"] = $("#na_trpl_c").val();
        srchData["clntnm"]    = $("#clntnm").val();
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
     	//그리드 초기화
     	$("#grd_BmTrpl").jqGrid("clearGridData", true); 
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
                
        fn_CreateGrid(result);                 
    } 
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){     
        var sel_rowid = $("#grd_BmTrpl").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_BmTrpl").jqGrid("getRowData", sel_rowid);
        
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
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
        
        var searchResultColNames = ["거래처코드","경제통합거래처구분코드","중앙회조합구분코드","거래처명","고객실명번호"
						        	,"거래처약어명","경제통합본지사구분코드","상위경제통합거래처코드","앞자리우편번호","뒷자리우편번호"
						        	,"우편번호일련번호","동이상<br>주소","동이하<br>주소","경제통합지역코드","전화국가번호"
						        	,"지역번호","국가번호","일련번호","전화번호","팩스지역번호","팩스국번호"
						        	,"팩스일련번호","휴대전화서비스번호","휴대전화국번호","휴대전화일련번호","조합원여부"
						        	,"농기계부품취급여부","경제통합사업장세무신고형태코드","표준업체코드","표준업체코드일련번호","경제통합사용자시스템종류코드"
						        	,"전자세금계산서사용여부","경제통합거래처적용여부","경제통합거래처적용일자","거래중지<br>여부","거래중지사유코드"
						        	,"거래중지일자","비고내용","최초등록일시","최초등록자개인번호","최초등록자경제통합사업장코드"
						        	,"최종변경일시","최종변경자개인번호","최종변경자경제통합사업장코드","거래처상세유형코드","토요영업여부"
						        	,"경제통합고객번호","경제통합대표고객번호","삭제여부"
        	                       ];        
        var searchResultColModel = [
						        	{name:"NA_TRPL_C",               index:"NA_TRPL_C",               width:30,align:"center"},
						        	{name:"NA_TRPL_DSC",             index:"NA_TRPL_DSC",             width:30,align:"center"},
						        	{name:"NAAC_DSC",                index:"NAAC_DSC",                width:30,align:"center"},
						        	{name:"CLNTNM",                  index:"CLNTNM",                  width:30,align:"center"},
						        	{name:"CUS_RLNO",                index:"CUS_RLNO",                width:30,align:"center"},
						        	{name:"NA_TRPL_ABR_NM",          index:"NA_TRPL_ABR_NM",          width:30,align:"center"},
						        	{name:"NA_MBCO_DSC",             index:"NA_MBCO_DSC",             width:30,align:"center"},
						        	{name:"UP_NA_TRPL_C",            index:"UP_NA_TRPL_C",            width:30,align:"center"},
						        	{name:"FZIP",                    index:"FZIP",                    width:30,align:"center"},
						        	{name:"RZIP",                    index:"RZIP",                    width:30,align:"center"},
						        	{name:"ZIP_SQNO",                index:"ZIP_SQNO",                width:30,align:"center"},
						        	{name:"DONGUP",                  index:"DONGUP",                  width:30,align:"center"},
						        	{name:"DONGBW",                  index:"DONGBW",                  width:30,align:"center"},
						        	{name:"NA_RGN_C",                index:"NA_RGN_C",                width:30,align:"center"},
						        	{name:"TEL_NAT_NO",              index:"TEL_NAT_NO",              width:30,align:"center"},
						        	{name:"ATEL",                    index:"ATEL",                    width:20,align:"center"},
						        	{name:"HTEL",                    index:"HTEL",                    width:20,align:"center"},
                                    {name:"STEL",                    index:"STEL",                    width:20,align:"center"},
                                    {name:"TELNO",                   index:"TELNO",                   width:20,align:"center"},
						        	{name:"FAX_RGNO",                index:"FAX_RGNO",                width:30,align:"center"},
						        	{name:"HFAX",                    index:"HFAX",                    width:30,align:"center"},
						        	{name:"FAX_SQNO",                index:"FAX_SQNO",                width:30,align:"center"},
						        	{name:"MPSVNO",                  index:"MPSVNO",                  width:30,align:"center"},
						        	{name:"MPHNO",                   index:"MPHNO",                   width:30,align:"center"},
						        	{name:"MPSQNO",                  index:"MPSQNO",                  width:30,align:"center"},
						        	{name:"MACO_YN",                 index:"MACO_YN",                 width:30,align:"center"},
						        	{name:"FMACH_PATS_TRT_YN",       index:"FMACH_PATS_TRT_YN",       width:30,align:"center"},
						        	{name:"NA_BZPL_TXBZ_RPT_FORM_C", index:"NA_BZPL_TXBZ_RPT_FORM_C", width:30,align:"center"},
						        	{name:"STD_COMP_C",              index:"STD_COMP_C",              width:30,align:"center"},
						        	{name:"STD_COMP_C_SQNO",         index:"STD_COMP_C_SQNO",         width:30,align:"center"},
						        	{name:"NA_USR_SYS_KDC",          index:"NA_USR_SYS_KDC",          width:30,align:"center"},
						        	{name:"ELT_TXBIL_UYN",           index:"ELT_TXBIL_UYN",           width:30,align:"center"},
						        	{name:"NA_TRPL_APL_YN",          index:"NA_TRPL_APL_YN",          width:30,align:"center"},
						        	{name:"NA_TRPL_APL_DT",          index:"NA_TRPL_APL_DT",          width:30,align:"center"},
						        	{name:"TR_STOP_YN",              index:"TR_STOP_YN",              width:20,align:"center", edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
						        	{name:"TR_STOP_RSNC",            index:"TR_STOP_RSNC",            width:30,align:"center"},
						        	{name:"TR_STOP_DT",              index:"TR_STOP_DT",              width:30,align:"center"},
						        	{name:"RMK_CNTN",                index:"RMK_CNTN",                width:30,align:"center"},
						        	{name:"FSRG_DTM",                index:"FSRG_DTM",                width:30,align:"center"},
						        	{name:"FSRGMN_ENO",              index:"FSRGMN_ENO",              width:30,align:"center"},
						        	{name:"FSRGMN_NA_BZPLC",         index:"FSRGMN_NA_BZPLC",         width:30,align:"center"},
						        	{name:"LSCHG_DTM",               index:"LSCHG_DTM",               width:30,align:"center"},
						        	{name:"LS_CMENO",                index:"LS_CMENO",                width:30,align:"center"},
						        	{name:"LSCGMN_NA_BZPLC",         index:"LSCGMN_NA_BZPLC",         width:30,align:"center"},
						        	{name:"TRPL_DTL_TPC",            index:"TRPL_DTL_TPC",            width:30,align:"center"},
						        	{name:"SAT_BIZ_YN",              index:"SAT_BIZ_YN",              width:30,align:"center"},
						        	{name:"NA_CUSNO",                index:"NA_CUSNO",                width:30,align:"center"},
						        	{name:"NA_REP_CUSNO",            index:"NA_REP_CUSNO",            width:30,align:"center"},
						        	{name:"DEL_YN",                  index:"DEL_YN",                  width:20,align:"center", edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                   ];
            
        $("#grd_BmTrpl").jqGrid("GridUnload");
                
        $("#grd_BmTrpl").jqGrid({
            datatype:    "local",
            data:        data,
            height:      320,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 20,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
           },
           loadComplete:function(){
        	   var ids = $('#grd_BmTrpl').jqGrid('getDataIDs');
               for (var i = 0, len = ids.length; i < len; i++) {
                   var rowData = $('#grd_BmTrpl').jqGrid('getRowData', ids[i]);
                   var telno = $.trim(rowData.ATEL) + ($.trim(rowData.ATEL) == ''?'':'-') + $.trim(rowData.HTEL) + ($.trim(rowData.HTEL) == ''?'':'-') + $.trim(rowData.STEL);
                   $('#grd_BmTrpl').jqGrid('setCell', ids[i], 'TELNO', telno);
               }
           }
        });
        
        //행번호
        $("#grd_BmTrpl").jqGrid("setLabel", "rn","No");  
        

        $("#grd_BmTrpl").jqGrid("hideCol","NA_TRPL_DSC");
        $("#grd_BmTrpl").jqGrid("hideCol","NAAC_DSC");
        $("#grd_BmTrpl").jqGrid("hideCol","NA_TRPL_ABR_NM");
        $("#grd_BmTrpl").jqGrid("hideCol","NA_MBCO_DSC");   
        $("#grd_BmTrpl").jqGrid("hideCol","UP_NA_TRPL_C");  
        $("#grd_BmTrpl").jqGrid("hideCol","FZIP");          
        $("#grd_BmTrpl").jqGrid("hideCol","RZIP");          
        $("#grd_BmTrpl").jqGrid("hideCol","ZIP_SQNO");      
        $("#grd_BmTrpl").jqGrid("hideCol","NA_RGN_C");
        $("#grd_BmTrpl").jqGrid("hideCol","TEL_NAT_NO");
        $("#grd_BmTrpl").jqGrid("hideCol","ATEL");
        $("#grd_BmTrpl").jqGrid("hideCol","HTEL");
        $("#grd_BmTrpl").jqGrid("hideCol","STEL");
        $("#grd_BmTrpl").jqGrid("hideCol","FAX_RGNO");                            
        $("#grd_BmTrpl").jqGrid("hideCol","HFAX");                  
        $("#grd_BmTrpl").jqGrid("hideCol","FAX_SQNO");              
        $("#grd_BmTrpl").jqGrid("hideCol","MPSVNO");                
        $("#grd_BmTrpl").jqGrid("hideCol","MPHNO");                 
        $("#grd_BmTrpl").jqGrid("hideCol","MPSQNO");                
        $("#grd_BmTrpl").jqGrid("hideCol","MACO_YN");               
        $("#grd_BmTrpl").jqGrid("hideCol","FMACH_PATS_TRT_YN");     
        $("#grd_BmTrpl").jqGrid("hideCol","NA_BZPL_TXBZ_RPT_FORM_C");
        $("#grd_BmTrpl").jqGrid("hideCol","STD_COMP_C");            
        $("#grd_BmTrpl").jqGrid("hideCol","STD_COMP_C_SQNO");       
        $("#grd_BmTrpl").jqGrid("hideCol","NA_USR_SYS_KDC");       
        $("#grd_BmTrpl").jqGrid("hideCol","ELT_TXBIL_UYN");         
        $("#grd_BmTrpl").jqGrid("hideCol","NA_TRPL_APL_YN");        
        $("#grd_BmTrpl").jqGrid("hideCol","NA_TRPL_APL_DT");
        $("#grd_BmTrpl").jqGrid("hideCol","TR_STOP_RSNC");   
        $("#grd_BmTrpl").jqGrid("hideCol","TR_STOP_DT");   
        $("#grd_BmTrpl").jqGrid("hideCol","RMK_CNTN");        
        $("#grd_BmTrpl").jqGrid("hideCol","FSRG_DTM");        
        $("#grd_BmTrpl").jqGrid("hideCol","FSRGMN_ENO");      
        $("#grd_BmTrpl").jqGrid("hideCol","FSRGMN_NA_BZPLC"); 
        $("#grd_BmTrpl").jqGrid("hideCol","LSCHG_DTM");       
        $("#grd_BmTrpl").jqGrid("hideCol","LS_CMENO");        
        $("#grd_BmTrpl").jqGrid("hideCol","LSCGMN_NA_BZPLC"); 
        $("#grd_BmTrpl").jqGrid("hideCol","TRPL_DTL_TPC");    
        $("#grd_BmTrpl").jqGrid("hideCol","SAT_BIZ_YN");      
        $("#grd_BmTrpl").jqGrid("hideCol","NA_CUSNO");        
        $("#grd_BmTrpl").jqGrid("hideCol","NA_REP_CUSNO");    
     
        //가로스크롤 있는경우 추가
//         $("#grd_BmTrpl .jqgfirstrow td:last-child").width($("#grd_BmTrpl .jqgfirstrow td:last-child").width() - 17);
        
    }
    
</script>
</html>