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
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    $(document).ready(function(){
        fn_Init();
        
        fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 1, true, "전체");
        
    	//날짜 선택
    	$("input[name='srch_month']").change(function(){
    		var month = $(this).val();
    		var gapDay = month == "12" ? 365 * -1 : month * 30 * -1;
    		$("input[name='st_dt']").datepicker().datepicker("setDate", fn_getDay(gapDay,'YYYY-MM-DD'));
    		$("input[name='en_dt']").datepicker().datepicker("setDate", fn_getToday());
    	});
    	
    	//탭 타이틀 클릭 시
        var $tabEvtT = $('.tab_box .tab_list li a');        
 		$tabEvtT.on('click',function(){
 			$tabEvtT.removeClass('on');
 			$(this).addClass('on');
 			$(".tab_content").hide();
 			var activeTab = $(this).attr("href");
 			$(activeTab).fadeIn();
 			
 			if(activeTab.replace("#", "") =="tab1"){
 				fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 1, true, "전체");
 				$("#month_03").attr("disabled", false);
 				$(".tab1_txt").show();
 				$(".tab2_txt").hide();
 			}else{
 				fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 1, true);
 				$("#month_03").attr("disabled", true);
 				$(".tab1_txt").hide();
 				$(".tab2_txt").show();
 			}
 			
 			//검색해야 하는 영역에 대한 값도 셋팅
 			$("#srch_tab_gubun").val(activeTab.replace("#", ""));
 			
 			//탭 이동 있을 때마다 그리드 초기화
 			$("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
 	    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
 			
 			return false;
 	    });
 		
 		//경매대상 변경
 		/* $("#srch_auc_obj_dsc").bind('change',function(e){
            e.preventDefault();
            fn_ChangeAucObjDsc();
        }); */
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
    	$("input[name='st_dt']").datepicker().datepicker("setDate", fn_getDay(-30,'YYYY-MM-DD'));
     	$("input[name='en_dt']").datepicker().datepicker("setDate", fn_getToday());
     	
    	$(".tab_content").hide();
        $(".tab_content:first").show();
        
        $("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
    	
    	fn_CreateGridMhSogCowStatics();	
    	fn_CreateGridMhSogCowRowData();
    	
    	$("#srch_tab_gubun").val("tab1");
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(clearFlag){
    	var searchUrl =  ""; 
        var tabGubun = $("#srch_tab_gubun").val();
    	$("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
    	
    	//기간 설정 : 사용자접속현황은 최대 1년, 경매낙찰현황은 최대 3개월
        var st_dt = $("input[name='st_dt']").val().replaceAll("-", "");
     	var en_dt = $("input[name='en_dt']").val().replaceAll("-", "");
        var searchStMonth = new Date(st_dt.substr(0,4), st_dt.substr(4,2) - 1, st_dt.substr(6,2));
        var searchEnMonth = new Date(en_dt.substr(0,4), en_dt.substr(4,2) - 1, en_dt.substr(6,2));
		var monthDiff = searchEnMonth.getMonth() - searchStMonth.getMonth() + (12 * (searchEnMonth.getFullYear() - searchStMonth.getFullYear()));
		
        if(tabGubun == "tab1"){
        	searchUrl = "/LALM0919_selMhSogCowStaticsList";
        	
        	if(monthDiff > 12){
        		//en_dt 로부터 1년
        		$("input[name='st_dt']").val( fn_getAddDay(en_dt, -365 ,'YYYY-MM-DD'));
        	}
        }else if(tabGubun == "tab2"){
        	searchUrl = "/LALM0919_selMhSogCowRowDataList";
        	if(monthDiff > 3){
        		//en_dt 로부터 3개월
        		$("input[name='st_dt']").val( fn_getAddDay(en_dt, -90 ,'YYYY-MM-DD'));
        	}
        }
        
       	var results = sendAjaxFrm("frm_Search", searchUrl, "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            if(clearFlag != "clear"){
                showErrorMessage(results);
            }
            return;      	
        }else{
            result = setDecrypt(results);
            mv_RunMode = 2;
            if(tabGubun == "tab1"){
            	fn_CreateGridMhSogCowStatics(result);	//grd_MhSogCowStatics
            }else if(tabGubun == "tab2"){
            	fn_CreateGridMhSogCowRowData(result);	//grd_MhSogCowRowData
            }
        }                  
    } 
    
    //사용자접속현황
	function fn_CreateGridMhSogCowStatics(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["조합코드","조합명","경매일자","출장우<br/>두수", "낙찰두수", "낙찰율", "응찰참여<br/>매수인", "낙찰<br/>매수인", "참여율"];        
        var searchResultColModel = [						 
	           {name:"NA_BZPLC",	index:"NA_BZPLC",	width:100, align:'center'},                                     
	           {name:"CLNTNM",	index:"CLNTNM",	width:100, align:'center'},                                     
	           {name:"AUC_DT",   	index:"AUC_DT", 		width:80, align:'center',formatter:'gridDateFormat'},
	           {name:"FORW_CNT",   	index:"FORW_CNT",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:100, align:'center'},
	           {name:"AUC_CNT",   	index:"AUC_CNT",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"AUC_RCV_CNT",     index:"AUC_RCV_CNT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AUC_RCV_PER",     	index:"AUC_RCV_PER",      	width:100, align:'center'}
        ];
        
        $("#grd_MhSogCowStatics").jqGrid("GridUnload");
        
        $("#grd_MhSogCowStatics").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        
        $("#grd_MhSogCowStatics").jqGrid("setLabel", "rn","No");
    }
  	
  	//경매낙찰현황
    function fn_CreateGridMhSogCowRowData(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","경매대상", "경매순번", "출하자", "우편번호", "주소", "귀표번호", "생일", "산차", "계대", "KPN번호", "등록구분", "성별", "어미귀표", "어미구분", "중량(Kg)", "예정가", "낙찰가", "낙찰단가", "제각여부", "수송자", "참가번호", "낙찰자", "낙찰자<br/>연락처", "출하자수수료", "낙찰자수수료"];         
        var searchResultColModel = [						 
        	   {name:"AUC_DT",   	index:"AUC_DT", 		width:80, align:'center',formatter:'gridDateFormat'},                                   
	           {name:"AUC_OBJ_DSC",	index:"AUC_OBJ_DSC",	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},   
	           {name:"AUC_PRG_SQ",     	index:"AUC_PRG_SQ",      	width:100, align:'center'},
	           {name:"FTSNM",		index:"FTSNM",	width:80, align:'center'},
	           {name:"ZIP",   	index:"ZIP", 		width:100, align:'center'},
	           {name:"ADDRESS",   	index:"ADDRESS", 		width:100, align:'center'},
	           {name:"SRA_INDV_AMNNO",   	index:"SRA_INDV_AMNNO", 		width:100, align:'center'},
	           {name:"BIRTH",   	index:"BIRTH",    	width:100, align:'center'},                                     
	           {name:"MATIME",     index:"MATIME",      width:100, align:'center', formatter : 'integer'},
	           {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",      width:100, align:'center', formatter : 'integer'},
	           {name:"KPN_NO",     	index:"KPN_NO",      	width:100, align:'center'},
	           {name:"RG_DSC",     	index:"RG_DSC",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	           {name:"INDV_SEX_C",     	index:"INDV_SEX_C",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	           {name:"MCOW_SRA_INDV_AMNNO",     	index:"MCOW_SRA_INDV_AMNNO",      	width:100, align:'center'},
	           {name:"MCOW_DSC",     	index:"MCOW_DSC",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	           {name:"COW_SOG_WT",     	index:"COW_SOG_WT",      	width:100, align:'center', formatter : 'integer'},
	           {name:"LOWS_SBID_LMT_AM",     	index:"LOWS_SBID_LMT_AM",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SRA_SBID_AM",     	index:"SRA_SBID_AM",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SRA_SBID_UPR",     	index:"SRA_SBID_UPR",      	width:100, align:'center', formatter : 'integer'},
	           {name:"RMHN_YN",     	index:"RMHN_YN",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
	           {name:"VHC_DRV_CAFFNM",     	index:"VHC_DRV_CAFFNM",      	width:100, align:'center'},
	           {name:"LVST_AUC_PTC_MN_NO",     	index:"LVST_AUC_PTC_MN_NO",      	width:100, align:'center', formatter : 'integer'},
	           {name:"SRA_MWMNNM",     	index:"SRA_MWMNNM",      	width:100, align:'center'},
	           {name:"CUS_MPNO",     	index:"CUS_MPNO",      	width:100, align:'center'},
	           {name:"FEE_CHK_YN_FEE",     	index:"FEE_CHK_YN_FEE",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SELFEE_CHK_YN_FEE",     	index:"SELFEE_CHK_YN_FEE",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}}
        ];
        
        $("#grd_MhSogCowRowData").jqGrid("GridUnload");
        
        $("#grd_MhSogCowRowData").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MhSogCowRowData").jqGrid("setLabel", "rn","No");
    }
  	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	//탭 타이틀 클릭 시
        var tabEvt = $('.tab_box .tab_list li a.on');
    	var activeId = tabEvt.attr("id");
  		
  		if(activeId == "pb_tab1"){
	    	fn_ExcelDownlad('grd_MhSogCowStatics', '사용자접속현황');
  		}else{
	    	fn_ExcelDownlad('grd_MhSogCowRowData', '경매낙찰현황');
  		}
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    //@Deprecated
    function fn_Search_backup(clearFlag){
    	var searchUrl =  ""; 
        var tabGubun = $("#srch_tab_gubun").val();
    	$("#grd_MhSogCowCnt").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowPrice").jqGrid("clearGridData", true);
    	
        if(tabGubun == "tab1"){
        	searchUrl = "/LALM0919_selMhSogCowCntList";
        }else if(tabGubun == "tab2"){
        	searchUrl = "/LALM0919_selMhSogCowPriceList";
        }
        
       	var results = sendAjaxFrm("frm_Search", searchUrl, "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            if(clearFlag != "clear"){
                showErrorMessage(results);
            }
            return;      	
        }else{
            result = setDecrypt(results);
            mv_RunMode = 2;
            if(tabGubun == "tab1"){
	            fn_CreateGridMhSogCowCnt(result);	//grd_MhSogCowCnt
            }else if(tabGubun == "tab2"){
            	fn_CreateGridMhSogCowPrice(result);	//grd_MhSogCowPrice
            }
        }                  
    } 
    
  	//그리드 생성
  	//@Deprecated
    function fn_CreateGridMhSogCowCnt(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","총 출장두수", "송아지", "비육우", "번식우", "총 낙찰두수", "송아지","비육우", "번식우", "낙찰율"];        
        var searchResultColModel = [						 
	           {name:"AUC_DT",	index:"AUC_DT",	width:100, align:'center'},                                     
	           {name:"FORW_CNT",	index:"FORW_CNT",	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"FORW_CALF",   	index:"FORW_CALF", 		width:80, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"FORW_NBFCT",   	index:"FORW_NBFCT",    	width:80, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"FORW_PPGCOW",     index:"FORW_PPGCOW",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_CALF",     	index:"SEL_CALF",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_NBFCT",     	index:"SEL_NBFCT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PPGCOW",     	index:"SEL_PPGCOW",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:100, align:'center'}
        ];
        
        $("#grd_MhSogCowCnt").jqGrid("GridUnload");
        
        $("#grd_MhSogCowCnt").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            /* multiselect:true, */	/*체크박스 선택 가능하게끔 하는 속성*/
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            afterInsertRow : function(rowId, data){
            	$("#grd_MhSogCowCnt").setCell(rowId, 'FORW_CNT', '', {'background-color':'#ccffcc', 'border-left':'1px solid #999'});
            	$("#grd_MhSogCowCnt").setCell(rowId, 'SEL_CNT', '', {'background-color':'#ccffcc', 'border-left':'1px solid #999'});
            	$("#grd_MhSogCowCnt").setCell(rowId, 'SEL_PER', '', {'background-color':'#ffcc99', 'border-left':'1px solid #999'});
            }
        });
        
        $("#grd_MhSogCowCnt").jqGrid("setLabel", "rn","No");
    }
  	
  	//@Deprecated
    function fn_CreateGridMhSogCowPrice(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","총 출장두수", "총 낙찰두수", "낙찰율", "송아지(암) 평균 낙찰가", "송아지(수) 평균 낙찰가", "비육우(암) 평균 낙찰가", "비육우(수) 평균 낙찰가", "번식우 평균 낙찰가"];         
        var searchResultColModel = [						 
        	   {name:"AUC_DT",	index:"AUC_DT",	width:80, align:'center'},                                     
	           {name:"FORW_CNT",	index:"FORW_CNT",	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},   
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:80, align:'center'},
	           {name:"AVG_FCALF",   	index:"AVG_FCALF", 		width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_MCALF",   	index:"AVG_MCALF",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"AVG_FNBFCT",     index:"AVG_FNBFCT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_MNBFCT",     index:"AVG_MNBFCT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_PPGCOW",     	index:"AVG_PPGCOW",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}}
        ];
        
        $("#grd_MhSogCowPrice").jqGrid("GridUnload");
        
        $("#grd_MhSogCowPrice").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MhSogCowPrice").jqGrid("setLabel", "rn","No");
    }
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                	<form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="250">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="srch_auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox" id="rd_month" style="width:555px;">
                                        <div class="cell">
                                            <input type="radio" id="month_01" name="srch_month" value="1" checked="checked" onclick="javascript:fn_setChgRadio('srch_month','1');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_01">1개월</label>
                                            <input type="radio" id="month_02" name="srch_month" value="3" onclick="javascript:fn_setChgRadio('srch_month','3');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_02">3개월</label>
                                            <input type="radio" id="month_03" name="srch_month" value="12" onclick="javascript:fn_setChgRadio('srch_month','12');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_03">1년</label>
                                            
                                            <input type="text" class="date search_date" name="st_dt" id="st_dt" maxlength="10" style="width:150px;margin-left:15px;">
						        			~
						        			<input type="text" class="date search_date" name="en_dt" id="en_dt" maxlength="10" style="width:150px;">
                                        </div>
                                        
                                        <span class="tab1_txt">* 최대 1년</span>
                                    	<span class="tab2_txt" style="display:none;">* 최대 3개월</span>
                                    </div>
                                    <input type="hidden" id="srch_month" />
                                    <input type="hidden" id="srch_tab_gubun" />
                                    
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
            
            <div class="tab_box clearfix line">
				<ul class="tab_list fl_L">
					<li><a href="#tab1" id="pb_tab1" class="on">사용자접속현황</a></li>
					<li><a href="#tab2" id="pb_tab2">경매낙찰현황</a></li>
				</ul>
				
				<div class="fl_R dorm_secs_btn"><!--  //버튼 모두 우측정렬 -->
                </div>
			</div>
			
			<div id="tab1" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCowStatics" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab2" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCowRowData" style="width:100%;">
	               
	                </table>
                </div>
			</div>
        </section>
        
        
    </div>
</body>
</html>