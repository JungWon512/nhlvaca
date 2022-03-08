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
        
        //프로그램ID 대문자 변환
        $("#pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
        });
        
        //프로그램ID 대문자 변환
        $("#de_pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
        });
        
        //프로그램ID 대문자 변환
        $("#de_btn_id").bind("keyup", function(){
            $(this).val($(this).val().padStart(2,'0'));
        });
        
        /******************************
        * 버튼 저장
        ******************************/
        $("#pb_InsBtn").bind('click',function(e){
            e.preventDefault();
            this.blur();
            fn_BtnInsBtn();
        });
        
        /******************************
         * 셀렉트박스 변경
         ******************************/
         $(document).on("keyup", "#pgid, #pgmnm", function() {
        	 $("#mainGrid").jqGrid("clearGridData", true);
             $("#subGrid").jqGrid("clearGridData", true);
             fn_InitFrm('srchFrm_detail');
         });
      
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        fn_CreateGrid();
        fn_CreateSubGrid();
        //폼 초기화
        fn_InitFrm('srchFrm_list');
        fn_InitFrm('srchFrm_detail');               
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){           

        fn_InitFrm('srchFrm_detail'); 
         
        //프로그램 리스트        
        var srchData = new Object();
        srchData["pgid"] = $("#pgid").val();
        srchData["pgmnm"] = $("#pgmnm").val();
        
        var results = sendAjax(srchData, "/LALM0832_selList", "POST");        
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
                       
        var sel_rowid = $("#mainGrid").jqGrid("getGridParam", "selrow");        
        var sel_data  = $("#mainGrid").jqGrid("getRowData", sel_rowid);   
                
        //프로그램등록 validation check     
        if($("#de_pgid").val().length < 8){
            MessagePopup("OK", "프로그램ID는 8자로 해야합니다.");
            return;
        }       
        if($("#de_pgmnm").val().length < 1){
            MessagePopup("OK", "프로그램명을 입력하세요.");
            return;
        }
        if($("#de_flnm").val().length < 1){
            MessagePopup("OK", "파일경로를 입력하세요.");
            return;
        }
                
        //신규 저장
        if(sel_data.PGID == null || sel_data.PGID != $("#de_pgid").val()){
             MessagePopup('YESNO',"신규등록 하시겠습니까?",function(res){
                 if(res){
                     var results = sendAjaxFrm('srchFrm_detail', "/LALM0832_insPgm", "POST");  
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{          
                         MessagePopup("OK", "신규등록되었습니다.");
                         fn_Search();
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
                     
        //수정
        }else if(sel_data.PGID != null || sel_data.PGID == $("#de_pgid").val()){
            
            MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('srchFrm_detail', "/LALM0832_updPgm", "POST");  
                    
                    console.log(results);
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "수정되었습니다.");
                        fn_Search();
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
        if($("#de_pgid").val() == ''){
            MessagePopup("OK", "프로그램을 선택하세요.");
            return;
        }       
        MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm('srchFrm_detail', "/LALM0832_delPgm", "POST");      
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.");
                    fn_Search();
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
    } 

    //////////////////////////////////////////////////////////////////// ////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
        
    function fn_BtnInsBtn(){

    	var tmpObject = new Array();
    	gridSaveRow('subGrid');
    	
    	var ids = $('#subGrid').jqGrid('getDataIDs');      
        for(var i = 0, len = ids.length; i < len; i++) {
            var rowId =ids[i];
            var rowdata = $("#subGrid").jqGrid('getRowData', rowId);
            rowdata["de_pgid"] = $("#de_pgid").val();
            
            tmpObject.push(rowdata);
        }
        
        var updData = new Object();
        updData["data"] = tmpObject;
    	    	
    	var results = sendAjax(updData, "/LALM0832_updPgmBtn", "POST");      
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{          
            MessagePopup("OK", "수정 되었습니다.");
            fn_Search();
        }
    	
    }
    
    //그리드 생성
    function fn_CreateGrid(data){       
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["프로그램ID", "프로그램명", "프로그램구분", "파일경로명", "사용여부",];        
        var searchResultColModel = [
                                     {name:"PGID",        index:"PGID",        width:150, align:'center'},
                                     {name:"PGMNM",       index:"PGMNM",       width:150, align:'center'},
                                     {name:"PGM_DSC",     index:"PGM_DSC",     width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:화면;2:팝업;"}},
                                     {name:"FLNM",        index:"FLNM",        width:150, align:'center'},
                                     {name:"UYN",         index:"UYN",         width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype    : "local",
            data        : data,
            height      : 250,
            rowNum      : rowNoValue,
            rownumbers  : true,
            rownumWidth : 40,
            resizeing   : true,
            autowidth   : true,
            shrinkToFit : false,            
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){      
                fn_CreateSubGrid();             
                var sel_data = $("#mainGrid").getRowData(rowid);                
                $("#de_pgid").val(sel_data.PGID);
                $("#de_pgmnm").val(sel_data.PGMNM);
                $("#de_pgm_dsc").val(sel_data.PGM_DSC);
                $("#de_flnm").val(sel_data.FLNM);
                $("#de_uyn").val(sel_data.UYN);
                var data = new Object();                
                data["pgid"] = sel_data.PGID;  
                var btnResults = sendAjax(data, "/LALM0832_selBtnList", "POST");
                var btnResult;
                if(btnResults.status != RETURN_SUCCESS){
                    showErrorMessage(btnResults);
                    return;
                }else{      
                    btnResult = setDecrypt(btnResults);
                }
                
                $("#de_btn_id").val(btnResult[0].BTN_C);
                $("#de_btn_uyn").val(btnResult[0].BTN_UYN);   
                
                fn_CreateSubGrid(btnResult);
           },
        });

        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No");  
        
    }
      
    
    function fn_CreateSubGrid(data){
                
        var searchResultColNames = ["버튼ID", "버튼권한", "사용여부"];        
        var searchResultColModel = [
                                     {name:"BTN_C",   index:"BTN_C",   width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:"001:초기화;002:조회;003:선택;004:추가;005:저장;006:삭제;007:엑셀;008:인쇄;"}},
                                     {name:"BTN_TPC", index:"BTN_TPC", width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:"A:전체;R:조회;C:등록;U:수정;D:삭제;X:엑셀;P:인쇄;"}},
                                     {name:"BTN_UYN", index:"BTN_UYN", width:50, align:'center', edittype:"checkbox", formatter:"checkbox", editoptions:{value:"1:0"}, formatoptions:{disabled:false}, sortable: false},
                                    ];
            
        $("#subGrid").jqGrid("GridUnload");
                
        $("#subGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      210,
            rownumbers:  true,
            rownumWidth : 40,
            resizeing:   true,
            shrinkToFit: false,
            colNames: searchResultColNames,  
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#subGrid").getRowData(rowid);
                $("#de_btn_id").val(sel_data.BTN_C);
                $("#de_btn_uyn").val(sel_data.BTN_UYN);
           },
         }); 

        //행번호
        $("#subGrid").jqGrid("setLabel", "rn","No");  
    }
    
    function fn_GridBtnChange(v_selrow, v_btn_uyn){
    	$("#subGrid").jqGrid('setCell', v_selrow, 'BTN_UYN', $("#subGrid").jqGrid('getCell', v_selrow, 'BTN_UYN'));
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
                    <table id="srchFrm_list">
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><span class="tb_dot">프로그램 ID</span></th>
                                <td>
                                    <input type="text" id="pgid">
                                </td>
                                <th scope="row"><span class="tb_dot">프로그램 명</span></th>
                                <td>
                                    <input type="text" id="pgmnm">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v">
                <table id="mainGrid" style="width:1807px;">
                </table>
            </div>
            <ul class="clearfix">
                <li class="fl_L allow_R m_full" style="width:50%;"><!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
                    <div class="tab_box clearfix">
                        <ul class="tab_list">
                            <li><p class="dot_allow">프로그램 상세</p></li>
                        </ul>
                    </div>                        
                    <div class="grayTable rsp_h">
                        <form id="srchFrm_detail">
                            <table>
                                <colgroup>
                                    <col width="120">
                                    <col width="*">
                                    <col width="80">
                                    <col width="80">
                                    <col width="80">
                                </colgroup>
                                <tbody>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">프로그램ID</span></th>
                                 <td>
                                    <input type="text" id="de_pgid">
                                 </td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">프로그램명</span></th>
                                       <td>
                                          <input type="text" id="de_pgmnm">
                                       </td>
                                   </tr>
                                   <tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">프로그램구분</span></th>
                                       <td>
                                           <select id="de_pgm_dsc">
                                               <option value="1">화면</option>
                                               <option value="2">팝업</option>
                                           </select>
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">파일경로명</span></th>
                                       <td>
                                          <input type="text" id="de_flnm">
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">사용여부</span></th>
                                       <td>
                                           <select id="de_uyn">
                                               <option value="1">여</option>
                                               <option value="0">부</option>
                                           </select>
                                       </td>
                                   </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
               </li>
            
               <!-- //좌 e -->
               <li class="fl_R m_full" style="width: 48%">
                   <div class="tab_box clearfix"> 
                       <ul class="tab_list fl_L">
                           <li><p class="dot_allow">버튼속성</p></li>
                       </ul>
                       <div class="fl_R"><!--  //버튼 모두 우측정렬 -->  
                           <button class="tb_btn" id="pb_InsBtn">버튼저장</button>
                       </div>
                   </div>
                   <div class="listTable">
                       <table id="subGrid" style="width:100%;">
                       </table>
                   </div>
               </li>
            </ul>
        </section>       
    </div>
</body>
</html>