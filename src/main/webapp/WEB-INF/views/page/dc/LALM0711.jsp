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

<script src="/js/xlsx.full.min.js"></script>
<script src="/js/FileSaver.min.js"></script>

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
        
        $(".tab_content").hide();
        $(".tab_content:first").show()
        
        var $tabEvtT = $('.tab_box .tab_list li a');        
		$tabEvtT.on('click',function(){
			$tabEvtT.removeClass('on');
			$(this).addClass('on');
			$(".tab_content").hide();
			var activeTab = $(this).attr("href");
			$(activeTab).fadeIn();
			return false;
	    });
			
		fn_Init();
	});   
	
	/*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
        //그리드 초기화
        fn_GridInit();
        fn_InitChecked();
    }
	
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //체크박스 default check
    function fn_InitChecked(){
    	$("input[name=trans_obj_dsc]").prop('checked', true);
    }
    
    //체크박스 이벤트
    function fn_Chkbox(box){
    	if(box.checked == false){
    		fn_GridInit();
    	}
    }
    
    //그리드 초기화
    function fn_GridInit(){
    	
        fn_CreateGrd_MmFhs();
        fn_CreateGrd_MmFee();
        fn_CreateGrd_MmIndv();
        fn_CreateGrd_MmVhc();
        fn_CreateGrd_MmKpn();
        fn_CreateGrd_MhBadTrmn();
        fn_CreateGrd_MmTrpl();
        fn_CreateGrd_MhComnApl();
        
    }
	
	//농가정보
    function fn_CreateGrd_MmFhs(data){
    	 var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "농가", "농장관리번호", "농장식별번호", "경제통합거래처"
                                   , "출하자명", "우편번호", "동이상주소", "동이하주소", "자택전화번호"
                                   , "휴대전화번호", "조합원", "관내외구분", "비고내용",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",    index:"NA_BZPLC",   width:100, align:'center'},
                                      {name:"FHS_ID_NO",   index:"FHS_ID_NO",  width:100, align:'center'},
                                      {name:"FARM_AMNNO",  index:"FARM_AMNNO", width:100, align:'center'},
                                      {name:"FARM_ID_NO",  index:"FARM_ID_NO", width:100, align:'center'},
                                      {name:"NA_TRPL_C",   index:"NA_TRPL_C",  width:100, align:'center'},
                                      {name:"FTSNM",       index:"FTSNM",      width:100, align:'left'},
                                      {name:"ZIP",         index:"ZIP",        width:100, align:'center'},
                                      {name:"DONGUP",      index:"DONGUP",     width:100, align:'left'},
                                      {name:"DONGBW",      index:"DONGBW",     width:100, align:'left'},
                                      {name:"OHSE_TELNO",  index:"OHSE_TELNO", width:100, align:'left'},
                                      {name:"CUS_MPNO",    index:"CUS_MPNO",   width:60,  align:'left'},
                                      {name:"MACO_YN",     index:"MACO_YN",    width:60,  align:'center'},
                                      {name:"JRDWO_DSC",   index:"JRDWO_DSC",  width:60,  align:'center'},
                                      {name:"RMK_CNTN",    index:"RMK_CNTN",   width:60,  align:'left'},
                                     ];             
         $("#grd_MmFhs").jqGrid("GridUnload");                 
         $("#grd_MmFhs").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //수수료정보
    function fn_CreateGrd_MmFee(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "적용일자", "경매대상", "일련번호", "수수료코드"
                                   , "수수료명", "분개업부구분", "통합수수료코드", "수수료적용대상", "금액/비율"
                                   , "단수처리", "조합원수수료", "비조합원수수료", "가감", "낙찰구분"
                                   , "번식우수수료구분", "삭제",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",       index:"NA_BZPLC",       width:100, align:'center'},
                                      {name:"APL_DT",         index:"APL_DT",         width:100, align:'center'},
                                      {name:"AUC_OBJ_DSC",    index:"AUC_OBJ_DSC",    width:100, align:'center'},
                                      {name:"FEE_SQNO",       index:"FEE_SQNO",       width:100, align:'right'},
                                      {name:"NA_FEE_C",       index:"NA_FEE_C",       width:100, align:'center'},
                                      {name:"SRA_FEENM",      index:"SRA_FEENM",      width:100, align:'left'},
                                      {name:"JNLZ_BSN_DSC",   index:"JNLZ_BSN_DSC",   width:100, align:'center'},
                                      {name:"SRA_NA_FEE_C",   index:"SRA_NA_FEE_C",   width:100, align:'center'},
                                      {name:"FEE_APL_OBJ_C",  index:"FEE_APL_OBJ_C",  width:100, align:'left'},
                                      {name:"AM_RTO_DSC",     index:"AM_RTO_DSC",     width:100, align:'left'},
                                      {name:"SGNO_PRC_DSC",   index:"SGNO_PRC_DSC",   width:60,  align:'center'},
                                      {name:"MACO_FEE_UPR",   index:"MACO_FEE_UPR",   width:60,  align:'right'},
                                      {name:"NMACO_FEE_UPR",  index:"NMACO_FEE_UPR",  width:60,  align:'right'},
                                      {name:"ANS_DSC",        index:"ANS_DSC",        width:60,  align:'center'},
                                      {name:"SBID_YN",        index:"SBID_YN",        width:60,  align:'center'},
                                      {name:"PPGCOW_FEE_DSC", index:"PPGCOW_FEE_DSC", width:60,  align:'center'},
                                      {name:"DEL_YN",         index:"DEL_YN",         width:60,  align:'center'},
                                     ];             
         $("#grd_MmFee").jqGrid("GridUnload");                 
         $("#grd_MmFee").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //개체정보
    function fn_CreateGrd_MmIndv(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "귀표번호", "축산출종구분", "농가", "농장관리번호"
                                   , "생년월일", "어미구분", "KPN", "성별", "어미바코드"
                                   , "산차", "계대", "개체번호", "개체종축등록번호", "등록구분",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",              index:"NA_BZPLC",              width:100, align:'center'},
                                      {name:"SRA_INDV_AMNNO",        index:"SRA_INDV_AMNNO",        width:100, align:'left'},
                                      {name:"SRA_SRS_DSC",           index:"SRA_SRS_DSC",           width:100, align:'left'},
                                      {name:"FHS_ID_NO",             index:"FHS_ID_NO",             width:100, align:'center'},
                                      {name:"FARM_AMNNO",            index:"FARM_AMNNO",            width:100, align:'center'},
                                      {name:"BIRTH",                 index:"BIRTH",                 width:100, align:'center'},
                                      {name:"MCOW_DSC",              index:"MCOW_DSC",              width:100, align:'left'},
                                      {name:"KPN_NO",                index:"KPN_NO",                width:100, align:'center'},
                                      {name:"INDV_SEX_C",            index:"INDV_SEX_C",            width:100, align:'right'},
                                      {name:"MCOW_SRA_INDV_EART_NO", index:"MCOW_SRA_INDV_EART_NO", width:100, align:'right'},
                                      {name:"MATIME",                index:"MATIME",                width:60,  align:'center'},
                                      {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",     width:60,  align:'center'},
                                      {name:"INDV_ID_NO",            index:"INDV_ID_NO",            width:60,  align:'center'},
                                      {name:"SRA_INDV_BRDSRA_RG_NO", index:"SRA_INDV_BRDSRA_RG_NO", width:60,  align:'left'},
                                      {name:"RG_DSC",                index:"RG_DSC",                width:60,  align:'center'},
                                     ];             
         $("#grd_MmIndv").jqGrid("GridUnload");                 
         $("#grd_MmIndv").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
	
    //수송자정보
    function fn_CreateGrd_MmVhc(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "수송자", "경제통합거래처", "차주명", "차량번호"
                                   , "차량구분", "수송자명", "정산경제통합거래처", "차주전화번호", "차주휴대전화번호"
                                   , "수송자전화번호", "적재중량", "차량톤수", "적재가능용적", "차종코드"
                                   , "수송여부", "방역일자", "교육이수", "삭제",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",          index:"NA_BZPLC",          width:100, align:'center'},
                                      {name:"VHC_SHRT_C",        index:"VHC_SHRT_C",        width:100, align:'left'},
                                      {name:"NA_TRPL_C",         index:"NA_TRPL_C",         width:100, align:'left'},
                                      {name:"BRWRNM",            index:"BRWRNM",            width:100, align:'left'},
                                      {name:"VHCNO",             index:"VHCNO",             width:100, align:'left'},
                                      {name:"VHC_DSC",           index:"VHC_DSC",           width:100, align:'left'},
                                      {name:"VHC_DRV_CAFFNM",    index:"VHC_DRV_CAFFNM",    width:100, align:'left'},
                                      {name:"ADJ_NA_TRPL_C",     index:"ADJ_NA_TRPL_C",     width:100, align:'center'},
                                      {name:"BRWR_TELNO",        index:"BRWR_TELNO",        width:100, align:'left'},
                                      {name:"BRWR_MPNO",         index:"BRWR_MPNO",         width:100, align:'left'},
                                      {name:"DRV_CAFF_TELNO",    index:"DRV_CAFF_TELNO",    width:60,  align:'left'},
                                      {name:"SRA_LOAD_WT",       index:"SRA_LOAD_WT",       width:60,  align:'right'},
                                      {name:"SRA_VHC_TNCN",      index:"SRA_VHC_TNCN",      width:60,  align:'right'},
                                      {name:"SRA_LOAD_PSB_BULK", index:"SRA_LOAD_PSB_BULK", width:60,  align:'right'},
                                      {name:"CARTP_C",           index:"CARTP_C",           width:60,  align:'left'},
                                      {name:"LVST_TRPT_YN",      index:"LVST_TRPT_YN",      width:60,  align:'left'},
                                      {name:"PVEP_DT",           index:"PVEP_DT",           width:60,  align:'center'},
                                      {name:"EDU_CPL_YN",        index:"EDU_CPL_YN",        width:60,  align:'left'},
                                      {name:"DEL_YN",            index:"DEL_YN",            width:60,  align:'center'},
                                     ];             
         $("#grd_MmVhc").jqGrid("GridUnload");                 
         $("#grd_MmVhc").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //KPN정보
    function fn_CreateGrd_MmKpn(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "KPN", "등급", "생년월일", "냉도채중(kg)"
                                   , "배최장근면적", "근내지방도", "비고내용", "거래단가",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",            index:"NA_BZPLC",            width:100, align:'center'},
                                      {name:"KPN_NO",              index:"KPN_NO",              width:100, align:'center'},
                                      {name:"GRD",                 index:"GRD",                 width:100, align:'center'},
                                      {name:"BIRTH",               index:"BIRTH",               width:100, align:'center'},
                                      {name:"SRA_WGH",             index:"SRA_WGH",             width:100, align:'right'},
                                      {name:"PEAR_LONS_MSCL_AREA", index:"PEAR_LONS_MSCL_AREA", width:100, align:'right'},
                                      {name:"MCIN_GRSDR",          index:"MCIN_GRSDR",          width:100, align:'right'},
                                      {name:"RMK_CNTN",            index:"RMK_CNTN",            width:100, align:'left'},
                                      {name:"SRA_TR_UPR",          index:"SRA_TR_UPR",          width:100, align:'right'},
                                     ];             
         $("#grd_MmKpn").jqGrid("GridUnload");                 
         $("#grd_MmKpn").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //불량거래인
    function fn_CreateGrd_MhBadTrmn(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "중도매인", "번호", "등록일자", "중도매인명"
                                   , "전화번호", "실명번호", "경제통합거래처", "거래가능", "등록조합"
                                   , "등록자", "등록자연락처", "사고등록사유내용",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",      index:"NA_BZPLC",      width:100, align:'center'},
                                      {name:"TRMN_AMNNO",    index:"TRMN_AMNNO",    width:100, align:'center'},
                                      {name:"RG_SQNO",       index:"RG_SQNO",       width:100, align:'right'},
                                      {name:"RG_DT",         index:"RG_DT",         width:100, align:'center'},
                                      {name:"SRA_MWMNNM",    index:"SRA_MWMNNM",    width:100, align:'left'},
                                      {name:"TELNO",         index:"TELNO",         width:100, align:'left'},
                                      {name:"FRLNO",         index:"FRLNO",         width:100, align:'center'},
                                      {name:"NA_TRPL_C",     index:"NA_TRPL_C",     width:100, align:'center'},
                                      {name:"TR_PMSS_YN",    index:"TR_PMSS_YN",    width:100, align:'center'},
                                      {name:"RG_BZPLNM",     index:"RG_BZPLNM",     width:100, align:'left'},
                                      {name:"RGMNM",         index:"RGMNM",         width:60,  align:'left'},
                                      {name:"RGMN_TELNO",    index:"RGMN_TELNO",    width:60,  align:'left'},
                                      {name:"ACD_RG_RSNCTT", index:"ACD_RG_RSNCTT", width:60,  align:'left'},
                                     ];             
         $("#grd_MhBadTrmn").jqGrid("GridUnload");                 
         $("#grd_MhBadTrmn").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //거래처내역
    function fn_CreateGrd_MmTrpl(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["사업장", "거래처구분", "거래처", "경제통합거래처", "거래처명"
                                   , "우편번호", "동이상주소", "동이하주소", "자택전화번호", "휴대전화번호"
                                   , "가격산정위원수당", "삭제",];        
         var searchResultColModel = [
                                      {name:"NA_BZPLC",            index:"NA_BZPLC",            width:100, align:'center'},
                                      {name:"LVST_MKT_TRPL_DSC",   index:"LVST_MKT_TRPL_DSC",   width:100, align:'left'},
                                      {name:"LVST_MKT_TRPL_AMNNO", index:"LVST_MKT_TRPL_AMNNO", width:100, align:'center'},
                                      {name:"NA_TRPL_C",           index:"NA_TRPL_C",           width:100, align:'center'},
                                      {name:"BRKR_NAME",           index:"BRKR_NAME",           width:100, align:'left'},
                                      {name:"ZIP",                 index:"ZIP",                 width:100, align:'center'},
                                      {name:"DONGUP",              index:"DONGUP",              width:100, align:'left'},
                                      {name:"DONGBW",              index:"DONGBW",              width:100, align:'left'},
                                      {name:"OHSE_TELNO",          index:"OHSE_TELNO",          width:100, align:'left'},
                                      {name:"CUS_MPNO",            index:"CUS_MPNO",            width:100, align:'left'},
                                      {name:"PR_RKON_CM_ALW",      index:"PR_RKON_CM_ALW",      width:60,  align:'right'},
                                      {name:"DEL_YN",              index:"DEL_YN",              width:60,  align:'center'},
                                     ];             
         $("#grd_MmTrpl").jqGrid("GridUnload");                 
         $("#grd_MmTrpl").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    
    //공통코드정보
    function fn_CreateGrd_MhComnApl(data){
         var rowNoValue = 0;     
         if(data != null){
             rowNoValue = data.length;
         }         
         var searchResultColNames = ["업무구분", "단순코드", "단순코드유형", "단순코드그룹일련번호", "단순코드여부"
                                   , "단순코드명", "부모단순유형코드", "부모단순코드", "정렬순서", "관리항목내용"
                                   , "관리항목내용2", "관리항목내용3", "관리항목내용4", "관리항목내용5", "관리항목내용6"
                                   , "관리항목내용7", "관리항목내용8", "관리항목내용9", "관리항목내용10", "관리항목내용11",];        
         var searchResultColModel = [
                                      {name:"BSN_DSC",         index:"BSN_DSC",         width:100, align:'center'},
                                      {name:"SIMP_C",          index:"SIMP_C",          width:100, align:'left'},
                                      {name:"SIMP_TPC",        index:"SIMP_TPC",        width:100, align:'left'},
                                      {name:"SIMP_C_GRP_SQNO", index:"SIMP_C_GRP_SQNO", width:100, align:'right'},
                                      {name:"SIMP_C_YN",       index:"SIMP_C_YN",       width:100, align:'left'},
                                      {name:"SIMP_CNM",        index:"SIMP_CNM",        width:100, align:'left'},
                                      {name:"PRET_SIMP_TPC",   index:"PRET_SIMP_TPC",   width:100, align:'left'},
                                      {name:"PRET_SIMP_C",     index:"PRET_SIMP_C",     width:100, align:'center'},
                                      {name:"SORT_SQ",         index:"SORT_SQ",         width:100, align:'center'},
                                      {name:"AMN_HCNT",        index:"AMN_HCNT",        width:100, align:'left'},
                                      {name:"AMN_HCNT2",       index:"AMN_HCNT2",       width:60,  align:'left'},
                                      {name:"AMN_HCNT3",       index:"AMN_HCNT3",       width:60,  align:'left'},
                                      {name:"AMN_HCNT4",       index:"AMN_HCNT4",       width:60,  align:'left'},
                                      {name:"AMN_HCNT5",       index:"AMN_HCNT5",       width:60,  align:'left'},
                                      {name:"AMN_HCNT6",       index:"AMN_HCNT6",       width:60,  align:'left'},
                                      {name:"AMN_HCNT7",       index:"AMN_HCNT7",       width:60,  align:'left'},
                                      {name:"AMN_HCNT8",       index:"AMN_HCNT8",       width:60,  align:'left'},
                                      {name:"AMN_HCNT9",       index:"AMN_HCNT9",       width:60,  align:'left'},
                                      {name:"AMN_HCNT10",      index:"AMN_HCNT10",      width:60,  align:'left'},
                                      {name:"AMN_HCNT11",      index:"AMN_HCNT11",      width:60,  align:'left'},
                                      
                                     ];             
         $("#grd_MhComnApl").jqGrid("GridUnload");                 
         $("#grd_MhComnApl").jqGrid({
             datatype:    "local",
             data:        data,
             height:      520,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   true,
             shrinkToFit: false, 
             rownumbers:true,
             rownumWidth:30,
             colNames: searchResultColNames,
             colModel: searchResultColModel,            
         });
    }
    

</script>
</head>
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
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">대상<strong class="req_dot">*</strong></th>
                                <td>
                                    <label for="01"><input type="checkbox" name="trans_obj_dsc" id="01" onClick="fn_Chkbox(this)" checked="checked"/>농가정보</label>
                                    <label for="02"><input type="checkbox" name="trans_obj_dsc" id="02" onClick="fn_Chkbox(this)" checked="checked"/>수수료정보</label>
                                    <label for="03"><input type="checkbox" name="trans_obj_dsc" id="03" onClick="fn_Chkbox(this)" checked="checked"/>개체정보</label>
                                    <label for="04"><input type="checkbox" name="trans_obj_dsc" id="04" onClick="fn_Chkbox(this)" checked="checked"/>수송자정보</label>
                                    <label for="05"><input type="checkbox" name="trans_obj_dsc" id="05" onClick="fn_Chkbox(this)" checked="checked"/>KPN정보</label>
                                    <label for="06"><input type="checkbox" name="trans_obj_dsc" id="06" onClick="fn_Chkbox(this)" checked="checked"/>불량거래인</label>
                                    <label for="07"><input type="checkbox" name="trans_obj_dsc" id="07" onClick="fn_Chkbox(this)" checked="checked"/>거래처정보</label>
                                    <label for="08"><input type="checkbox" name="trans_obj_dsc" id="08" onClick="fn_Chkbox(this)" checked="checked"/>공통코드</label>
                                </td>
                                <th scope="row">Excel 파일<strong class="req_dot">*</strong></th>
                                <td>
                                    <input id="excel_file" class="popup"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
              <div class="tab_box clearfix line">
                 <ul class="tab_list"> 
                     <li><a href="#tab1" class="on">농가정보</a></li>
                     <li><a href="#tab2">수수료정보</a></li>
                     <li><a href="#tab3">개체정보</a></li>
                     <li><a href="#tab4">수송자정보</a></li>
                     <li><a href="#tab5">KPN정보</a></li>
                     <li><a href="#tab6">불량거래인</a></li>
                     <li><a href="#tab7">거래처내역</a></li>
                     <li><a href="#tab8">공통코드정보</a></li>
                 </ul>
             </div>
             
             <!-- 농가정보 -->
             <div id="tab1" class="tab_content">
                <div class="listTable">
	                <table id="grd_MmFhs">
	                </table>
	            </div>
             </div>
             <!-- 수수료정보 -->
             <div id="tab2" class="tab_content">
                <div class="listTable">
                    <table id="grd_MmFee">
                    </table>
                </div>
             </div>
             <!-- 개체정보 -->
             <div id="tab3" class="tab_content">
                <div class="listTable">
                    <table id="grd_MmIndv">
                    </table>
                </div>
             </div>
             <!-- 수송자정보 -->
             <div id="tab4" class="tab_content">
                 <div class="listTable">
                    <table id="grd_MmVhc">
                    </table>
                </div>
             </div>
             <!-- KPN정보 -->
             <div id="tab5" class="tab_content">
                 <div class="listTable">
                    <table id="grd_MmKpn">
                    </table>
                </div>
             </div>
             <!-- 불량거래인 -->
             <div id="tab6" class="tab_content">
                 <div class="listTable">
                    <table id="grd_MhBadTrmn">
                    </table>
                </div>
             </div>
             <!-- 거래처내역 -->
             <div id="tab7" class="tab_content">
                <div class="listTable">
                    <table id="grd_MmTrpl">
                    </table>
                </div>
             </div>
             <!-- 공통코드정보 -->
             <div id="tab8" class="tab_content">
                 <div class="listTable">
                    <table id="grd_MhComnApl">
                    </table>
                </div>
             </div>
        </section>
    </div>
</body>
</html>
