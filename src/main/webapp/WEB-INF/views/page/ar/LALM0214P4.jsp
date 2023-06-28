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
                        <col width="170">
                        <col width="70">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">경매대상</th>
                            <td>
                                <select id="auc_obj_dsc" disabled="disabled"></select>
                            </td>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <td>
                                <div class="cellBox">
                                    <div class="cell">
                                        <input type="radio" id="ppgcow_fee_dsc_1" name="ppgcow_fee_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('ppgcow_fee_dsc','1');"/>
                                        <label>임신우</label>
                                    </div>                                    
                                    <div class="cell">
                                        <input type="radio" id="ppgcow_fee_dsc_2" name="ppgcow_fee_dsc_radio" value="0" onclick="javascript:fn_setChgRadio('ppgcow_fee_dsc','0');"/>
                                        <label>비임신우</label>
                                    </div>
                                </div>
                                <input type="hidden" id="ppgcow_fee_dsc">
                            </td>
                            <th class="tb_dot">수의사</th>
                            <td>
                                <div class="cellBox">
                                     <div class="cell" style="width:40px;">
                                         <input disabled="disabled" type="text" id="lvst_mkt_trpl_amnno">                                             
                                     </div>
                                     <div class="cell pl2" style="width:26px;">
                                         <button id="pb_searchVet" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                     </div>
                                     <div class="cell">
                                         <input type="text" id="brkr_name">
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
                 
                <button class="tb_btn" id="pb_DelModDt">수정일자 일괄삭제</button>
                <button class="tb_btn" id="pb_ListReport">감정 명단</button>
                <button class="tb_btn" id="pb_ConfirmReport">감정 확인서</button>
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
         * 수의사 팝업
         ******************************/
        $("#brkr_name").keydown(function(e){           
            if(e.keyCode == 13){
                if(fn_isNull($("#brkr_name").val())){
                    MessagePopup('OK','출하주 명을 입력하세요.');
                    return;
                }else {
                    var data = new Object();  
                    data['lvst_mkt_trpl_dsc'] = '1';
                    data['brkr_name'] = $("#brkr_name").val();
                    fn_CallMmTrplPopup(data,true,function(result){
                        if(result){
                            $("#lvst_mkt_trpl_amnno").val(result.LVST_MKT_TRPL_AMNNO);
                            $("#brkr_name").val(result.BRKR_NAME);
                        }
                    });
                }
             }else {
                 $("#lvst_mkt_trpl_amnno").val('');
             }
        });
        
        
        $("#pb_searchVet").on('click',function(e){
            e.preventDefault();
            this.blur();
            var data = new Object();
            data['lvst_mkt_trpl_dsc'] = '1';
            data['brkr_name'] = $("#brkr_name").val();
            fn_CallMmTrplPopup(data,false,function(result){
                if(result){
                    $("#lvst_mkt_trpl_amnno").val(result.LVST_MKT_TRPL_AMNNO);
                    $("#brkr_name").val(result.BRKR_NAME);
                }
            });
        });
        /******************************
         * 수정일자 일괄삭제
         ******************************/        
        $("#pb_DelModDt").on('click',function(){
        	var rowList = $('#grd_CowBun').getRowData()?.filter((o,i)=>{if(o.SEL_STS_DSC !='22'){o.ROWNUM=i+1; return o;}});
        	if(rowList.length > 0 ){
        		rowList .forEach((o,i) => {        			
        			$("#grd_CowBun").jqGrid('setCell', o.ROWNUM, 'AFISM_MOD_DT', null);
	        		fn_setGridStatus('grd_CowBun',o.ROWNUM, '' , o.AFISM_MOD_DT);
	        		fn_GridAfismModDtChange(o.ROWNUM, '');
        		});
        	}
        });     
        /******************************
         * 감정명단
         ******************************/        
        $("#pb_ListReport").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var TitleData = new Object();
            TitleData.title = "감정명단";
            TitleData.sub_title = "";
            TitleData.unit = "";
            TitleData.auc_dt = $('#auc_dt').val();
            TitleData.srch_condition =  '[경매일자 : '+ $('#auc_dt').val() + ']'
                                     +  '/ [경매대상 : '+ $( "#auc_obj_dsc option:selected").text()  + ']';            
            //그리드 값 가져오기
            gridSaveRow('grd_CowBun');

            
            if($('#ppgcow_fee_dsc').val() == '1'){
            	ReportPopup('LALM0214R4_1',TitleData, 'grd_CowBun', 'H');//V:가로 , H:세로
            }else {
            	ReportPopup('LALM0214R4_2',TitleData, 'grd_CowBun', 'H');//V:가로 , H:세로
            }
        });

        /******************************
         * '감정 확인서
         ******************************/  
        $("#pb_ConfirmReport").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var TitleData = new Object();
            TitleData.title = "감정 확인서";
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
            
            
            //var tmpObject = $.grep($("#grd_CowBun").jqGrid('getRowData'), function(obj){
            //    return obj.PRNY_JUG_YN == "1"  ;
            //});
            var tmpObject = new Array();
            var ids = $('#grd_CowBun').jqGrid('getDataIDs');
            var chkLenFlag = $('#grd_CowBun td.chkPrint input[type=checkbox]:checked').length > 0?false:true;

        	for(var i = 0; i < ids.length; i++) {        
                var rowdata = $("#grd_CowBun").jqGrid('getRowData', ids[i]);
                if((chkLenFlag || rowdata.CHK_PRINT === 'Yes') && rowdata.PRNY_JUG_YN == "1"){
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
            
            
            ReportPopup('LALM0214R4_3',TitleData, tmpObject, 'H');//V:가로 , H:세로
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
        $( "#auc_obj_dsc" ).val('3').prop("selected",true);  
        $( "#auc_dt" ).datepicker().datepicker("setDate", pageInfo.param.auc_dt);
        $("#ppgcow_fee_dsc").val('1'); 
        fn_setRadioChecked('ppgcow_fee_dsc');
        
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
        var results = sendAjaxFrm("frm_Search", "/LALM0214P4_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);       
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 //정합성 체크
         var v_selrow = $("#grd_CowBun").getGridParam('selrow');
         if(v_selrow) $('#grd_CowBun').editCell( v_selrow , 0 , true); 
    	 var ids = $('#grd_CowBun').jqGrid('getDataIDs');
    	 for (var i = 0, len = ids.length; i < len; i++) {
    		 var rowData = $('#grd_CowBun').jqGrid('getRowData', ids[i]);
    		 if(rowData._STATUS_ != "*" && rowData._STATUS_ != "+")continue;
             if(fn_isNull(rowData.AFISM_MOD_DT) == false && fn_isDate(rowData.AFISM_MOD_DT) == false){
            	 var AFISM_MOD_DT_index = fn_GridColByName('grd_CowBun', 'AFISM_MOD_DT');
                 MessagePopup("OK", "수정일자가 올바르지 않습니다.",function(res){
                	 setTimeout("$('#grd_CowBun').editCell(" + ids[i] + "," + AFISM_MOD_DT_index + ", true);", 100);                     
                 });
                 return;                 
             }
         }
    	 MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
             if(res){
            	 
            	 var tmpSaveObject = $.grep($("#grd_CowBun").jqGrid('getRowData'), function(obj){
            		return obj._STATUS_ == "*" || obj._STATUS_ == "+" ;
            	 });
                 
                 if(tmpSaveObject.length > 0) {
                	 
                	 var result        = null;
                                          
                     var insDataObj = new Object();     
                     insDataObj['data'] = tmpSaveObject;
                             
                     result = sendAjax(insDataObj, "/LALM0214P4_updCowBun", "POST");
                     
                     if(result.status == RETURN_SUCCESS){
                         MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                        	 fn_Search();
                         });
                     }else{      
                         result = setDecrypt(results);
                     }  
                 } else {
                     MessagePopup("OK", "변경된 내역이 없습니다.");
                     return;
                 }
                 
                    
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });      
    } 
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    function fn_check_click(id, lvl, obj, event) {
	    if(lvl == 0 && obj.checked) {
	    	var e = e||event;/* get IE event ( not passed ) */ 
		    e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
		    $("#grd_CowBun").find('td.chkPrint input[type=checkbox]').attr('checked',true);
		    
	    } else if(lvl == 0 && !obj.checked) {
	    	var e = e||event;/* get IE event ( not passed ) */ 
		    e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
		    $("#grd_CowBun").find('td.chkPrint input[type=checkbox]').attr('checked',false);
	    }
	}
    
    
    //그리드 생성
    function fn_CreateGrid(data){              
        var v_vetCodeString = fn_createVetCodeBox(null,null, "선택");
        var v_before_afism_mod_dt;
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["","H임신구분","H수정일자","H수정KPN","임신개월수","H임신감정여부","H임신여부","H괴사감정여부","H과사여부","H비고내용","H수의사"
        	                          ,"<input type='checkbox' class='grdAllCheckBox' onclick=\"fn_check_click('all', 0, this, event);\"/>","경매일자","출하자","귀표번호","전화번호","주소","생년월일","낙찰자","상태","H거래병원명"
        	                          ,"경매대상","경매번호","대표번호","성별","임신구분","수정일자","분만예정일","수정KPN","임신개월수","임신<br>감정여부","임신<br>여부","괴사<br>감정여부"," 괴사<br>여부","비고내용","수의사", ];        
        var searchResultColModel = [
        	                         {name:"_STATUS_",           index:"_STATUS_",           width:10,  align:'center'},
        	                         
        	                         {name:"V_PPGCOW_FEE_DSC",   index:"V_PPGCOW_FEE_DSC",   width:80,  align:'center', hidden:true},
                                     {name:"V_AFISM_MOD_DT",     index:"V_AFISM_MOD_DT",     width:80,  align:'center', hidden:true},
                                     {name:"V_MOD_KPN_NO",       index:"V_MOD_KPN_NO",       width:80,  align:'center', hidden:true},
                                     {name:"V_PRNY_MTCN",        index:"V_PRNY_MTCN",        width:80,  align:'center', hidden:true},
                                     {name:"V_PRNY_JUG_YN",      index:"V_PRNY_JUG_YN",      width:80,  align:'center', hidden:true},
                                     {name:"V_PRNY_YN",          index:"V_PRNY_YN",          width:80,  align:'center', hidden:true},
                                     {name:"V_NCSS_JUG_YN",      index:"V_NCSS_JUG_YN",      width:80,  align:'center', hidden:true},
                                     {name:"V_NCSS_YN",          index:"V_NCSS_YN",          width:80,  align:'center', hidden:true},
                                     {name:"EX_RMK_CNTN",        index:"EX_RMK_CNTN",        width:80,  align:'center', hidden:true},
                                     {name:"V_LVST_MKT_TRPL_AMNNO",index:"V_LVST_MKT_TRPL_AMNNO",width:80,  align:'center', hidden:true},
                                     
                                     {name:"CHK_PRINT",          index:"CHK_PRINT",        width:40,  align:'center', edittype:"checkbox", formatter:"checkbox", formatoptions:{disabled:false},classes: 'chkPrint', sortable: false},

                                     {name:"AUC_DT",             index:"AUC_DT",             width:80,  align:'center', hidden:true},
                                     {name:"FTSNM",              index:"FTSNM",              width:80,  align:'center', hidden:true},
                                     {name:"SRA_INDV_AMNNO",     index:"SRA_INDV_AMNNO",     width:80,  align:'center', hidden:true},
                                     {name:"TEL",                index:"TEL",                width:80,  align:'center', hidden:true},
                                     {name:"DONGUP",             index:"DONGUP",             width:80,  align:'center', hidden:true},
                                     {name:"BIRTH",              index:"BIRTH",              width:80,  align:'center', hidden:true},
                                     {name:"SRA_MWMNNM",         index:"SRA_MWMNNM",         width:80,  align:'center', hidden:true},
                                     {name:"SEL_STS_DSC",        index:"SEL_STS_DSC",        width:80,  align:'center', hidden:true},
                                     {name:"BRKR_NAME_HOST",     index:"BRKR_NAME_HOST",        width:80,  align:'center', hidden:true},                                     
                                     
        	                         {name:"AUC_OBJ_DSC",        index:"AUC_OBJ_DSC",        width:70,  align:'center', edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
                                     {name:"AUC_PRG_SQ",         index:"AUC_PRG_SQ",         width:50,  align:'center'},
                                     {name:"SRA_INDV_AMNNO4",    index:"SRA_INDV_AMNNO4",    width:70,  align:'center'},
                                     {name:"INDV_SEX_C",         index:"INDV_SEX_C",         width:50,  align:'center', edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"PPGCOW_FEE_DSC",     index:"PPGCOW_FEE_DSC",     width:80,  align:'center', editable:true, edittype:"select", formatter:"select",
                                    	   editoptions:{
                                    		   value:fn_setCodeString("PPGCOW_FEE_DSC", 1),
                                               dataEvents:[{type:'change',fn:function(e){
                                            	   var v_ppgcow_fee_dsc = $(this).val();
                                            	   var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                            	   fn_GridPpgcowFeeDscChange(v_selrow, v_ppgcow_fee_dsc);
                                            	   
                                               }}]
                                           }
                                     },
                                     {name:"AFISM_MOD_DT",       index:"AFISM_MOD_DT",     width:100,  align:'center', editable:true, formatter:'gridDateFormat',
                                    	    /*cellattr:function(){
                                    	    	return "class='date'";
                                    	    },*/
                                    	    editoptions:{
                                                dataInit:function(e){$(e).datepicker({
                                                	onSelect:function(text,obj){
                                                		var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                		var v_afism_mod_dt = $(this).val();   
                                                		$("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','AFISM_MOD_DT'));
                                                		fn_setGridStatus('grd_CowBun',v_selrow, v_afism_mod_dt , v_before_afism_mod_dt);
                                                		fn_GridAfismModDtChange(v_selrow, v_afism_mod_dt);
                                                	}
                                                }).addClass('date');},
                                    	    	maxlength:"10",
                                    	    	dataEvents:[
                                                {type:'keyup',fn:function(e){
                                                    var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                    var v_afism_mod_dt = $(this).val();
                                                    if(fn_isDate(v_afism_mod_dt)){
                                                    	$("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','AFISM_MOD_DT'));                                                    	
                                                    }
                                                    fn_setGridStatus('grd_CowBun',v_selrow, v_afism_mod_dt , v_before_afism_mod_dt);
                                                    fn_GridAfismModDtChange(v_selrow, v_afism_mod_dt);
                                                }}]
                                            }
                                     },
                                     {name:"PTUR_PLA_DT",        index:"PTUR_PLA_DT",        width:80,  align:'center', formatter:'gridDateFormat',},
                                     {name:"MOD_KPN_NO",         index:"MOD_KPN_NO",         width:80,  align:'center', editable:true,
                                    	 editoptions:{
                                             maxlength:"9",
                                             
                                          }
                                     },
                                     {name:"PRNY_MTCN",          index:"PRNY_MTCN",          width:50,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                    	 editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"3",
                                             dataEvents:[{type:'keyup',fn:function(e){
                                                 var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                 var v_prny_mtcn = $(this).val();
                                                 fn_GridPrnyMtcnChange(v_selrow, v_prny_mtcn);
                                             }}]
                                             
                                          }
                                     },
                                     {name:"PRNY_JUG_YN",        index:"PRNY_JUG_YN",        width:60,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"PRNY_YN",            index:"PRNY_YN",            width:50,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"NCSS_JUG_YN",        index:"NCSS_JUG_YN",        width:60,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"NCSS_YN",            index:"NCSS_YN",            width:50,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"RMK_CNTN",           index:"RMK_CNTN",           width:160, align:'left', editable:true  },
                                     {name:"LVST_MKT_TRPL_AMNNO",index:"LVST_MKT_TRPL_AMNNO",width:100, align:'center', editable:true, edittype:"select", formatter:"select",
                                    	   editoptions:{
                                    		   value:v_vetCodeString,
                                    	       dataEvents:[{type:'change',fn:function(e){
                                    	    	                                 console.log('변경');
                                    	    	                             }
                                    	       
                                    	                   }]
                                           } 
                                     },
                                     
                                     ];
            
        $("#grd_CowBun").jqGrid("GridUnload");
                
        $("#grd_CowBun").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            cellEdit:    true,
            multiselect: false,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            sortable: true,
            cellsubmit:  "clientArray",
            gridComplete:function(rowid){
            	$("#grd_CowBun").undelegate("td:not(.chkPrint) input[type=checkbox]","change");
            	$("#grd_CowBun").delegate("td:not(.chkPrint) input[type=checkbox]","change",function(e){
            		var gridId = $("#grd_CowBun").prop("id");
            		var rowId = $(this).closest("tr").prop("id");
            		var colId = $(this).closest("td").attr("aria-describedby").substring(gridId.length+1);
					if(colId ==='CHK_PRINT') return;
            		var value = "0";
            		if($(this).prop("checked") == true)value = "1";
            		$("#grd_CowBun").jqGrid('setCell', rowId, colId, value);
            		if($("#grd_CowBun").jqGrid('getCell', rowId, '_STATUS_') == '+') {
                        return;
                    }else {
                        $("#grd_CowBun").jqGrid('setCell', rowId, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);
                    }
            	});
            },
            afterInsertRow:function(rowid, rowdata, rowelem){
            	var v_sel_sts_dsc = $("#grd_CowBun").jqGrid('getCell', rowid, 'SEL_STS_DSC');
            	
            	if(v_sel_sts_dsc == '22'){
            		var colModel    = $('#grd_CowBun').jqGrid('getGridParam', 'colModel');
                    
                    for (var i = 0, len = colModel.length; i < len; i++) {
                       if (colModel[i].hidden === true) {
                           continue;
                       }
                       if(colModel[i].name !== "CHK_PRINT"){
                           if(String(colModel[i].formatoptions) != 'undefined' && colModel[i].formatoptions.disabled == false){
                        	   $('#grd_CowBun tr').eq(rowid).children("td:eq("+i+")").find('input[type=checkbox]').attr('disabled','disabled');
                           }
                           if(colModel[i].editable == true){
                        	   $('#grd_CowBun').jqGrid('setCell', rowid, colModel[i].name, "","not-editable-cell");
                           }                    	   
                       }
                    }
            	}
            },
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  
                
                if(cellname == 'AFISM_MOD_DT'){
                	v_before_afism_mod_dt = value;
                }else{
                	$("#"+rowid+"_"+cellname).on('blur',function(e){
                		$("#grd_CowBun").jqGrid("saveCell", iRow, iCol);
                		
                		fn_setGridStatus('grd_CowBun',rowid, value, $(this).val());
                	}).on('keydown',function(e){
                		var code = e.keyCode || e.which;
                        if(code == 13){
                        	e.preventDefault();
                        	$("#grd_CowBun").jqGrid("saveCell", iRow, iCol);                        	
                        	fn_setGridStatus('grd_CowBun',rowid, value, $(this).val());
                        }                        
                    });
                }
                    
                                 
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        //가로스크롤 있는경우 추가
        $("#grd_CowBun .jqgfirstrow td:last-child").width($("#grd_CowBun .jqgfirstrow td:last-child").width() - 17);

        
    }
    
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_GridPpgcowFeeDscChange
     * 2. 입 력 변 수 : v_selrow(그리드의 행 아이디)
     *                , v_ppgcow_fee_dsc(컬럼명(키값))
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
    function fn_GridPpgcowFeeDscChange(v_selrow, v_ppgcow_fee_dsc){ 
       	if(v_ppgcow_fee_dsc != '1' && v_ppgcow_fee_dsc != '3'){
        	$("#grd_CowBun").jqGrid('setCell', v_selrow, 'PTUR_PLA_DT', null);
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'AFISM_MOD_DT', null);
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_MTCN', '0');
            //$("#grd_CowBun").jqGrid('getCell', v_selrow, 'NCSS_JUG_YN').find('input[type=checkbox]').prop("checked",false);
            
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'NCSS_JUG_YN', '0');
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'NCSS_YN', '0');
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'MOD_KPN_NO', null);
            /*
            	23.05.04 경주축협 요청사항
            	임신구분 미임신으로 변경시 임신여부 체크해제(임신감정여부는 현상태 유지)
            */ 
            if(v_ppgcow_fee_dsc == '2' ){
                $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_YN', '0');            	
            }
        }else {
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'AFISM_MOD_DT', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'V_AFISM_MOD_DT'));
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'NCSS_JUG_YN', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'V_NCSS_JUG_YN'));
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'NCSS_YN', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'V_NCSS_YN'));
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'MOD_KPN_NO', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'V_MOD_KPN_NO'));
            
            fn_GridAfismModDtChange(v_selrow, $("#grd_CowBun").jqGrid('getCell', v_selrow, 'AFISM_MOD_DT'));
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_GridAfismModDtChange
     * 2. 입 력 변 수 : v_selrow(그리드의 행 아이디)
     *                , v_ppgcow_fee_dsc(값)
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
    function fn_GridAfismModDtChange(v_selrow, v_afism_mod_dt){
    	if(fn_isDate(v_afism_mod_dt)){
    		var addday = fn_getAddDay(v_afism_mod_dt,285,'YYYYMMDD');
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PTUR_PLA_DT', addday);
            //var spaday = fn_SpanDay(v_afism_mod_dt, $("#grd_CowBun").jqGrid('getCell', v_selrow, 'AUC_DT'),'Month') + 1;
            
			var aucDt		= dayjs($("#grd_CowBun").jqGrid('getCell', v_selrow, 'AUC_DT'));				// 경매일자
			var afismModDt	= dayjs(v_afism_mod_dt);			// 인공수정일자
			var prnyMtcn = aucDt.diff(afismModDt, "month") + 1
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_MTCN', prnyMtcn);
            
            
        } else {
        	$("#grd_CowBun").jqGrid('setCell', v_selrow, 'PTUR_PLA_DT', null);
        	$("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_MTCN', null);
        }  
    	fn_GridPrnyMtcnChange(v_selrow, $("#grd_CowBun").jqGrid('getCell', v_selrow, 'PRNY_MTCN'));
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_GridPrnyMtcnChange
     * 2. 입 력 변 수 : v_selrow(그리드의 행 아이디)
     *                , v_prny_mtcn(값)
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
    function fn_GridPrnyMtcnChange(v_selrow, v_prny_mtcn){
   		// 어미소 정규식 패턴
		var mcowPattern = /임신[0-9]{1,2}개월/gi;
		
		var ppgcowFeeDsc = $("#grd_CowBun").jqGrid('getCell', v_selrow, 'PPGCOW_FEE_DSC');
		
		var prnyMtcn = (v_prny_mtcn == "" || v_prny_mtcn == undefined) ? 0 : parseInt(v_prny_mtcn);
		var mcowText = "";
		if ((ppgcowFeeDsc == "1" || ppgcowFeeDsc == "3") && prnyMtcn > 0) {
			mcowText = "임신 " + prnyMtcn + "개월"
		}
		
		var rmkCntn = $("#grd_CowBun").jqGrid('getCell', v_selrow, 'RMK_CNTN');
		var arrRmkCntn = $("#grd_CowBun").jqGrid('getCell', v_selrow, 'RMK_CNTN').split(",");
		var newArrRmkCntn = [];
		if (rmkCntn.replace(/ /g, "").search(mcowPattern) == -1) {
			newArrRmkCntn = arrRmkCntn;
			if (mcowText != "") newArrRmkCntn.push(mcowText);
		}
		else {
			for (var i in arrRmkCntn) {
				if (arrRmkCntn[i].replace(/ /g, "").search(mcowPattern) == -1) {
					newArrRmkCntn.push(arrRmkCntn[i]);
					continue;
				}
				if (arrRmkCntn[i].replace(/ /g, "").search(mcowPattern) > -1) {
					newArrRmkCntn.push(arrRmkCntn[i].replace(/ /g, "").replace(mcowPattern, mcowText));
					continue;
				}
			}
			if (mcowText != "") newArrRmkCntn.push(mcowText);
		}

		const uniqueArr = newArrRmkCntn.filter((element, index) => {
			return (newArrRmkCntn.indexOf(element) === index && element != "")
		});
		
		$("#grd_CowBun").jqGrid('setCell', v_selrow, 'RMK_CNTN', uniqueArr.join(","));
    	 
        if (prnyMtcn > 0){
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_JUG_YN', '1');
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_YN', '1');
//             var v_prny_mtcn = '임신' + v_prny_mtcn + '개월';
//             if ($("#grd_CowBun").jqGrid('getCell', v_selrow, 'RMK_CNTN') == ''){
//                 $("#grd_CowBun").jqGrid('setCell', v_selrow, 'RMK_CNTN', v_prny_mtcn);
//             }else{
//                 $("#grd_CowBun").jqGrid('setCell', v_selrow, 'RMK_CNTN', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'EX_RMK_CNTN') + v_prny_mtcn);
//             }
        }
        else {
//             $("#grd_CowBun").jqGrid('setCell', v_selrow, 'RMK_CNTN', $("#grd_CowBun").jqGrid('getCell', v_selrow, 'EX_RMK_CNTN'));
            $("#grd_CowBun").jqGrid('setCell', v_selrow, 'PRNY_YN', '0');
        }        
    }
    
    
</script>
</html>