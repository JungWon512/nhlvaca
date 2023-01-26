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
 <script type="text/javascript" src="/js/assets/plugins/custom/ckeditor4/ckeditor.js"></script>
</head>
<body>
    <div class="pop_warp">
        <div class="tab_box btn_area clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow" >시스템게시판상세</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="grayTable rsp_v">
                <form id="frm_Input" name="frm_Input">
                <input type="hidden" id="na_bzplc">                
                <input type="hidden" id="rl_sqno">
                <input type="hidden" id="inq_cn_yn">
                <input type="hidden" id="ss_userid">
                <input type="hidden" id="ss_na_bzplc">
                <input type="hidden" id="apdfl_id">
                <table width="100%">
                    <colgroup>
                        <col width="90">
                        <col width="100">
                        <col width="150">
                        <col width="90">
                        <col width="350">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">게시글번호</th>
                            <td colspan="2">
                                <input type="text" id="bbrd_sqno" readonly="readonly">
                            </td>
                            <th class="tb_dot">조회건수</th>
                            <td colspan="2">
                                <input type="text" id="bbrd_inq_cn" readonly="readonly">
                            </td>
                        </tr>
                        <tr>
                            <th class="tb_dot">등록자</th>
                            <td colspan="2">
                                <input type="text" id="usrnm" readonly="readonly">
                            </td>
                            <th class="tb_dot">등록일</th>
                            <td colspan="2">
                                <input type="text" id="fsrg_dtm" readonly="readonly">
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <th class="tb_dot">팝업여부</th>
                            <td colspan="2">
                                <input type="checkbox" id="pup_uyn" name="pup_uyn">
                                <label id="pup_uyn_text" for="pup_uyn"> 부</label>
                            </td>
                            <th class="tb_dot">팝업기간</th>
                            <td colspan="2">
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="st_dt"></div>
                                    <div class="cell ta_c"> ~ </div>
                                    <div class="cell"><input type="text" class="date" id="ed_dt"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="tb_dot">제목</th>
                            <td>
                                <select id="blbd_dsc"></select>
                            </td>
                            <td colspan="3">
                                <input type="text" id="bbrd_tinm" >
                            </td>
                            <td>
                                <label id="fix_yn_text" for="fix_yn"> 상단고정</label>
                                <input type="checkbox" id="fix_yn" name="fix_yn">
                            </td>
                        </tr>
                        <tr>
                            <th class="tb_dot">내용</th>
                            <td colspan="5">
                                <textarea id="bbrd_cntn"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="tb_dot">파일다운로드</th>
                            <td colspan="5">
                                <div class="cellBox">
                                    <div class="cell" style="width:500px;">
                                        <button class="tb_btn" id="pb_fileDown" value="파일다운로드">파일다운로드</button>
                                        <input type="text" id='downflnm' readonly/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="tb_dot">파일등록</th>
                            <td colspan="5">
                                <div class="cellBox">
	                                <div class="cell" style="width:500px;"><input type="file" id="flnm"  name="flnm" title="파일첨부"/></div>
	                            </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
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
        CKEDITOR.replace('bbrd_cntn', {
        	height : 200
        });
        fn_setCodeBox("blbd_dsc", "BLBD_DSC", 3, false,'선택'); 
        /******************************
         * 팝업여부 checkbox 이벤트
         ******************************/
        $("#pup_uyn").change(function() {
            if($("#pup_uyn").is(":checked")) {
                $("#pup_uyn_text").text("여");
                $("#st_dt").attr("disabled",false);
                $("#ed_dt").attr("disabled",false);
                $("#st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
                $("#ed_dt" ).datepicker().datepicker("setDate", fn_getToday()); 
            } else {
                $("#pup_uyn_text").text("부");
                $("#st_dt").attr("disabled",true);
                $("#ed_dt").attr("disabled",true);
                $("#st_dt").val('');
                $("#ed_dt").val('');
            }           
        });
                
        /******************************
         * 파일다운로드
         ******************************/
        $("#pb_fileDown").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_fileDownload();
        });
        
        fn_Init();
        
    }); 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){    
        //폼 초기화
        fn_InitFrm('frm_Input');    
        $( '#na_bzplc' ).val('0000000000000');    
        $( "#blbd_dsc" ).val(pageInfo.param.blbd_dsc); 
        $( "#inq_cn_yn" ).val("0");
        $( "#ss_userid" ).val(App_userId);
        $( "#ss_na_bzplc" ).val(App_na_bzplc);
        CKEDITOR.instances.bbrd_cntn.setData(''); 
        if(pageInfo.param.bbrd_sqno != null && pageInfo.param.bbrd_sqno !=''){
            $("#bbrd_sqno").val(pageInfo.param.bbrd_sqno);
            $("#rl_sqno").val(pageInfo.param.rl_sqno);
        	fn_Search();
        }else {
        	$("#rl_sqno").val("0");
            $("#pup_uyn").prop('checked',false).trigger('change');
        }
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){ 
        //정합성체크        
        var results = sendAjaxFrm("frm_Input", "/LALM0900P1_selData", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            fn_setFrmByObject("frm_Input", result);
            $('#bbrd_tinm').val($('#bbrd_tinm').val());
            if($("#pup_uyn").is(":checked")) {
                $("#pup_uyn_text").text("여");
                $("#st_dt").attr("disabled",false);
                $("#ed_dt").attr("disabled",false);
            } else {
                $("#pup_uyn_text").text("부");
                $("#st_dt").attr("disabled",true);
                $("#ed_dt").attr("disabled",true);
                $("#st_dt").val('');
                $("#ed_dt").val('');
            }
            
            CKEDITOR.instances.bbrd_cntn.setData($('#bbrd_cntn').val());
                        
            $("#downflnm").val(result.FLNM);
            
            if(result.APDFL_ID == null && result.APDFL_ID == ''){
            	$("#pb_fileDown").attr("disabled",true);
            }else{
            	$("#pb_fileDown").attr("disabled",false);
            }
                        
        }        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){     
        //정합성체크
    	if(fn_isNull($('#blbd_dsc').val()) == true){
            MessagePopup("OK", "게시판구분을 선택하세요.",function(res){
            	$('#blbd_dsc').focus();
            });
            return;
        } 
        if(fn_isNull($('#bbrd_tinm').val()) == true){
            MessagePopup("OK", "제목을 입력하세요.",function(res){
                $('#bbrd_tinm').focus();
            });
            return;
        } 
        
        if(fn_isNull(CKEDITOR.instances.bbrd_cntn.getData()) == true){
            MessagePopup("OK", "내용을 입력하세요.");
            return;
        }
        
        //파일저장        
        //파일이 있을때
        if($("#flnm").val() != ''){   
        	
        	var formData = new FormData($("#frm_Input")[0]);
        	formData.append('ss_userid', App_userId);
        	formData.append('ss_na_bzplc', '0000000000000');
        	var cntn_result;
            
            $.ajax({
                url: "/LALM0900P1_insApdfl",
                type: "POST",
                enctype:"multipart/form-data",
                processData:false,
                contentType:false,
                data: formData,
                async: false,
                headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
                success:function(data) {    
                	cntn_result = setDecrypt(data);         
                },
                error:function(request){   
                	MessagePopup("OK", "서버 수행중 오류가 발생하였습니다.",function(res){
                    });
                    return;
                                
                },complete:function(data){
                	   localStorage.setItem("nhlvaca_token", getCookie('token'));
    			}
            });
            
        	$("#apdfl_id").val(cntn_result.apdfl_id);     	
        }
                        
        $('#bbrd_cntn').val(CKEDITOR.instances.bbrd_cntn.getData());
        console.log($('#bbrd_cntn').val());
        if(fn_isNull($('#bbrd_sqno').val()) == true ){
             MessagePopup('YESNO',"신규등록 하시겠습니까?",function(res){
                 if(res){                	 
                     var results = sendAjaxFrm('frm_Input', "/LALM0900P1_insBlbd", "POST");  
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{  
                         MessagePopup("OK", "신규등록되었습니다.",function(res){
                        	 pageInfo.returnValue = true;
                             var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                             parentInput.val(true).trigger('change');
                         });
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
        }else {
            MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('frm_Input', "/LALM0900P1_updBlbd", "POST");                      
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{
                        MessagePopup("OK", "수정되었습니다.",function(res){
                        	pageInfo.returnValue = true;
                            var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                            parentInput.val(true).trigger('change');
                        });
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
           
        if(fn_isNull($('#bbrd_sqno').val()) == true){
            MessagePopup("OK", "신규게시물은 삭제할수 없습니다.");
            return;
        }       
        MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm('frm_Input', "/LALM0900P1_delBlbd", "POST");      
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.",function(res){
                    	pageInfo.returnValue = true;
                        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                        parentInput.val(true).trigger('change');
                    });
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
    } 
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////    
    function fn_fileDownload(){
    	
    	if($("#apdfl_id").val() != null && $("#apdfl_id").val() != ''){
    		
    	    var xhr  = new XMLHttpRequest();
    	       
    	    var param = JSON.stringify({'apdfl_id': $("#apdfl_id").val()});
    	       
    	    xhr.open("POST", "/LALM0900_selFileDownload", true);
    	    xhr.responseType = "blob";
    	    xhr.setRequestHeader("Authorization", 'Bearer ' + localStorage.getItem("nhlvaca_token"));
    	    xhr.setRequestHeader("Content-Type",  "application/json; charset=UTF-8");
    	                         
    	    xhr.onload = function(e){
           	   localStorage.setItem("nhlvaca_token", getCookie('token'));
    	        var filename =  $("#apdfl_id").val();
    	        var disposition = xhr.getResponseHeader('Content-Disposition');
			    disposition = fn_XXSEncode(disposition);
    	        if(disposition && disposition.indexOf("attachment") !== -1){
    	            var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
    	            var matches       = filenameRegex.exec(disposition);
    	            if(matches != null && matches[1]){
    	                filename = decodeURI(matches[1].replace(/['"]/g, ''));
    	            }
    	             
    	            if(this.status == 200){
    	                var blob = this.response;
    	                if(window.navigator.msSaveOrOpenBlob){
    	                    window.navigator.msSaveBlob(blob, filename);
    	                }else{
    	                   var downloadLink = window.document.createElement('a');
    	                   var contentTypeHeader = xhr.getResponseHeader("Content-Type");
				  		   contentTypeHeader = fn_XXSEncode(contentTypeHeader);
    	                   downloadLink.href = window.URL.createObjectURL(new Blob([blob], {type:contentTypeHeader}));
    	                   downloadLink.download = filename;
    	                   document.body.appendChild(downloadLink);
    	                   downloadLink.click();
    	                   document.body.removeChild(downloadLink);                     
    	                }
    	            }                 
    	        }           
    	    };    	                   
    	    xhr.send(param);
    		
    	}else{
    		 MessagePopup('OK','다운로드할 파일이 없습니다.');
    	}
    	
    }
    
    
    
</script>
</html>