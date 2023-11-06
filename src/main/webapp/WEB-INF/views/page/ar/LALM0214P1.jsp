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
                        <col width="70">
                        <col width="*">
                        <col width="70">
                        <col width="*">
                        <col width="70">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">경매대상</th>
                            <td>
                                <select id="auc_obj_dsc"></select>
                            </td>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th class="tb_dot">출하주</th>
                            <td>
                                <div class="cellBox">
                                     <div class="cell" style="width:40px;">
                                         <input disabled="disabled" type="text" id="fhs_id_no" maxlength="10">                                             
                                     </div>
                                     <div class="cell pl2" style="width:26px;">
                                         <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                     </div>
                                     <div class="cell">
                                         <input type="text" id="ftsnm" maxlength="30">
                                     </div>
                                 </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
            <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 출하주 별 출력시 출하주 검색후 조회하세요.</label> 
                <button class="tb_btn" id="pb_ReceiptReport">접수증 출력</button>
            </div>  
        </div>
        
        <div class="listTable mb0">           
            <table id="grd_CowBun">
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
    	/******************************
         * 초기값 설정
         ******************************/ 
        fn_CreateGrid();                
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
        
        fn_Init();
        
        /******************************
         * 농가검색 팝업
         ******************************/
        $("#ftsnm").keydown(function(e){           
            if(e.keyCode == 13){
                if(fn_isNull($("#ftsnm").val())){
                    MessagePopup('OK','출하주 명을 입력하세요.');
                    return;
                }else {
                    var data = new Object();
                    data['ftsnm'] = $("#ftsnm").val();
                    fn_CallFtsnmPopup(data,true,function(result){
                        if(result){
                            $("#fhs_id_no").val(result.FHS_ID_NO);
                            $("#ftsnm").val(result.FTSNM);
                        }
                    });
                }
             }else {
                 $("#fhs_id_no").val('');
             }
        });
        
        
        $("#pb_searchFhs").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_CallFtsnmPopup(null,false,function(result){
                if(result){
                    $("#fhs_id_no").val(result.FHS_ID_NO);
                    $("#ftsnm").val(result.FTSNM);
                }
            });
        });
        
        
        /******************************
         * 접수증 출력
         ******************************/  
        $("#pb_ReceiptReport").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var TitleData = new Object();
            TitleData.title = "경매우접수증";
            TitleData.sub_title = "";
            TitleData.unit = "";
            TitleData.srch_condition =  "";            
            //그리드 값 가져오기
            gridSaveRow('grd_CowBun');

            var colModel    = $('#grd_CowBun').jqGrid('getGridParam', 'colModel');
                
            for (var i = 0, len = colModel.length; i < len; i++) {
               if (colModel[i].hidden === true) {
                   continue;
               }
               
               if (colModel[i].formatter == 'select') {
                   $('#grd_CowBun').jqGrid('setColProp', colModel[i].name, {
                       unformat: gridUnfmt
                   });
               }
            }
                        
            var tmpObject = new Array();
            var ids = $('#grd_CowBun').jqGrid('getDataIDs');
            for (var i = 0, len = ids.length; i < len; i++) {
               var rowId =ids[i];
               if($("input:checkbox[id='jqg_grd_CowBun_"+rowId+"']").is(":checked")){
            	   var rowdata = $("#grd_CowBun").jqGrid('getRowData', rowId);
            	   tmpObject.push(rowdata);
               }
            }
            
            for (var i = 0, len = colModel.length; i < len; i++) {
                if (colModel[i].hidden === true) {
                    continue;
                }
                
                if (colModel[i].formatter == 'select') {
                    $('#grd_CowBun').jqGrid('setColProp', colModel[i].name, {
                        unformat: gridRedoFmt
                    });
                }
            }
            
            if(App_na_bzplc == '8808990657622' ){// 홍성: 8808990657622 테스트: 8808990643625
            	ReportPopup('LALM0214R1_2',TitleData, tmpObject, 'H');//V:가로 , H:세로
            }else {
            	ReportPopup('LALM0214R1_1',TitleData, tmpObject, 'H');//V:가로 , H:세로
            }
            
            
           
        });

        
               
        
    }); 


    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
    	//그리드 초기화
         $("#grd_CowBun").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        $( "#auc_obj_dsc" ).val(pageInfo.param.auc_obj_dsc).prop("selected",true);  
        $( "#auc_dt" ).datepicker().datepicker("setDate", pageInfo.param.auc_dt);
        
        fn_Search();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){ 
    	 $("#grd_CowBun").jqGrid("clearGridData", true);
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0214P1_selList", "POST");        
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
        
        var searchResultColNames = [
        	                          "경제통합사업장명","전화번호","생년월일","최초등록일시"
        	                          ,"경매일자","경매대상","경매번호","귀표번호","성별","출하자코드","출하자명","주소","비고내용" ];        
        var searchResultColModel = [
                                     {name:"NA_BZPLNM",          index:"NA_BZPLNM",          width:80,  align:'center', hidden:true},
        	                         
                                     

                                     {name:"TEL",                index:"TEL",                width:80,  align:'center', hidden:true},
                                     {name:"BIRTH",              index:"BIRTH",              width:80,  align:'center', hidden:true},
                                     {name:"FSRG_DTM",           index:"FSRG_DTM",           width:80,  align:'center', hidden:true},


                                     {name:"AUC_DT",             index:"AUC_DT",             width:90,  align:'center', formatter:'gridDateFormat'},
        	                         {name:"AUC_OBJ_DSC",        index:"AUC_OBJ_DSC",        width:70,  align:'center', edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
                                     {name:"AUC_PRG_SQ",         index:"AUC_PRG_SQ",         width:50,  align:'center'},
                                     {name:"SRA_INDV_AMNNO",     index:"SRA_INDV_AMNNO",     width:150,  align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",         index:"INDV_SEX_C",         width:50,  align:'center', edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"FHS_ID_NO",          index:"FHS_ID_NO",          width:80,  align:'center'},
                                     {name:"FTSNM",              index:"FTSNM",              width:80,  align:'center'},
                                     {name:"DONGUP",             index:"DONGUP",             width:80,  align:'left'},
                                     {name:"RMK_CNTN",           index:"RMK_CNTN",           width:160, align:'left'},
                                     
                                     
                                     ];
            
        $("#grd_CowBun").jqGrid("GridUnload");
                
        $("#grd_CowBun").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            cellEdit:    false,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            multiselect:true,
            //multiboxonly:true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            beforeSelectRow:function(rowid,e){
            	var $myGrid = $(this);
            	var i= $.jgrid.getCellIndex($(e.target).closest('td')[0]);
            	var cm = $myGrid.jqGrid('getGridParam','colModel');
            	return (cm[i].name == 'cb');
            }
        });

        
    }
    
    
</script>
</html>