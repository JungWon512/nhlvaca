<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>


<meta charset="UTF-8">
<title>main</title>
<%@ include file="../common/serviceCall.jsp" %>
<%@ include file="../common/head.jsp" %>
</head>
<style>
.ui-jqgrid .ui-jqgrid-hbox{width:100% !important; padding-right:0 !important;}
.ui-jqgrid .ui-jqgrid-bdiv{overflow-y:hidden !important;}
</style>
<script src="/js/chart/chart.js"></script>
<script type="text/javascript">
    //차트 변수
    var ctx;    
    var config;
    var mainChart;
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	$(document).ready(function(){ 
		
		//차트 생성
	    ctx = $("#mainChart");
	    //ctx.height(340);
	    
	    config = {
	        type : 'line',
	        data : {
	            //
	            labels:["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	            datasets:[{
	                label:'송아지',
	                data:[0,0,0,0,0,0,0,0,0,0,0,0],
	                borderColor:"rgba(220,60,14,1)",
	                backgroundColor:"rgba(0,0,0,0)",
	                fill:true,
	                lineTension:0
	            },
	            {
	                label:'비육우',
	                data:[0,0,0,0,0,0,0,0,0,0,0,0],
	                borderColor:"rgba(80,201,14,1)",
	                backgroundColor:"rgba(0,0,0,0)",
	                fill:true,
	                lineTension:0
	            },
	            {
	                label:'번식우',
	                data:[0,0,0,0,0,0,0,0,0,0,0,0],
	                borderColor:"rgba(55,21,170,1)",
	                backgroundColor:"rgba(0,0,0,0)",
	                fill:true,
	                lineTension:0
	            },
	            ]
	        },
	        options:{
	            responsive:false,
	            maintainAspecRatio:false,
	            title:{
	                display:false,
	                text:'월별 출하두수 Chart'
	            },
	            tooltips:{
	                mode:'index',
	                intersect:false,
	            },
	            hover:{
	                mode:'nearest',
	                intersect:true,
	            },
	            scales:{
	                xAxes:[{
	                    display:true,
	                    scaleLabel:{
	                        display:false,
	                        labelString:'x축'
	                    }
	                }],
	                yAxes:[{
	                    display:true,
	                    ticks:{
	                        min:0
	                    },
	                    scaleLabel:{
	                        display:false,
	                        labelString:'y축'
	                    }
	                }]
	            }               
	        }           
	    };
	    mainChart = new Chart(ctx, config);
		
	    //년도조회
	    fn_SogYearSearch();	
		fn_MonQcnSearch();
		fn_MainNoticeSearch();
		fn_MainSecApplySearch();
		
		//바로가기
	    $('.mainList > ul > li > a').on('click',function(){
	    	var v_pgid = $(this).attr('pgid');	    	
	    	fn_OpenMenu(v_pgid, null);

	    });
		
	    //공지사항
        $('.notice_list > li > a').on('click',function(){
            var v_bbrd_sqno = $(this).attr('bbrd_sqno');  
            
            var pgid = 'LALM0901P1';
            var menu_id = $("#menu_info").attr("menu_id");
            var data = new Object();
            data['blbd_dsc'] =  '2';
            data['bbrd_sqno'] =  v_bbrd_sqno;
            data['rl_sqno'] =  '0';
            parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600);

        }); 
        $('.more_bg > a.notice_more').on('click',function(){ 
            var v_pgid = 'LALM0901';
            fn_OpenMenu(v_pgid, null);
        });
        
        $('.more_bg > a.apply_more').on('click',function(){ 
            var data = new Object();
			data["flag_secaply"] = "Y";
			fn_OpenMenu('LALM0117',data);
        });
        
        $('.sec_aply_item').on('click',function(){ 
            var data = new Object();
			data["flag_secaply"] = "Y";
			fn_OpenMenu('LALM0117',data);
        });
		fn_MainNoticePopupSearch();
	}); 
	

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_MonQcnSearch(){
    	 var srchData = new Object();
    	 srchData["cb_year"] = $("#cb_year").val();
        var results = sendAjax(srchData, "/MainSogQcn_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return false;
        }else{      
            result = setDecrypt(results);
        }
                
        fn_CreateGrid(result); 
        
        return true;
                
    }
    function fn_MainNoticePopupSearch(){
        var srchData = new Object();
        srchData["na_bzplc"] = '0000000000000';
        var results = sendAjax(srchData, "/MainNotice_selPopupList", "POST");        
        var result;
        var noticeItem = [];

        if(results.status == RETURN_SUCCESS){
            result = setDecrypt(results);

            var v_bbrd_sqno = $(this).attr('bbrd_sqno');  
            
            var pgid = 'LALM0901P1';
            var menu_id = $("#menu_info").attr("menu_id");
            var data = new Object();
            data['blbd_dsc'] =  '2';
            data['bbrd_sqno'] =  result[0].BBRD_SQNO;
            data['rl_sqno'] =  '0';
            parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600);
        }
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_MainNoticeSearch(){
        var srchData = new Object();
        srchData["na_bzplc"] = '0000000000000';
        var results = sendAjax(srchData, "/MainNotice_selList", "POST");        
        var result;
        var noticeItem = [];
        
        if(results.status != RETURN_SUCCESS){
        	noticeItem.push('<li>등록된 공지사항이 없습니다.</li>');
        }else{
       		$(".main_notice").show();
            result = setDecrypt(results);
            
            $.each(result, function(i){
            	noticeItem.push('<li><a href="javascript:;" bbrd_sqno="'
            	                + result[i].BBRD_SQNO
            	                + '"'
                                + (result[i].FIX_YN == '1' ? ' class="red_txt"' : '')
                                + '><span>[' 
            	               	+ result[i].FSRG_DTM 
            	               	+ ']</span>[' 
            	               	+ result[i].USRNM 
            	               	+'] '
            	               	+ result[i].BBRD_TINM 
            	               	+ '</a></li>');
            });
        }      
        
        $(".notice_list").append(noticeItem.join(""));
    }   
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 년도조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SogYearSearch(){    	 
   	    var result_1;
	    var results_1 = null; 
        var srchData = new Object();
        
 	    results_1 = sendAjax(srchData, "/MainSogYear_selList", "POST");
        if(results_1.status != RETURN_SUCCESS){
            showErrorMessage(results_1);
             return;
        }else{     
        	result_1 = setDecrypt(results_1);           
        }    
        
    	$("#cb_year").empty().data('options');
    	$.each(result_1, function(i){
//     	    var v_simp_nm = ('['+result_1[i].CB_YEAR + '] ' + result_1[i].CB_YEARNM);
    	    $("#cb_year").append('<option value=' + result_1[i].CB_YEAR + '>' + result_1[i].CB_YEARNM + '</option>');
    	});
                
    }     
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 이용해지 신청 회원 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_MainSecApplySearch(){
        var srchData = new Object();
        srchData["na_bzplc"] = App_na_bzplc;
        var results = sendAjax(srchData, "/MainSecApply_selList", "POST");        
        var result;
        var userItem = [];
        
        if(results.status != RETURN_SUCCESS){
        	userItem.push('<li>');
        	userItem.push('이용해지 신청기록이 없습니다.');
        	userItem.push('</li>');
        }else{
            result = setDecrypt(results);
            
            $.each(result, function(i){
            	userItem.push('<li>');
            	userItem.push('		<a href="javascript:;" class="sec_aply_item">');
            	userItem.push('			<span class="secReceDtm">[' + result[i].SEC_RECE_DTM+ ']</span>');
            	userItem.push('			[' + result[i].SRA_MWMNNM +'] '+ result[i].SEC_REASON);
            	userItem.push('		</a>');
            	userItem.push('</li>');
            });
        }      
        $(".secAply_list").append(userItem.join(""));
    }   
    
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["월", "송아지", "비육우", "번식우"];        
        var searchResultColModel = [
        							 {name:"MONTHNM",       index:"MONTHNM",    	width:1, align:'center'},						 
        							 {name:"SOCOW",       	index:"SOCOW",       	width:1, align:'right' },        	
                                     {name:"BICOW",	        index:"BICOW",	        width:1, align:'right'},                                     
                                     {name:"BUCOW",        	index:"BUCOW",        	width:1, align:'right'}
                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      'auto',
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,            
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){               
           },
        });
        //////////////////// chart /////////////////////
        var SOCOWarr = new Array();
        var BICOWarr = new Array();
        var BUCOWarr = new Array();
        for(idx in data){
            SOCOWarr.push(data[idx].SOCOW);
            BICOWarr.push(data[idx].BICOW);
            BUCOWarr.push(data[idx].BUCOW);
        }
        
        var dataset = config.data.datasets;
        dataset[0].data = SOCOWarr;
        dataset[1].data = BICOWarr;
        dataset[2].data = BUCOWarr;
        mainChart.update();
    }
    
    
    
</script>
<body>
    <!-- content-header -->
    <section class="content-mainheader">
        <h1>
            MAIN
        </h1>
    </section>
            
    <!-- content -->
    <section class="content">
	    <div class="main">
	        <div class="sec_table">
	            <h2 class="tit">바로가기 메뉴 서비스</h2>
	            <div class="mainList">
	                <ul class="clearfix">
	                    <li>
                            <a href="javascript:;" pgid="LALM0113">
                                <img src="/images/common/lalm0113.png" alt="" >
                                <p>중도매인 등록</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0212">
                                <img src="/images/common/lalm0212.png" alt="">
                                <p>경매차수 관리</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0215">
                                <img src="/images/common/lalm0215.png" alt="">
                                <p>출장우내역 등록</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0213">
                                <img src="/images/common/lalm0213.png" alt="">
                                <p>참가번호 관리</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0216">
                                <img src="/images/common/lalm0216.png" alt="">
                                <p>출장우내역 출력</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0311">
                                <img src="/images/common/lalm0311.png" alt="">
                                <p>중량/예정가 입력</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0312">
                                <img src="/images/common/lalm0321.png" alt="">
                                <p>산정가 입력</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0314">
                                <img src="/images/common/lalm0314.png" alt="">
                                <p>일괄경매내역조회</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0320">
                                <img src="/images/common/lalm0320.png" alt="">
                                <p>실시간 조회</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0412">
                                <img src="/images/common/lalm0412.png" alt="">
                                <p>중도매인 정산</p>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:;" pgid="LALM0411">
                                <img src="/images/common/lalm0411.png" alt="">
                                <p>경매정보 전송</p>
                            </a>
                        </li>
	                </ul>
	            </div>
	            <!--  //blueTable e -->
	        </div>
                    
            <div class="sec_table">
                <div class="cont_bottom clarfix">
                    <div class="noticeSec">
                        <h2 class="tit" >월별 출하두수   <select class="pl5" id="cb_year" name="cb_year" onchange="fn_MonQcnSearch()" style="width:140px;"></select></h2>
                        <div class="noticeBox">
                            <div class="mainTable">
                                <table id="mainGrid">
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="noticeSec">
                        <h2 class="tit" >월별 출하두수 Chart</h2>
                        <canvas id="mainChart" style="width:100%;height: 320px">
                        </canvas>
                    </div>
                    <div class="noticeSec LastnoticeSec">
                       <div class="main_notice">
                            <dl>
                                <dt>공지사항</dt>
                                <dd>
                                    <ul class="notice_list">
                                    </ul>
                                </dd>
                            </dl>
                            <span class="more_bg"><a href="javascript:;" class="notice_more"><img src="/images/common/more.png" alt=""></a></span>
                        </div>
                    </div>
                    <div class="noticeSec LastnoticeSec">
                       <div class="main_secAplyUser">
                            <dl>
                                <dt>이용해지 신청회원</dt>
                                <dd>
                                    <ul class="secAply_list">
                                    </ul>
                                </dd>
                            </dl>
                            <span class="more_bg"><a href="javascript:;" class="apply_more"><img src="/images/common/more.png" alt=""></a></span>
                        </div>
                    </div>
                    
                    </div>
                </div>
            </div>
        </div>          
    </section>
    <!-- //.content -->


</body>
</html>