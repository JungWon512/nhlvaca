<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <!-- content-header -->
        <div id="menu_info" class="fl_R"><!--  //버튼 모두 우측정렬 -->            
            <button class="tb_btn" id="btn_Init">초기화</button>
            <button class="tb_btn" id="btn_Search">조회</button>
            <button class="tb_btn" id="btn_Select">선택</button>
            <button class="tb_btn" id="btn_Insert">추가</button>
            <button class="tb_btn" id="btn_Save">저장</button>
            <button class="tb_btn" id="btn_Delete">삭제</button>
            <button class="tb_btn" id="btn_Excel">엑셀</button>
            <button class="tb_btn" id="btn_Print">인쇄</button>
            <button class="tb_btn" id="btn_Close">닫기</button>
        </div>            
<script>
jQuery("link[rel=stylesheet][href*='/css/content-media.css']").remove();
var pageInfo = setDecryptData('${pageInfo}');
    $(document).ready(function() {  
        var menu_id  = pageInfo.menu_id;
        var pgid     = pageInfo.pgid;
        var pgmnm    = pageInfo.pgmnm;
        var menu_btn = pageInfo.menu_btn;
        var auth_btn = pageInfo.auth_btn;
        $("#menu_info").attr("menu_id", pageInfo.menu_id);
                                        
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
            parent.PopupClose("#popupPage_"+pgid);
            return false;                  
        });  
        
    });
    
    

</script>