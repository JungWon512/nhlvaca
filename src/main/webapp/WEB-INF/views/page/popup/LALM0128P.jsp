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
                <li><p class="dot_allow" >검색조건 </p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="120">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><span class="tb_dot">수송자코드/명</span></th>
                            <td><input type="text" id="vhc_drv_caffnm"></td>
                            <td><input type="text" id="vhc_drv_caffnm_c"></td>                            
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
            <table id="grd_MmVhc">
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
        	$("#vhc_drv_caffnm").val(pageInfo.param.vhc_drv_caffnm); 
        	
        	if( pageInfo.result != null){
        		fn_CreateGrid(pageInfo.result);
        	}
            $("#vhc_drv_caffnm").focus();
        }else {
            fn_Init();
        }   
        
     // enter로 조회
		$('#vhc_drv_caffnm').on('keydown',function(e){
			if(e.keyCode==13){
				 fn_Search();
		    	return;
			}
		});
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmVhc");           

        $("#grd_MmVhc").jqGrid("hideCol","NA_TRPL_C");
        $("#grd_MmVhc").jqGrid("hideCol","ADJ_NA_TRPL_C");
        $("#grd_MmVhc").jqGrid("hideCol","DEL_YN");
        $("#vhc_drv_caffnm_c").hide();
        
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
       
    	//그리드 초기화
    	$("#grd_MmVhc").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        $("#vhc_drv_caffnm").focus();        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){   
    	 
   	 if(fn_isNull( $('#vhc_drv_caffnm').val() )){
			MessagePopup('OK', '수송자코드/명을 입력해주세요.', function(){
				$( "#vhc_drv_caffnm" ).focus();
			});
			return;
	 }

	 	$( "#vhc_drv_caffnm_c" ).val().clear;
	 	if( fn_isNum($( "#vhc_drv_caffnm" ).val()) && fn_isChar($( "#vhc_drv_caffnm" ).val()) ){
	     	$( "#vhc_drv_caffnm_c" ).val('2');
	    }else if( fn_isNum($( "#vhc_drv_caffnm" ).val()) ){
	     	$( "#vhc_drv_caffnm_c" ).val('1');
	    }else{
	     	$( "#vhc_drv_caffnm_c" ).val('2');
	    }        
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0128P_selList", "POST");        
        var result;

     	//그리드 초기화
     	$("#grd_MmVhc").jqGrid("clearGridData", true);         
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
        var sel_rowid = $("#grd_MmVhc").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmVhc").jqGrid("getRowData", sel_rowid);
        
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
        
        var searchResultColNames = ["차량단축코드", "수송자명", "수송자<br>전화번호", "차량번호","차주명","차량구분","차주<br>자택전화번호","차주<br>휴대전화번호","적재중량","차량톤수","적재가능용적","차종코드", "수송여부", "방역일자","교육이수여부","거래처코드","정산거래처코드","삭제여부" ];        
        var searchResultColModel = [
						            {name:"VHC_SHRT_C"       , index:"VHC_SHRT_C"       , width:80,  align:'center'},
						            {name:"VHC_DRV_CAFFNM"   , index:"VHC_DRV_CAFFNM"   , width:80,  align:'center'},
						            {name:"DRV_CAFF_TELNO"   , index:"DRV_CAFF_TELNO"   , width:100, align:'center'},
						            {name:"VHCNO"            , index:"VHCNO"            , width:80,  align:'center'},
						            {name:"BRWRNM"           , index:"BRWRNM"           , width:60,  align:'center'},
						            {name:"VHC_DSC"          , index:"VHC_DSC"          , width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("VHC_DSC", 1)}},
						            {name:"BRWR_TELNO"       , index:"BRWR_TELNO"       , width:100, align:'left'},
						            {name:"BRWR_MPNO"        , index:"BRWR_MPNO"        , width:90,  align:'center'},
						            {name:"SRA_LOAD_WT"      , index:"SRA_LOAD_WT"      , width:90,  align:'center'},
						            {name:"SRA_VHC_TNCN"     , index:"SRA_VHC_TNCN"     , width:70,  align:'center'},
						            {name:"SRA_LOAD_PSB_BULK", index:"SRA_LOAD_PSB_BULK", width:80,  align:'center'},
						            {name:"CARTP_C"          , index:"CARTP_C"          , width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("CARTP_C", 1)}},
						            {name:"LVST_TRPT_YN"     , index:"LVST_TRPT_YN"     , width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
						            {name:"PVEP_DT"          , index:"PVEP_DT"          , width:80, align:'center'},
						            {name:"NA_TRPL_C"        , index:"NA_TRPL_C"        , width:70,  align:'center'},
						            {name:"ADJ_NA_TRPL_C"    , index:"ADJ_NA_TRPL_C"    , width:70,  align:'center'},    
						            {name:"DEL_YN"           , index:"DEL_YN"           , width:70,  align:'center'},
						            {name:"EDU_CPL_YN"       , index:"EDU_CPL_YN"       , width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     
                                     ];
            
        $("#grd_MmVhc").jqGrid("GridUnload");
                
        $("#grd_MmVhc").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
                
           },
        });
        $("#grd_MmVhc").jqGrid("hideCol","NA_TRPL_C");
        $("#grd_MmVhc").jqGrid("hideCol","ADJ_NA_TRPL_C");
        $("#grd_MmVhc").jqGrid("hideCol","DEL_YN");        
        //가로스크롤 있는경우 추가
        $("#grd_MmVhc .jqgfirstrow td:last-child").width($("#grd_MmVhc .jqgfirstrow td:last-child").width() - 17);
        
    } 
    
</script>
</html>