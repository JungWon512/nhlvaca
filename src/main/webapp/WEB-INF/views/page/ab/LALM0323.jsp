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
    	fn_CreateGrid(); 
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
        fn_Init();
        
        //하한가 낮추기
        $("#pb_BatPrice").on('click',function(e){
            e.preventDefault();
            this.blur();
            if($('#am_rto_dsc').val() == '1'){
            	if($( "#sbt_am" ).val() <= 0) {
                    MessagePopup('OK','예정가금액을 0보다 크게 입력하세요.',function(){
                        $( "#sbt_am" ).focus();
                    });
                    return;
                }
            }else {
            	if($( "#sbt_pmr" ).val() <= 0) {
                    MessagePopup('OK','예정가율을 0보다 크게 입력하세요.',function(){
                        $( "#sbt_pmr" ).focus();
                    });
                    return;
                }
            }
            var tmpObject = $.grep($("#grd_MhSogCow").jqGrid('getRowData'), function(obj){
                return obj.AUC_PRG_C == "0" && obj.SEL_STS_DSC != "22";
            });
            if(tmpObject.length == 0){
            	MessagePopup('OK','예정가를 낮출 건이 없습니다.');
                return;
            }
            
            MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
                if(res){
                    var result        = null;
                                         
                    var insDataObj = new Object();     
                    insDataObj['frm'] = setFrmToData('frm_input'); 
                    insDataObj['list'] = tmpObject;
                            
                    result = sendAjax(insDataObj, "/LALM0323_updBatPrice", "POST");
                    
                    if(result.status == RETURN_SUCCESS){
                        MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                            fn_Search();
                        });
                    }else {
                        showErrorMessage(result);
                        return;
                    }
                       
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            }); 
            
            
        });
        
        $("#pb_Conti").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var qcn_results = sendAjaxFrm("frm_Search", "/Common_selAucQcn", "POST");
            var qcn_result = null;
           
            if(qcn_results.status != RETURN_SUCCESS) {
                showErrorMessage(qcn_results,'NOTFOUND');
                if(qcn_results.status == NO_DATA_FOUND){
                    MessagePopup('OK','경매차수를 먼저 등록하여야 합니다.');
                }
                return;
            } else {
                qcn_result = setDecrypt(qcn_results);
                if(qcn_result[0].DDL_YN == '1'){
                	MessagePopup('OK','경매마감 되었습니다.');
                	return;
                }
            }
            
            var tmpObject = $.grep($("#grd_MhSogCow").jqGrid('getRowData'), function(obj){
                return obj.AUC_PRG_C == "1" && obj.SEL_STS_DSC != "22";
            });
            if(tmpObject.length == 0){
                MessagePopup('OK','낙찰 결정할 건이 없습니다.');
                return;
            }
            
            MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
                if(res){
                    var result        = null;
                                         
                    var insDataObj = new Object();     
                    insDataObj['list'] = tmpObject;
                            
                    result = sendAjax(insDataObj, "/LALM0323_updConti", "POST");
                    
                    if(result.status == RETURN_SUCCESS){
                        MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                            fn_Search();
                        });
                    }else {
                        showErrorMessage(result);
                        return;
                    }
                       
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            }); 
            
            
        });
        
        $("#pb_SmSel").on('click',function(e){
            e.preventDefault();
            this.blur();
            var data = new Object();
            data['auc_obj_dsc'] = $('#auc_obj_dsc').val();
            data['auc_dt'] = $('#auc_dt').val();
            fn_CallAtdrLogPopup(data,false,function(res){
            	//처리로직
            });
            
        });
        
        $(window).on('resize.jqGrid',function(){
        	$('#grd_MhSogCow').setGridWidth($('.content').width() - 17,true);
        })
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        $( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:first").val());
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
        $( "#nbfct_auc_upr_dsc" ).val(parent.envList[0]["NBFCT_AUC_UPR_DSC"]);
        $( "#calf_auc_atdr_unt_am" ).val(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
        $( "#nbfct_auc_atdr_unt_am" ).val(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
        $( "#ppgcow_auc_atdr_unt_am" ).val(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);

        fn_InitFrm('frm_input');
        $('#am_rto_dsc').val('1');
        fn_setChgRadioAmRtoDsc('1');
        fn_setRadioChecked('am_rto_dsc');
        $( "#auc_obj_dsc" ).focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        //정합성체크
        if(fn_isNull($( "#auc_obj_dsc" ).val()) == true) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val()) == true){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        
        if(fn_isDate($( "#auc_dt" ).val()) == false){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
        var qcn_results = sendAjaxFrm("frm_Search", "/Common_selAucQcn", "POST");
        var qcn_result = null;
       
        if(qcn_results.status != RETURN_SUCCESS) {
        	showErrorMessage(qcn_results,'NOTFOUND');
        	if(qcn_results.status == NO_DATA_FOUND){
        		MessagePopup('OK','경매차수가 등록되지 않았습니다.');
        	}
            return;
        } else {
        	qcn_result = setDecrypt(qcn_results);
            $('#cut_am').val(qcn_result[0].CUT_AM);
            $('#sgno_prc_dsc').val(qcn_result[0].SGNO_PRC_DSC);
        }
        
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        var results = sendAjaxFrm("frm_Search", "/LALM0323_selList", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);                 
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
        
        var searchResultColNames = ["H사업장코드","H경매일자","H원표번호","H판매상태구분","H거래인","H참여자번호","H혈통금액","H출하수수료수기적용여부","H출하수수료수기등록","H판매수수료수기적용여부","H판매수수료수기등록"
        	                       ,"H12개월이상여부","H12개월이상수수료","H번식우수수료구분코드","H사료미사용여부","H친자검사여부","H친자검사결과","H출하자조합원여부","H중도매인조합원여부"
        	                       ,"H임신감정여부","H임신여부","H괴사감정여부","H괴사여부","H운송비지급여부","H제각여부","H축산생산자명"
        	                       ,"경매번호","경매대상","귀표번호","생년월일","성별","계대","산차"
        	                       ,"어미귀표번호","어미구분","중량","예정가","응찰가","낙찰금액","낙찰차","상태"];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",            index:"NA_BZPLC",            width:100, align:'center', hidden:true},
        	                         {name:"OSLP_NO",             index:"OSLP_NO",             width:100, align:'center', hidden:true},
                                     {name:"AUC_DT",              index:"AUC_DT",              width:100, align:'center', hidden:true},
                                     {name:"SEL_STS_DSC",         index:"SEL_STS_DSC",         width:100, align:'center', hidden:true},
                                     {name:"TRMN_AMNNO",          index:"TRMN_AMNNO",          width:100, align:'center', hidden:true},
                                     {name:"LVST_AUC_PTC_MN_NO",  index:"LVST_AUC_PTC_MN_NO",  width:100, align:'center', hidden:true},
                                     {name:"BLOOD_AM",            index:"BLOOD_AM",            width:100, align:'center', hidden:true},
                                     {name:"FEE_CHK_YN",          index:"FEE_CHK_YN",          width:100, align:'center', hidden:true},
                                     {name:"FEE_CHK_YN_FEE",      index:"FEE_CHK_YN_FEE",      width:100, align:'center', hidden:true},
                                     {name:"SELFEE_CHK_YN",       index:"SELFEE_CHK_YN",       width:100, align:'center', hidden:true},
                                     {name:"SELFEE_CHK_YN_FEE",   index:"SELFEE_CHK_YN_FEE",   width:100, align:'center', hidden:true},
                                     {name:"MT12_OVR_YN",         index:"MT12_OVR_YN",         width:100, align:'center', hidden:true},
                                     {name:"MT12_OVR_FEE",        index:"MT12_OVR_FEE",        width:100, align:'center', hidden:true},
                                     {name:"PPGCOW_FEE_DSC",      index:"PPGCOW_FEE_DSC",      width:100, align:'center', hidden:true},
                                     {name:"SRA_FED_SPY_YN",      index:"SRA_FED_SPY_YN",      width:100, align:'center', hidden:true},
                                     {name:"DNA_YN_CHK",          index:"DNA_YN_CHK",          width:100, align:'center', hidden:true},
                                     {name:"DNA_YN",              index:"DNA_YN",              width:100, align:'center', hidden:true},
                                     {name:"IO_SOGMN_MACO_YN",    index:"IO_SOGMN_MACO_YN",    width:100, align:'center', hidden:true},
                                     {name:"IO_MWMN_MACO_YN",     index:"IO_MWMN_MACO_YN",     width:100, align:'center', hidden:true},
                                     {name:"PRNY_JUG_YN",         index:"PRNY_JUG_YN",         width:100, align:'center', hidden:true},
                                     {name:"PRNY_YN",             index:"PRNY_YN",             width:100, align:'center', hidden:true},
                                     {name:"NCSS_JUG_YN",         index:"NCSS_JUG_YN",         width:100, align:'center', hidden:true},
                                     {name:"NCSS_YN",             index:"NCSS_YN",             width:100, align:'center', hidden:true},
                                     {name:"TRPCS_PY_YN",         index:"TRPCS_PY_YN",         width:100, align:'center', hidden:true},
                                     {name:"RMHN_YN",             index:"RMHN_YN",             width:100, align:'center', hidden:true},
                                     {name:"SRA_PDMNM",           index:"SRA_PDMNM",           width:100, align:'center', hidden:true},
                                     
        	                         {name:"AUC_PRG_SQ",          index:"AUC_PRG_SQ",          width:60,  align:'center'},
        	                         {name:"AUC_OBJ_DSC",         index:"AUC_OBJ_DSC",         width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
        	                         {name:"SRA_INDV_AMNNO",      index:"SRA_INDV_AMNNO",      width:120, align:'center', formatter:'gridIndvFormat'},
                                     {name:"BIRTH",               index:"BIRTH",               width:100, align:'center', formatter:'gridDateFormat'},
                                     {name:"INDV_SEX_C",          index:"INDV_SEX_C",          width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",   index:"SRA_INDV_PASG_QCN",   width:60,  align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MATIME",              index:"MATIME",              width:60,  align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MCOW_SRA_INDV_AMNNO", index:"MCOW_SRA_INDV_AMNNO", width:120, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MCOW_DSC",            index:"MCOW_DSC",            width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"COW_SOG_WT",          index:"COW_SOG_WT",          width:100, align:'right', formatter:'number', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",    index:"LOWS_SBID_LMT_AM",    width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"ATDR_AM",             index:"ATDR_AM",             width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",         index:"SRA_SBID_AM",         width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_MWMNNM",          index:"SRA_MWMNNM",          width:100, align:'center',},
                                     {name:"AUC_PRG_C",           index:"AUC_PRG_C",           width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_PRG_C", 1)}},
                                    ];
            
        $("#grd_MhSogCow").jqGrid("GridUnload");
                
        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onCellSelect: function(rowid, iCol, cellcontent, e){
            	var colModel    = $('#grd_MhSogCow').jqGrid('getGridParam', 'colModel');
            	console.log(colModel[iCol].name);
            	if(colModel[iCol].name == 'AUC_PRG_C'){
                    if($('#grd_MhSogCow').getCell(rowid, 'AUC_PRG_C') == '2'){
                        var data = new Object();
                        data['auc_obj_dsc'] = $('#auc_obj_dsc').val();
                        data['auc_dt'] = $('#auc_dt').val();
                        fn_CallAtdrLogPopup(data,true,function(res){
                            //처리로직
                        });
                    }
            	}
                
            },
        });
        
        //행번호
        $("#grd_MhSogCow").jqGrid("setLabel", "rn","No");
        
        $("#grd_MhSogCow.jqgfirstrow td:last-child").width($("#grd_MhSogCow.jqgfirstrow td:last-child").width() - 17);
    }
    
    function fn_setChgRadioAmRtoDsc(p_value){
    	if(p_value == "1"){
            $('#sbt_am').removeAttr('disabled');
            $('#sbt_pmr').attr('disabled',true);
            $('#sbt_pmr').val(0);
            $('#sbt_am').focus();
    	}else {
            $('#sbt_pmr').removeAttr('disabled');
            $('#sbt_am').attr('disabled',true);
            $('#sbt_am').val(0);
            $('#sbt_pmr').focus();
    	}
    }
    
  //***************************************
  //* function   : 수기 응찰 동가 검색 팝업
  //* paramater  : p_param(object), p_flg(단건 리턴여부)
  //* result     : gridRowData
  //***************************************
  function fn_CallAtdrLogPopup(p_param,p_flg,callback){
      var pgid = 'LALM0323P';
      var menu_id = $("#menu_info").attr("menu_id");
      
      if(p_flg){
          var result;
          var resultData = sendAjax(p_param, "/LALM0323P_selList", "POST");  

          if(resultData.status != RETURN_SUCCESS){
            showErrorMessage(resultData,'NOTFOUND');
        }else{      
            result = setDecrypt(resultData);
        }
        if(result != null && result.length == 1){
              callback(result[0]);
        }else {
              parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
              callback(result);
           });
        }
      }else {
          parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
              callback(result);
          });
      }
  }
        
    
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <input type="hidden" id="nbfct_auc_upr_dsc">
                    <input type="hidden" id="calf_auc_atdr_unt_am">
                    <input type="hidden" id="nbfct_auc_atdr_unt_am">
                    <input type="hidden" id="ppgcow_auc_atdr_unt_am">
                    <input type="hidden" id="cut_am">
                    <input type="hidden" id="sgno_prc_dsc">
                    
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상구분<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">경매일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt"></div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_input" name="frm_input">
                    <input type="hidden" id="am_rto_dsc"/>
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="300">
                            <col width="100">
                            <col width="300">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">
                                    <input type="radio" id="am_rto_dsc_1" name="am_rto_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('am_rto_dsc','1');fn_setChgRadioAmRtoDsc('1');"/> 금액
                                </th>
                                <td>
                                    <input type="text" id="sbt_am" class="number" inputmode="decimal" pattern="\d*">
                                </td>
                                <th scope="row">
                                    <input type="radio" id="am_rto_dsc_2" name="am_rto_dsc_radio" value="2" onclick="javascript:fn_setChgRadio('am_rto_dsc','2');fn_setChgRadioAmRtoDsc('2');"/> 율
                                </th>
                                <td>
                                    <input type="text" id="sbt_pmr" class="number" inputmode="decimal" pattern="\d*">
                                </td>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell pl2" >
                                            <button id="pb_BatPrice" class="tb_btn">예정가 낮추기</button>
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
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
                   
                              
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                     
                    <button class="tb_btn" id="pb_Conti">낙찰결정</button>
                    <button class="tb_btn" id="pb_SmSel">동가조회</button>
                </div>  
                
            </div>
            
            
            <div class="listTable">
                <table id="grd_MhSogCow">
                </table>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>