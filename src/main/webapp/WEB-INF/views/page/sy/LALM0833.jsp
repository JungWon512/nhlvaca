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
	 var wkGrpNm="";
	$(document).ready(function(){ 
			    		
		var selDataObj = new Object();
		
		//그룹코드 조회
		var results = sendAjax(selDataObj, "/LALM0833_selGrpCode", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        wkGrpNm="";
        //조회조건
        $("#wk_grp_c").empty().data('options');
        $("#wk_grp_c").append('<option value="">전체</option>');          
        
        $.each(result, function(i){
            $("#wk_grp_c").append('<option value=' + result[i].WK_GRP_C + '>' + result[i].WK_GRPNM + '</option>');          
            wkGrpNm+=result[i].WK_GRP_C+":"+result[i].WK_GRPNM+";";
        });           
        
        //사용자정보
        $("#de_wk_grp_c").empty().data('options');        
        $.each(result, function(i){
            $("#de_wk_grp_c").append('<option value=' + result[i].WK_GRP_C + '>' + result[i].WK_GRP_C + '-'  + result[i].WK_GRPNM + '</option>');
        }); 
        
        /******************************
         * 주소 검색
         ******************************/
         $("#pb_grpAdd").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_CallGrpAddPopup(function(result){
                 if(result){
                 }
             });
         }); 
         
         /******************************
          * 사용자 검색
          ******************************/
         $("#pb_usrAdd").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_CallUserAddPopup(function(result){
            	 console.log(result);
                 if(result){
                     $('#de_usrid').val(result.USRID);
                 }
             });
         });
        
	    /******************************
        * 셀렉트박스 변경
        ******************************/
        $(document).on("change", "#wk_grp_c, #apl_sts_dsc", function() {
            $("#grd_grpUsr").jqGrid("clearGridData", true);
            fn_InitFrm('frm_Detail');
        });
	    
        $(document).on("keyup", "#usrid", function() {
            $("#grd_grpUsr").jqGrid("clearGridData", true);
            fn_InitFrm('frm_Detail');
        });
        
        fn_Init();
	    
	});    
	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Init(){        
         //그리드 초기화
         fn_CreateGrid();
         //폼 초기화
         fn_InitFrm('frm_Search');
         fn_InitFrm('frm_Detail');
         $('#pb_usrAdd').show();
         $('#de_usrid').attr('disabled',true);
         
         $( "#de_apl_st_dt" ).datepicker().datepicker("setDate", fn_getToday());
         $( "#de_apl_ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
         
     }    
 	
     /*------------------------------------------------------------------------------
      * 1. 함 수 명    : 추가 함수
      * 2. 입 력 변 수 : N/A
      * 3. 출 력 변 수 : N/A
      ------------------------------------------------------------------------------*/
     function fn_Insert(){
         fn_InitFrm('frm_Detail');
         $('#pb_usrAdd').show();
         $('#de_usrid').attr('disabled',true);
         $( "#de_apl_st_dt" ).datepicker().datepicker("setDate", fn_getToday());
         $( "#de_apl_ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
         
     }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){

    	$("#grd_grpUsr").jqGrid("clearGridData", true);
        $('#pb_usrAdd').show();
        $('#de_usrid').attr('disabled',true);
    	fn_InitFrm('frm_Detail');
    	
        var results = sendAjaxFrm("frm_Search", "/LALM0833_selList", "POST");        
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
    	          
         var sel_rowid = $("#grd_grpUsr").jqGrid("getGridParam", "selrow");        
         var sel_data  = $("#grd_grpUsr").jqGrid("getRowData", sel_rowid);
    	 
    	//정합성체크
        if($("#de_usrid").val().length < 1){
            MessagePopup("OK", "사용자아이디를 입력하세요.");
            return;
        }
        if(fn_isNull($( "#de_apl_st_dt" ).val()) == true){
            MessagePopup('OK','적용시작일자를 선택하세요.',null,function(){
                $( "#de_apl_st_dt" ).focus();
            });
            return;
        }        
        if(fn_isDate($( "#de_apl_st_dt" ).val()) == false){
            MessagePopup('OK','적용시작일자가 날짜형식에 맞지 않습니다.',null,function(){
                $( "#de_apl_st_dt" ).focus();
            });
            return;
        }
        if(fn_isNull($( "#de_apl_ed_dt" ).val()) == true){
            MessagePopup('OK','적용종료일자를 선택하세요.',null,function(){
                $( "#de_apl_ed_dt" ).focus();
            });
            return;
        }        
        if(fn_isDate($( "#de_apl_ed_dt" ).val()) == false){
            MessagePopup('OK','적용종료일자가 날짜형식에 맞지 않습니다.',null,function(){
                $( "#de_apl_ed_dt" ).focus();
            });
            return;
        }

        if(sel_data.USRID == null || (sel_data.USRID != $("#de_usrid").val() && sel_data.WK_GRP_C != $("#de_wk_grp_c").val())){
        	MessagePopup('YESNO',"신규등록하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm("frm_Detail", "/LALM0833_insUsr", "POST");        
                    var result;
                    
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "저장되었습니다.");
                        fn_Search();
                        fn_InitFrm('frm_Detail');
                    }      
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            });
        }else if(sel_data.USRID != null || (sel_data.USRID == $("#de_usrid").val() && sel_data.WK_GRP_C != $("#de_wk_grp_c").val())){
        	MessagePopup('YESNO',"수정하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm("frm_Detail", "/LALM0833_updUsr", "POST");        
                    var result;
                    
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "수정되었습니다.");
                        fn_Search();
                        fn_InitFrm('frm_Detail');
                    }      
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            });
        } 
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete (){
         
        //프로그램삭제 validation check     
        if($("#de_usrid").val() == '') {
            MessagePopup("OK", "유저아이디를 선택하세요.");
            return;
        }
        
        MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm("frm_Detail", "/LALM0833_delUsr", "POST");        
                var result;
                
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.");
                    fn_Search();
                    fn_InitFrm('frm_Detail');
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
    	
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }

        var searchResultColNames = ["그룹코드", "그룹명", "그룹사용여부", "사용자아이디", "권한상태", "적용시작일자", "적용종료일자"];        
        var searchResultColModel = [
                                     {name:"WK_GRP_C", index:"WK_GRP_C", width:20, align:'center', edittype:"select", formatter : "select", editoptions:{value:wkGrpNm}},
                                     {name:"WK_GRPNM", index:"WK_GRPNM", width:20, align:'center'},
                                     {name:"UYN",      index:"UYN",      width:20, align:'center', hidden : true},
                                     {name:"USRID",    index:"USRID",    width:20, align:'center'},
                                     {name:"APL_STS_DSC", index:"APL_STS_DSC",  width:20, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:사용;2:미사용;3:기간만료;"}},
                                     {name:"APL_ST_DT",   index:"APL_ST_DT",    width:20, align:'center', formatter:'gridDateFormat'},
                                     {name:"APL_ED_DT",   index:"APL_ED_DT",    width:20, align:'center', formatter:'gridDateFormat'},
                                    ];
        
        
        $("#grd_grpUsr").jqGrid("GridUnload");
                
        $("#grd_grpUsr").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:1,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){                                   
                var sel_data = $("#grd_grpUsr").getRowData(rowid);                
                $("#de_wk_grp_c").val(sel_data.WK_GRP_C);
                $("#de_usrid").val(sel_data.USRID);
                $("#de_apl_sts_dsc").val(sel_data.APL_STS_DSC);
                $("#de_apl_st_dt").val(fn_toDate(sel_data.APL_ST_DT));
                $("#de_apl_ed_dt").val(fn_toDate(sel_data.APL_ED_DT));
                $('#de_usrid').attr('disabled',true);
                $('#pb_usrAdd').hide();
           },
        });
        
        //행번호
        $("#grd_grpUsr").jqGrid("setLabel", "rn","No");  
        
//         $("#grd_grpUsr").jqGrid('setGroupHeaders', {useColSpanStyle:false, groupHeaders:[{startColumnName:"경제통합코드", numberOfColumns:2, titleText:"첫번째"}]});
        
        
        
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
                                <th scope="row">그룹코드<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="wk_grp_c">
                                    </select>
                                </td>
                                <th scope="row">사용자ID</th>
                                <td>
                                    <input type="text" id="usrid"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">권한상태</th>
                                <td>
                                    <select id="apl_sts_dsc">
                                        <option value="">전체</option>
                                        <option value="1">사용</option>
                                        <option value="2">미사용</option>
                                        <option value="3">기간만료</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">사용자정보</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
                    <button class="tb_btn" id="pb_grpAdd">그룹추가</button>
                </div>
            </div>
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_Detail">
	                    <table>
	                        <colgroup>
	                            <col width="120">
	                            <col width="*">
	                        </colgroup>
	                        <tbody>
	                            <tr>
	                                <th scope="row"><span class="tb_dot">사용자그룹</span></th>
	                                <td>
	                                    <select id="de_wk_grp_c">
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row"><span class="tb_dot">사용자아이디</span></th>
	                                <td>
	                                    <input type="text" id="de_usrid" style="width:80%;">
                   						<button class="tb_btn" id="pb_usrAdd">검색</button>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row"><span class="tb_dot">적용상태구분</span></th>
	                                <td>
	                                    <select id="de_apl_sts_dsc">
	                                        <option value="1">사용</option>
	                                        <option value="2">미사용</option>
	                                        <option value="3">기간만료</option>
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row"><span class="tb_dot">적용시작일자</span></th>
	                                <td>
	                                    <div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="de_apl_st_dt"></div>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th scope="row"><span class="tb_dot">적용종료일자</span></th>
	                                <td>
	                                    <div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="de_apl_ed_dt"></div>
	                                    </div>
	                                </td>
	                            </tr>
	                        </tbody>
	                    </table>
	                </form>
                </div>
            </div> 
            <div class="tab_box clearfix">
                 <ul class="tab_list" id="backdoor">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable">
                <table id="grd_grpUsr">
                </table>
            </div>
        </section>
    </div>
</body>
</html>