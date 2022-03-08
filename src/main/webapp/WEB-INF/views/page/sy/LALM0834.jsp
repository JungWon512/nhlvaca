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
var menuList_lvl_2;
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	$(document).ready(function(){
		
		var selDataObj = new Object();        
        selDataObj['dsc'] = '2';
        
        //그룹코드 조회
        var results = sendAjax(selDataObj, "/LALM0833_selGrpCode", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        //조회조건
        $("#wk_grp_c").empty().data('options');    
        $.each(result, function(i){
            $("#wk_grp_c").append('<option value=' + result[i].WK_GRP_C + '>' + result[i].WK_GRPNM + '</option>');
        }); 
		
		//중메뉴 받아오기
		menuList_lvl_2 = new Array();		
		$.each(parent.menuList, function(i){
			 if(parent.menuList[i].MENU_LVL_C == "2"){
				 menuList_lvl_2.push(parent.menuList[i]);
			 }
		});
		
	    fn_Init();
	    
	    /******************************
        * 셀렉트박스 변경
        ******************************/
        $(document).on("change", "#wk_grp_c, #lvl_2_menu_id", function() {
        	fn_Search();
        });
	});    
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init(){
		//중메뉴 콤보셋팅
		fn_setMenuCombo('lvl_2_menu_id');

        fn_InitFrm('frm_Search'); 
		fn_CreateGrid();
		fn_Search();
		 
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search(){                
	    
		fn_CreateGrid();
		 
		var results = sendAjaxFrm('frm_Search', "/LALM0834_selList", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
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
		 
        gridSaveRow("grd_MenuAuth");
		 
		var insData  = $("#grd_MenuAuth").getRowData();
		var colModel = $("#grd_MenuAuth").jqGrid('getGridParam', 'colModel');
				
	    $.each(insData, function(i){	    	
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[4].name).is(":checked")){
	            insData[i].AUTH_R = '1';
	    	}else{
	    		insData[i].AUTH_R = '0';
	    	}
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[5].name).is(":checked")){
                insData[i].AUTH_U = '1';
            }else{
                insData[i].AUTH_U = '0';
            }
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[6].name).is(":checked")){
                insData[i].AUTH_C = '1';
            }else{
                insData[i].AUTH_C = '0';
            }
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[7].name).is(":checked")){
                insData[i].AUTH_D = '1';
            }else{
                insData[i].AUTH_D = '0';
            }
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[8].name).is(":checked")){
                insData[i].AUTH_X = '1';
            }else{
                insData[i].AUTH_X = '0';
            }
	        if($("#grd_MenuAuth_"+ (i+1) + "_" + colModel[9].name).is(":checked")){
                insData[i].AUTH_P = '1';
            }else{
                insData[i].AUTH_P = '0';
            }
	    });
	    
	    var insDataObj = new Object();	    
	    insDataObj['data'] = insData;
	    		
	    var results = sendAjax(insDataObj, "/LALM0834_insList", "POST");
		
	    if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{
        	MessagePopup("OK", "수정되었습니다.");
        	fn_Search();
        }
		
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 삭제 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Delete (){
	    
	} 
	
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////

	//중메뉴 콤보셋팅
	function fn_setMenuCombo(p_obj){		        
        var comboList = menuList_lvl_2;            
        $("#" + p_obj).empty().data('options');
        
        $("#" + p_obj).append('<option value=' + "" + '>전체</option>');
        
        $.each(comboList, function(i){
            $("#" + p_obj).append('<option value=' + comboList[i].MENU_ID + '>' + comboList[i].MENU_NM + '</option>');
        });	    
	}	
	
	//그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["메뉴", "메뉴명", "권한그룹", "조회", "저장", "선택", "삭제", "엑셀", "인쇄",];        
        var searchResultColModel = [
                                     {name:"MENU_ID",   index:"MENU_ID",   width:40, align:'center'},
                                     {name:"MNNM_CNTN", index:"MNNM_CNTN", width:40, align:'center'},
                                     {name:"GRP_C",     index:"GRP_C",     width:40, align:'center', hidden:true},
                                     {name:'AUTH_R',    index:"AUTH_R",    width:30, align:'center', formatter: gridCboxFormat, sortable: false },
                                     {name:"AUTH_U",    index:"AUTH_U",    width:40, align:'center', formatter: gridCboxFormat, sortable: false },
                                     {name:"AUTH_C",    index:"AUTH_C",    width:40, align:'center', formatter: gridCboxFormat, sortable: false },
                                     {name:"AUTH_D",    index:"AUTH_D",    width:40, align:'center', formatter: gridCboxFormat, sortable: false },
                                     {name:"AUTH_X",    index:"AUTH_X",    width:40, align:'center', formatter: gridCboxFormat, sortable: false },
                                     {name:"AUTH_P",    index:"AUTH_P",    width:40, align:'center', formatter: gridCboxFormat, sortable: false },
                                    ];
            
        $("#grd_MenuAuth").jqGrid("GridUnload");
                
        $("#grd_MenuAuth").jqGrid({
            datatype:    "local",
            data:        data,
            height:      520,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            loadComplete : function(data){            	
            	var idArry = $("#grd_MenuAuth").jqGrid("getDataIDs");
            	for(var i = 0; i < idArry.length; i++){   
            		var ret = $("#grd_MenuAuth").getRowData(idArry[i]);            		
            		if("00" == ret.MENU_ID.substring(4,6)){
            			$("#grd_MenuAuth").setRowData(i+1, false, {background:"#FFD400"});
            		}
            	}
            },
        });

        //행번호
        $("#grd_MenuAuth").jqGrid("setLabel", "rn","No");  
        
    } 
	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_grid_cbox_onclick
     * 2. 입 력 변 수 : gid(그리드명)
     *                , rowid(그리드의 행 아이디)
     *                , colkey(컬럼명(키값))
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
	 function grid_cbox_onclick(gid, rowid, colkey){
	 	          
         var dataList = $("#grd_MenuAuth").getRowData();
         var ret      = $("#grd_MenuAuth").getRowData(rowid);
         
         if("00" == ret.MENU_ID.substring(4,6)){        	 
             $.each(dataList, function(i){            	 
            	 if(dataList[i].MENU_ID.substring(0,4) == ret.MENU_ID.substring(0,4)){            		 
            		 console.log(dataList[i].MENU_ID.substring(0,4), ret.MENU_ID.substring(0,4));            		 
            	     //체크                 	     
                     if($("#grd_MenuAuth_"+ rowid + "_" + colkey).is(":checked")){    
                         $("#grd_MenuAuth_"+ (i+1) + "_" + colkey).attr("checked", true);
                     //체크 풀기
                     }else{
                    	 $("#grd_MenuAuth_"+ (i+1) + "_" + colkey).attr("checked", false);            
                     }            	     
            	 }
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
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">권한그룹<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="wk_grp_c">
                                    </select>
                                </td>
                                <th scope="row">중메뉴</th>
                                <td>
                                    <select id="lvl_2_menu_id"></select>
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
            <div class="listTable rsp_v">
                <table id="grd_MenuAuth" style="width:1807px;">
                </table>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>