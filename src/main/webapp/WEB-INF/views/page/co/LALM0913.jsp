<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp"%>
<%@ include file="/WEB-INF/common/head.jsp"%>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
</head>


<script type="text/javascript">
var g_cmpid = false;
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
        fn_Init();
        //입렵초기화 버튼 클릭
        $('#pb_Init').on('click',function(e){
        	e.preventDefault();
            this.blur();
            fn_FrmInit() ;
        	$('#pb_CmpId').attr('disabled',false);
            $('#usrid').attr('disabled',false);
            $('#strg_yn').val($( "#strg_yn option:first").val()).prop("selected",true);
            $('.pws').show();
            $('#txtPw').show();
            
            $('#btn_Save').attr('disabled',false);            
            $('#btn_Delete').attr('disabled',true);
            
            g_cmpid = false;
        });
        
        //중복확인 버튼클릭
        $('#pb_CmpId').on('click',function(e){
            e.preventDefault();
            this.blur();
            if(fn_isNull($('#usrid').val()) == true){
            	MessagePopup("OK", "사용자 ID를 입력하세요.");
            	return;
            }
            var results = sendAjaxFrm("frm_MmUsr", "/LALM0913_selUser", "POST");        
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                return;
            }else{      
                result = setDecrypt(results);
                if(result.USER_CNT == 0){
                	 MessagePopup("OK", "등록가능한 ID입니다.");
                	 g_cmpid = true;
                     return;
                }else {
                	 MessagePopup("OK", "이미등록된 ID입니다.");
                     g_cmpid = false;
                     return;
                }
            }        
            
        });
        
        $('#usrid').on('input',function(e){
        	g_cmpid = false;
        });
        
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	
        //그리드 초기화
        $("#grd_MmUsr").jqGrid("clearGridData", true);
        fn_FrmInit() ;
        g_cmpid = true;
        $('#btn_Save').attr('disabled',true);            
        $('#btn_Delete').attr('disabled',true);
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){              
        
        var results = sendAjaxFrm("", "/LALM0913_selList", "POST");        
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
    	//정합성체크
        if(g_cmpid == false){
            MessagePopup("OK", "중복확인을 하지 않았습니다");
            return;
        } 
    	
    	if($('#RunMode').val() == '1'){
	        var pw = $('#pw').val();
	        var num = pw.search(/[0-9]/g);
	        var eng = pw.search(/[a-z]/ig);
	        //var spe = pw.search(/['-!@@#$%^&*|\\\'\";:\/?]/gi);
	         
	        if(pw.length < 8 || pw.length > 20){
	            MessagePopup('OK','비밀번호는 8자리 이상 20자리 이내로 입력하세요.',function(){
	                $( "#pw" ).focus();
	            });
	            return;
	        }else if(pw.search(/\s/) != -1){
	            MessagePopup('OK','비밀번호는 공백 없이 입력해주세요.',function(){
	                $( "#pw" ).focus();
	            });
	            return;
	        }else if(num < 0 || eng < 0 ){//} || spe < 0){, 특수문자
	            MessagePopup('OK','비밀번호는 영문,숫자를 혼합하여 입력해주세요.',function(){
	                $( "#pw" ).focus();
	            });
	            return;
	        }
	        if(pw != $('#pw2').val()){
	            MessagePopup('OK','비밀번호가 비밀번호 확인란과 불일치 합니다.',function(){
	                $( "#pw" ).focus();
	            });
	            return;
	        }
    	}
        if($('#RunMode').val() == '1'){
             MessagePopup('YESNO',"신규등록 하시겠습니까?",function(res){
                 if(res){
                     var results = sendAjaxFrm('frm_MmUsr', "/LALM0913_insUser", "POST");  
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{          
                         MessagePopup("OK", "신규등록되었습니다.");
                         fn_Init();
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
        }else {
            MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('frm_MmUsr', "/LALM0913_updUser", "POST");  
                    
                    console.log(results);
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "수정되었습니다.");
                        fn_Init();
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
        if($("#usrid").val() == ''){
            MessagePopup("OK", "사용자를 선택하세요.");
            return;
        }       
        MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm('frm_MmUsr', "/LALM0913_delUser", "POST");      
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.");
                    fn_Init();
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
    } 

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel (){
    	fn_ExcelDownlad('grd_MmUsr', '사용자정보');
    }
    
    
    //////////////////////////////////////////////////////////////////// ////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    //입력사항 초기화    
    function fn_FrmInit(){
    	fn_InitFrm('frm_MmUsr');
    	
        $('#RunMode').val('1');
        $('#pb_CmpId').attr('disabled',true);
        $('#usrid').attr('disabled',true);
    	$('.pws').hide();
        $('#txtPw').hide();
    }
    
    //그리드 생성
    function fn_CreateGrid(data){       
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["H사업장코드","사용자ID","비밀번호변경","사용자명", "개인번호","휴대전화번호", "비밀번호변경일자", "등록여부"];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",     index:"NA_BZPLC",    width:150, align:'center', hidden:true},
                                     {name:"USRID",        index:"USRID",       width:150, align:'left'},
                                     {name:"CHGPW",        index:"CHGPW",       width:100, align:'center', sortable: false, formatter :gridButtonFormat },    
                                     {name:"USRNM",        index:"USRNM",       width:150, align:'center'},
                                     {name:"ENO",          index:"ENO",         width:150, align:'center',hidden:true},
                                     {name:"MPNO",         index:"MPNO",        width:150, align:'center'},
                                     {name:"STRG_DT",      index:"STRG_DT",     width:150, align:'center', formatter:'gridDateFormat'},
                                     {name:"STRG_YN",      index:"STRG_YN",     width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:등록;0:조회"}}
                                    ];
            
        $("#grd_MmUsr").jqGrid("GridUnload");
                
        $("#grd_MmUsr").jqGrid({
            datatype    : "local",
            data        : data,
            height      : 500,
            rowNum      : rowNoValue,
            rownumbers  : true,
            rownumWidth : 30,
            resizeing   : true,
            autowidth   : true,
            shrinkToFit : false,            
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, status, e){
            	var sel_data = $("#grd_MmUsr").getRowData(rowid);
            	fn_setFrmByObject("frm_MmUsr", sel_data); 
            	$('#RunMode').val('2');
            	if(sel_data.NA_BZPLC == App_na_bzplc){
            		$('#btn_Save').attr('disabled',false);            
                    $('#btn_Delete').attr('disabled',false);            		
            	}else {
            		$('#btn_Save').attr('disabled',true);            
                    $('#btn_Delete').attr('disabled',true);
            	}
                if(sel_data["STRG_YN"] == "1") {
                	fn_setChgRadio("strg_yn", "1");
                	$("#strg_yn_1").prop("checked", true);
                }
                else if(sel_data["STRG_YN"] == "0") {
                	fn_setChgRadio("strg_yn", "0");
                	$("#strg_yn_0").prop("checked", true);
                }
           },
        });
        
        $("#grd_MmUsr").jqGrid("setGroupHeaders", {
            useColSpanStyle:true,
            groupHeaders:[
              {startColumnName:"USRID", numberOfColumns: 2, titleText: '사용자'}]
           });
        

        //행번호
        $("#grd_MmUsr").jqGrid("setLabel", "rn","No");  
        
    }
    
    function gridButtonFormat(val, options, rowdata) {
        var gid = options.gid;
        var rowid = options.rowId;
        var colkey = options.colModel.name;
        return '<button class="tb_btn" id="' + gid + '_' + rowid + '_' + colkey + '" ' 
        + 'onclick="fn_ChgPw(\'' + gid + '\',\'' + rowid + '\',\'' + colkey + '\');return false;">비밀번호변경</button>';
    } 
    
    function fn_ChgPw(gid, rowid, colkey){

    	var pgid = 'LALM0916';
        var menu_id = $("#menu_info").attr("menu_id");
        var data = new Object();
        data['usrid'] = $('#'+gid).jqGrid('getCell', rowid, 'USRID');
        data['old_pw_yn'] = 'Y';
          
        parent.layerPopupPage(pgid, menu_id, data, null, 500, 300,function(result){
            if(result){
            	//성공 엑션 없음
            }
        });
    }
</script>

<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>
		<!-- content -->
		<section class="content">
			<ul class="clearfix">
				<li class="fl_L allow_R m_full" style="width: 40%;">
					<!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
					<div class="tab_box clearfix fl_L">
						<ul class="tab_list">
							<li><p class="dot_allow">사용자정보</p></li>
						</ul>
					</div>
					<div class="fl_R">
						<!--  //버튼 모두 우측정렬 -->
						<button class="tb_btn" id="pb_Init">입력초기화</button>
					</div>
					<div class="grayTable rsp_h">
						<form id=frm_MmUsr autocomplete="off">
							<input type="hidden" id="RunMode" />
							<table>
								<colgroup>
									<col width="120">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><span class="tb_dot">사용자ID</span></th>
										<td>
											<div class="cellBox">
												<div class="cell" style="width: 150px;">
													<input type="text" id="usrid" class="pops" maxlength="9" autocomplete="off" />
												</div>
												<div class="cell pl2">
													<button class="tb_btn" id="pb_CmpId">중복확인</button>
												</div>
											</div>

										</td>
									</tr>
									<tr>
										<th scope="row"><span class="tb_dot">사용자명</span></th>
										<td><input type="text" id="usrnm" autocomplete="off" />
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="tb_dot">휴대전화번호</span></th>
										<td>
											<div class="cellBox">
												<div class="cell">
													<input type="text" id="mpno" class="digit" maxlength="11" autocomplete="off">
												</div>
												<div class="cell pl2">'-'없이 숫자만 입력</div>
											</div>
										</td>
									</tr>
									<tr class="pws">
										<th scope="row"><span class="tb_dot">비밀번호</span></th>
										<td><input type="password" id="pw" autocomplete="new-password"></td>
									</tr>
									<tr class="pws">
										<th scope="row"><span class="tb_dot">비밀번호확인</span></th>
										<td><input type="password" id="pw2" autocomplete="new-password"></td>
									</tr>
									<tr>
										<th scope="row"><span class="tb_dot">사용권한</span></th>
										<td>
											<div class="cellBox" style="width:30%;">
												<div class="cell">
													<input type="radio" id="strg_yn_0" name="strg_yn_radio" value="0" onclick="javascript:fn_setChgRadio('strg_yn','0');" checked="checked" />
													<label for="strg_yn_0">조회</label>
												</div>
												<div class="cell">
													<input type="radio" id="strg_yn_1" name="strg_yn_radio" value="1" onclick="javascript:fn_setChgRadio('strg_yn','1');" />
													<label for="strg_yn_1">등록</label>
												</div>
												<input type="hidden" id="strg_yn" value="" />
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>
					<div id="txtPw" class="tab_box fl_R">
						<!--  //버튼 모두 우측정렬 -->
						<label style="font-size: 15px; color: blue; font: message-box;">*
							영문,숫자의 조합으로 8자리 이상</label>
					</div>
				</li>

				<!-- //좌 e -->
				<li class="fl_R m_full" style="width: 58%">
					<div class="tab_box clearfix">
						<ul class="tab_list">
							<li><p class="dot_allow">검색결과</p></li>
						</ul>
					</div>
					<div class="listTable">
						<table id="grd_MmUsr">
						</table>
					</div>
				</li>
			</ul>
		</section>
	</div>
</body>
</html>