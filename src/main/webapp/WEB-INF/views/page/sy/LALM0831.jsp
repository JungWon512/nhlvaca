<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>

<link rel="stylesheet" href="/css/jqTree/jqtree.css">

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>

<script type="text/javascript">
var results;
var treeData;

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
	});    
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init(){
	    fn_Search();
	    fn_InitFrm('srch_table');
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search(){                
		//메뉴 리스트
        results = sendAjaxFrm('', "/LALM0831_selList", "POST");
        		
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            results = setDecrypt(results);
        }        
        
        treeData = new Array();        
        var menu_pid;        
        for(var i = 0; i < results.length; i++){
            if(results[i].MENU_LVL_C == "2"){               
                var data_2  = new Object();
                var dataAry = new Array();
                menu_pid      = results[i].PID;
                data_2["label"] = results[i].SCD_MENU_NM;
                data_2["id"]    = results[i].MENU_ID;
                for(var j = 0; j < results.length; j++){
                    if(results[j].MENU_LVL_C == "3" && results[j].PID == menu_pid){
                        var data_3      = new Object();
                        data_3["label"] = results[j].MNNM_CNTN;
                        data_3["id"]    = results[j].MENU_ID;
                        dataAry.push(data_3);
                    }
                }
                data_2["children"] = dataAry;
                treeData.push(data_2);
            }
        }   
        fn_CreateTree();                
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 저장 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Save(){
		 
        //메뉴등록 validation check
        if($("#menu_id").val().length < 1 || $("#menu_id").val().length < 6){
        	MessagePopup("OK", "메뉴아이디를 입력하세요.");
            return;
        }
        if($("#mnnm_cntn").val().length < 1){
            MessagePopup("OK", "메뉴명을 입력하세요.");
            return;
        }
        if($("#menu_lvl_c").val().length < 1){
            MessagePopup("OK", "메뉴레벨을 입력하세요.");
            return;
        }
        if($("#menu_lvl_c").val() == '2' && fn_isNull($("#icon_nm").val()) == true){
            MessagePopup("OK", "메뉴 2레벨 일경우 아이콘을 선택하셔야 합니다.");
            return;
        }else if($("#menu_lvl_c").val() != '2' && fn_isNull($("#icon_nm").val()) == false){
            MessagePopup("OK", "메뉴 2레벨 이 아닐경우 아이콘을 선택할수 없습니다.",function(res){
            	$( "#icon_nm" ).val($( "#icon_nm option:first").val()).prop("selected",true);
            	$( "#icon_nm" ).focus();
            });
            return;
        }
        if($("#sort_sq").val().length < 1){
            MessagePopup("OK", "정렬순서를 입력하세요.");
            return;
        }    
       	if(!$("#menu_id").val().substring(4,6) != "00" && $("#pgid").val() == ''){
            MessagePopup("OK", "프로그램 아이디를 입력하세요.");
            return;
        }
        
        var insCheck = 0;
                
        for(var i = 0; i < results.length; i++){
        	if(results[i].MENU_ID == $("#menu_id").val()){        		
        		insCheck = 1;
        		break;
        	}
        }                
        //신규등록
        if(insCheck != 1){        
        	MessagePopup('YESNO',"신규등록 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('srch_table', "/LALM0831_insMenu", "POST");  
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "신규등록되었습니다.");
                        fn_Init();
                        fn_InitTree(treeData);
                    }      
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            });
        //업데이트
        }else{        	
        	MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('srch_table', "/LALM0831_updMenu", "POST"); 
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{          
                        MessagePopup("OK", "수정되었습니다.");
                        fn_Init();
                        fn_InitTree(treeData);
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
		//메뉴삭제 validation check
        if($("#menu_id").val() == ''){
            MessagePopup("OK", "메뉴아이디를 입력하세요.");
            return;
        }
		
        MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
            if(res){
            	var results = sendAjaxFrm('srch_table', "/LALM0831_delMenu", "POST");
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.");
                    fn_Init();
                    fn_InitTree(treeData);
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
	} 
	
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////

   
    //트리생성
    function fn_CreateTree(){
    	$tree = $('#tree_v1');
        $tree.tree({
            data: treeData,
            autoOpen: false,
            dragAndDrop: false,
            closedIcon: $('<i class="fa fa-plus-square-o"></i>'),
            openedIcon: $('<i class="fa fa-minus-square-o"></i>')
        });
        $("#tree_v1").bind("tree.click", function(event){
        	event.preventDefault();
            var node = event.node;
            for(var k = 0; k< results.length; k++){
            	if(results[k].MENU_ID == node.id){            		
                    $("#menu_id").val(results[k].MENU_ID);
                    $("#mnnm_cntn").val(results[k].MNNM_CNTN);
                    $("#menu_lvl_c").val(results[k].MENU_LVL_C);
                    $("#sort_sq").val(results[k].SORT_SQ);
                    $("#pgid").val(results[k].PGID);
                    $("#uyn").val(results[k].UYN);   
                    $("#icon_nm").val(results[k].ICON_NM);               
                    break;
                }
            }
        })
    }
	
	function fn_InitTree(treeData){
		$tree.tree("loadData", treeData);
	}
	
	
</script>

<body>
    <div class=contents>
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            
            <ul class="clearfix">
                <li class="fl_L allow_R m_full" style="width:30%;"><!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
                    <div class="tab_box clearfix">
                        <ul class="tab_list">
                            <li><p class="dot_allow">메뉴 관리</p></li>
                        </ul>
                    </div>                        
                    <div class="grayTable rsp_h">
                        <div id="tree_v1"></div>
                    </div>
               </li>
            
               <!-- //좌 e -->
               <li class="fl_R m_full" style="width: 68%">
                   <div class="tab_box clearfix"> 
                       <ul class="tab_list">
                           <li><p class="dot_allow">메뉴 상세</p></li>
                       </ul>
                   </div>
                   <div class="grayTable rsp_h">
                       <form id="menu_detail">
	                       <table id="srch_table">
	                           <tbody>
	                               <colgroup>
	                                   <col width="120">
	                                   <col width="*">
	                                   <col width="80">
	                                   <col width="120">
	                                   <col width="150">
	                               </colgroup>
		                           <tr>
		                               <th scope="row"><span class="tb_dot">메뉴아이디</span></th>
		                               <td colspan="4">
		                                   <input type="text" id="menu_id" maxlength="6"/>
		                               </td>
		                           </tr>
		                           <tr>
		                               <th scope="row"><span class="tb_dot">메뉴 명</span></th>
		                               <td colspan="4">
		                                   <input type="text" id="mnnm_cntn"/>
		                               </td>
		                           </tr>
		                           <tr>
		                               <th scope="row"><span class="tb_dot">메뉴 레벨</span></th>
		                               <td colspan="2">
		                                   <input type="text" id="menu_lvl_c" maxlength="1"/>
		                               </td>		                               
                                       <th scope="row"><span class="tb_dot">메뉴 ICON</span></th>
                                       <td >
                                           <select id="icon_nm">
                                               <option value="">선택</option>
                                               <option value="fa-table">테이블</option>
                                               <option value="fa-pie-chart">차트</option>
                                               <option value="fa-calendar-o">달력</option>
                                               <option value="fa-folder">폴더</option>
                                               <option value="fa-file">파일</option>
                                               <option value="fa-clone">문서</option>
                                               <option value="fa-book">책</option>                                               
                                               <option value="fa-user">유저</option>                                               
                                               <option value="fa-wrench">설정</option>          
                                               <option value="fa-camera">카메라</option>                                                                                          
                                               <option value="fa-film">필름</option>                                          
                                               <option value="fa-home">홈</option>
                                               
                                           </select>
                                       </td>
		                           </tr>                                
		                           <tr>
		                               <th scope="row"><span class="tb_dot">정렬 순서</span></th>
		                               <td colspan="4">
		                                   <input type="text" id="sort_sq"/>
		                               </td>
		                           </tr>
		                           <tr>
		                               <th scope="row"><span class="tb_dot">프로그램 아이디</span></th>
		                               <td colspan="4">
		                                   <input type="text" id="pgid" maxlength="8"/>
		                               </td>
		                           </tr>
		                           <tr>
		                               <th scope="row"><span class="tb_dot">사용 여부</span></th>
		                               <td colspan="4">
		                                   <select id="uyn">
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
            </ul>
        </section>
    </div>
<!-- ./wrapper -->

<!-- jquery -->
<script type="text/javascript" src="/js/default.js"></script>
<script src="/js/jqTree/tree.jquery.js"></script>
<script>

</script>
</body>
</html>