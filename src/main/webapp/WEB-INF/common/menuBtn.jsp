<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <!-- content-header -->
        <section class="content-header">
            <h1 class="tit" id="menu_info">
            </h1>
            <div class="main_btn ta_r"><!--  //버튼 모두 우측정렬 -->
                <button class="button resetBtn" id="btn_Init"><span>초기화</span></button>
                <button class="button searchBtn" id="btn_Search"><span>조회</span></button>
                <button class="button selectBtn" id="btn_Select"><span>선택</span></button>
                <button class="button insertBtn" id="btn_Insert"><span>추가</span></button>
                <button class="button saveBtn" id="btn_Save"><span>저장</span></button>
                <button class="button deleteBtn" id="btn_Delete"><span>삭제</span></button>
                <button class="button excelBtn" id="btn_Excel"><span>엑셀</span></button>
                <button class="button printBtn" id="btn_Print"><span>인쇄</span></button>
                <button class="button closeBtn" id="btn_Close"><span>닫기</span></button>
            </div>
        </section>        
<script>
var pageInfo = setDecryptData('${pageInfo}');
    $(document).ready(function() {            
        
        var menu_id  = pageInfo.menu_id;
        var pgid     = pageInfo.pgid;
        var menu_nm  = pageInfo.menu_nm;
        var menu_btn = pageInfo.menu_btn;
        var auth_btn = pageInfo.auth_btn;
                        
        //화면아이디 + 화면명
        $("#menu_info").text("[" + pgid + "] " + menu_nm);
        $("#menu_info").attr("menu_id", pageInfo.menu_id);
        $("#menu_info").attr("menu_nm", pageInfo.menu_nm);
        
        
                
        //사용버튼 처리
        if(menu_btn.B_REFRESH != "1"){
        	$("#btn_Init").remove();
        }
        if(menu_btn.B_SEARCH != "1"){
        	$("#btn_Search").remove();
        }
        if(menu_btn.B_SELECT != "1"){
            $("#btn_Select").remove();
        }
        if(menu_btn.B_INSERT != "1"){
            $("#btn_Insert").remove();
        }
        if(menu_btn.B_SAVE != "1"){
        	$("#btn_Save").remove();
        }
        if(menu_btn.B_DELETE != "1"){
        	$("#btn_Delete").remove();
        }
        if(menu_btn.B_EXCEL != "1"){
        	$("#btn_Excel").remove();
        }
        if(menu_btn.B_PRINT != "1"){
        	$("#btn_Print").remove();
        }
        
        //버튼 리스너
        $("#btn_Init").click(function(event){
        	event.preventDefault();
        	this.blur();
        	fn_Init();
        });
        
        $("#btn_Search").click(function(event){
            event.preventDefault();
            this.blur();
        	if(auth_btn.AUTH_R == "1"){
        		fn_Search();                  
            }else{
            	alert("권한이없습니다");
            }        	        	
        });
        
        $("#btn_Select").click(function(event){
            event.preventDefault();
            this.blur();
            fn_Select();
        });
        
        $("#btn_Insert").click(function(event){
            event.preventDefault();
            this.blur();
            if(auth_btn.AUTH_C == "1"){
                fn_Insert();                  
            }else{
                alert("권한이없습니다");
            }                       
        });
                
        $("#btn_Save").click(function(event){
            event.preventDefault();
            this.blur();
            if(auth_btn.AUTH_U == "1"){
            	fn_Save();                  
            }else{
            	alert("권한이없습니다");
            }                       
        });
        
        $("#btn_Delete").click(function(event){
            event.preventDefault();
            this.blur();
            if(auth_btn.AUTH_D == "1"){
            	fn_Delete(); 
            }else{
            	alert("권한이없습니다");
            }                       
        });
        
        $("#btn_Excel").click(function(event){
            event.preventDefault();
            this.blur();
            if(auth_btn.AUTH_X == "1"){
            	fn_Excel(); 
            }else{
            	alert("권한이없습니다");
            }                       
        });
        
        $("#btn_Print").click(function(event){
            event.preventDefault();
            this.blur();
            if(auth_btn.AUTH_P == "1"){
            	fn_Print();                  
            }else{
            	alert("권한이없습니다");
            }                       
        });
        
        $("#btn_Close").click(function(event){
            event.preventDefault();
            this.blur();
        	parent.$('li.ui-tabs-tab.ui-corner-top.ui-state-default.ui-tab.ui-tabs-active.ui-state-active > span').trigger('click');                      
        });  
        
    });    

</script>