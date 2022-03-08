<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>
<script src="/js/xlsx.full.min.js"></script>
<script src="/js/FileSaver.min.js"></script>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body>
    <div class="pop_warp">
        <div class="tab_box btn_area clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow" >검색조건</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="95">
                        <col width="*">
                        <col width="75">
                        <col width="*">
                        <col width="75">
                        <col width="*">
                        <col width="120">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="tb_dot">경매대상구분</th>
                            <td>
                                <select id="auc_obj_dsc"></select>
                            </td>
                            <th class="tb_dot">경매일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th class="tb_dot">접수일자</th>
                            <td>
                                <div class="cellBox">
                                    <div class="cell"><input type="text" class="date" id="rc_dt" maxlength="10"></div>
                                </div>
                            </td>
                            <th colspan="2"><input type="file" title="파일첨부" onchange="excelExport(event);"/></th>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
        </div>
        
        <div class="listTable mb0">           
            <table id="grd_MmFhs">
            </table>
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
        if(pageInfo.param){
        	$("#ftsnm").val(pageInfo.param.ftsnm);    

            fn_CreateGrid(pageInfo.result);
            $("#ftsnm").focus();
        }else {
            fn_Init();
        }
               
        
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
        $("#ftsnm").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){     
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0134P_selList", "POST");        
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
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){     
        var sel_rowid = $("#grd_MmFhs").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmFhs").jqGrid("getRowData", sel_rowid);
        
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
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
        
        var searchResultColNames = ["* 경매대상","* 농가식별번호","* 농장관리번호","* 농가명","* 개체관리번호","* 경매번호","자가운송여부","운송비","출자금","사료공급금액"
        	                        ,"당일접수비용","예방접종일자", "브루셀라<br>검사일자","브루셀라검사증<br>확인여부","제각여부", "12개월이상여부","12개월이상<br>수수료","* 임신구분","인공수정일자","인공수정증명서<br>제출여부"
        	                        ,"수정KPN","인심개월수","* 임신감정여부","임신여부","괴사감정여부","괴사여부","비고","생산자명","생산지역명"];        
        
        var searchResultColModel = [
                                     {name:"auc_obj_dsc",          index:"auc_obj_dsc",          width:70,  align:'center'},
                                     {name:"fhs_id_no",            index:"fhs_id_no",            width:80,  align:'center'},
                                     {name:"farm_amnno",           index:"farm_amnno",           width:80,  align:'center'},
                                     {name:"ftsnm",                index:"ftsnm",                width:80,  align:'center'},
                                     {name:"sra_indv_amnno",       index:"sra_indv_amnno",       width:60,  align:'center'},
                                     {name:"auc_prg_sq",           index:"auc_prg_sq",           width:100, align:'left'},
                                     {name:"trpcs_py_yn",          index:"trpcs_py_yn",          width:100, align:'left'},
                                     {name:"sra_trpcs",            index:"sra_trpcs",            width:90,  align:'center'},
                                     {name:"sra_pyiva",            index:"sra_pyiva",            width:90,  align:'center'},
                                     {name:"sra_fed_spy_am",       index:"sra_fed_spy_am",       width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     
                                     {name:"td_rc_cst",            index:"td_rc_cst",            width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"vacn_dt",              index:"vacn_dt",              width:160, align:'left',   },
                                     {name:"brcl_isp_dt",          index:"brcl_isp_dt",          width:160, align:'left',   },
                                     {name:"brcl_isp_ctfw_smt_yn", index:"brcl_isp_ctfw_smt_yn", width:160, align:'left',   },
                                     {name:"rmhn_yn",              index:"rmhn_yn",              width:160, align:'left',   },
                                     {name:"mt12_ovr_yn",          index:"mt12_ovr_yn",          width:160, align:'left',   },
                                     {name:"mt12_ovr_fee",         index:"mt12_ovr_fee",         width:160, align:'left',   },
                                     {name:"ppgcow_fee_dsc",       index:"ppgcow_fee_dsc",       width:160, align:'left',   },
                                     {name:"afism_mod_dt",         index:"afism_mod_dt",         width:160, align:'left',   },
                                     {name:"afism_mod_ctfw_smt_yn",index:"afism_mod_ctfw_smt_yn",width:160, align:'left',   },
                                     
                                     {name:"mod_kpn",              index:"mod_kpn",              width:160, align:'left',   },
                                     {name:"prny_mtcn",            index:"prny_mtcn",            width:160, align:'left',   },
                                     {name:"prny_jug_yn",          index:"prny_jug_yn",          width:160, align:'left',   },
                                     {name:"prny_yn",              index:"prny_yn",              width:160, align:'left',   },
                                     {name:"ncss_jug_yn",          index:"ncss_jug_yn",          width:160, align:'left',   },
                                     {name:"ncss_yn",              index:"ncss_yn",              width:160, align:'left',   },
                                     {name:"rmk_cntn",             index:"rmk_cntn",             width:160, align:'left',   },
                                     {name:"sra_pdmnm",            index:"sra_pdmnm",            width:160, align:'left',   },
                                     {name:"sra_pd_rgnnm",         index:"sra_pd_rgnnm",         width:160, align:'left',   },
                                     
                                     ];

        $("#grd_MmFhs").jqGrid("GridUnload");
                
        $("#grd_MmFhs").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
                
           },
        });
        //가로스크롤 있는경우 추가
        $("#grd_MmFhs .jqgfirstrow td:last-child").width($("#grd_MmFhs .jqgfirstrow td:last-child").width() - 17);
        
    }
    
    function excelExport(event){
    	excelExportCommon(event, handleExcelDataAll);
    }
    
    function excelExportCommon(event, callback){
        var input = event.target;        
        var reader = new FileReader();        
        reader.onload = function(){
            var fileData = reader.result;
            var wb = XLSX.read(fileData, {type:'binary'});
            var sheetNameList = wb.SheetNames;
            var firstSheetName = sheetNameList[0];
            var firstSheet = wb.Sheets[firstSheetName];
            callback(firstSheet);
//             wb.SheetNames.forEach(function(sheetName){
//                 var rowObj = XLSX.utils.sheet_to_json(wb.Sheets[sheetName]);
//                 console.log(JSON.stringify(rowObj));
//             });
        };
        reader.readAsBinaryString(input.files[0]);
    }
    
    function handleExcelDataAll(sheet){
        var Obj = XLSX.utils.sheet_to_json(sheet,{header:1,raw:true});
        
        var ExcelList = new Array();
    	Obj.forEach(function(item,idx){
    		if(idx != 0 && item.length > 0){
    			var ExcelData = new Object();
    			ExcelData['auc_obj_dsc'          ] = item[0 ]; /* 경매대상구분코드             */
    			ExcelData['ftsnm'                ] = item[1 ]; /* 농가명                       */
    			ExcelData['sra_pdmnm'            ] = item[2 ]; /* 축산생산자명                 */
    			ExcelData['sra_pd_rgnnm'         ] = item[3 ]; /* 축산생산지역명               */
    			ExcelData['sra_indv_amnno'       ] = item[4 ]; /* 축산개체관리번호             */
    			ExcelData['auc_prg_sq'           ] = item[5 ]; /* 경매번호                     */
    			ExcelData['trpcs_py_yn'          ] = item[6 ]; /* 운송비지급여부               */
    			ExcelData['sra_trpcs'            ] = item[7 ]; /* 축산운송비                   */
    			ExcelData['sra_pyiva'            ] = item[8 ]; /* 축산납입출자금               */
    			ExcelData['sra_fed_spy_am'       ] = item[9 ]; /* 축산사료공급금액             */
    			ExcelData['td_rc_cst'            ] = item[10]; /* 당일접수비용                 */
    			ExcelData['vacn_dt'              ] = item[11]; /* 예방접종일자                 */
    			ExcelData['brcl_isp_dt'          ] = item[12]; /* 브루셀라검사일자             */
    			ExcelData['brcl_isp_ctfw_smt_yn' ] = item[13]; /* 브루셀라검사증명서제출여부   */
    			ExcelData['rmhn_yn'              ] = item[14]; /* 제각여부                     */
    			ExcelData['mt12_ovr_yn'          ] = item[15]; /* 12개월이상여부               */
    			ExcelData['mt12_ovr_fee'         ] = item[16]; /* 12개월이상수수료             */
    			ExcelData['ppgcow_fee_dsc'       ] = item[17]; /* 번식우수수료구분코드         */
    			ExcelData['afism_mod_dt'         ] = item[18]; /* 인공수정일자                 */
    			ExcelData['afism_mod_ctfw_smt_yn'] = item[19]; /* 인공수정증명서제출여부       */
    			ExcelData['mod_kpn'              ] = item[20]; /* 수정kpn                      */
    			ExcelData['prny_mtcn'            ] = item[21]; /* 임신개월수                   */
    			ExcelData['prny_jug_yn'          ] = item[22]; /* 임신감정여부                 */
    			ExcelData['prny_yn'              ] = item[23]; /* 임신여부                     */
    			ExcelData['ncss_jug_yn'          ] = item[24]; /* 괴사감정여부                 */
    			ExcelData['ncss_yn'              ] = item[25]; /* 괴사여부                     */
    			ExcelData['rmk_cntn'             ] = item[26]; /* 비고                         */
    			ExcelData['fhs_id_no'            ] = item[27]; /* 농가식별번호                 */
    			ExcelData['farm_amnno'           ] = item[28]; /* 농가관리번호                 */
    			ExcelList.push(ExcelData);
    		}
    	});
    	console.log(ExcelList);
    	fn_CreateGrid(ExcelList); 
    }
</script>
</html>