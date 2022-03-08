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
                        <col width="*">
                        <col width="85">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><span class="tb_dot">농가코드</span></th>
                            <td><input type="text" id="fhs_id_no"></td>    
                            <th><span class="tb_dot">농가명</span></th>
                            <td><input type="text" id="sra_fhsnm"></td>
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
        
        <div class="listTable">           
            <table id="grd_ImFhsinf">
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0222P
 * 3. 파일명(한글) : 농가검색(인터페이스) 팝업
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.11.01   신명진   최초작성
 ------------------------------------------------------------------------------*/
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
    	
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');
            $("#fhs_id_no").val(pageInfo.param.fhs_id_no);
            $("#sra_fhsnm").val(pageInfo.param.sra_fhsnm);
        	
        	if(pageInfo.param.flag == '1'){
        		fn_Search();
        	}
            $("#fhs_id_no").focus();
        }else {
            fn_Init();
        }        
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_ImFhsinf");
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_ImFhsinf").jqGrid("clearGridData", true);
         //폼 초기화
         fn_InitFrm('frm_Search');
         $("#fhs_id_no").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(pageCnt){
    	if(fn_isNull($( "#fhs_id_no" ).val()) == true && fn_isNull($( "#sra_fhsnm" ).val()) == true) {
            MessagePopup('OK','농가코드 또는 농가명을 입력하세요.',null,function(){
                $( "#fhs_id_no" ).focus();
            });
            return;
        }
    	 
    	//개체이력정보
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["ctgrm_cd"]   = "4100";
        srchData["in_sqno"]    = 1;
        srchData["in_rec_cn"]  = "10";
        srchData["farm_amnno"] = "0";
        srchData["fhs_id_no"]  = $("#fhs_id_no").val();
        srchData["sra_fhsnm"]  = $("#sra_fhsnm").val();
        
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        
        if(results.status != RETURN_SUCCESS) {
            showErrorMessage(results,'NOTFOUND');
            return;
            
        } else {
            result = setDecrypt(results);
            fn_CreateGrid(result);
        }
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){
    	 
        var sel_rowid = $("#grd_ImFhsinf").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_ImFhsinf").jqGrid("getRowData", sel_rowid);
        
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
    }  
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    // 분만정보 그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["농가식별번호", "농가명", "농장식별번호", "농장관리번호", "관리사무소", "관리사무소명", "우편번호", "주소",
        	 						"경제통합거래처코드", "핵심농가여부", "축산농가구분코드", "축산농가등록일자", "축산농가대표자명", "축산농가앞자리우편번호", "축산농가뒷자리우편번호", "축산농가우편번호일련번호", 
        	 						"축산농가동이상주소", "축산농가동이하주소", "축산농가전화국가번호", "축산농가전화지역번호", "축산농가전화국번호", "축산농가전화일련번호","축산농가사업자등록번호", 
        	 						"축산농가팩스지역번호", "축산농가팩스국번호", "축산농가팩스일련번호", "축산농가대표휴대전화서비스번호", "축산농가대표휴대전화국번호", "축산농가대표휴대전화일련번호", 
        	 						"축산농가이메일주소", "비고내용", "축산농가관리여부", "축산농가사용여부", "축산농가CIF확인여부", "축산농가사용자ID", "품질평가원농가식별번호", "축산농가수정프로그램ID", 
        	 						"축산농장운영상태코드", "축산농장등록사무소코드", "축산농장돈방시설명", "축산농장관리자명", "축산농장관리자전화국가번호", "축산농장관리자전화지역번호", "축산농장관리자전화국번호", 
        	 						"축산농장관리자전화일련번호", "축산농장뒷자리우편번호", "축산농장우편번호일련번호", "축산농장은행코드", "축산농장계좌번호", "축산농장예금주명", "축산농장우편물수신여부", 
						        	"축산농가조합원가입여부", "영농작목반관리번호", "품질평가원농장식별번호", "우편번호", "자택전화번호", "고객휴대전화번호", "상세주소"];        
        var searchResultColModel = [
						        	{name:"FHS_ID_NO"				, index:"FHS_ID_NO"              , width:100, align:'center'},
						        	{name:"SRA_FHSNM"               , index:"SRA_FHSNM"              , width:100, align:'center'},
						        	{name:"FARM_ID_NO"              , index:"FARM_ID_NO"             , width:100, align:'center'},
						        	{name:"FARM_AMNNO"              , index:"FARM_AMNNO"             , width:100, align:'center'},
						        	{name:"SRA_FHS_AMN_ACO_C"       , index:"SRA_FHS_AMN_ACO_C"      , width:100, align:'center'},
						        	{name:"BRNM"                    , index:"BRNM"                   , width:100, align:'center'},
						        	{name:"SRA_FARM_FZIP"           , index:"SRA_FARM_FZIP"          , width:100, align:'center'},
						        	{name:"SRA_FARM_DONGUP"         , index:"SRA_FARM_DONGUP"        , width:100, align:'center'},
									{name:"NA_TRPL_C"               , index:"NA_TRPL_C"              , width:100, align:'center', hidden:true},
						        	{name:"CORE_FHS_YN"             , index:"CORE_FHS_YN"            , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_DSC"             , index:"SRA_FHS_DSC"            , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_RG_DT"           , index:"SRA_FHS_RG_DT"          , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_REPMNM"          , index:"SRA_FHS_REPMNM"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_FZIP"            , index:"SRA_FHS_FZIP"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_RZIP"            , index:"SRA_FHS_RZIP"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_ZIP_SQNO"        , index:"SRA_FHS_ZIP_SQNO"       , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_DONGUP"          , index:"SRA_FHS_DONGUP"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_DONGBW"          , index:"SRA_FHS_DONGBW"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_TEL_NAT_NO"      , index:"SRA_FHS_TEL_NAT_NO"     , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_ATEL"            , index:"SRA_FHS_ATEL"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_HTEL"            , index:"SRA_FHS_HTEL"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_STEL"            , index:"SRA_FHS_STEL"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_BZNO"            , index:"SRA_FHS_BZNO"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_FAX_RGNO"        , index:"SRA_FHS_FAX_RGNO"       , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_HFAX"            , index:"SRA_FHS_HFAX"           , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_FAX_SQNO"        , index:"SRA_FHS_FAX_SQNO"       , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_REP_MPSVNO"      , index:"SRA_FHS_REP_MPSVNO"     , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_REP_MPHNO"       , index:"SRA_FHS_REP_MPHNO"      , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_REP_MPSQNO"      , index:"SRA_FHS_REP_MPSQNO"     , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_EMAIL_ADR"       , index:"SRA_FHS_EMAIL_ADR"      , width:100, align:'center', hidden:true},
						        	{name:"RMK_CNTN"                , index:"RMK_CNTN"               , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_AMN_YN"          , index:"SRA_FHS_AMN_YN"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_UYN"             , index:"SRA_FHS_UYN"            , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_CIF_CNF_YN"      , index:"SRA_FHS_CIF_CNF_YN"     , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_USRID"           , index:"SRA_FHS_USRID"          , width:100, align:'center', hidden:true},
						        	{name:"QLT_EVL_OGN_FHS_ID_NO"   , index:"QLT_EVL_OGN_FHS_ID_NO"  , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_MOD_PGID"        , index:"SRA_FHS_MOD_PGID"       , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_OPER_STSC"      , index:"SRA_FARM_OPER_STSC"     , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_RG_BRC"         , index:"SRA_FARM_RG_BRC"        , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_PGROOM_EQNM"    , index:"SRA_FARM_PGROOM_EQNM"   , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_AMRNM"          , index:"SRA_FARM_AMRNM"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_AMN_TEL_NAT_NO" , index:"SRA_FARM_AMN_TEL_NAT_NO", width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_AMN_ATEL"       , index:"SRA_FARM_AMN_ATEL"      , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_AMN_HTEL"       , index:"SRA_FARM_AMN_HTEL"      , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_AMN_STEL"       , index:"SRA_FARM_AMN_STEL"      , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_RZIP"           , index:"SRA_FARM_RZIP"          , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_ZIP_SQNO"       , index:"SRA_FARM_ZIP_SQNO"      , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_BNK_C"          , index:"SRA_FARM_BNK_C"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_ACNO"           , index:"SRA_FARM_ACNO"          , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_DPRNM"          , index:"SRA_FARM_DPRNM"         , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_PSTMTT_DPZ_YN"  , index:"SRA_FARM_PSTMTT_DPZ_YN" , width:100, align:'center', hidden:true},
						        	{name:"SRA_FHS_MACO_ENT_YN"     , index:"SRA_FHS_MACO_ENT_YN"    , width:100, align:'center', hidden:true},
						        	{name:"FANG_ABIT_AMNNO"         , index:"FANG_ABIT_AMNNO"        , width:100, align:'center', hidden:true},
						        	{name:"QLT_EVL_OGN_FARM_ID_NO"  , index:"QLT_EVL_OGN_FARM_ID_NO" , width:100, align:'center', hidden:true},
						        	{name:"ZIP"                     , index:"ZIP"                    , width:100, align:'center', hidden:true},
						        	{name:"TELNO"                   , index:"TELNO"                  , width:100, align:'center', hidden:true},
						        	{name:"MPNO"                    , index:"MPNO"                   , width:100, align:'center', hidden:true},
						        	{name:"SRA_FARM_DONGBW"         , index:"SRA_FARM_DONGBW"        , width:100, align:'center'},
                                     ];
            
        $("#grd_ImFhsinf").jqGrid("GridUnload");
                
        $("#grd_ImFhsinf").jqGrid({
            datatype:    "local",
            data:        data,
            height:      300,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
           },
           
        });
        
      	//가로스크롤 있는경우 추가
        $("#grd_ImFhsinf .jqgfirstrow td:last-child").width($("#grd_ImFhsinf .jqgfirstrow td:last-child").width() - 17);
        
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
</html>