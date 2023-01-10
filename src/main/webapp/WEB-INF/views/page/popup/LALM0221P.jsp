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
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><span class="tb_dot">귀표번호</span></th>
                            <td><input type="text" id="sra_indv_amnno"></td>    
                            <td><input type="text" id="hid_sra_indv_amnno_c"></td>                                                 
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
            <table id="grd_MmIndv">
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
    	
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');
            $("#sra_indv_amnno").val(pageInfo.param.sra_indv_amnno);
            $("#hid_sra_indv_amnno_c").val(pageInfo.param.hid_sra_indv_amnno_c);
        	
        	if( pageInfo.result != null){
        		fn_CreateGrid(pageInfo.result);
        	}
            $("#sra_indv_amnno").focus();
        }else {
            fn_Init();
        }        
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmTrpl");            
        
        $("#grd_MmIndv").jqGrid("hideCol","SRA_SRS_DSC"  );
        $("#grd_MmIndv").jqGrid("hideCol","NA_TRPL_C"    );
        $("#grd_MmIndv").jqGrid("hideCol","ZIP"          );
        $("#grd_MmIndv").jqGrid("hideCol","DONGUP"       );
        $("#grd_MmIndv").jqGrid("hideCol","DONGBW"       );
        $("#grd_MmIndv").jqGrid("hideCol","OHSE_TELNO"   );
        $("#grd_MmIndv").jqGrid("hideCol","CUS_MPNO"     );
        $("#grd_MmIndv").jqGrid("hideCol","MACO_YN"      );
        $("#grd_MmIndv").jqGrid("hideCol","DEL_YN"       );
        $("#grd_MmIndv").jqGrid("hideCol","JRDWO_DSC"    );
        $("#grd_MmIndv").jqGrid("hideCol","SRA_FARM_ACNO");  
        $("#grd_MmIndv").jqGrid("hideCol","SRA_FED_SPY_YN");  
        $("#hid_sra_indv_amnno_c").hide();  
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_MmIndv").jqGrid("clearGridData", true);
         //폼 초기화
         fn_InitFrm('frm_Search');
         $("#sra_indv_amnno").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
 	
		if( $( "#sra_indv_amnno" ).val().length == 4 ) {
			$( "#hid_sra_indv_amnno_c" ).val('1');
		} else if($( "#sra_indv_amnno" ).val().length >= 5) {
			$( "#hid_sra_indv_amnno_c" ).val('2');			
		} else if($( "#sra_indv_amnno" ).val() != null) {
			$( "#hid_sra_indv_amnno_c" ).val('3');			
		}	 	
	 	
    	if (fn_isNull($("#sra_indv_amnno").val())){
    		MessagePopup('OK','개체번호는 4글자 이상입력하세요.');
            return;
     	}		 	
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0221P_selList", "POST");        
        var result;
              
     	//그리드 초기화
     	$("#grd_MmIndv").jqGrid("clearGridData", true); 
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
        var sel_rowid = $("#grd_MmIndv").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmIndv").jqGrid("getRowData", sel_rowid);
        
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
        
        var searchResultColNames = ["귀표번호", "농가코드", "농장관리번호", "출하주","생년월일","어미구분","KPN","개체성별","어미귀표번호","산차","계대","식별번호", "종축등록번호"
        	                      , "축종구분", "거래처코드", "우편번호", "동이상주소", "동이하주소", "자택전화번호", "고객휴대전화번호", "조합원여부", "삭제여부", "관내외구분", "계좌번호", "사료사용여부", "등록구분"];        
        var searchResultColModel = [
						            {name:"SRA_INDV_AMNNO"       , index:"SRA_INDV_AMNNO"         , width:120,  align:'center', formatter:'gridIndvFormat'},
						            {name:"FHS_ID_NO"            , index:"FHS_ID_NO"              , width:80,  align:'center'},
						            {name:"FARM_AMNNO"           , index:"FARM_AMNNO"             , width:80,  align:'center'},
						            {name:"FTSNM"                , index:"FTSNM"                  , width:80,  align:'center'},
						            {name:"BIRTH"                , index:"BIRTH"                  , width:80,  align:'center', formatter:'gridDateFormat'},
						            {name:"MCOW_DSC"             , index:"MCOW_DSC"               , width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
						            {name:"KPN_NO"               , index:"KPN_NO"                 , width:70,  align:'center'},
						            {name:"INDV_SEX_C"           , index:"INDV_SEX_C"             , width:90,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						            {name:"MCOW_SRA_INDV_AMNNO"  , index:"MCOW_SRA_INDV_AMNNO"    , width:90,  align:'center'},
						            {name:"MATIME"               , index:"MATIME"                 , width:70,  align:'center'},
						            {name:"SRA_INDV_PASG_QCN"    , index:"SRA_INDV_PASG_QCN"      , width:70,  align:'center'},
						            {name:"INDV_ID_NO"           , index:"INDV_ID_NO"             , width:100, align:'center'},
						            {name:"SRA_INDV_BRDSRA_RG_NO", index:"SRA_INDV_BRDSRA_RG_NO"  , width:80,  align:'center'},
						            {name:"SRA_SRS_DSC"          , index:"SRA_SRS_DSC"            , width:70,  align:'center'},
						            {name:"NA_TRPL_C"            , index:"NA_TRPL_C"              , width:70,  align:'center'},
						            {name:"ZIP"                  , index:"ZIP"                    , width:70,  align:'center'},
						            {name:"DONGUP"               , index:"DONGUP"                 , width:70,  align:'center'},
						            {name:"DONGBW"               , index:"DONGBW"                 , width:70,  align:'center'},
						            {name:"OHSE_TELNO"           , index:"OHSE_TELNO"             , width:70,  align:'center'},
						            {name:"CUS_MPNO"             , index:"CUS_MPNO"               , width:70,  align:'center'},
						            {name:"MACO_YN"              , index:"MACO_YN"                , width:70,  align:'center'},
						            {name:"DEL_YN"               , index:"DEL_YN"                 , width:70,  align:'center'},
						            {name:"JRDWO_DSC"            , index:"JRDWO_DSC"              , width:70,  align:'center'},
						            {name:"SRA_FARM_ACNO"        , index:"sra_farm_acno"          , width:70,  align:'center'},
						            {name:"SRA_FED_SPY_YN"       , index:"SRA_FED_SPY_YN"         , width:70,  align:'center'},
						            {name:"RG_DSC"               , index:"RG_DSC"                 , width:80, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},

                                     
                                     ];
            
        $("#grd_MmIndv").jqGrid("GridUnload");
                
        $("#grd_MmIndv").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
                
           },
           
        });   

        //가로스크롤 있는경우 추가
        $("#grd_MmIndv .jqgfirstrow td:last-child").width($("#grd_MmIndv .jqgfirstrow td:last-child").width() - 17);
        
        $("#grd_MmIndv").jqGrid("hideCol","SRA_SRS_DSC"  );
        $("#grd_MmIndv").jqGrid("hideCol","NA_TRPL_C"    );
        $("#grd_MmIndv").jqGrid("hideCol","ZIP"          );
        $("#grd_MmIndv").jqGrid("hideCol","DONGUP"       );
        $("#grd_MmIndv").jqGrid("hideCol","DONGBW"       );
        $("#grd_MmIndv").jqGrid("hideCol","OHSE_TELNO"   );
        $("#grd_MmIndv").jqGrid("hideCol","CUS_MPNO"     );
        $("#grd_MmIndv").jqGrid("hideCol","MACO_YN"      );
        $("#grd_MmIndv").jqGrid("hideCol","DEL_YN"       );
        $("#grd_MmIndv").jqGrid("hideCol","JRDWO_DSC"    );
        $("#grd_MmIndv").jqGrid("hideCol","SRA_FARM_ACNO");  
        $("#grd_MmIndv").jqGrid("hideCol","SRA_FED_SPY_YN");         
        
        
         
        
    }
    
</script>
</html>