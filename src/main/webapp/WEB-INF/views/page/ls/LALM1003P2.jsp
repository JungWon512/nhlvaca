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
                        <col width="95">
                        <col width="*">
                        <col width="95">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">경매대상구분</th>
                            <td>
                                <select id="auc_obj_dsc" disabled="disabled"></select>
                            </td>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
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
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
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
       $( "#auc_obj_dsc" ).val('1').prop("selected",true);  
       $( "#auc_dt" ).datepicker().datepicker("setDate", pageInfo.param.auc_dt);
       
       fn_Search();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){     
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM1003P4_selList", "POST");        
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
         $('#grd_CowBun').editCell( v_selrow , 0 , true); 
         var ids = $('#grd_CowBun').jqGrid('getDataIDs');
         for (var i = 0, len = ids.length; i < len; i++) {
        	 
             var rowData = $('#grd_CowBun').jqGrid('getRowData', ids[i]);
             if(rowData._STATUS_ != "*" && rowData._STATUS_ != "+")continue;            
             //예장접종일:VACN_DT 
             if(fn_isNull(rowData.VACN_DT) == false && fn_isDate(rowData.VACN_DT) == false){
                 var VACN_DT_index = fn_GridColByName('grd_CowBun', 'VACN_DT');
                 MessagePopup("OK", "예장접종일이 올바르지 않습니다.",function(res){
                     setTimeout("$('#grd_CowBun').editCell(" + ids[i] + "," + VACN_DT_index + ", true);", 100);                     
                 });
                 return;                 
             }
             //브루셀라검사일:BRCL_ISP_DT
             if(fn_isNull(rowData.BRCL_ISP_DT) == false && fn_isDate(rowData.BRCL_ISP_DT) == false){
                 var BRCL_ISP_DT_index = fn_GridColByName('grd_CowBun', 'BRCL_ISP_DT');
                 MessagePopup("OK", "브루셀라검사일이 올바르지 않습니다.",function(res){
                     setTimeout("$('#grd_CowBun').editCell(" + ids[i] + "," + BRCL_ISP_DT_index + ", true);", 100);                     
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
                             
                     result = sendAjax(insDataObj, "/LALM1003P2_updCow", "POST");
                     
                     if(result.status == RETURN_SUCCESS){
                         MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                             fn_Search();
                         });
                     }else {
                         showErrorMessage(result);
                         return;
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
    
    
    
    //그리드 생성
    function fn_CreateGrid(data){              

        var v_before_VACN_DT;
        var v_before_BRCL_ISP_DT;
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = [""
                                      ,"경매일자","상태"
                                      ,"경매대상","경매번호","농가명","귀표번호","대표번호","친자검사여부","친자일치","예방접종일","브루셀라검사일","비고내용","추가운송비","사료대금","당일접수비","여부","금액","여부","금액" ];        
        var searchResultColModel = [
                                     {name:"_STATUS_",           index:"_STATUS_",           width:10,  align:'center'},
                                     

                                     {name:"AUC_DT",             index:"AUC_DT",             width:80,  align:'center', hidden:true},
                                     {name:"SEL_STS_DSC",        index:"SEL_STS_DSC",        width:80,  align:'center', hidden:true},

                                     
                                     {name:"AUC_OBJ_DSC",        index:"AUC_OBJ_DSC",        width:70,  align:'center', edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
                                     {name:"AUC_PRG_SQ",         index:"AUC_PRG_SQ",         width:40,  align:'center'},
                                     {name:"FTSNM",              index:"FTSNM",              width:80,  align:'center'},
                                     {name:"SRA_INDV_AMNNO",     index:"SRA_INDV_AMNNO",     width:110, align:'center', formatter:'gridIndvFormat'},
                                     {name:"SRA_INDV_AMNNO4",    index:"SRA_INDV_AMNNO4",    width:70,  align:'center'},
                                     {name:"DNA_YN_CHK",         index:"DNA_YN_CHK",         width:80,  align:'center'   ,editable:true, edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},        
                                     {name:"DNA_YN",     index:"DNA_YN",     width:80,  align:'center', editable:true, edittype:"select", formatter:"select",
                                  	   editoptions:{
                                  		   value:GRID_DNA_YN_DATA,
                                             dataEvents:[{type:'change',fn:function(e){
                                          	   var v_ppgcow_fee_dsc = $(this).val();
                                          	   var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                         	   fn_GridPpgcowFeeDscChange(v_selrow, v_ppgcow_fee_dsc);                                          	   
                                             }}]
                                         }
                                     },
                                     {name:"VACN_DT",            index:"VACN_DT",            width:100,  align:'center', editable:true, formatter:'gridDateFormat',
                                            editoptions:{
                                                dataInit:function(e){$(e).datepicker({
                                                    onSelect:function(text,obj){
                                                        var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                        var v_VACN_DT = $(this).val();   
                                                        $("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','VACN_DT'));
                                                        fn_setGridStatus('grd_CowBun',v_selrow, v_before_VACN_DT , v_VACN_DT);
                                                    }
                                                }).addClass('date');},
                                                maxlength:"10",
                                                dataEvents:[
                                                {type:'keyup',fn:function(e){
                                                    var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                    var v_VACN_DT = $(this).val();   
                                                    if(fn_isDate(v_VACN_DT)){
                                                        $("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','VACN_DT'));                                                        
                                                    }
                                                    fn_setGridStatus('grd_CowBun',v_selrow, v_before_VACN_DT , v_VACN_DT);
                                                }}]
                                            }
                                     },
                                     {name:"BRCL_ISP_DT",        index:"BRCL_ISP_DT",        width:100,  align:'center', editable:true, formatter:'gridDateFormat',
                                    	 editoptions:{
                                             dataInit:function(e){$(e).datepicker({
                                                 onSelect:function(text,obj){
                                                     var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                     var v_BRCL_ISP_DT = $(this).val();   
                                                     $("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','BRCL_ISP_DT'));
                                                     fn_setGridStatus('grd_CowBun',v_selrow, v_before_BRCL_ISP_DT , v_BRCL_ISP_DT);
                                                 }
                                             }).addClass('date');},
                                             maxlength:"10",
                                             dataEvents:[
                                             {type:'keyup',fn:function(e){
                                                 var v_selrow = $("#grd_CowBun").getGridParam('selrow');
                                                 var v_BRCL_ISP_DT = $(this).val();   
                                                 if(fn_isDate(v_BRCL_ISP_DT)){
                                                     $("#grd_CowBun").jqGrid("saveCell", v_selrow, fn_GridColByName('grd_CowBun','BRCL_ISP_DT'));                                                     
                                                 }
                                                 fn_setGridStatus('grd_CowBun',v_selrow, v_before_BRCL_ISP_DT , v_BRCL_ISP_DT);
                                             }}]
                                         }
                                     },
                                     {name:"RMK_CNTN",           index:"RMK_CNTN",           width:160, align:'left', editable:true,   },
                                     {name:"SRA_TRPCS",          index:"SRA_TRPCS",          width:90,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                         editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"8",
                                          }
                                     },
                                     {name:"SRA_FED_SPY_AM",     index:"SRA_FED_SPY_AM",     width:90,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                         editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"8",
                                          }
                                     },
                                     {name:"TD_RC_CST",          index:"TD_RC_CST",          width:90,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                         editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"8",
                                          }
                                     },
                                     {name:"FEE_CHK_YN",         index:"FEE_CHK_YN",         width:50,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"FEE_CHK_YN_FEE",     index:"FEE_CHK_YN_FEE",     width:90,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                         editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"8",
                                          }
                                     },
                                     {name:"SELFEE_CHK_YN",      index:"SELFEE_CHK_YN",      width:50,  align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                     {name:"SELFEE_CHK_YN_FEE",  index:"SELFEE_CHK_YN_FEE",  width:110, align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                         editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"8",
                                          }
                                     },
                                     
                                     ];
            
        $("#grd_CowBun").jqGrid("GridUnload");
                
        $("#grd_CowBun").jqGrid({
            datatype:    "local",
            data:        data,
            height:      320,
            rowNum:      rowNoValue,
            cellEdit:    true,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            cellsubmit:  "clientArray",
            gridComplete:function(){
                $("#grd_CowBun").undelegate("input[type=checkbox]","change");
                $("#grd_CowBun").delegate("input[type=checkbox]","change",function(e){
                	
                    var gridId = $("#grd_CowBun").prop("id");
                    var rowId = $(this).closest("tr").prop("id");
                    var colId = $(this).closest("td").attr("aria-describedby").substring(gridId.length+1);

                    var value = "0";
                    if($(this).prop("checked") == true)value = "1";
                    $("#grd_CowBun").jqGrid('setCell', rowId, colId, value);
                    
                    if(colId == 'FEE_CHK_YN'){
                        if($('#grd_CowBun').jqGrid('getCell', rowId, colId) != '1'){
                            $('#grd_CowBun').jqGrid('setCell', rowId, "FEE_CHK_YN_FEE", null,"not-editable-cell");
                        }else {
                        	var colIndex = fn_GridColByName('grd_CowBun','FEE_CHK_YN_FEE');
                        	$('#grd_CowBun tr').eq(rowId).children("td:eq("+colIndex+")").removeClass('not-editable-cell');
                        } 
                    }
                    if(colId == 'SELFEE_CHK_YN'){
                        if($('#grd_CowBun').jqGrid('getCell', rowId, colId) != '1'){
                            $('#grd_CowBun').jqGrid('setCell', rowId, "SELFEE_CHK_YN_FEE", null,"not-editable-cell");
                        }else {
                            var colIndex = fn_GridColByName('grd_CowBun','SELFEE_CHK_YN_FEE');
                            $('#grd_CowBun tr').eq(rowId).children("td:eq("+colIndex+")").removeClass('not-editable-cell');
                        } 
                    }
                    
                    fn_setGridStatus('grd_CowBun',rowId, '0', '1');
                });
            },
            afterInsertRow:function(rowid, rowdata, rowelem){
                var v_sel_sts_dsc = $("#grd_CowBun").jqGrid('getCell', rowid, 'SEL_STS_DSC');
                var colModel    = $('#grd_CowBun').jqGrid('getGridParam', 'colModel');
                if(v_sel_sts_dsc == '22'){
                    for (var i = 0, len = colModel.length; i < len; i++) {
                    	if (colModel[i].hidden === true) {
                    		continue;
                    	}
                    	if(String(colModel[i].formatoptions) != 'undefined' && colModel[i].formatoptions.disabled == false){
                    		$('#grd_CowBun tr').eq(rowid).children("td:eq("+i+")").find('input[type=checkbox]').attr('disabled','disabled');
                    	}
                    	if(colModel[i].editable == true){
                    		$('#grd_CowBun').jqGrid('setCell', rowid, colModel[i].name, "","not-editable-cell");
                    	}
                    }
                }else {
                	for (var i = 0, len = colModel.length; i < len; i++) {
                        if (colModel[i].hidden === true) {
                            continue;
                        }
                        if(colModel[i].name == 'FEE_CHK_YN'){
                        	if($('#grd_CowBun').jqGrid('getCell', rowid, colModel[i].name) != '1'){
                        		$('#grd_CowBun').jqGrid('setCell', rowid, "FEE_CHK_YN_FEE", null,"not-editable-cell");
                        	} 
                        }
                        if(colModel[i].name == 'SELFEE_CHK_YN'){
                            if($('#grd_CowBun').jqGrid('getCell', rowid, colModel[i].name) != '1'){
                                $('#grd_CowBun').jqGrid('setCell', rowid, "SELFEE_CHK_YN_FEE", null,"not-editable-cell");
                            } 
                        }
                        
                    }
                }
            },
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  
                
                if(cellname == 'VACN_DT' || cellname =='BRCL_ISP_DT'){
                	if(cellname == 'VACN_DT')v_before_VACN_DT= value;
                	else if(cellname == 'BRCL_ISP_DT')v_before_BRCL_ISP_DT = value; ;
                    
                }else{
                    $("#"+rowid+"_"+cellname).on('blur',function(e){
                        $("#grd_CowBun").jqGrid("saveCell", iRow, iCol);
                        fn_setGridStatus('grd_CowBun',rowid, $(this).val(), value);
                    }).on('keydown',function(e){
                        var code = e.keyCode || e.which;
                        if(code == 13){
                            e.preventDefault();
                            $("#grd_CowBun").jqGrid("saveCell", iRow, iCol);
                            fn_setGridStatus('grd_CowBun',rowid, $(this).val(), value);

                        }                        
                    });
                }
                    
                                 
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_CowBun").jqGrid("setGroupHeaders", {
            useColSpanStyle:true,
            groupHeaders:[
              {startColumnName:"FEE_CHK_YN", numberOfColumns: 2, titleText: '출하수수료 수기등록'},
              {startColumnName:"SELFEE_CHK_YN", numberOfColumns: 2, titleText: '판매수수료수기등록'}
              ]
           }); 
        //행번호
        $("#grd_CowBun").jqGrid("setLabel", "rn","No");     
        //가로스크롤 있는경우 추가
        $("#grd_CowBun .jqgfirstrow td:last-child").width($("#grd_CowBun .jqgfirstrow td:last-child").width() - 17);
        
    }
    
    
    
    
    
</script>
</html>