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
<style>
#gbox_grd_MhSogCow_1 .ui-jqgrid-hbox{width:100% !important; padding-right:0 !important;}
#gbox_grd_MhSogCow_1 .ui-jqgrid-bdiv{overflow-y:hidden !important;}
.ui-jqgrid tr.jqgrow{height: 30px;white-space: nowrap;}

</style>

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
        fn_CreateGrid3();
        fn_CreateSubGrid();
                
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
        //비고삭제버튼
        if(App_na_bzplc == '8808990659008'){//경주 8808990659008
        	$("#pb_CntnDel").show();
        }else {
        	$("#pb_CntnDel").hide();
        }
        //낙찰취소 출력물, 전송여부초기화
        if(App_na_bzplc == '8808990656236'){//합천 8808990656236
            $("#pb_SbidCancelReport").show();
            $("#pb_TmsYnReset").show();
        }else {
            $("#pb_SbidCancelReport").hide();
            $("#pb_TmsYnReset").hide();
        }
        
        //경매우 접수증
        if(App_na_bzplc == '8808990656588' || App_na_bzplc == '8808990657622'){//세종공주: 8808990656588 홍성: 8808990657622
        	$("#pb_AucReceipt").show();
        }else {
        	$("#pb_AucReceipt").hide();
        }
        //엑셀변환버튼사용안함
        $("#pb_ExcelConversion").hide();
//         $("#pb_ExcelUpload").hide();
        
        //귀표번호 컨트롤
        $("#sra_indv_amnno").on("keypress",function(e){           
            if(e.keyCode == 13 && fn_isNull($("#sra_indv_amnno").val()) == false){
            	fn_Search();
            }
        }).on("focus",function(e){
            this.select();
        });
        
        /******************************
         * 경매대상 변경
         ******************************/
        $("#auc_obj_dsc").bind('change',function(e){
            e.preventDefault();
            fn_ChangeAucObjDsc();
        });

        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow, #grd_MhSogCow_1,#grd_MhSogCow_2,#grd_MhSogCow3,#grd_MhCalf");
       
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
                            fn_Search();
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
                    fn_Search();
                }
            });
        });
                
        /******************************
         * 비고일괄삭제
         ******************************/
         $("#pb_CntnDel").on('click',function(e){
             e.preventDefault();
             this.blur();
             
             if ($('#grd_MhSogCow').jqGrid('getGridParam', 'reccount') == 0) {
                 MessagePopup("OK", '조회된 데이터가 없습니다.');
                 return false;
             }
             MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
                 if(res){
                     
                     var results = sendAjaxFrm("frm_Search", "/LALM0214_delCntnDel", "POST");        
                     var result;
                     
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{      
                         MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                             fn_Search();
                         });
                     }
                
                  }
             });
         });
        
        /******************************
         * 송아지정보등록
         ******************************/
        $("#pb_CalfRg").on('click',function(e){
            e.preventDefault();
            this.blur();
            var pgid = 'LALM0214P2';
            var menu_id = $("#menu_info").attr("menu_id");
            var data = new Object();
            data['auc_dt'] = $("#auc_dt").val();
            parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600,function(result){
                  //
            });
        });
                 
        /******************************
         * 번식우 감정등록
         ******************************/
        $("#pb_BreedCowRg").on('click',function(e){
            e.preventDefault();
            this.blur();
            var pgid = 'LALM0214P4';
            var menu_id = $("#menu_info").attr("menu_id");
            var data = new Object();
            data['auc_dt'] = $("#auc_dt").val();
            parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600,function(result){
            //
            });
        });         
        
        /******************************
         * 비육우 출력
         ******************************/
         $("#pb_CowReport").on('click',function(e){
             e.preventDefault();
             this.blur();
             var TitleData = new Object();
             TitleData.title = "출장우 내역 조회";
             if(App_na_bzplc == '8808990656557'){
            	 TitleData.title = "비육우 출장내역";            	 
             }
             TitleData.sub_title = "";
             TitleData.unit = "";
             TitleData.srch_condition =  '[경매일자 : '+ $('#auc_dt').val() + ']'
                                      +  '/ [경매대상 : '+ $( "#auc_obj_dsc option:selected").text()  + ']';
             var gridData = fnSetGridData('grd_MhSogCow');

             function fnSetGridData(frmId){
             
                 gridSaveRow(frmId);
                 var colModel    = $('#'+frmId).jqGrid('getGridParam', 'colModel');
                 var gridData    = $('#'+frmId).jqGrid('getGridParam', 'data');        
         		var result = new Array();        
                 if (gridData.length == 0) {
                    MessagePopup("OK", '조회된 데이터가 없습니다.');
                    return result;
                 }
         		for (var i = 0, len = colModel.length; i < len; i++) {
         		   if (colModel[i].hidden === true) {
         		       continue;
         		   }
         		   
         		   if (colModel[i].formatter == 'select') {
         		       $('#'+frmId).jqGrid('setColProp', colModel[i].name, {
         		           unformat: gridUnfmt
         		       });
         		   }
         		}
         		var index = 0;
         		$('#'+frmId).getRowData().forEach((o,i)=>{
         				//TO-DO 만월령 쿼리 추가
        			if(o.COW_SOG_WT == '0'){
        				o.COW_SOG_WT ='-';
        			}
        			
        			result.push(cloneObj(o));
         			if($('#bothPrint:checked').val() == 'Y'){
         				result.push(cloneObj(o));
         			}
         			
         			function cloneObj(source) {
         			  var target = {};
         			  for (let i in source) {			    
         			      target[i] = source[i];
         			  }
         			  return target;
         			}
         		}); 
         		
         		return result;
             }
             if(App_na_bzplc == '8808990656557'){
                 ReportPopup('LALM0214R0_0',TitleData, gridData, 'V');//V:가로 , H:세로            	 
             }else{
                 ReportPopup('LALM0214R0',TitleData, gridData, 'V');//V:가로 , H:세로            	 
             }
         });

         /******************************
          * 업로드방법 다운로드
          ******************************/
         $("#pb_ExcelUploadWay").on('click',function(e){
              e.preventDefault();
              this.blur();
              //fn_fileDownlad("NEW_엑셀업로드_순서.xlsx");
          });
         
         /******************************
          * 전체삭제 버튼클릭
          ******************************/ 
         $("#pb_AllDel").on('click',function(e){
             e.preventDefault();
             this.blur();
             if($("#auc_obj_dsc").val() == '0'){
                 MessagePopup('OK',"경매대상을 선택후 삭제하세요.");
                 return false;
             }
             MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
                 if(res){

                	 $("#chg_del_yn").val("1");
                     $("#chg_pgid").val("LALM0214");
                     $("#chg_rmk_cntn").val("전체 삭제 로그");                     
                     var results = sendAjaxFrm("frm_Search", "/LALM0214_delSogCow", "POST");        
                     var result;
                     
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{      
                    	 MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                             fn_Search();
                         });
                     }                
                  }
             });
         });
         
         /******************************
          * 낙찰취소 출력물 버튼 클릭
          ******************************/ 
         $("#pb_SbidCancelReport").on('click',function(e){
             e.preventDefault();
             this.blur();
             if(App_na_bzplc == '8808990656588'){
                 var TitleData = new Object();
                 var vtitle;
                 if($("#auc_obj_dsc").val() == '1'){
                     vtitle = "혈통송아지";
                 }else if($("#auc_obj_dsc").val() == '2'){
                     vtitle = "일반송아지";
                 }else {
                     vtitle = "큰소";
                 }
                 TitleData.title = vtitle + " " + fn_toDate($('#auc_dt').val(),"KR");
                 TitleData.sub_title = "";
                 TitleData.unit = "";
                 TitleData.srch_condition =  "";
                 
                 
                 if($("#auc_obj_dsc").val() == '3'){
                     ReportPopup('LALM0214R0_2',TitleData, 'grd_MhSogCow', 'V');//V:가로 , H:세로
                 }else {
                     ReportPopup('LALM0214R0_1',TitleData, 'grd_MhSogCow', 'V');//V:가로 , H:세로
                 }
             }
         });
         
         
         /******************************
          * 경매우접수증
          ******************************/
         $("#pb_AucReceipt").on('click',function(e){
             e.preventDefault();
             this.blur();
             var pgid = 'LALM0214P1';
             var menu_id = $("#menu_info").attr("menu_id");
             var data = new Object();
             data['auc_dt'] = $("#auc_dt").val();
             data['auc_obj_dsc'] = $("#auc_obj_dsc").val();
             parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600,function(result){
             //
             });
         });
         
         
         
         /******************************
          * 엑셀업로드 버튼 클릭
          ******************************/ 
         $("#pb_ExcelUpload").on('click',function(e){
             e.preventDefault();
             this.blur();
             var pgid = 'LALM0214P3';
             var menu_id = $("#menu_info").attr("menu_id");
             var param = {
            		 auc_obj_dsc : $('#auc_obj_dsc').val()
            		 , auc_dt : $('#auc_dt').val()
             }
             parent.layerPopupPage(pgid, menu_id, param, null, 1800, 750,function(result){
            	 if(result)fn_Search();
                 
             });
         });
         
         $('#pb_ExcelTempDownload').on('click',function(e){					
			    var pom = document.createElement('a');
			    pom.setAttribute('href', '/files/20230116_SOGCOW_EXCEL.xlsx');
			    pom.setAttribute('type', 'application/vnd.ms-excel');
			    pom.setAttribute('download', "출장우_엑셀업로드.xls");
			 
		        pom.click();
         });
         
         /******************************
          * 수수료재설정
          ******************************/ 
        $("#pb_FeeReset").on('click',function(e){
            e.preventDefault();
            this.blur();

            var exFeeSum = 0;
            var nowFeeSum = 0;
            //계산전수수료합계조회
            var result_feeImps = sendAjaxFrm("frm_Search", "/LALM0214_selFeeImps", "POST");        
            var feeImps;
              
            if(result_feeImps.status != RETURN_SUCCESS){
                showErrorMessage(result_feeImps,'NOTFOUND');
                return;
            }else{      
                feeImps = setDecrypt(result_feeImps);      
            }
            exFeeSum = Number(feeImps.FEE_SUM);
             
            var results = sendAjaxFrm("frm_Search", "/LALM0214_insFeeReset", "POST");        
            var result;
              
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
            	//계산후ㅜ수료합계조회
            	var result_feeImps2 = sendAjaxFrm("frm_Search", "/LALM0214_selFeeImps", "POST");
            	var feeImps2;
            	  
            	if(result_feeImps2.status != RETURN_SUCCESS){
            	    showErrorMessage(result_feeImps2,'NOTFOUND');
            	    return;
                }else{      
                    feeImps2 = setDecrypt(result_feeImps2);      
                }
                nowFeeSum = Number(feeImps2.FEE_SUM);
                  
                if(exFeeSum != nowFeeSum){
                	MessagePopup('OK','수수료 수정내역이 존재합니다.<br>해당 경매일, 경매대상의 수수료를 확인하세요.');
                }else {
                	MessagePopup('OK','수수료 수정내역이 존재하지 않습니다.');
                }
            }
              
        });         

        //초기화
        fn_Init();
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        $("#grd_MhSogCow_1").jqGrid("clearGridData", true);
        $("#grd_MhSogCow_2").jqGrid("clearGridData", true);
        $("#grd_MhSogCow3").jqGrid("clearGridData", true);
        $("#grd_MhSogCowH").jqGrid("clearGridData", true);
        $("#grd_MhCalf").jqGrid("clearGridData", true);

        //폼 초기화
        fn_InitFrm('frm_Search');
        if(App_na_bzplc == '8808990656588' || App_na_bzplc == '8808990659008'){// 세종공주: 8808990656588 경주 8808990659008
        	$( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:last").val()).prop("selected",true);
        }else {
            $( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:first").val()).prop("selected",true);
        }        
        fn_ChangeAucObjDsc();
        
        
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
        	MessagePopup('OK','경매대상구분을 선택하세요.',null,function(){
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
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        $("#grd_MhSogCow3").jqGrid("clearGridData", true);
        $("#grd_MhSogCowH").jqGrid("clearGridData", true);
        $("#grd_MhCalf").jqGrid("clearGridData", true);
        
        var results = sendAjaxFrm("frm_Search", "/LALM0214_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);            
            fn_CreateGrid(result);
            fn_CreateGrid3(result); 
        }
                        
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    

        $("#grd_MhSogCowH").jqGrid("clearGridData", true);
        if(App_na_bzplc=='8808990656632'){
            var gridData = $('#grd_MhSogCow').getRowData();
        	if(!gridData || gridData.length <= 0) return;
            var rowNoValue = 0;
            if(gridData != null){
                rowNoValue = gridData.length;
            }                    
            $("#grd_MhSogCowH").jqGrid({
                datatype:    "local",
                data:        gridData,
                height:      340,
                rowNum:      rowNoValue,
                resizeing:   true,
                autowidth:   false,
                shrinkToFit: false, 
                rownumbers:true,
                rownumWidth:30,
                footerrow: true,
                userDataOnFooter: true,
                colNames: ["H사업장코드","H경매일자","H원표번호","경매번호","경매대상","귀표번호","생년월일","월령","성별","계대","등록구분","KPN번호","어미귀표번호","산차","주소","성명","인공수정일자","임신 개월수","수정KPN","(송)귀표번호","(송)생년월일","(송)성별","(송)월령","비고"],
                colModel: [
         	       {name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,  height:30,  sortable:false, align:'center', hidden:true},
        	       {name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', hidden:true},
                   {name:"OSLP_NO",              index:"OSLP_NO",              width:90,  sortable:false, align:'center', hidden:true},
                   {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:50,  sortable:false, align:'center', sorttype: "number"},
                   {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                   {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                   {name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                   {name:"MTCN",                 index:"MTCN",                 width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                   {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                   {name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                   {name:"RG_DSC",               index:"RG_DSC",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                   {name:"KPN_NO",               index:"KPN_NO",               width:60,  sortable:false, align:'center'},
                   {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                   {name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right', sorttype: "number"},
                   {name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left'},
                   {name:"FTSNM",                index:"FTSNM",                width:75,  sortable:false, align:'center'},
                   {name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
                   {name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                   {name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
                   {name:"INDV_AMNNO",           index:"INDV_AMNNO",           width:120, sortable:false, align:'center', formatter:'gridIndvFormat'},
                   {name:"CALF_BIRTH",           index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                   {name:"CALF_INDV_SEX_C",      index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                   {name:"CALF_MTCN",            index:"MTCN",                 width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},                   
                   {name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'}                                     
        		]
            });
            fn_ExcelDownlad('grd_MhSogCowH', '출장우내역조회');        	
        }else if (App_na_bzplc == '8808990657622') {  // 홍성: 8808990657622
    		fn_ExcelDownlad('grd_MhSogCow3', '출장우내역조회');
    	}else{
        	var tempObj = [];
        	$('#gbox_grd_MhSogCow_1 tr.footrow:visible td:visible').each((i,o)=>{
        		tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
    		});
        	$('#gbox_grd_MhSogCow_2 tr.footrow:visible td:visible').each((i,o)=>{
        		tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
    		});
           fn_ExcelDownlad('grd_MhSogCow', '출장우내역조회',tempObj);
    	}
    } 
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //경매대상변경시 이벤트
    function fn_ChangeAucObjDsc(){
    	if($("#auc_obj_dsc").val() == '3' || $("#auc_obj_dsc").val() == '0'){
            $("#pb_BreedCowRg").show();
            $("#pb_CowReport").hide();
            $("#pb_CalfRg").hide(); 
            $("#msg_Sbid").show();
        }else if($("#auc_obj_dsc").val() == '2'){
            $("#pb_BreedCowRg").hide();
            $("#pb_CowReport").show();
            $("#pb_CalfRg").hide();  
            $("#msg_Sbid").hide();           
        }else {
            $("#pb_BreedCowRg").hide(); 
            $("#pb_CowReport").hide();
            $("#pb_CalfRg").show(); 
            $("#msg_Sbid").hide();
        }
    	$("#frm_Search").append("<input type='hidden' id='flag' name='flag' value='init' />");
    	var results = sendAjaxFrm("frm_Search", "/Common_selAucDt", "POST"); 
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        } 
        
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_toDate(result.AUC_DT));
    }
    
    //그리드 생성1
    function fn_CreateGrid(data){
        
    	var scrollPositionT	= $("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollTop();
    	var scrollPositionL	= $("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollLeft();
    	var selectId		= $("#grd_MhSogCow_1").jqGrid("getGridParam", "selrow");
    	
        var rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["H사업장코드","H경매일자","H원표번호"
        	                       ,"경매<br/>번호","경매<br/>대상","출하자<br/>코드","출하자","출하자<br>생년월일","조합원<br/>여부","관내외<br>구분","생산자","접수<br/>일자","진행<br/>상태"
                                   ,"낙찰자명","참가번호","귀표번호","성별","자가운송여부","생년월일","월령","계대","등록번호","등록구분"
                                   ,"제각여부","KPN번호","어미귀표번호","어미구분","산차","중량","수송자","수의사","예정가","낙찰단가"
                                   ,"낙찰가","브루셀라<br>검사일자","브루셀라<br>검사결과","브루셀라검사<br>증명서제출","예방접종<br>일자","예방접종<br>차수","괴사감정여부","괴사여부","임신감정여부","임신여부","임신구분","인공수정일자"
                                   ,"수정KPN","임신개월","인공수정<br>증명서제출여부","우결핵검사일","전송","주소","휴대폰번호","비고","친자검사결과","친자검사여부"
                                   ,"사료미사용여부","추가운송비","사료대금","당일접수비","브랜드명","수의사구분","고능력여부","난소적출여부","등록일시","등록자"
                                   ,"계좌번호","출자금","딸린송아지<br>귀표번호","구분"
                                  
                                  ];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",             index:"NA_BZPLC",             width:90, height:30,  sortable:false, align:'center', hidden:true},
        	                         {name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"OSLP_NO",              index:"OSLP_NO",              width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:50,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:60,  sortable:false, align:'center'},
                                     {name:"FTSNM",                index:"FTSNM",                width:75,  sortable:false, align:'center'},
                                     {name:"FHS_BIRTH",            index:"FHS_BIRTH",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MACO_YN",              index:"MACO_YN",              width:65,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC",            index:"JRDWO_DSC",            width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"SRA_PDMNM",            index:"SRA_PDMNM",            width:80,  sortable:false, align:'center'},
                                     {name:"RC_DT",                index:"RC_DT",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"SEL_STS_DSC",          index:"SEL_STS_DSC",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     
                                     {name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:80,  sortable:false, align:'center'},
                                     {name:"LVST_AUC_PTC_MN_NO",   index:"LVST_AUC_PTC_MN_NO",   width:40,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MTCN",                 index:"MTCN",                 width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_BRDSRA_RG_NO",index:"SRA_INDV_BRDSRA_RG_NO",width:60,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"RG_DSC",               index:"RG_DSC",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     
                                     {name:"RMHN_YN",              index:"RMHN_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",               index:"KPN_NO",               width:60,  sortable:false, align:'center'},
                                     {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MCOW_DSC",             index:"MCOW_DSC",             width:60,  sortable:false, align:'center', sorttype: "number", edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right', sorttype: "number"},
                                     {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:70,  sortable:false, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:80,  sortable:false, align:'center'},
                                     {name:"BRKR_NAME",            index:"BRKR_NAME",            width:80,  sortable:false, align:'center'},
                                     {name:"LOWS_SBID_LMT_AM",     index:"LOWS_SBID_LMT_AM",     width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",         index:"SRA_SBID_UPR",         width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     
                                     {name:"SRA_SBID_AM",          index:"SRA_SBID_AM",          width:70,  sortable:false, align:'right' , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRCL_ISP_DT",          index:"BRCL_ISP_DT",          width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"BRCL_ISP_RZT_C_NM",    index:"BRCL_ISP_RZT_C_NM",    width:70,  sortable:false, align:'center'},
                                     {name:"BRCL_ISP_CTFW_SMT_YN", index:"BRCL_ISP_CTFW_SMT_YN", width:90,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"VACN_DT",              index:"VACN_DT",              width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"VACN_ORDER",    	   index:"VACN_ORDER",    		 width:70,  sortable:false, align:'center'},
                                     {name:"NCSS_JUG_YN",          index:"NCSS_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"NCSS_YN",              index:"NCSS_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PRNY_YN",              index:"PRNY_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PPGCOW_FEE_DSC",       index:"PPGCOW_FEE_DSC",       width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
                                     {name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     
                                     {name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
                                     {name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"AFISM_MOD_CTFW_SMT_YN",index:"AFISM_MOD_CTFW_SMT_YN",width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"BOVINE_DT",            index:"BOVINE_DT",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"TMS_YN",               index:"TMS_YN",               width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_TMS_YN_DATA}},
                                     {name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left'},
                                     {name:"CUS_MPNO",             index:"CUS_MPNO",             width:120, sortable:false, align:'center'},
                                     {name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
                                     {name:"DNA_YN",               index:"DNA_YN",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},
                                     {name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     
                                     {name:"SRA_FED_SPY_YN",       index:"SRA_FED_SPY_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"TD_RC_CST",            index:"TD_RC_CST",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRANDNM",              index:"BRANDNM",              width:80,  sortable:false, align:'center'},
                                     {name:"PDA_ID",               index:"PDA_ID",               width:50,  sortable:false, align:'center'},
                                     {name:"EPD_YN",               index:"EPD_YN",               width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"SPAY_YN",              index:"SPAY_YN",              width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"FSRG_DTM",             index:"FSRG_DTM",             width:110, sortable:false, align:'center'},
                                     {name:"USRNM",                index:"USRNM",                width:80,  sortable:false, align:'center'},
                                     
                                     {name:"SRA_FARM_ACNO",        index:"SRA_FARM_ACNO",        width:120, sortable:false, align:'center'},
                                     {name:"SRA_PYIVA",            index:"SRA_PYIVA",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"INDV_AMNNO",           index:"INDV_AMNNO",           width:120, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"CASE_COW",             index:"CASE_COW",             width:90,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}},
                                     
                                     
                                    ];
            
        $("#grd_MhSogCow").jqGrid("GridUnload");
                
        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      340,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            onSelectRow: function(rowid, status, e){
            	var sel_data = $("#grd_MhSogCow").getRowData(rowid);
                
                var data = new Object();                
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                var Results = sendAjax(data, "/LALM0214_selCalfList", "POST");
                var Result;
                if(Results.status != RETURN_SUCCESS){
                    showErrorMessage(Results,"NOTFOUND");
                    fn_CreateSubGrid();
                    return;
                }else{      
                	Result = setDecrypt(Results);
                }
                
                fn_CreateSubGrid(Result);

            },
            ondblClickRow: function(rowid, iRow, iCol){
                var sel_data = $("#grd_MhSogCow").getRowData(rowid);
                
                var data = new Object();                
                data["na_bzplc"] = sel_data.NA_BZPLC;        
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                
                fn_OpenMenu('LALM0215',data);

            },
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        
        ///////////////////////////////////////////////////////////////////////
        //틀고정 grd
        ///////////////////////////////////////////////////////////////////////
                
        $("#grd_MhSogCow_1").jqGrid("GridUnload");
        
        $("#grd_MhSogCow_1").jqGrid({
            datatype:    "local",
            data:        data,
            height:      340,
            rowNum:      rowNoValue,
            resizeing:   false,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            onSelectRow: function(rowid, status, e){
            	$("#grd_MhSogCow_2").jqGrid('setSelection',rowid,false);
                var sel_data = $("#grd_MhSogCow_1").getRowData(rowid);
                
                var data = new Object();                
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                var Results = sendAjax(data, "/LALM0214_selCalfList", "POST");
                var Result;
                if(Results.status != RETURN_SUCCESS){
                    showErrorMessage(Results,"NOTFOUND");
                    fn_CreateSubGrid();
                    return;
                }else{      
                    Result = setDecrypt(Results);
                }
                
                fn_CreateSubGrid(Result);

            },
            ondblClickRow: function(rowid, iRow, iCol){
                var sel_data = $("#grd_MhSogCow_1").getRowData(rowid);
                
                var data = new Object();                
                data["na_bzplc"] = sel_data.NA_BZPLC;        
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                
                fn_OpenMenu('LALM0215',data);

            },
            gridComplete : function() {
            	$(".jqgrow", $("#grd_MhSogCow_1")).bind("mouseover", function(){
            		var rowId = $(this).attr("id");
            		$(".jqgrow#" + rowId, $("#grd_MhSogCow_2")).addClass("ui-state-hover");
            	})
            	.bind("mouseout", function(){
            		var rowId = $(this).attr("id");
            		$(".jqgrow#" + rowId, $("#grd_MhSogCow_2")).removeClass("ui-state-hover");
            	});
            	if (selectId != null) {
            		$("#grd_MhSogCow_1").jqGrid('setSelection',selectId,false);
            	}
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        

        //행번호
        $("#grd_MhSogCow_1").jqGrid("setLabel", "rn","No");  
        
        //출하자 생년월일 컬럼
        if(App_na_bzplc != '8808990656946'){  // 함안 :  8808990656946
            $("#grd_MhSogCow_1").jqGrid("hideCol","FHS_BIRTH");
        }else{
            $("#grd_MhSogCow_1").jqGrid("showCol","FHS_BIRTH");
        }
        
        //고정 타이틀 빼고 전부 숨김처리
        $("#grd_MhSogCow_1").jqGrid("hideCol",["TRPCS_PY_YN","BIRTH","MTCN","SRA_INDV_PASG_QCN","SRA_INDV_BRDSRA_RG_NO","RG_DSC","RMHN_YN","KPN_NO","MCOW_SRA_INDV_AMNNO","MCOW_DSC","MATIME","COW_SOG_WT","VHC_DRV_CAFFNM","BRKR_NAME","LOWS_SBID_LMT_AM","SRA_SBID_UPR","SRA_SBID_AM","BRCL_ISP_DT","BRCL_ISP_RZT_C_NM","BRCL_ISP_CTFW_SMT_YN","VACN_DT","VACN_ORDER","NCSS_JUG_YN","NCSS_YN","PRNY_JUG_YN","PRNY_YN","PPGCOW_FEE_DSC","AFISM_MOD_DT","MOD_KPN_NO","PRNY_MTCN","AFISM_MOD_CTFW_SMT_YN","BOVINE_DT","TMS_YN","DONGUP","CUS_MPNO","RMK_CNTN","DNA_YN","DNA_YN_CHK","SRA_FED_SPY_YN","SRA_TRPCS","SRA_FED_SPY_AM","TD_RC_CST","BRANDNM","PDA_ID","EPD_YN","SPAY_YN","FSRG_DTM","USRNM","SRA_FARM_ACNO","SRA_PYIVA","INDV_AMNNO","CASE_COW"]);
        
        ///////////////////////////////////////////////////////////////////////
        //스크롤 grd
        ///////////////////////////////////////////////////////////////////////
        $("#grd_MhSogCow_2").jqGrid("GridUnload");
        
        $("#grd_MhSogCow_2").jqGrid({
            datatype:    "local",
            data:        data,
            height:      340,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            footerrow: true,
            userDataOnFooter: true,
            onSelectRow: function(rowid, status, e){
                $("#grd_MhSogCow_1").jqGrid('setSelection',rowid,false);
                var sel_data = $("#grd_MhSogCow_2").getRowData(rowid);
                
                var data = new Object();                
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                var Results = sendAjax(data, "/LALM0214_selCalfList", "POST");
                var Result;
                if(Results.status != RETURN_SUCCESS){
                    showErrorMessage(Results,"NOTFOUND");
                    fn_CreateSubGrid();
                    return;
                }else{      
                    Result = setDecrypt(Results);
                }
                
                fn_CreateSubGrid(Result);

            },
            ondblClickRow: function(rowid, iRow, iCol){
                var sel_data = $("#grd_MhSogCow_2").getRowData(rowid);
                
                var data = new Object();                
                data["na_bzplc"] = sel_data.NA_BZPLC;        
                data["auc_dt"] = sel_data.AUC_DT;           
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;           
                data["oslp_no"] = sel_data.OSLP_NO;  
                
                fn_OpenMenu('LALM0215',data);
            },
            gridComplete : function() {
            	$(".jqgrow", $("#grd_MhSogCow_2")).bind("mouseover", function(){
            		var rowId = $(this).attr("id");
            		$(".jqgrow#" + rowId, $("#grd_MhSogCow_1")).addClass("ui-state-hover");
            	})
            	.bind("mouseout", function(){
            		var rowId = $(this).attr("id");
            		$(".jqgrow#" + rowId, $("#grd_MhSogCow_1")).removeClass("ui-state-hover");
            	});
            	$("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollTop(scrollPositionT);
            	$("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollLeft(scrollPositionL);
            	if (selectId != null) {
            		$("#grd_MhSogCow_2").jqGrid('setSelection',selectId,false);
            	}
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        

        //출자금 및 송아지 귀표번호 컬럼
        if(App_na_bzplc == '8808990659008'){//경주 8808990659008
            $("#grd_MhSogCow_2").jqGrid("hideCol","SRA_PYIVA");
            $("#grd_MhSogCow_2").jqGrid("showCol","INDV_AMNNO");
        }else {
            $("#grd_MhSogCow_2").jqGrid("showCol","SRA_PYIVA");
            $("#grd_MhSogCow_2").jqGrid("hideCol","INDV_AMNNO");
        }
        
        //계좌번호 컬럼 
        if (App_na_bzplc == '8808990660127' || App_na_bzplc == '8808990657622') {  // 부여: 8808990660127 홍성: 8808990657622
        	$("#grd_MhSogCow_2").jqGrid("showCol","SRA_FARM_ACNO");
        }else{
        	$("#grd_MhSogCow_2").jqGrid("hideCol","SRA_FARM_ACNO");
        }
        
        //고정 전부 숨김처리
        $("#grd_MhSogCow_2").jqGrid("hideCol",["AUC_PRG_SQ","AUC_OBJ_DSC","FHS_ID_NO","FTSNM","FHS_BIRTH","MACO_YN","JRDWO_DSC","SRA_PDMNM","RC_DT","SEL_STS_DSC","SRA_MWMNNM","LVST_AUC_PTC_MN_NO","SRA_INDV_AMNNO","INDV_SEX_C"]);
        
        
        
        
        //합계행에 가로스크롤이 있을경우 추가
        var $obj = document.getElementById('grd_MhSogCow_2');
        var $tgObj = document.getElementById('grd_MhSogCow_1');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv), $tgbDiv = $($tgObj.grid.bDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        $bDiv.scroll(function(){
            $tgbDiv.scrollTop($bDiv.scrollTop());
        });

        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow_2 .jqgfirstrow td:last-child").width($("#grd_MhSogCow .jqgfirstrow td:last-child").width() - 17);
        
        //footer        
        var gridDatatemp = $('#grd_MhSogCow').getRowData();
        var tot_sra_indv_amnno   = 0; //총두수
        var tot_cow_sog_wt = 0;       //중량등록두수
        var tot_lows_sbid_lmt_am = 0; //예정가등록수
        var am_sra_indv_amnno    = 0; //암, 미경산, 프리마틴 총두수
        var su_sra_indv_amnno    = 0; //수 총두수
        var am_lows_sbid_lmt_am  = 0; //예정가등록수 암
        var su_lows_sbid_lmt_am  = 0; //예정가등록수 수
        $.each(gridDatatemp,function(i){
            tot_sra_indv_amnno++;
        	if(gridDatatemp[i].COW_SOG_WT != 0){
        		tot_cow_sog_wt++;
        	}
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM != 0){
        		tot_lows_sbid_lmt_am++;
        		if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        			am_lows_sbid_lmt_am++;
                }else {
                	su_lows_sbid_lmt_am++;
                }
            }
        	if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        		am_sra_indv_amnno++;
            }else {
            	su_sra_indv_amnno++;
            }        	
        	
        });
        
        var arr1 = [
	        [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
              ["AUC_PRG_SQ","총두수",1 ,"String"]
             ,["AUC_OBJ_DSC",tot_sra_indv_amnno,2,"Integer"]
             ,["FTSNM","총두수(암)",3,"String"]
             ,["JRDWO_DSC",am_sra_indv_amnno,1,"Integer"]
             ,["SRA_PDMNM","총두수(수)",2,"String"]
             ,["SEL_STS_DSC",su_sra_indv_amnno,"1","Integer"]
             ,["LVST_AUC_PTC_MN_NO","중량등록두수",2,"String"]
             ,["INDV_SEX_C",tot_cow_sog_wt,1,"Integer"]                   
            ]
        ];
        
        var arr2 = [
            [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
              ["BIRTH","예정가등록수",2,"String"]
             ,["SRA_INDV_PASG_QCN",tot_lows_sbid_lmt_am,1,"Integer"]
             ,["SRA_INDV_BRDSRA_RG_NO","암",1,"String"]
             ,["RG_DSC",am_lows_sbid_lmt_am,1,"Integer"]
             ,["RMHN_YN"," 수","1","String"]
             ,["KPN_NO",su_lows_sbid_lmt_am,1,"Integer"]                    
            ]
        ];

        fn_setGridFooter('grd_MhSogCow_1', arr1); 
        fn_setGridFooter('grd_MhSogCow_2', arr2); 
        
        /* 정렬 */
        $(".ui-jqgrid-sortable").unbind('click');        
        $(".ui-jqgrid-sortable").on('click',function(e){
        	$(".s-ico").hide();
        	var tr_nm = e.target.id || e.target.offsetParent.id;
        	if(tr_nm.indexOf('jqgh_grd_MhSogCow_1') >= 0 || tr_nm.indexOf('jqgh_grd_MhSogCow_2') >= 0){
        		var sort_tr = tr_nm.replace('jqgh_grd_MhSogCow_1_','').replace('jqgh_grd_MhSogCow_2_','');
        		var before_tr = $('#grd_MhSogCow_1').jqGrid("getGridParam",'sortname');
        		var sort_order = 'asc';
        		if(sort_tr == before_tr){
        			if($('#grd_MhSogCow_1').jqGrid("getGridParam",'sortorder') == 'asc') sort_order = 'desc';
        		}        		
                $('#grd_MhSogCow_1').jqGrid("setGridParam",{sortname:sort_tr,sortorder:sort_order}).trigger('reloadGrid');
                $('#grd_MhSogCow_2').jqGrid("setGridParam",{sortname:sort_tr,sortorder:sort_order}).trigger('reloadGrid');
                
                $(this).find(".s-ico").show();
                if (sort_order == "asc") {
                	$(this).find(".s-ico").find(".ui-icon-asc").removeClass("ui-state-disabled");
                	$(this).find(".s-ico").find(".ui-icon-desc").addClass("ui-state-disabled");
                }
                else {
                	$(this).find(".s-ico").find(".ui-icon-asc").addClass("ui-state-disabled");
                	$(this).find(".s-ico").find(".ui-icon-desc").removeClass("ui-state-disabled");
                }
        	}
        });        
    }    
    
    //그리드 생성 송아지
    function fn_CreateGrid3(data){
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["경매번호","경매대상","귀표번호","성별","생년월일","월령","등록구분","KPN번호","어미귀표번호","어미구분","산차"
                                  
                                  ];        
        var searchResultColModel = [
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:40, align:'center'},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"BIRTH",                index:"BIRTH",                width:70, align:'center', formatter:'gridDateFormat'},
                                     {name:"MTCN",                 index:"MTCN",                 width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"RG_DSC",               index:"RG_DSC",               width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"KPN_NO",               index:"KPN_NO",               width:50, align:'center'},
                                     {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MCOW_DSC",             index:"MCOW_DSC",             width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"MATIME",               index:"MATIME",               width:40, align:'right'},
                                    ];
            
        $("#grd_MhSogCow3").jqGrid("GridUnload");
                
        $("#grd_MhSogCow3").jqGrid({
            datatype:    "local",
            data:        data,
            height:      40,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,            
        });
        
    }
    
    
   
    function fn_CreateSubGrid(data){
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["송아지 귀표번호", "성별", "생년월일", "KPN번호", "중량"];        
        var searchResultColModel = [
                                     {name:"SRA_INDV_AMNNO", index:"SRA_INDV_AMNNO", width:150, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",     index:"INDV_SEX_C",     width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"BIRTH",          index:"BIRTH",          width:150, align:'center', formatter:'gridDateFormat'},
                                     {name:"KPN_NO",         index:"KPN_NO",         width:150, align:'center',},
                                     {name:"COW_SOG_WT",     index:"COW_SOG_WT",     width:150, align:'right', formatter:'currency', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                    ];
            
        $("#grd_MhCalf").jqGrid("GridUnload");
                
        $("#grd_MhCalf").jqGrid({
            datatype:    "local",
            data:        data,
            height:      80,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: true, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
        });   
        
        //행번호
        $("#grd_MhCalf").jqGrid("setLabel", "rn","No");  
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
                    <input type="hidden" id="chg_del_yn"/>
                    <input type="hidden" id="chg_pgid"/>
                    <input type="hidden" id="chg_rmk_cntn"/>
                    <table>
                        <colgroup>
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상구분</th>
                                <td>
                                    <select id="auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                                <th scope="row">출하주</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:60px;">
                                             <input disabled="disabled" type="text" id="fhs_id_no" maxlength="10">                                             
                                         </div>
                                         <div class="cell pl2" style="width:28px;">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                         <div class="cell">
                                             <input type="text" id="ftsnm" maxlength="30">
                                         </div>
                                     </div>
                                </td>                              
                            </tr>
                            <tr>
                                <th scope="row">귀표번호</th>
                                <td>
                                    <input type="text" id="sra_indv_amnno" maxlength="4">                                        
                                </td>
                                <th scope="row">생산자명</th>
                                <td>
                                    <input type="text" id="sra_pdmnm"  maxlength="30" >                                        
                                </td>
                                <th scope="row">경매번호</th>
                                <td>
                                    <input type="text" id="auc_prg_sq" class="integer" maxlength="10">                                        
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
                
                
                <div class="fl_C"><!--  //버튼 모두 중앙정렬 -->   
                     
                    <button class="tb_btn" id="pb_CntnDel">비고 일괄삭제</button>
                </div>      
                              
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                     <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 낙찰된 건은 변경이 불가능 합니다.</label>
                     
                    <button class="tb_btn" id="pb_BreedCowRg">번식우 감정등록</button>
                    <button class="tb_btn" id="pb_CalfRg">송아지정보등록</button>
                    <button class="tb_btn" id="pb_CowReport">비육우 출력</button>
                </div>  
                
            </div>
            <div class="listTable mb5" style="display:none;">
                <table id="grd_MhSogCow">
                </table>
            </div>
            <div class="clearfix">
                <div style="width:860px;float:left;">
                     <div class="listTable mb30">
                         <table id="grd_MhSogCow_1">
                         </table>
                     </div>
                 </div>
                 <div style="position:absolute;width:100%;padding-left:860px;padding-right:30px;">
                      <div class="listTable">
                          <table id="grd_MhSogCow_2">
                          </table>
                      </div>
                  </div>
            </div>
            <div class="listTable" style="display:none;" >
                <table id="grd_MhSogCow3">
                </table>
            </div>
            <div class="listTable" style="display:none;" >
                <table id="grd_MhSogCowH">
                </table>
            </div>
            <div class="tab_box clearfix">
                <div class="fl_L"><!--  //버튼 모두 좌측정렬 -->   
                     
<!--                     <button class="tb_btn" id="pb_ExcelUploadWay">엑셀업로드 방법</button> -->
                    <button class="tb_btn" id="pb_FeeReset">수수료재설정</button>
                    <button class="tb_btn" id="pb_AllDel">전체삭제</button>
                    <button class="tb_btn" id="pb_SbidCancelReport">낙찰취소 출력물</button>
                    <button class="tb_btn" id="pb_TmsYnReset">전송여부초기화</button>
                    <button class="tb_btn" id="pb_AucReceipt">경매우접수증</button>
                </div>      
                              
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                     
                    <button class="tb_btn" id="pb_ExcelConversion">엑셀변환</button>
                    <button class="tb_btn" id="pb_ExcelTempDownload">엑셀 템플릿</button>
                    <button class="tb_btn" id="pb_ExcelUpload">엑셀업로드</button>
                </div> 
            </div>            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">송아지 내역</p></li>
                </ul>
            </div>
            
            <div class="listTable mb0">
                <table id="grd_MhCalf">
                </table>
            </div>
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>