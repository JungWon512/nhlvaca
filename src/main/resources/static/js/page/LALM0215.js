
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0215
 * 3. 파일명(한글) : 출장우내역등록
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.18   신명진   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    var na_bzplc = App_na_bzplc;
    //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
    var mv_RunMode             = 0;
    var mv_flg                 = "";
    var mv_vhc_shrt_c          = "";
    var mv_vhc_drv_caffnm      = "";
    var mv_auc_dt              = "";
    var mv_auc_chg_dt          = "";
    var mv_Today               = "";
    var mv_auc_obj_dsc         = "";
    var mv_gvno_bascd          = "";
    var mv_lvst_mkt_trpl_amnno = "";
    var mv_vhc_shrt_c          = "";
    var mv_vhc_drv_caffnm      = "";
    var mv_Today               = "";
    var mv_sgno_prc_dsc			= "";
    var setRowStatus           = "";
 	// init시 저장 후 init인지 아닌지 체크
    var mv_InitBoolean         = true;
    var mv_Tab_Boolean		   = false;
    var rowId                  = "";
	//EPD 연계 
	//부여 : 8808990660127 | 창녕 : 8808990656274 | 진주 : 8808990657240 | 함양산청 : 8808990656410 | 합천 : 8808990656236 | 상주 : 8808990657639 | 횡성 : 8808990656885 | 예산 : 8808990657196
	var arrNaBzplc = ['8808990660127','8808990656274','8808990657240','8808990656410','8808990657639','8808990656885','8808990657196'];
	
//    const endpoint = new AWS.Endpoint('https://kr.object.ncloudstorage.com');
//	const region = 'kr-standard';
//	const bucket_name = 'smartauction-storage';
//	const access_key = 'LBIYVr5QNEVHjiMOha3w';
//	const secret_key = 'NB06umoPLA89ODh48DlVs7n2OTlKjDs0c4IOArif';
//	
//	const S3 = new AWS.S3({
//		endpoint: endpoint,
//		region: region,
//		credentials: {
//			accessKeyId : access_key,
//			secretAccessKey: secret_key
//		}
//	});
    
	$(document).ready(function(){
		if(parent.envList[0] == null) {
			MessagePopup("OK", "응찰단위금액이 입력되지 않았습니다.",function(res){
				fn_OpenMenu('LALM0912','',true);
				return;
			});
			
			return;
		}
		
		$(".tab_content").hide();
        $(".tab_content:first").show();
        $("#tab2_text").hide();
        $("#tab3_text").hide();
        fn_CreateCalfGrid();
        
        var $tabEvtT = $('.tab_box .tab_list li a');        
		$tabEvtT.on('click',function(){
			$tabEvtT.removeClass('on');
			$(this).addClass('on');
			$(".tab_content").hide();
			var activeTab = $(this).attr("href");
			$(activeTab).fadeIn();
			return false;
	    });
		
		$("#chg_pgid").val("[LM0215]");
		
		// 최초 콤보박스 세팅
		fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1);
		fn_setCodeBox("rg_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
		fn_setCodeBox("mcow_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
		fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1);
		fn_setCodeBox("case_cow", "SRA_SOG_COW_DSC",1, null, "선택");
	    fn_setCodeBox("ppgcow_fee_dsc", "PPGCOW_FEE_DSC",1);
	    
	    // 수의사 콤보박스 세팅
	    fn_createVetCodeBox("lvst_mkt_trpl_amnno", null, "선택");
	    
	 	// 최초 라디오버튼 세팅
	    fn_setCodeRadio("rd_auc_obj_dsc","auc_obj_dsc","AUC_OBJ_DSC", 1);
	 	
	    mv_auc_dt              = "";
	    mv_auc_obj_dsc         = "1";
	    mv_gvno_bascd          = "0";
	    mv_lvst_mkt_trpl_amnno = "";
	    
	    $("#firstBody").hide();
		$("#secondBody").show();
		$("#thirdBody").show();
		
	 	// 라디오버튼 초기화
		fn_InitRadioSet();
	    
	    fn_InitSet();
	    
		// 사료미사용여부
		if($("#sra_fed_spy_yn").is(":checked")) {
			$("#sra_fed_spy_yn_fee").val("0");
		} else {
			$("#sra_fed_spy_yn_fee").val(parent.envList[0]["SRA_FED_SPY_YN_FEE"]);	/* 사료미사용여부수수료       */
		}
	    
	    /******************************
         * 프로그램ID 대문자 변환
         ******************************/
	    $("#de_pgid").bind("keyup", function(){
	        $(this).val($(this).val().toUpperCase());
	    });
	    
	 	/******************************
         * 경매대상 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("click", "input[name='auc_obj_dsc_radio']", function(e) {
        	fn_AucOnjDscModify("init");
        	
        });
    	
     	/******************************
         * 경매번호기준 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("click", "input[name='rd_gvno_bascd']", function(e) {
        	fn_GvnoBascdModify();
        });
    	
    	/******************************
         * 임신구분 콤보박스 이벤트
         ******************************/
    	$("#ppgcow_fee_dsc").change(function(e) {
    		if($("#ppgcow_fee_dsc").val() == "3" || $("#ppgcow_fee_dsc").val() =="4") {
    			$("#pb_tab2").show();
    		} else {
    			// ★경주: 8808990659008
    			if (App_na_bzplc == '8808990659008' && $("#ppgcow_fee_dsc").val() == "1") {
    				$("#pb_tab2").show();
    			} else {
    				$("#pb_tab2").hide();
    			}
    		}
    		
    		// 번식우
    		if($("#auc_obj_dsc").val() == "3") {
   		        if($("#ppgcow_fee_dsc").val() == "1" ||  $("#ppgcow_fee_dsc").val() == "3") {
   		      		// ★익산: 8808990227283
   		        	if(App_na_bzplc == "8808990227283") {
   		        		fn_contrChBox(false, "prny_jug_yn", "");   		        		
   		            } else {
   		            	fn_contrChBox(true, "prny_jug_yn", "");
   		            	//경주축협일때 임신구분 자동체크
   		            	if (App_na_bzplc == '8808990659008'){
	   		        		fn_contrChBox(true, "prny_yn", "");						   
 					    }
   		            }
   		        } else {
   		        	fn_contrChBox(false, "prny_jug_yn", "");
	            	//경주축협일때 임신구분 자동체크
	            	if (App_na_bzplc == '8808990659008'){
   		        		fn_contrChBox(false, "prny_yn", "");						   
				    }
   		        }

   		  		// ★거창: 8808990659701
   		        if(App_na_bzplc == "8808990659701") {
   		            if($("#ppgcow_fee_dsc").val() == "2" || $("#ppgcow_fee_dsc").val() == "4") {
   		                $("#afism_mod_dt").val("");
   		             	$("#prny_mtcn").val("");
   		             	fn_AfismModDtModify();
   		            }
   		        }
   		    }
    		
    		// 번식우 선택시 임신감정여부 체크
    		// ★밀양: 8808990656663
			//if(App_na_bzplc == '8808990656663') {
			//	fn_contrChBox(true, "prny_jug_yn", "");
			//	$("#prny_jug_yn").val("1");
			//}
    	    if($("#chk_continue").is(":checked")) {
    	    	fn_ChkContinue();
    		}
    	    if($("#chk_continue1").is(":checked")) {
    	    	fn_ChkContinue2();
    		}
    	});
    	
    	/******************************
         * 경매일자 변경이벤트
         ******************************/
    	$("#auc_dt").change(function(e) {
    	    if(mv_RunMode == "1" && mv_flg == "") {
    	    	fn_AucOnjDscModify();
    	    }
    		$("#hed_indv_no").val("410");
    	});
    	
    	/******************************
         * 개체이월일자 변경이벤트
         ******************************/
    	$("#auc_chg_dt").change(function(e) {
    	    if(mv_RunMode == "1" && mv_flg == "") {
    	    	fn_AucOnjDscModify();
    	    }
    	});
    	
    	/******************************
         * 임신개월수 변경 이벤트
         ******************************/
    	$("#prny_mtcn").change(function(e) {
    		if (!fn_isNull($("#afism_mod_dt").val())) {
    	        if ($("#prny_mtcn").val() == "0") {    		// 임신개월수
    	        	fn_contrChBox(false, "prny_yn", "");	// 임신여부: 부
    	        }else{
    	        	fn_contrChBox(true, "prny_yn", "");		// 임신여부: 여
    	        }
    	    }
    	    if ($("#prny_mtcn").val() > "0") {         		// 임신개월수
    	    	fn_contrChBox(true, "prny_yn", "");			// 임신여부: 여
    	    } else if ($("#prny_mtcn").val() == "0") {  	// 임신개월수
    	    	fn_contrChBox(false, "prny_yn", "");		// 임신여부: 부
    	    }
    	});
    	
    	/******************************
         * 접수일자 변경 이벤트
         ******************************/
    	$("#auc_dt").change(function(e) {
    		fn_RcDtModify();
    	});
    	
    	/******************************
         * 출하주 구분 콤보박스 변경 이벤트
         ******************************/
    	$("#io_sogmn_maco_yn").change(function(e) {
    		fn_IoSogmnMacoYnModify();
    	});
    	
    	
    	$('#pb_syncVacn').on('click',(e)=>{
            e.preventDefault();            
			fn_CallBrclIspSrch();
		});
		
    	$('#pb_syncEpd').on('click',(e)=>{
            e.preventDefault();            
			fn_CallAiakInfoSync();
		});
		
    	$('#pb_syncMEpd').on('click',(e)=>{
            e.preventDefault();
            if(!fn_isNull($("#mcow_sra_indv_amnno").val())){
				fn_CallAiakInfoSync($("#mcow_sra_indv_amnno").val());				
			}
		});
    	/******************************
         * 중도매인 검색 팝업 호출 이벤트(엔터)
         ******************************/
    	$("#sra_mwmnnm").keydown(function(e){
             if(e.keyCode == 13){
             	if(fn_isNull($("#sra_mwmnnm").val())) {
             		MessagePopup('OK','중도매인 명을 입력하세요.');
                 } else {
                 	var data = new Object();
                 	var qcn = $("#aucQcnGrid").getRowData();
                 	if(qcn[0].AUC_OBJ_DSC == '0'){
						data['auc_obj_dsc'] = qcn[0].AUC_OBJ_DSC;						 
					}else{
						data['auc_obj_dsc'] = $("#auc_obj_dsc").val();						 
					}
                    
                    data['auc_dt']      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
                    data['sra_mwmnnm']  = $("#sra_mwmnnm").val();
                    fn_CallMwmnnmNoPopup(data,true,function(result) {
	                     	if(result){
	                     		$("#trmn_amnno").val(result.TRMN_AMNNO);
	                     		$("#sra_mwmnnm").val(result.SRA_MWMNNM);
	    	                    $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
	    	                    $("#io_mwmn_maco_yn").val(result.IO_MWMN_MACO_YN);
	                     	}
	                     }); 
                 }
              } else {
            	  $("#trmn_amnno").val("");
                  $("#lvst_auc_ptc_mn_no").val("");
                  $("#io_mwmn_maco_yn").val("");
              }
        });
    	
    	/******************************
         * 중도매인 검색 팝업 호출 이벤트(돋보기)
         ******************************/
    	$("#pb_sra_mwmnnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            var data = new Object();
         	var qcn = $("#aucQcnGrid").getRowData();
         	if(qcn[0].AUC_OBJ_DSC == '0'){
				data['auc_obj_dsc'] = qcn[0].AUC_OBJ_DSC;						 
			}else{
            data['auc_obj_dsc'] = $("#auc_obj_dsc").val();
			}
            //data['auc_obj_dsc'] = $("#auc_obj_dsc").val();
            data['auc_dt']      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
            data['sra_mwmnnm']  = $("#sra_mwmnnm").val();
            fn_CallMwmnnmNoPopup(data,false,function(result){
	            	if(result){
	            		$("#trmn_amnno").val(result.TRMN_AMNNO);
	            		$("#sra_mwmnnm").val(result.SRA_MWMNNM);
	                    $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
	                    $("#io_mwmn_maco_yn").val(result.IO_MWMN_MACO_YN);
	            	} else {
	              	  $("#trmn_amnno").val("");
	                  $("#sra_mwmnnm").val("");
	                  $("#lvst_auc_ptc_mn_no").val("");
	                  $("#io_mwmn_maco_yn").val("");
	              	}
	            });
        });
    	
    	/******************************
         * 생산자 검색 팝업 호출 이벤트(엔터)
         ******************************/
    	$("#sra_pdmnm").keydown(function(e){
             if(e.keyCode == 13){
             	if(fn_isNull($("#sra_pdmnm").val())) {
             		MessagePopup('OK','생산자 명을 입력하세요.');
                 } else {
                 	var data = new Object();
                    data['ftsnm'] = $("#sra_pdmnm").val();
                    fn_CallMmFhsPopup(data,true,function(result) {
                     	if(result){
                     		$("#sogmn_c").val(result.FHS_ID_NO);
    	                    $("#sra_pdmnm").val(result.FTSNM);
                     	}
                    }); 
                 }
              } else {
             	 $("#sogmn_c").val("");
              }
        });
    	
    	/******************************
         * 생산자 검색 팝업 호출 이벤트(돋보기)
         ******************************/
    	$("#pb_sra_pdmnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_CallMmFhsPopup(null,false,function(result){
            	if(result){
	         		$("#sogmn_c").val(result.FHS_ID_NO);
	                $("#sra_pdmnm").val(result.FTSNM);
            	}
            });
        });
    	
    	/******************************
         * 수송자 검색 팝업 호출 이벤트(엔터)
         ******************************/
    	$("#vhc_drv_caffnm").keydown(function(e){
             if(e.keyCode == 13){
             	if(fn_isNull($("#vhc_drv_caffnm").val())) {
             		MessagePopup('OK','수송자 명을 입력하세요.');
                 } else {
                 	var data = new Object();
                    data['vhc_drv_caffnm'] = $("#vhc_drv_caffnm").val();
                    fn_CallCaffnmPopup(data,true,function(result) {
                     	if(result){
                     		$("#vhc_shrt_c").val(result.VHC_SHRT_C);
    	                    $("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);
    	                    $("#vhc_drv_caffnm").blur();
                     	}
                     }); 
                 }
              }else {
             	 $("#vhc_shrt_c").val("");
              }
        });
    	
    	/******************************
         * 수송자 검색 팝업 호출 이벤트(돋보기)
         ******************************/
    	$("#pb_vhc_drv_caffnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_CallCaffnmPopup(null,false,function(result){
            	if(result){
            		$("#vhc_shrt_c").val(result.VHC_SHRT_C);
                    $("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);
                    $("#vhc_drv_caffnm").blur();
            	}
            });
        });
    	
    	/******************************
         * 개체이력 조회(인터페이스) 팝업버튼 클릭 이벤트
         ******************************/
    	$("#pb_IndvHst").on('click',function(e){
    		e.preventDefault();
            this.blur();
            fn_popInfHstPopup(false);
    	});
    	
    	/******************************
         * 귀표번호 검색 팝업 호출 이벤트(돋보기)
         ******************************/
    	$("#pb_sra_indv_amnno").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            fn_CallIndvInfSrchPopup(false, "");
        });
    	
    	/******************************
         * 귀표번호 검색 팝업 호출 이벤트(엔터)
         ******************************/
    	$("#sra_indv_amnno").keydown(function(e) {
             if(e.keyCode == 13) {
            	 if(fn_isNull($("#sra_indv_amnno").val())) {
            		 MessagePopup('OK','귀표번호를 입력하세요.');
            		 return;
            		 
            	 } else {
            		 // 출장우 등록시 이전 경매에 참가한 개체 확인창 요청
            	     // ★문경: 8808990656427 충주: 8808990656465
            		 if(App_na_bzplc == "8808990656427" || App_na_bzplc == "8808990656465") {
            			 var resultsndv = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selIndvAmnnoPgm", "POST");    
						 var resultndv;
             	       
             	         if(resultsndv.status != RETURN_SUCCESS){
             	        	 //showErrorMessage(resultsndv);
     	            		 fn_CallIndvInfSrch();
             	         } else {
             	        	 resultIndv = setDecrypt(resultsndv);
             	             var t_sra_indv_amnno = resultIndv[0]["SRA_INDV_AMNNO"];
             	             var t_auc_dt         = resultIndv[0]["AUC_DT"];
             	             var t_auc_prg_sq     = resultIndv[0]["AUC_PRG_SQ"];
             	           
             	             MessagePopup('YESNO',"개체[" + t_sra_indv_amnno + "]는 [" + t_auc_dt + "]경매에 [" + t_auc_prg_sq + "]번 출장우로 참가한 개체입니다. 등록하시겠습니까?",function(res){
             	            	 if(res) {
             	            		 fn_CallIndvInfSrch();
             	            	 } else {
             	            		 $("#sra_indv_amnno").val("");
             	            		 return;
             	        		 }
             	             });
             	         }
            		 } else {
            			 fn_CallIndvInfSrch();
            		 }
            	 }
              } else {
            	  if(na_bzplc != '8808990656601') {
            		  $("#sra_srs_dsc").val("01");
            		  $("#fhs_id_no").val("");
            		  $("#farm_amnno").val("");
            		  $("#ftsnm").val("");
            		  $("#ohse_telno").val("");
            		  $("#zip").val("");
            		  $("#dongup").val("");
            		  $("#dongbw").val("");
            		  $("#sra_pdmnm").val("");
            		  $("#sra_pd_rgnnm").val("");
            		  $("#sog_na_trpl_c").val("");
            		  $("#indv_sex_c").val("0");
            		  $("#birth").val("");
            		  $("#indv_id_no").val("");
            		  $("#sra_indv_brdsra_rg_no").val("");
            		  $("#rg_dsc").val("");
            		  $("#kpn_no").val("");
            		  $("#mcow_dsc").val("");
            		  $("#mcow_sra_indv_amnno").val("");
            		  $("#matime").val("");
            		  $("#sra_indv_pasg_qcn").val("");
            		  $("#io_sogmn_maco_yn").val("");
            		  $("#sogmn").val("");
            		  $("#sra_farm_acno").val("");
            		  $("#mod_kpn_no").val("");
            	  }
              }
        });
    	
    	/******************************
         * 귀표번호 변경 이벤트
         ******************************/
    	$("#sra_indv_amnno").change(function() {
    		if(!fn_isNull($("#sra_indv_amnno").val())) {
    			$("#re_indv_no").val($("#hed_indv_no").val() + $("#sra_indv_amnno").val());
       	 	}
    	});
    	
    	/******************************
         * 출하주 검색 팝업 호출 이벤트(엔터)
         ******************************/
    	$("#ftsnm").keydown(function(e){        	
    		if(e.keyCode == 13){
    			if(fn_isNull($("#fhs_id_no").val())) {
    				if(fn_isNull($("#ftsnm").val())) {
    					MessagePopup('OK','출하주 명을 입력하세요.');
                    } else {
                    	fn_CallFtsnmPopup(true);
                    }
    			} else if(!fn_isNull($("#indv_sex_c").val()) || !fn_isNull($("#birth").val())) {
    				$("#vacn_dt").focus();
    			} else{
					$("#ftsnm").blur();
				}
            }else{
				$("#fhs_id_no").val("");
          	  	$("#farm_amnno").val("");
          	  	$("#ohse_telno").val("");
          	  	$("#zip").val("");
          	  	$("#dongup").val("");
          	  	$("#dongbw").val("");
          	  	$("#sra_pdmnm").val("");
          	  	$("#sra_pd_rgnnm").val("");
          	  	$("#sog_na_trpl_c").val("");
          	  	$("#io_sogmn_maco_yn").val("");
          	  	$("#sra_farm_acno").val("");
			}
        });
    	
    	/******************************
         * 출하주 검색 팝업 호출 이벤트(돋보기)
         ******************************/
    	$("#pb_ftsnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_CallFtsnmPopup(false);
        });
    	
    	/******************************
         * 출하주 변경 이벤트(키업)
         ******************************/
    	//$("#ftsnm").on("change keyup paste", function(e){
		//	if(e.keyCode != 13) {
		//		$("#fhs_id_no").val("");
        //  	  	$("#farm_amnno").val("");
        //  	  	$("#ohse_telno").val("");
        //  	  	$("#zip").val("");
        //  	  	$("#dongup").val("");
        //  	  	$("#dongbw").val("");
        //  	  	$("#sra_pdmnm").val("");
        //  	  	$("#sra_pd_rgnnm").val("");
        //  	  	$("#sog_na_trpl_c").val("");
        //  	  	$("#io_sogmn_maco_yn").val("");
        //  	  	$("#sra_farm_acno").val("");
        //     }
    	//});
    	
    	/******************************
         * 출하주 변경 이벤트(체인지 포커스아웃)
         ******************************/
    	$("#ftsnm").change(function() {
    		fn_FtsnmModify();
    	});
    	
    	/******************************
         * 경매번호 조회 클릭 이벤트
         ******************************/
    	$("#pb_auc_prg_sq").on('click',function(e){
            e.preventDefault();
            this.blur();
	    	fn_DisableAuc(true);
	    	
            if(fn_isNull($("#auc_dt").val()) || fn_isNull($("#auc_prg_sq").val())) {
            	MessagePopup('OK','경매일자 / 경매번호를 확인해 주세요.');
				return;
            }
            
            var results = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selOslpNo", "POST");
       	 	var result = null;
       	 	
	       	if(results.status != RETURN_SUCCESS){
	            showErrorMessage(results);
	            mv_InitBoolean = true;
	            mv_Tab_Boolean = false;
	            fn_Init();
//	            fn_selCowImg();
	            $("#btn_Delete").attr("disabled", true);
	            return;
	        } else {
	            result = setDecrypt(results);
	            //mv_InitBoolean = true;
	            //fn_Init();
	            fn_AucOnjDscModify();
	            
	            $("#hdn_auc_dt").val(fn_dateToData($("#auc_dt").val()));
	    		$("#hdn_auc_obj_dsc").val($("#auc_obj_dsc").val());
	    		$("#hdn_oslp_no").val(result[0]["OSLP_NO"]);
	    		
	    		fn_Search();
	    		
	    		$("#emp_auc_prg_sq").val($("#auc_prg_sq").val());
	    		$("#emp_sra_indv_amnno").val("410" + $("#sra_indv_amnno").val());
	    		
	    		if(!fn_isNull($("#lows_sbid_lmt_am").val())) {
	    			if ($("#auc_obj_dsc").val() == "1") {
	    				$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]));
	    			}
	    			else if ($("#auc_obj_dsc").val() == "2") {
	    				$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]));
	    			}
	    			else if ($("#auc_obj_dsc").val() == "3") {
	    				$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]));
	    			}
	    		}
	    		
	    		$("#btn_Save").attr("disabled", false);
		    	$("#btn_Delete").attr("disabled", false);
	    		
	    		fn_SelMhCalf();
	        }
	       	if($("#ppgcow_fee_dsc").val() == "3" || $("#ppgcow_fee_dsc").val() == "4") {
	       		$("#pb_tab2").show(); 
    		} else {
    			// ★경주: 8808990659008
    			if (na_bzplc == '8808990659008' && $("#ppgcow_fee_dsc").val() == "1") {
    				$("#pb_tab2").show();
    			} else {
    				$("#pb_tab2").hide();
    			}
    		}
    		
    		// 번식우
    		if($("#auc_obj_dsc").val() == "3") {	      		
        		//2022.08.08 익산의 경우 값이 수정했을경우 수정한값으로 표기되게 기존 false 고정
	        	//if(!arrPrnyJugNaBzplc.includes(App_na_bzplc)) {
	   		    //    if($("#ppgcow_fee_dsc").val() == "1" ||  $("#ppgcow_fee_dsc").val() == "3") {
		        //    	fn_contrChBox(true, "prny_jug_yn", "");
	   		    //    } else {
	   		    //    	fn_contrChBox(false, "prny_jug_yn", "");
	   		    //    }
   		        //}

   		  		// ★거창: 8808990659701
   		        if(App_na_bzplc == "8808990659701") {
   		            if($("#ppgcow_fee_dsc").val() == "2" || $("#ppgcow_fee_dsc").val() == "4") {
   		                $("#afism_mod_dt").val("");
   		             	$("#prny_mtcn").val("");
   		             	fn_AfismModDtModify();
   		            }
   		        }
   		    }
    		
    		mv_InitBoolean = false;
    		$("#sra_indv_amnno").attr("disabled", true);
	    	$("#pb_IndvHst").attr("disabled", true);
	    	$("#pb_sra_indv_amnno").attr("disabled", true);
    		
    		// 번식우 선택시 임신감정여부 체크
    	    if($("#chk_continue").is(":checked")) {
    	    	fn_ChkContinue();
    		}
    	    if($("#chk_continue1").is(":checked")) {
    	    	fn_ChkContinue2();
    		}
    	    fn_ClearReProduct();           
        });
    	
    	/******************************
         * 경매번호 엔터 이벤트
         ******************************/
    	$("#auc_prg_sq").keydown(function(e) {        	
             if(e.keyCode == 13) {
            	 if(!fn_isNull($("#auc_prg_sq").val())) {
            		 $("#sra_indv_amnno").focus();
            	 }
              }
        });
    	
    	/******************************
         * 예방접종일 엔터 이벤트
         ******************************/
    	$("#vacn_dt").keydown(function(e){
             if(e.keyCode == 13) {
            	 if(!fn_isNull($("#vacn_dt").val())) {
            		 $("#brcl_isp_dt").focus();
            	 }
              }
        });
    	
    	/******************************
         * 브루셀라 검사일 엔터 이벤트
         ******************************/
    	$("#brcl_isp_dt").keydown(function(e){
             if(e.keyCode == 13) {
            	 // 경주: 8808990659008
            	 if(App_na_bzplc == "8808990659008") {
					$("#ppgcow_fee_dsc").focus();
            	 }
             }
        });
    	
    	/******************************
         * 중량 변경 이벤트
         ******************************/
    	$("#cow_sog_wt").on("change keyup paste", function(e) {        	
             if(e.keyCode != 13) {
            	 if($("#auc_obj_dsc").val() == "2") {
             		// Kg별
             		if(parent.envList[0]["NBFCT_AUC_UPR_DSC"] == "1") {
             			
             			var v_sra_sbid_am = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(fn_delComma($("#cow_sog_wt").val())) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);

             			// 절사
             			if(mv_sgno_prc_dsc == "1") {
             				v_sra_sbid_am = Math.floor(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			// 절상
             			} else if(mv_sgno_prc_dsc == "2") {
             				v_sra_sbid_am = Math.ceil(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			// 사사오입
             			} else {
             				v_sra_sbid_am = Math.round(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			}
             			if(isNaN(parseInt(v_sra_sbid_am))) $("#sra_sbid_am").val(0);
             			else $("#sra_sbid_am").val(fn_toComma(v_sra_sbid_am));
             		}
             	}
			}
        });
    	
    	/******************************
         * 응찰 예정가 변경 이벤트
         ******************************/
    	$("#lows_sbid_lmt_am_ex").on("change keyup paste", function(e){        	
            if(e.keyCode != 13) {
				// 송아지
            	if($("#auc_obj_dsc").val() == "1") {
					$("#lows_sbid_lmt_am").val(fn_toComma(parseInt($("#lows_sbid_lmt_am_ex").val()) * parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"])));
				// 비육우
            	} else if($("#auc_obj_dsc").val() == "2") {
             		$("#lows_sbid_lmt_am").val(fn_toComma(parseInt($("#lows_sbid_lmt_am_ex").val()) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"])));
             	// 번식우
            	} else {
             		$("#lows_sbid_lmt_am").val(fn_toComma(parseInt($("#lows_sbid_lmt_am_ex").val()) * parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"])));
             	}
            	if(fn_isNull($("#lows_sbid_lmt_am_ex").val())) {
            		$("#lows_sbid_lmt_am").val("0");
            	}
			}
        });
    	
    	/******************************
         * 개체이월 버튼클릭 이벤트
         ******************************/
    	$("#pb_AucChange").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_AucChange();
    	});
    	
     	/******************************
         * 자가운송여부 checkbox 이벤트
         ******************************/
        $("#trpcs_py_yn").change(function() {
        	fn_TrpcsPyYnModify();		
    	});
     	
     	/******************************
         * 사료사용여부 checkbox 이벤트
         ******************************/
        $("#sra_fed_spy_yn").change(function() {
    		if($("#sra_fed_spy_yn").is(":checked")) {
    			fn_contrChBox(true, "sra_fed_spy_yn", "");
    			$("#sra_fed_spy_yn_text").text("여");
    			$("#sra_fed_spy_yn_fee").val(parent.envList[0]["SRA_FED_SPY_YN_FEE"]);
    			$("#sra_fed_spy_yn_fee").attr("disabled", false);
    		} else {
    			fn_contrChBox(false, "sra_fed_spy_yn", "");
    			$("#sra_fed_spy_yn_text").text("부");
    			$("#sra_fed_spy_yn_fee").val("0");
    			$("#sra_fed_spy_yn_fee").attr("disabled", true);
    		}
    	});
     	
     	/******************************
         * 브루셀라검사증확인여부 checkbox 이벤트
         ******************************/
        $("#brcl_isp_ctfw_smt_yn").change(function() {
    		if($("#brcl_isp_ctfw_smt_yn").is(":checked")) {
    			fn_contrChBox(true, "brcl_isp_ctfw_smt_yn", "");
    			$("#brcl_isp_ctfw_smt_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "brcl_isp_ctfw_smt_yn", "");
    			$("#brcl_isp_ctfw_smt_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 제각여부 checkbox 이벤트
         ******************************/
        $("#rmhn_yn").change(function() {
    		if($("#rmhn_yn").is(":checked")) {
    			fn_contrChBox(true, "rmhn_yn", "");
    			$("#rmhn_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "rmhn_yn", "");
    			$("#rmhn_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 난소적출여부 checkbox 이벤트
         ******************************/
        $("#spay_yn").change(function() {
    		if($("#spay_yn").is(":checked")) {
    			fn_contrChBox(true, "spay_yn", "");
    			$("#spay_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "spay_yn", "");
    			$("#spay_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 친자검사여부 checkbox 이벤트
         ******************************/
        $("#dna_yn_chk").change(function() {
    		if($("#dna_yn_chk").is(":checked")) {
    			fn_contrChBox(true, "dna_yn_chk", "");
    			$("#dna_yn_chk_text").text("여");
    		} else {
    			fn_contrChBox(false, "dna_yn_chk", "");
    			$("#dna_yn_chk_text").text("부");
    			$("#rmk_cntn").val("");
    		}
    	});
     	
     	/******************************
         * 출하수수료 수기등록 checkbox 이벤트
         ******************************/
        $("#fee_chk_yn").change(function() {
    		if($("#fee_chk_yn").is(":checked")) {
    			fn_contrChBox(true, "fee_chk_yn", "");
    			$("#fee_chk_yn_fee").attr("disabled", false);
    			$("#fee_chk_yn_text").text("여");
    			$("#fee_chk_yn_fee").val("0");
    		} else {
    			fn_contrChBox(false, "fee_chk_yn", "");
    			$("#fee_chk_yn_fee").attr("disabled", true);
    			$("#fee_chk_yn_text").text("부");
    			$("#fee_chk_yn_fee").val("0");
    		}
    	});
     	
     	/******************************
         * 판매수수료 수기등록 checkbox 이벤트
         ******************************/
        $("#selfee_chk_yn").change(function() {
    		if($(this).is(":checked")) {
    			fn_contrChBox(true, "selfee_chk_yn", "");
    			$("#selfee_chk_yn_fee").attr("disabled", false);
    			$("#selfee_chk_yn_text").text("여");
    			$("#selfee_chk_yn_fee").val("0");
    		} else {
    			fn_contrChBox(false, "selfee_chk_yn", "");
    			$("#selfee_chk_yn_fee").attr("disabled", true);
    			$("#selfee_chk_yn_text").text("부");
    			$("#selfee_chk_yn_fee").val("0");
    		}
    	});
     	
     	/******************************
         * 인공수정증명서 제출여부 checkbox 이벤트
         ******************************/
        $("#afism_mod_ctfw_smt_yn").change(function() {
    		if($("#afism_mod_ctfw_smt_yn").is(":checked")) {
    			fn_contrChBox(true, "afism_mod_ctfw_smt_yn", "");
    			$("#afism_mod_ctfw_smt_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "afism_mod_ctfw_smt_yn", "");
    			$("#afism_mod_ctfw_smt_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 임신감정여부 checkbox 이벤트
         ******************************/
        $("#prny_jug_yn").change(function() {
    		if($("#prny_jug_yn").is(":checked")) {
    			fn_contrChBox(true, "prny_jug_yn", "");
    			$("#prny_jug_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "prny_jug_yn", "");
    			$("#prny_jug_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 임신여부 checkbox 이벤트
         ******************************/
        $("#prny_yn").change(function() {
    		if($("#prny_yn").is(":checked")) {
    			fn_contrChBox(true, "prny_yn", "");
    			$("#prny_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "prny_yn", "");
    			$("#prny_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 괴사감정여부 checkbox 이벤트
         ******************************/
        $("#ncss_jug_yn").change(function() {
    		if($("#ncss_jug_yn").is(":checked")) {
    			fn_contrChBox(true, "ncss_jug_yn", "");
    			$("#ncss_jug_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "ncss_jug_yn", "");
    			$("#ncss_jug_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 괴사여부 checkbox 이벤트
         ******************************/
        $("#ncss_yn").change(function() {
    		if($("#ncss_yn").is(":checked")) {
    			fn_contrChBox(true, "ncss_yn", "");
    			$("#ncss_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "ncss_yn", "");
    			$("#ncss_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 12개월이상여부 checkbox 이벤트
         ******************************/
        $("#mt12_ovr_yn").change(function() {
    		if($("#mt12_ovr_yn").is(":checked")) {
    			fn_contrChBox(true, "mt12_ovr_yn", "");
    			$("#mt12_ovr_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "mt12_ovr_yn", "");
    			$("#mt12_ovr_yn_text").text("부");
    		}
    		
    		if($("#auc_obj_dsc").val() == "1") {
    			if($("#mt12_ovr_yn").is(":checked")) {
    				$("#mt12_ovr_fee").attr("disabled", false);
    				$("#mt12_ovr_fee").val(parent.envList[0]["MT12_OVR_FEE"]);
    			} else {
    				$("#mt12_ovr_fee").attr("disabled", true);
    				$("#mt12_ovr_fee").val("0");
    			}
    		}
    	});
     	
     	/******************************
         * 고능력 여부 checkbox 이벤트
         ******************************/
        $("#epd_yn").change(function() {
    		if($("#epd_yn").is(":checked")) {
    			fn_contrChBox(true, "epd_yn", "");
    			$("#epd_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "epd_yn", "");
    			$("#epd_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 개체수기등록 checkbox 이벤트
         ******************************/
        $("#chk_AucNoChg").change(function() {
    		if($("#chk_AucNoChg").is(":checked")) {
    			$("pb_Indvfhs").show();
    		} else {
    			$("pb_Indvfhs").hide();
    		}    		
    	});
     	
     	/******************************
         * 사료사용여부 checkbox 이벤트
         ******************************/
        $("#fed_spy_yn").change(function() {
    		if($("#fed_spy_yn").is(":checked")) {
    			fn_contrChBox(true, "fed_spy_yn", "");
    			$("#fed_spy_yn_text").text("여");
    		} else {
    			fn_contrChBox(false, "fed_spy_yn", "");
    			$("#fed_spy_yn_text").text("부");
    		}
    	});
     	
     	/******************************
         * 개체수기등록 이벤트
         ******************************/
        $("#sel_sts_dsc").change(function() {
    		if($("#sel_sts_dsc").val() == "11") {
    			$("#trmn_amnno").val("");
    			$("#sra_mwmnnm").val("");
    			$("#lvst_auc_ptc_mn_no").val("");
    			$("#sra_sbid_am").val("0");
    			$("#sra_sbid_upr").val("0");
    		}    		
    	});
     	
     	/******************************
         * 낙찰가 금액변경 이벤트
         ******************************/
        $("#sra_sbid_upr").on("change keyup paste", function(e) {
            if(e.keyCode != 13) {
            	// 송아지
            	if($("#auc_obj_dsc").val() == "1") {
            		$("#sra_sbid_am").val(fn_toComma(parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"])));
            	// 비육우
            	} else if($("#auc_obj_dsc").val() == "2") {
            		// Kg별
            		if(parent.envList[0]["NBFCT_AUC_UPR_DSC"] == "1") {
            			
            			var v_sra_sbid_am = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(fn_delComma($("#cow_sog_wt").val())) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
            			
            			// 절사
            			if(mv_sgno_prc_dsc == "1") {
            				v_sra_sbid_am = Math.floor(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
            			// 절상
            			} else if(mv_sgno_prc_dsc == "2") {
            				v_sra_sbid_am = Math.ceil(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
            			// 사사오입
            			} else {
            				v_sra_sbid_am = Math.round(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
            			}
            			
             			if(isNaN(parseInt(v_sra_sbid_am))) $("#sra_sbid_am").val(0);
             			else $("#sra_sbid_am").val(fn_toComma(v_sra_sbid_am));
            		// 두별
            		} else {
            			$("#sra_sbid_am").val(fn_toComma(parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"])));
            		}
            	// 번식우
            	} else {
            		$("#sra_sbid_am").val(fn_toComma(parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"])));
            	}
            	if(fn_isNull($("#sra_sbid_upr").val())) {
            		$("#sra_sbid_am").val("0");
            	}
             }
       	});
     	
     	/******************************
         * 낙찰가 금액 초기화 이벤트
         ******************************/
        $("#sra_sbid_upr").bind("focus", function(e) {
        	mv_flag = '0';
       });
     	
		/******************************
         * 낙찰가 금액 이벤트
         ******************************/
//         $("#sra_sbid_upr").blur(function(e) {
//         	if(parseInt($("#sra_sbid_upr").val()) > 0 && (parseInt($("#sra_sbid_upr").val()) < parseInt($("#lows_sbid_lmt_am_ex").val()))) {
//         		if (mv_flag == '1') return;
//         		MessagePopup('YESNO',"낙찰가["+$("#lows_sbid_lmt_am_ex").val()+"]가 예정가보다 작습니다. 계속 진행하시겠습니까?",function(res){
//         			if(res) {
//         				mv_flag = "1";
//         			} else {
//         				$("#sra_sbid_upr").focus();
//         			}
//         		});
//         	}
//        	});
		
        /******************************
         * 행추가 버튼 이벤트
         ******************************/
		$("#pb_plusRow").on("click", function(e) {
			e.preventDefault();
			rowId ++;
			var data = {_STATUS_:'+', SRA_INDV_AMNNO:'', INDV_SEX_C:'', BIRTH:'', KPN_NO:'', AUC_OBJ_DSC:'', AUC_DT:'', OSLP_NO:'', RG_SQNO:'', SRA_SRS_DSC:'', TMS_YN:'', DEL_YN:'', MCOW_SRA_INDV_AMNNO:'', COW_SOG_WT:'0'};
			$("#calfGrid").jqGrid("addRowData", rowId, data, 'last');
		});
		
		/******************************
         * 행삭제 버튼 이벤트
         ******************************/
		$("#pb_minusRow").on("click", function(e) {
			e.preventDefault();
			var selRowIds = $("#calfGrid").jqGrid("getGridParam", "selrow");
			
			if ($("#calfGrid").jqGrid('getCell', selRowIds, '_STATUS_') != '+') {
				$("#calfGrid").jqGrid('setCell', selRowIds, '_STATUS_', '-')
			} else {
				$("#calfGrid").jqGrid("delRowData", selRowIds);
			}
			
            var getData = $("#calfGrid").jqGrid('getRowData');
            $("#calfGrid").jqGrid("clearGridData", true);
            var rowid = 1;
            for (var i = 0, len = getData.length; i < len; i++) {
            	$("#calfGrid").jqGrid("addRowData", rowid, getData[i], 'last');
            	
            	if(getData[i]["_STATUS_"] == '+') {
            		$("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '+');
            	} else if(getData[i]["_STATUS_"] == '*') {
            		$("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);
            	}
            	
            	rowid++;
            }
		});

		 /******************************
         * 이미지 등록 이벤트
         ******************************/
         $("#addImg").click(function(e){
        	e.preventDefault();
 	        $("#uploadImg").click();
 	    });
         
         $("#uploadImg").on("change", function(e){
        	 fn_ImageFiles(e);
	    });
		
     	/******************************
         * 텝1번 클릭 이벤트
         ******************************/
    	$("#pb_tab1").on('click',function(e){
    		e.preventDefault();
    		$("#tab1_text").show();
    		$("#tab2_text").hide();
    		$("#tab3_text").hide();
        });
     	
    	/******************************
         * 텝2번 클릭 이벤트
         ******************************/
    	$("#pb_tab2").on('click',function(e){
    		e.preventDefault();
    		$("#tab1_text").hide();
    		$("#tab2_text").show();
    		$("#tab3_text").hide();
        });
        
        /******************************
         * 텝3번 클릭 이벤트
         ******************************/
    	$("#pb_tab3").on('click',function(e){
    		e.preventDefault();
    		$("#tab1_text").hide();
    		$("#tab2_text").hide();
    		$("#tab3_text").show();
    		
    		mv_Tab_Boolean = true;
    		fn_selCowImg();
        });

    	/******************************
         * 인공수정일자 변경 이벤트
         ******************************/
    	$("#afism_mod_dt").on('change',function(e) {
    		var d1 = new Date($('#auc_dt').val());
    		var d2 = new Date($(this).val());
    		//console.log(d1.getMonth() - d2.getMonth() + (12*(d1.getFullYear() - d2.getFullYear())));
    		var result = d1.getMonth() - d2.getMonth() + (12*(d1.getFullYear() - d2.getFullYear()));
    		if(d1.getDate() - d2.getDate() < 0){
    			result-=1;
    		}
    		result = result<0?0:result;
    		$("#prny_mtcn").val(result+=1);
    	});
	});
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
	function fn_Init() {
    	 //그리드 초기화
    	 $(".tab_content").hide();
         $(".tab_content:first").show();
         $("#tab2_text").hide();
         $("#tab3_text").hide();
         
		 $("#pb_tab1").addClass('on');
		 $("#pb_tab2").removeClass('on');
		 $("#pb_tab3").removeClass('on');
		 
    	 if(mv_InitBoolean) {
    		 fn_Reset();
    	 } else {
    		 MessagePopup('YESNO',"초기화 하시겠습니까?",function(res){
   	 			if(res){
   	 				fn_Reset();
   	 				mv_InitBoolean = true;
   	 				mv_Tab_Boolean = false;
   	     		} else {    			
   	     			MessagePopup('OK','취소되었습니다.');
   	     			return;
   	     		}
   	 		});
    	 }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search() {    	 
		
    	mv_RunMode = "2";
		fn_SelList();
				
		$("#re_indv_no").val("410"+$("#sra_indv_amnno").val());
		
		if(fn_isDate($("#afism_mod_dt").val())) {
			
			var tmp_date = fn_getAddDay($("#afism_mod_dt").val(), 285);
			$("#ptur_pla_dt").val(tmp_date.substr(0, 10));
			
		}
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save() {
    	$("#re_indv_no").val($("#hed_indv_no").val() + $("#sra_indv_amnno").val());
    	gridSaveRow('calfGrid');
    	var calfArray = $("#calfGrid").jqGrid("getRowData");
    	var srchData      = new Object();
     	var result        = null;
     	
    	if(calfArray.length > 0) {
    		for(var i = 0; i < calfArray.length; i++) {
    			if(calfArray[i]["SRA_INDV_AMNNO"].length < 15) {
    				MessagePopup("OK", "송아지 귀표번호는 15자리 입니다.귀표번호를 확인 바랍니다.");
    				return;
    			}
    		}
    	}
    	
    	if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#afism_mod_dt").val()))) {
    		MessagePopup("OK", "인공 수정 일자는 경매 일자보다 클 수 없습니다.");
			return;
    	}
    	
    	//============================================================fn_CheckValidSave Start=========================================================================//
    	if(fn_isNull($("#sra_indv_amnno").val())) {
    		MessagePopup("OK", "귀표번호가 정확하지 않습니다.");
			return;
    	}
    	if($("#sra_indv_amnno").val().length != 12) {
    		MessagePopup("OK", "귀표번호는 12자리를 입력하시기 바랍니다.");
			return;
    	}
    	if(($("#indv_sex_c").val()?.length||0) == 0) {
    		MessagePopup("OK", "개체성별코드를 입력하기 바랍니다.");
			return;
    	}
    	if(fn_isNull($.trim($("#fhs_id_no").val()))) {
    		MessagePopup("OK", "출하주가 정확하지 않습니다.");
			return;
    	}
    	if(fn_isNull($.trim($("#ftsnm").val()))) {
    		MessagePopup("OK", "출하주가 정확하지 않습니다.");
			return;
    	}
    	// 수기등록 정합성체크
    	// ★합천: 8808990656236 테스트: 8808990643625 정합성체크 해제
        if(App_na_bzplc != "8808990656236") {
            if(fn_isNull($("#birth").val())) {
            	MessagePopup("OK", "개체 생년월일을 입력하기 바랍니다.");
                return;
            }
        }
     	// ★함평: 8808990656601 합천: 8808990656236  정합성체크 해제
    	if (App_na_bzplc != "8808990656601" &&  App_na_bzplc != "8808990656236" ){
    		if(fn_isNull($("#matime").val())) {
    			MessagePopup("OK", "어미산차를 입력하기 바랍니다.");
                return;
            }
    		if(fn_isNull($("#sra_indv_pasg_qcn").val())) {
    			MessagePopup("OK", "개체 계대를 입력하기 바랍니다.");
                return;
            }
        }
     	
    	// 경매차수 조회
		var resultAucQcn = fn_SelAucQcn();
    	
    	console.log(resultAucQcn, fn_delComma($("#lows_sbid_lmt_am").val()));
		
		if(resultAucQcn == null) {
			MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
			return;
		} else {
			if(resultAucQcn[0]["DDL_YN"] == 1) {
				MessagePopup("OK", "경매마감 되었습니다.");
                return;
			}
		}
		if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#rc_dt").val()))) {
    		MessagePopup("OK", "접수일자는 경매일자 보다 클수 없습니다.");
    		$("#rc_dt").focus();
			return;
    	}
		if(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) > parseInt(resultAucQcn[0]["BASE_LMT_AM"])){
			MessagePopup("OK", "예정가가 최고 응찰 한도금액을 초과 하였습니다.");
			$("#lows_sbid_lmt_am_ex").focus();
	        return;
	    }
		
		var v_sra_sbid_upr = 0;
		//송아지
		if($("#auc_obj_dsc").val() == "1") {
			v_sra_sbid_upr = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
		// 비육우
		} else if($("#auc_obj_dsc").val() == "2") {
			v_sra_sbid_upr = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
		// 번식우
		} else {
			v_sra_sbid_upr = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
		}
		
		if(parseInt(v_sra_sbid_upr) > parseInt(resultAucQcn[0]["BASE_LMT_AM"])) {
			MessagePopup('OK','낙찰단가가 최고 응찰 한도금액을 초과 하였습니다.(최고응찰한도금액:'+resultAucQcn[0]["BASE_LMT_AM"]+'원');
			$("#sra_sbid_upr").focus();
			return;
		}
		
		// 생산지역 길이 체크
		if(!maxLengthCheck("sra_pd_rgnnm", "생산지역", 50)){
			return;
		}

		// 낙찰인경우 낙찰자, 낙찰금액 필수
		if($("#sel_sts_dsc").val() == "22") {
			if(fn_isNull($("#trmn_amnno").val())) {
				MessagePopup('OK','중도매인을 입력하세요.');
				return;
			}

			if(fn_isNull($("#sra_mwmnnm").val())) {
				MessagePopup('OK','중도매인을 입력하세요.');
				return;
			}
			if($("#sra_sbid_upr").val() == "0" || $("#sra_sbid_upr").val() == "") {
				MessagePopup('OK','낙찰단가를 입력하세요.');
				return;
			}
			// 비육우 아닐 경우
			if($("#auc_obj_dsc").val() != "2") {
				if($("#sra_sbid_am").val() == "0") {
					MessagePopup('OK','낙찰금액이 없습니다.');
					return;
				}
			}

			if(parseInt(fn_delComma($("#sra_sbid_upr").val())) < parseInt(fn_delComma($("#lows_sbid_lmt_am_ex").val()))) {
				MessagePopup('OK','낙찰단가가 예정가 보다 작습니다.');
				return;
			}

			if($("#lows_sbid_lmt_am_ex").val() == "0") {
				MessagePopup('OK','예정가가 없습니다.');
				return;
			}
		}
		else {
			//if(!fn_isNull($("#trmn_amnno").val())) {
			//	MessagePopup('OK','낙찰이 아닌경우 중도매인을 입력할수 없습니다.');
			//	$("#trmn_amnno").val("");
			//	$("#sra_mwmnnm").val("");
			//	return;
			//}
			
			if($("#sra_sbid_am").val() != "0") {
				MessagePopup('OK','낙찰이 아닌경우 낙찰금액을 입력할수 없습니다.');
				$("#sra_sbid_upr").focus();
				return;
			}
		}
    	//============================================================fn_CheckValidSave End=========================================================================//
    	
    	var saveMessage = "저장 하시겠습니까?";
    	
    	if(setRowStatus == "update") {
    		var resultStsDscs = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selStsDsc", "POST");
        	var resultStsDsc;
            
        	if(resultStsDscs.status == RETURN_SUCCESS) {
        		resultStsDsc = setDecrypt(resultStsDscs);
        		
        		if(resultStsDsc[0]["SEL_STS_DSC"] != $("#sel_sts_dsc").val()) {
	       			if(resultStsDsc[0]["SEL_STS_DSC"] == '22'){
	       			   var message = '<br/>낙찰상태 변경 사유를 입력하세요.<br/><br/><input id="input_rn" maxlength="30" style="padding: 4px 6px 2px 6px;width: 100%;line-height: 12px;border: 1px solid #d9d9d9;vertical-align: middle;background: #fff;outline: none;"/>';
	       			   message += '<script type="text/javascript">';
	       			   message += '	$(document).find(\'input[id=input_rn]\').focusout(function(e){';
	       			   //message += '		$(\'#chg_rmk_cntn\').val($(this).val());';
	       			   message += '		parent.inputRn=$(this).val();';
	       			   message += '	});';
	       			   message += '<';
	       			   message += "/script>";
	       			   saveMessage += message;  
	       			   fn_SaveSogCow(saveMessage);
	       			   parent.inputRn='';
	       			   return;
	         		}
            		saveMessage = "경매진행상태가 일치하지 않습니다. 그래도 저장하시겠습니까?";
            	}
            }
    	}
    	fn_SaveSogCow(saveMessage);
    	
    	function fn_SaveSogCow(saveMessage){
        	
    		MessagePopup('YESNO', saveMessage, function(res){
    			if(res){    				
    				// 수수료 조회
    				var tmpResult = fn_SelFee();
    				var i         = 0;
    				var v_upr     = "0";
    								
    				// 콤마 삭제
    				$("#sra_sbid_am").val(fn_delComma($("#sra_sbid_am").val()));
    				$("#lows_sbid_lmt_am").val(fn_delComma($("#lows_sbid_lmt_am").val()));
    				
    				//수수료 데이타 처리
    				if(fn_isNull(tmpResult)) {
    					MessagePopup('OK','수수료코드가 등록되어있지 않습니다.');
    					return;
    					
    				} else {
    					//송아지 혈통 수수료
    					if(fn_isNull($("#blood_am").val())) {
    						$("#blood_am").val("0");
    					}
    					
    					for(i=0; i < tmpResult.length; i++) {
    						tmpResult[i]["SRA_TR_FEE"] = "0";
    						v_upr = "0";
    						
    						if(tmpResult[i]["NA_FEE_C"] == "010" || tmpResult[i]["NA_FEE_C"] == "011") {
    							if($("#ppgcow_fee_dsc").val() == tmpResult[i]["PPGCOW_FEE_DSC"]) {
    								// 금액
    								if(tmpResult[i]["AM_RTO_DSC"] == "1") {
    									//출하자
    									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
    										// 조합원 구분
    										if($("#io_sogmn_maco_yn").val() == "1") {
    											v_upr = tmpResult[i]["MACO_FEE_UPR"];
    										} else {
    											v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    										}
    									// 낙찰자
    									} else {
    										if($("#io_mwmn_maco_yn").val() == "1") {
    											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) + parseInt($("#blood_am").val());
    										} else {
    											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) + parseInt($("#blood_am").val());
    										}
    									}
    									// 낙찰, 불락
    									if((tmpResult[i]["SBID_YN"] == 1 && $("#sel_sts_dsc").val() == "22") || (tmpResult[i]["SBID_YN"] == 0 && $("#sel_sts_dsc").val() != "22")) {
    										tmpResult[i]["SRA_TR_FEE"] = v_upr;
    										
    										// 조합사료미사용수수료 : 출하수수료 = 출하수수료 + 사료미사용수수료
    										if(tmpResult[i]["NA_FEE_C"] == '010' && $("#sra_fed_spy_yn").val() == '0') {
    											if (isNaN(parseInt(parent.envList[0]["SRA_FED_SPY_YN_FEE"]))) {
    												parent.envList[0]["SRA_FED_SPY_YN_FEE"] = '0';
    											}
    											// 출하수수료 + 사료미사용수수료
    											tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["SRA_FED_SPY_YN_FEE"]); 
    											
    										}
    										// ★3. 합천축협 친자확인 수수료
    				                        // 2016.09.05 친자확인여부 수수료추가
    				                        // 2016.11.02 친자확인여부 수수료추가 1차수정으로로 원복
    				                        // 2017.01.06 합천사료사용 여: 친자감별수수료(0) 부: 친자감별수수료(10000)
    				                        // ★합천: 8808990656236  테스트: 8808990643625
    										if (App_na_bzplc == "8808990656236") {
    											// 출하자 DNA_YN_CHK : 친자검사여부(1:여 0:부)
    											if (tmpResult[i]["NA_FEE_C"] == '010' && $("#dna_yn_chk").val() == '1') {
    												// SRA_FED_SPY_YN : 사료미사용여부 (1:여 0:부)
    												if ($("#SRA_FED_SPY_YN").val() == "0" || fn_isNull($("#sra_fed_spy_yn").val())) {
    													// 출하수수료 = 출하수수료 + 친자검사여부 출하수수료(10000원)
    													tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["FEE_CHK_DNA_YN_FEE"]);
    												} else {
    													 // 출하수수료 + 친자검사여부 출하수수료(10000원) 지원해서 0원
    													 tmpResult[i]["SRA_TR_FEE"] = tmpResult[i]["SRA_TR_FEE"];
    												}
    											}
    											// 판매자 친자검사여부:여, 친자확인결과:여
    				                        	if (tmpResult[i]["NA_FEE_C"] == '011' && $("#dna_yn_chk").val() == '1' &&  $("#dna_yn").val() == "1" ) {
    				                        		// 판매수수료 = 판매수수료 + 친자검사여부 판매수수료(5000원)
    				                        		tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["SELFEE_CHK_DNA_YN_FEE"]);
    											}
    										}
    										
    				                        // ★4. 영주축협
    				                        //  2017.04.14 관내  등록우	 12개월이상: 25000
    				                        //                       12개월이하: 30000
    				                        //                 미등록우 12개월이상: 25000
    				                        //                       12개월이하: 20000
    				                        //             관외 	     12개월이상: 25000
    				                        //                       12개월이하: 20000
    				                        //  2022.04.05 12개월이상 송아지 수수료 : 15,000원 (낙찰자에게 부과)
    				                        //             혈통 송아지 친자검사여부에 따라 출하주와 낙찰자에게 각각 부과
    				                        // ★영주: 8808990687094 테스트: 8808990643625
    				                        if (App_na_bzplc == "8808990687094") {
    				                            if (tmpResult[i]["NA_FEE_C"] == '010' && $("#dna_yn_chk").val() == "1" ){
    				                            	// 출하수수료 + 친자검사여부 출하수수료(10000원)
    				                            	tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["FEE_CHK_DNA_YN_FEE"]);
    				                            }
    				                            // 12개월이상수수료 / 친자검사여부판매수수료 2017.06.20
    				                            
    				                            if (tmpResult[i]["NA_FEE_C"] == "011") {
    				                                if ($("#mt12_ovr_yn").val() == "1") {
    				                                	// 판매수수료 + 12개월이상 수수료 (5000원)
    				                                	tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt($("#mt12_ovr_fee").val());
    				                                } else if ($("#dna_yn_chk").val() == "1") {
    				                                	// 판매수수료 + 친자검사여부 판매수수료(10000원)
    				                                	tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["SELFEE_CHK_DNA_YN_FEE"]);
    				                                }
    				                            }
    				                        }
    				                        
    				                     	// ★4. 청양축협 수수료 2020.11.09
    				                     	// ★청양: 8808990657646 테스트: 8808990643625
    				                     	if (App_na_bzplc == "8808990657646") {
    				                     		if (tmpResult[i]["NA_FEE_C"] == '011') {
    				                     			if ($("#mt12_ovr_yn").val() == "1") {
    				                     				// 판매수수료 + 12개월이상 수수료
    				                     				tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt($("#mt12_ovr_fee").val());
    				                     			}
    				                     		}
    				                     	}
    				                     	// 구미축협
    				                        // ★구미: 8808990657615  테스트: 8808990643625
    				                     	if (App_na_bzplc == "8808990657615") {
    				                            // 출하자 DNA_YN_CHK : 친자검사여부(1:여 0:부)
    				                            if (tmpResult[i]["NA_FEE_C"] == "010" && $("#dna_yn_chk").val() == "1") {
    				                            	// 출하수수료 = 출하수수료 + 친자검사여부 출하수수료
    				                            	tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["FEE_CHK_DNA_YN_FEE"]);
    				                            }
    				                         	// 판매자 친자검사여부:여
    				                     		if (tmpResult[i]["NA_FEE_C"] == "011" && $("#dna_yn_chk").val() == "1") {
    				                                // 판매수수료 = 판매수수료 + 친자검사여부 판매수수료
    				                                tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["SELFEE_CHK_DNA_YN_FEE"]);
    				                            }
    				                        }
    				                     	
    				                     	// 출하/판매수수료 수기등록
    				                        // 출하수수료
    				                        if (tmpResult[i]["NA_FEE_C"] == "010" && $("#fee_chk_yn").val() == "1") {
    				                        	// 출하수수료 수기등록
    				                        	tmpResult[i]["SRA_TR_FEE"] = $("#fee_chk_yn_fee").val();
    				                        }
    				                     	// 판매수수료
    				                        if (tmpResult[i]["NA_FEE_C"] == "011" && $("#selfee_chk_yn").val() == "1") {
    				                        	// 판매수수료 수기등록
    				                        	tmpResult[i]["SRA_TR_FEE"] = $("#selfee_chk_yn_fee").val();
    				                        }
    									}
    								// 율
    								} else {
    									// 출하자
    									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
    										if($("#io_sogmn_maco_yn").val() == "1") {
    											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
    										} else {
    											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
    										}
    									// 낙찰자
    									} else {
    										if($("#io_mwmn_maco_yn").val() == "1") {
    											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
    										} else {
    											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
    										}
    									}
    									
    									// 낙찰
    									if(tmpResult[i]["SBID_YN"] == "1" && $("#sel_sts_dsc").val() == "22") {
    										if(tmpResult[i]["SGNO_PRC_DSC"] == "1") {
    											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
    										} else if(tmpResult[i]["SGNO_PRC_DSC"] == "2") {
    											tmpResult[i]["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
    										} else {
    											tmpResult[i]["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
    										}
    									}
    									
    									// 춘천축협
    									// 1000단위미만 버림  춘천축협: 8808990656229
    									if(App_na_bzplc == "8808990656229") {
    										if(tmpResult[i]["NA_FEE_C"] == "010") {
    											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(tmpResult[i]["SRA_TR_FEE"]) / 1000) * 1000;
    										}
    									}
    									
    									// ★5. 횡성축협 2017.12.14
    			                        // 친자사업: 출하수수료 + 친자확인출하수수료(10000)  ★횡성축협: 8808990656885 테스트: 8808990643625
    			                        // 출하/판매수수료 수기등록
    									if(tmpResult[i]["NA_FEE_C"] == "010" && $("#fee_chk_yn").val() == "1") {
    										// 출하수수료
    										tmpResult[i]["SRA_TR_FEE"] = $("#fee_chk_yn_fee").val();
    									} else if(tmpResult[i]["NA_FEE_C"] == "011" && $("#selfee_chk_yn").val() == "1") {
    										// 판매수수료
    										tmpResult[i]["SRA_TR_FEE"] = $("#selfee_chk_yn_fee").val();
    									}
    								}
    							}
    						} else {
    							var v_ppgcow_fee_dsc = fn_GetPpgcowFeeDsc(tmpResult[i]);
    							if(v_ppgcow_fee_dsc == tmpResult[i]["PPGCOW_FEE_DSC"]) {
    								// 금액
    								if(tmpResult[i]["AM_RTO_DSC"] == "1") {
    									// 출하자
    									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
    										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
    										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675    										
											// 2023.12.06 : 화순축협 제거
    										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267"  
    										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    											// 임신감정료 / 진행상태:낙찰 / 임신여부:여
												//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
												if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = tmpResult[i]["MACO_FEE_UPR"];
    												} else {
    													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    												}
												}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "1") {
    												v_upr = 0;
    											} else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "0") {
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = tmpResult[i]["MACO_FEE_UPR"];
    												} else {
    													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    												}
    											} else {
    												// 보성 : 8808990656267, 장흥 : 8808990656533, 영광 : 8808990811710, 장성 : 8808990817675
    												if(App_na_bzplc == "8808990656267" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    													if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "1") {
    														if($("#io_sogmn_maco_yn").val() == "1") {
    															v_upr = tmpResult[i]["MACO_FEE_UPR"];
    														} else {
    															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    														}
    													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "0") {
    														v_upr = 0;
    													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "0" && $("#ncss_yn").val() == "0") {
    														v_upr = 0;
    													} else {
    														if($("#io_sogmn_maco_yn").val() == "1") {
    															v_upr = tmpResult[i]["MACO_FEE_UPR"];
    														} else {
    															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    														}
    														 
    													}
    												} else {
    													if($("#io_sogmn_maco_yn").val() == "1") {
    														v_upr = tmpResult[i]["MACO_FEE_UPR"];
    													} else {
    														v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    													}
    												}
    											}
    										} else {
    											if($("#io_sogmn_maco_yn").val() == "1") {
    												v_upr = tmpResult[i]["MACO_FEE_UPR"];
    											} else {
    												v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    											}
    										}
    									// 낙찰자
    									} else {    										
											// 2023.12.06 : 화순축협 제거
    										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
    										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
    										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
    										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    											// 임신감정료 / 진행상태:낙찰 / 임신여부:부    											
												//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
												if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = tmpResult[i]["MACO_FEE_UPR"];
    												} else {
    													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    												}
												}else if(tmpResult[i]["NA_FEE_C"] == '060' && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "0") {
    												v_upr = 0;
    											// 임신감정료 / 진행상태:낙찰 / 임신감정여부:부 / 임신여부:부
    											}else if (tmpResult[i]["NA_FEE_C"] == '060' && $("#sel_sts_dsc").val() == '22' && $("#prny_yn").val() == "1"){
    												if($("#io_mwmn_maco_yn").val() == "1") {
                                                        v_upr = tmpResult[i]["MACO_FEE_UPR"];
                                                    } else {
                                                        v_upr = tmpResult[i]["NMACO_FEE_UPR"];
                                                    }
    											} else {
    												// 보성 : 8808990656267, 장흥 : 8808990656533, 영광 : 8808990811710, 장성 : 8808990817675
    												if(App_na_bzplc == "8808990656267" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    													if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "0") {
    														if($("#io_mwmn_maco_yn").val() == "1") {
    															v_upr = tmpResult[i]["MACO_FEE_UPR"];
    														} else {
    															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    														}
    													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "0" && $("#ncss_yn").val() == "0") {
    														v_upr = 0;
    													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "1") {
    														v_upr = 0;
    													} else {
    														if($("#io_mwmn_maco_yn").val() == "1") {
    															v_upr = tmpResult[i]["MACO_FEE_UPR"];
    														} else {
    															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    														}
    													}
    												} else {
    													if($("#io_mwmn_maco_yn").val() =="1") {
    														v_upr = tmpResult[i]["MACO_FEE_UPR"];
    													} else {
    														v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    													}
    												}
    											}
    										} else {
    											if($("#io_mwmn_maco_yn").val() =="1") {
    												v_upr = tmpResult[i]["MACO_FEE_UPR"];
    											} else {
    												v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    											}
    										}
    									}
    									// 낙찰, 불락
    									if((tmpResult[i]["SBID_YN"] == "1" && $("#sel_sts_dsc").val() == "22") 
    									|| (tmpResult[i]["SBID_YN"] == "0" && $("#sel_sts_dsc").val() != "22")) {
    										tmpResult[i]["SRA_TR_FEE"] = v_upr;
    									}
    									//송장등록
    									if($("#sel_sts_dsc").val() == "11") {
    										tmpResult[i]["SRA_TR_FEE"] = 0;
    									}
    								// 율
    								} else {
    									// 출하자
    									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {    										
											// 2023.12.06 : 화순축협 제거
    										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
    										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
    										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
    										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    											
												//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
												if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = tmpResult[i]["MACO_FEE_UPR"];
    												} else {
    													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    												}
												}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() != "0") {
    												v_upr = 0;
    											} else {
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
    												} else {
    													v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
    												}
    											}
    										}else {
    											if($("#io_sogmn_maco_yn").val() == "1") {
                                                    v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
                                                } else {
                                                    v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
                                                }
    										}
    									// 낙찰자
    									} else {
											// 2023.12.06 : 화순축협 제거
    										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
    										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
    										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
    										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
    											
												//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
												if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
    												if($("#io_sogmn_maco_yn").val() == "1") {
    													v_upr = tmpResult[i]["MACO_FEE_UPR"];
    												} else {
    													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
    												}
												}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "0") {
    												v_upr = 0;
    											} else {
    												if($("#io_mwmn_maco_yn").val() == "1") {
    													v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
    												} else {
    													v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
    												}
    											}
    										}else {
    											if($("#io_mwmn_maco_yn").val() == "1") {
                                                    v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
                                                } else {
                                                    v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
                                                }
    										}
    									}
    									// 낙찰
    									if(tmpResult[i]["SBID_YN"] == "1" && $("#sel_sts_dsc").val() == "22") {
    										if(tmpResult[i]["SGNO_PRC_DSC"] == "1") {
    											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
    										} else if(tmpResult[i]["SGNO_PRC_DSC"] == "2") {
    											tmpResult[i]["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
    										} else {
    											tmpResult[i]["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
    										}
    									}
    								}
    								// 괴사감정료
    								if(tmpResult[i]["NA_FEE_C"] == "050" && $("#ncss_jug_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
    								// 임심감정료
    								if(tmpResult[i]["NA_FEE_C"] == "060" && $("#prny_jug_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
    								// 제각수수료
    								if(tmpResult[i]["NA_FEE_C"] == "110" && $("#rmhn_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
    								// 운송비
    								if(tmpResult[i]["NA_FEE_C"] == "040" && $("#trpcs_py_yn").val() == "1") tmpResult[i]["SRA_TR_FEE"] = 0;
    								
    								// 사고적립금 백운학일때 사고적립금 0 적용 - 청도축협
    								// ★청도: 8808990656571 테스트: 8808990643625
    				                if (App_na_bzplc == "8808990656571") {
    				                    if (tmpResult[i]["NA_FEE_C"] == "030" && $("#sra_pdmnm").val() == '백운학'){
    				                    	tmpResult[i]["SRA_TR_FEE"] = 0;   // 사고적립금 0 입력
    				                    }
    				                }
    							}
    						}
    					} // End For
    					

    					if(fn_isNull($("#case_cow").val())) {
    						$("#case_cow").val("1");
    					}
    					// 추가운송비
    					if(fn_isNull($("#sra_trpcs").val())) {
    						$("#sra_trpcs").val("0");
    					}
    					// 출자금
    					if(fn_isNull($("#sra_pyiva").val())) {
    						$("#sra_pyiva").val("0");
    					}
    					// 사료대금
    					if(fn_isNull($("#sra_fed_spy_am").val())) {
    						$("#sra_fed_spy_am").val("0");
    					}
    					// 당일접수비
    					if(fn_isNull($("#td_rc_cst").val())) {
    						$("#td_rc_cst").val("0");
    					}
    					// 사료사용여부금액
    					if(fn_isNull($("#sra_fed_spy_yn_fee").val())) {
    						$("#sra_fed_spy_yn_fee").val("0");
    					}
    					// 출하수수료수기등록
    					if(fn_isNull($("#fee_chk_yn_fee").val())) {
    						$("#fee_chk_yn_fee").val("0");
    					}
    					// 판매수수료수기등록
    					if(fn_isNull($("#selfee_chk_yn_fee").val())) {
    						$("#selfee_chk_yn_fee").val("0");
    					}
    					
    					if(fn_isNull($("#cow_sog_wt").val())) {
    			 			$("#cow_sog_wt").val("0");
    			 		}
    					
    					if(fn_isNull($("#brcl_isp_rzt_c").val())) {
    			 			$("#brcl_isp_rzt_c").val("0");
    			 		}
    					
    					console.log("계산결과 > ", tmpResult);
    					
    					if(setRowStatus == "insert") {
    						$("#fir_lows_sbid_lmt_am").val($("#lows_sbid_lmt_am").val());
    						$("#chg_rmk_cntn").val("최초 저장 등록");
    						$("#chg_del_yn").val("0");
    						
    						srchData["frm_MhSogCow"] 	= setFrmToData("frm_MhSogCow");
    				     	srchData["calfGrid"] 		= calfArray;
    				     	srchData["grd_MhFee"] 		= tmpResult;
    				     	
    						result = sendAjax(srchData, "/LALM0215_insPgm", "POST");
    						
    						if(result.status == RETURN_SUCCESS){
								if (mv_Tab_Boolean) {
	    							var status = fn_UploadImage(setDecrypt(result));
	   	                    		if (status){
	   									MessagePopup("OK", "저장되었습니다.",function(res){
	   					            		mv_RunMode = 3;
	   										mv_auc_dt = $("#auc_dt").val();
	   										mv_auc_obj_dsc = $("#auc_obj_dsc").val();
	   										
	   										if(fn_isNull($("gvno_bascd").val())) {
	   											mv_gvno_bascd = 0;
	   										} else {
	   											mv_gvno_bascd = $("#gvno_bascd").val();
	   										}
	   										mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
	   										
	   										mv_InitBoolean = true;
	   										mv_Tab_Boolean = false;
	   										fn_Init();
	   					            	});
	   								} 									
								} else {
									MessagePopup("OK", "저장되었습니다.",function(res){
   										mv_RunMode = 3;
   										mv_auc_dt = $("#auc_dt").val();
   										mv_auc_obj_dsc = $("#auc_obj_dsc").val();
   										
   										if(fn_isNull($("gvno_bascd").val())) {
   											mv_gvno_bascd = 0;
   										} else {
   											mv_gvno_bascd = $("#gvno_bascd").val();
   										}
   										mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
   										
   										mv_InitBoolean = true;
   										mv_Tab_Boolean = false;
   										fn_Init();
   									});
								}
    			            } else {
    			            	showErrorMessage(result);
    			                return;
    			            }
    					} else if(setRowStatus == "update") {
    						$("#fir_lows_sbid_lmt_am").val($("#lows_sbid_lmt_am").val());
    						$("#chg_rmk_cntn").val("수정로그");
    	    				$('#chg_rmk_cntn').val($('#chg_rmk_cntn').val()+' 상태변경 사유 :'+parent.inputRn);
    						$("#chg_del_yn").val("0");
    						srchData["frm_MhSogCow"] 	= setFrmToData("frm_MhSogCow");
    				     	srchData["calfGrid"] 		= calfArray;
    				     	srchData["grd_MhFee"] 		= tmpResult;
    						
    						result = sendAjax(srchData, "/LALM0215_updPgm", "POST");
    						
    						if(result.status == RETURN_SUCCESS){
								if (mv_Tab_Boolean) {
									var status = fn_UploadImage(setDecrypt(result));
	   	                    		if (status){
	   									MessagePopup("OK", "저장되었습니다.",function(res){
	   										mv_RunMode = 3;
	   										mv_auc_dt = $("#auc_dt").val();
	   										mv_auc_obj_dsc = $("#auc_obj_dsc").val();
	   										
	   										if(fn_isNull($("gvno_bascd").val())) {
	   											mv_gvno_bascd = 0;
	   										} else {
	   											mv_gvno_bascd = $("#gvno_bascd").val();
	   										}
	   										mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
	   										
	   										mv_InitBoolean = true;
	   										mv_Tab_Boolean = false;
	   										fn_Init();
	   									});
	                       			}
								} else {
									MessagePopup("OK", "저장되었습니다.",function(res){
   										mv_RunMode = 3;
   										mv_auc_dt = $("#auc_dt").val();
   										mv_auc_obj_dsc = $("#auc_obj_dsc").val();
   										
   										if(fn_isNull($("gvno_bascd").val())) {
   											mv_gvno_bascd = 0;
   										} else {
   											mv_gvno_bascd = $("#gvno_bascd").val();
   										}
   										mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
   										
   										mv_InitBoolean = true;
   										mv_Tab_Boolean = false;
   										fn_Init();
   									});
								}
    			            } else {
    			            	showErrorMessage(result);
    			                return;
    			            }
    					}
    				}
    				
    			} else {    			
    				MessagePopup('OK','취소되었습니다.');
    				return;
    			}
    		});    		
    	}
    	
		
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete () {
		MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
			if(res){
				
				$("#chg_rmk_cntn").val("출장우 삭제");
				$("#chg_del_yn").val("1");
				
				var result = sendAjaxFrm("frm_MhSogCow", "/LALM0215_delPgm", "POST");
				
	            if(result.status == RETURN_SUCCESS){
	            	MessagePopup("OK", "삭제되었습니다.");
	            	
	            	mv_RunMode             = 3;
	            	mv_InitBoolean         = true;
	            	mv_auc_dt              = $("#auc_dt").val();
	            	mv_auc_obj_dsc         = $("#auc_obj_dsc").val();
	            	mv_gvno_bascd          = $("#gvno_bascd").val();
	            	mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
	            	
	            	fn_Init();
	            	
	            } else {
	            	showErrorMessage(result);
	                return;
	            }
				
			} else {    			
				MessagePopup('OK','취소되었습니다.');
				return;
			}
		});
	}
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명   	: 개체이월 함수
     * 2. 입 력 변 수 	: N/A
     * 3. 출 력 변 수 	: N/A
     * 4. 설   명 	: 자료이월 처리 - 낙찰일 때는 활성화되지 않으며 기존차수의 출장우내역은 삭제 된다.
     ------------------------------------------------------------------------------*/
    function fn_AucChange() {
    	MessagePopup('YESNO',"개체이월 처리 하시겠습니까?",function(res){
			if(res){
				$("#re_indv_no").val($("#hed_indv_no").val() + $("#sra_indv_amnno").val());
				//============================================================fn_CheckValidAucChg Start=========================================================================//
				
				if(fn_isNull($("#sra_srs_dsc").val())) {
					MessagePopup('OK','귀표번호가 정확하지 않습니다.');
					return;
				}
				
				if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#rc_dt").val()))) {
					MessagePopup('OK','접수일자는 경매일자 보다 클수 없습니다.');
					$("#rc_dt").focus();
					return;
				}
				
				if(parseInt(fn_dateToData($("#auc_dt").val())) >= parseInt(fn_dateToData($("#auc_chg_dt").val()))) {
					MessagePopup('OK','이월일자는 경매일자 이후여야 합니다.');
					$("#auc_chg_dt").focus();
					return;
				}
				
				if(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) > parseInt($("#base_lmt_am").val())) {
					MessagePopup('OK','예정가가 최고 응찰 한도금액을 초과 하였습니다.(최고응찰한도금액:'+$("#base_lmt_am").val()+'원');
					$("#lows_sbid_lmt_am_ex").focus();
					return;
				}
				
				var v_sra_sbid_upr = 0;
				//송아지
				if($("#auc_obj_dsc").val() == "1") {
					v_sra_sbid_upr = parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
				// 비육우
				} else if($("#auc_obj_dsc").val() == "2") {
					v_sra_sbid_upr = parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
				// 번식우
				} else {
					v_sra_sbid_upr = parseInt($("#sra_sbid_upr").val()) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
				}
				
				if(parseInt(v_sra_sbid_upr) > parseInt($("#base_lmt_am").val())) {
					MessagePopup('OK','낙찰단가가 최고 응찰 한도금액을 초과 하였습니다.(최고응찰한도금액:'+$("#base_lmt_am").val()+'원');
					$("#sra_sbid_upr").focus();
					return;
				}
				// 낙찰인경우 낙찰자, 낙찰금액 필수
				if($("#sel_sts_dsc").val() == "22") {
					if(fn_isNull($("#sra_mwmnnm").val())) {
						MessagePopup('OK','중도매인을 입력하세요');
						$("#sra_mwmnnm").focus();
						return;
					}
					if($("#sra_sbid_upr").val() == "0") {
						MessagePopup('OK','낙찰단가를 입력하세요');
						$("#sra_sbid_upr").focus();
						return;
					}
					// 비육우 아닐 경우
					if($("#auc_obj_dsc").val() != "2") {
						if($("#sra_sbid_am").val() == "0") {
							MessagePopup('OK','낙찰금액이 없습니다');
							$("#sra_sbid_upr").focus();
							return;
						}
					}
					if(parseInt($("#sra_sbid_upr").val()) < parseInt($("#lows_sbid_lmt_am_ex").val())) {
						MessagePopup('OK','낙찰단가가 예정가 보다 작습니다');
						$("#sra_sbid_upr").focus();
						return;
					}
					if($("#lows_sbid_lmt_am_ex").val() == "0") {
						MessagePopup('OK','예정가가 없습니다');
						$("#lows_sbid_lmt_am_ex").focus();
						return;
					}
				} else {
					if(!fn_isNull($("#trmn_amnno").val())) {
						MessagePopup('OK','낙찰이 아닌경우 중도매인을 입력할수 없습니다.');
						$("#trmn_amnno").focus();
						return;
					}
					
					if($("#sra_sbid_am").val() != "0") {
						MessagePopup('OK','낙찰이 아닌경우 낙찰금액을 입력할수 없습니다.');
						$("#sra_sbid_upr").focus();
						return;
					}
				}
				
				//============================================================fn_CheckValidAucChg END=========================================================================//
				
				if(fn_isNull($("#oslp_no").val())) {
					MessagePopup('OK','저장 후 이월가능합니다.');
					return;
				}
				
				if($("#sel_sts_dsc").val() == "22") {
					MessagePopup('OK','낙찰된 건은 이월할 수 없습니다.');
					return;
				}
				
				// 수수료 조회
				var tmpResult = fn_SelFee();
				var i         = 0;
				var v_upr     = "0";
				
				//수수료 데이타 처리
				if(tmpResult.length == null) {
					MessagePopup('OK','수수료코드가 등록되어있지 않습니다.');
					return;
					
				} else {
					for(i=0; i < tmpResult.length; i++) { 
						tmpResult[i]["SRA_TR_FEE"] = "0";
						v_upr = "0";
						
						if(tmpResult[i]["NA_FEE_C"] == "010" || tmpResult[i]["NA_FEE_C"] == "011") {
							if($("#ppgcow_fee_dsc").val() == tmpResult[i]["PPGCOW_FEE_DSC"]) {
								// 금액
								if(tmpResult[i]["AM_RTO_DSC"] == "1") {
									//출하자
									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
										// 조합원 구분
										if($("#io_sogmn_maco_yn").val() == "1") {
											v_upr = tmpResult[i]["MACO_FEE_UPR"];
										} else {
											v_upr = tmpResult[i]["NMACO_FEE_UPR"];
										}
									// 낙찰자
									} else {
										if($("#io_mwmn_maco_yn").val() == "1") {
											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) + parseInt($("#blood_am").val());
										} else {
											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) + parseInt($("#blood_am").val());
										}
									}
									// 낙찰, 불락
									if((tmpResult[i]["SBID_YN"] == 1 && $("#sel_sts_dsc").val() == "22") || (tmpResult[i]["SBID_YN"] == 0 && $("#sel_sts_dsc").val() != "22")) {
										if(tmpResult[i]["NA_FEE_C"] == "010" && $("#fee_chk_yn").val() == "1") {
											// 출하수수료
											tmpResult[i]["SRA_TR_FEE"] = $("#fee_chk_yn_fee").val();
										} else if(tmpResult[i]["NA_FEE_C"] == "011" && $("#selfee_chk_yn").val() == "1") {
											// 판매수수료
											tmpResult[i]["SRA_TR_FEE"] = $("#selfee_chk_yn_fee").val();
										} else {
											tmpResult[i]["SRA_TR_FEE"] = v_upr;
										}
										if(tmpResult[i]["NA_FEE_C"] == "010" && $("#sra_fed_spy_yn").val() == "0") {
											tmpResult[i]["SRA_TR_FEE"] = parseInt(tmpResult[i]["SRA_TR_FEE"]) + parseInt(parent.envList[0]["SRA_FED_SPY_YN_FEE"]);
										}
									}
								// 율
								} else {
									// 출하자
									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
										if($("#io_sogmn_maco_yn").val() == "1") {
											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
										} else {
											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
										}
									// 낙찰자
									} else {
										if($("#io_mwmn_maco_yn").val() == "1") {
											v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
										} else {
											v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100
										}
									}
									
									// 낙찰
									if(tmpResult[i]["NMACO_FEE_UPR"] == "1" && $("#sel_sts_dsc").val() == "22") {
										if(tmpResult[i]["SGNO_PRC_DSC"] == "1") {
											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
										} else if(tmpResult[i]["SGNO_PRC_DSC"] == "2") {
											tmpResult[i]["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
										} else {
											tmpResult[i]["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
										}
									}
									
									// 춘천축협
									// 1000단위미만 버림  춘천축협: 8808990656229
									if(App_na_bzplc == "8808990656229") {
										if(tmpResult[i]["NA_FEE_C"] == "010") {
											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(tmpResult[i]["SRA_TR_FEE"]) / 1000) * 1000;
										}
									}
									
									// ★5. 횡성축협 2017.12.14
			                        // 친자사업: 출하수수료 + 친자확인출하수수료(10000)  ★횡성축협: 8808990656885 테스트: 8808990643625
			                        // 출하/판매수수료 수기등록
									if(tmpResult[i]["NA_FEE_C"] == "010" && $("#fee_chk_yn").val() == "1") {
										// 출하수수료
										tmpResult[i]["SRA_TR_FEE"] = $("#fee_chk_yn_fee").val();
									} else if(tmpResult[i]["NA_FEE_C"] == "011" && $("#fee_chk_yn").val() == "1") {
										// 판매수수료
										tmpResult[i]["SRA_TR_FEE"] = $("#selfee_chk_yn_fee").val();
									}
								}
							}
						} else {
							//$("#tmp_hd_na_fee_c").val(tmpResult[i]["NA_FEE_C"]);
							var v_ppgcow_fee_dsc = fn_GetPpgcowFeeDsc(tmpResult[i]);
							
							if(v_ppgcow_fee_dsc == tmpResult[i]["PPGCOW_FEE_DSC"]) {
								// 금액
								if(tmpResult[i]["AM_RTO_DSC"] == "1") {
									// 출하자
									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
										// 2023.12.06 : 화순축협 제거
										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
											// 임신감정료 / 진행상태:낙찰 / 임신여부:여
											
											//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
											if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = tmpResult[i]["MACO_FEE_UPR"];
												} else {
													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
												}
											}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "1") {
												v_upr = 0;
											} else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "0") {
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = tmpResult[i]["MACO_FEE_UPR"];
												} else {
													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
												}
											} else {
												// 보성 : 8808990656267, 장흥 : 8808990656533, 영광 : 8808990811710, 장성 : 8808990817675
												if(App_na_bzplc == "8808990656267" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
													if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "1") {
														if($("#io_sogmn_maco_yn").val() == "1") {
															v_upr = tmpResult[i]["MACO_FEE_UPR"];
														} else {
															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
														}
													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "0") {
														v_upr = 0;
													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "0" && $("#ncss_yn").val() == "0") {
														v_upr = 0;
													} else {
														if($("#io_sogmn_maco_yn").val() == "1") {
															v_upr = tmpResult[i]["MACO_FEE_UPR"];
														} else {
															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
														}
														 
													}
												} else {
													if($("#io_sogmn_maco_yn").val() == "1") {
														v_upr = tmpResult[i]["MACO_FEE_UPR"];
													} else {
														v_upr = tmpResult[i]["NMACO_FEE_UPR"];
													}
												}
											}
										} else {
											if($("#io_sogmn_maco_yn").val() == "1") {
												v_upr = tmpResult[i]["MACO_FEE_UPR"];
											} else {
												v_upr = tmpResult[i]["NMACO_FEE_UPR"];
											}
										}
									// 낙찰자
									} else {
										// 2023.12.06 : 화순축협 제거
										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
																						
											//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
											if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = tmpResult[i]["MACO_FEE_UPR"];
												} else {
													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
												}
											}else if(tmpResult[i]["NA_FEE_C"] == '060' && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() == "0") {
												v_upr = 0;
											} else {
												// 보성 : 8808990656267, 장흥 : 8808990656533, 영광 : 8808990811710, 장성 : 8808990817675
												if(App_na_bzplc == "8808990656267" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
													if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "0") {
														if($("#io_mwmn_maco_yn").val() == "1") {
															v_upr = tmpResult[i]["MACO_FEE_UPR"];
														} else {
															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
														}
													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "0" && $("#ncss_yn").val() == "0") {
														v_upr = 0;
													} else if(tmpResult[i]["NA_FEE_C"] == "050" && $("#sel_sts_dsc").val() == "22" && $("#ncss_jug_yn").val() == "1" && $("#ncss_yn").val() == "1") {
														v_upr = 0;
													} else {
														if($("#io_mwmn_maco_yn").val() == "1") {
															v_upr = tmpResult[i]["MACO_FEE_UPR"];
														} else {
															v_upr = tmpResult[i]["NMACO_FEE_UPR"];
														}
													}
												} else {
													if($("#io_mwmn_maco_yn").val() =="1") {
														v_upr = tmpResult[i]["MACO_FEE_UPR"];
													} else {
														v_upr = tmpResult[i]["NMACO_FEE_UPR"];
													}
												}
											}
										} else {
											if($("#io_mwmn_maco_yn").val() =="1") {
												v_upr = tmpResult[i]["MACO_FEE_UPR"];
											} else {
												v_upr = tmpResult[i]["NMACO_FEE_UPR"];
											}
										}
									}
									// 낙찰, 불락
									if((tmpResult[i]["SBID_YN"] == "1" && $("#sel_sts_dsc").val() == "22") 
									|| (tmpResult[i]["SBID_YN"] == "0" && $("#sel_sts_dsc").val() != "22")) {
										tmpResult[i]["SRA_TR_FEE"] = v_upr;
									}
									//송장등록
									if($("#sel_sts_dsc").val() == "11") {
										tmpResult[i]["SRA_TR_FEE"] = 0;
									}
								// 율
								} else {
									// 출하자
									if(tmpResult[i]["FEE_APL_OBJ_C"] == "1") {
										// 2023.12.06 : 화순축협 제거
										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267 
										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
																					
											//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
											if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = tmpResult[i]["MACO_FEE_UPR"];
												} else {
													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
												}
											}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#sel_sts_dsc").val() == "22" && $("#prny_yn").val() != "0") {
												v_upr = 0;
											} else {
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
												} else {
													v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
												}
											}
										}
									// 낙찰자
									} else {
										// 2023.12.06 : 화순축협 제거
										// 고창부안 : 8808990657189, 장흥 : 8808990656533, 보성 : 8808990656267,  
										// 곡성 : 8808990656717, 순천광양: 8808990658896, 영광 : 8808990811710 , 장성 : 8808990817675
										if(App_na_bzplc == "8808990657189" || App_na_bzplc == "8808990656533" || App_na_bzplc == "8808990656267" 
										|| App_na_bzplc == "8808990656717" || App_na_bzplc == "8808990658896" || App_na_bzplc == "8808990811710" || App_na_bzplc == "8808990817675") {
																						
											//임신감정료이면서 장성축협일경우 낙찰에 상관없이 임신감정료 부과
											if(tmpResult[i]["NA_FEE_C"] == "060" && App_na_bzplc == "8808990817675" ){
												if($("#io_sogmn_maco_yn").val() == "1") {
													v_upr = tmpResult[i]["MACO_FEE_UPR"];
												} else {
													v_upr = tmpResult[i]["NMACO_FEE_UPR"];
												}
											}else if(tmpResult[i]["NA_FEE_C"] == "060" && $("#SEL_STS_DSC").val() == "22" && $("#prny_yn").val() == "0") {
												v_upr = 0;
											} else {
												if($("#io_mwmn_maco_yn").val() == "1") {
													v_upr = parseInt(tmpResult[i]["MACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
												} else {
													v_upr = parseInt(tmpResult[i]["NMACO_FEE_UPR"]) * parseInt($("#sra_sbid_am").val()) / 100;
												}
											}
										}
									}
									// 낙찰
									if(tmpResult[i]["SBID_YN"] == "1" && $("#sel_sts_dsc").val() == "22") {
										if(tmpResult[i]["SGNO_PRC_DSC"] == "1") {
											tmpResult[i]["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
										} else if(tmpResult[i]["SGNO_PRC_DSC"] == "2") {
											tmpResult[i]["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
										} else {
											tmpResult[i]["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
										}
									}
								}
								// 괴사감정료
								if(tmpResult[i]["NA_FEE_C"] == "050" && $("#ncss_jug_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
								// 임심감정료
								if(tmpResult[i]["NA_FEE_C"] == "060" && $("#prny_jug_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
								// 제각수수료
								if(tmpResult[i]["NA_FEE_C"] == "110" && $("#rmhn_yn").val() == "0") tmpResult[i]["SRA_TR_FEE"] = 0;
								// 운송비
								if(tmpResult[i]["NA_FEE_C"] == "040" && $("#trpcs_py_yn").val() == "1") tmpResult[i]["SRA_TR_FEE"] = 0;
							}
						}
					}
					
					$("#fir_lows_sbid_lmt_am").val($("#lows_sbid_lmt_am").val());
					
					var calfArray = $("#calfGrid").jqGrid("getRowData");
			    	var srchData      = new Object();
			     	var result        = null;
			     	
			     	$("#chg_rmk_cntn").val("개체 이월");
					$("#chg_del_yn").val("0");
			     	     	
			     	srchData["frm_MhSogCow"] 	= setFrmToData("frm_MhSogCow");
			     	srchData["calfGrid"] 		= calfArray;
			     	srchData["grd_MhFee"] 		= tmpResult;
					
					result = sendAjax(srchData, "/LALM0215_updAucChange", "POST");
					
					if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "저장되었습니다.");
		            	
		            	mv_RunMode 		= 3;
						mv_auc_dt 		= $("#auc_dt").val();
						mv_auc_obj_dsc 	= $("#auc_obj_dsc").val();
						
						if(fn_isNull($("gvno_bascd").val())) {
							mv_gvno_bascd = 0;
						} else {
							mv_gvno_bascd = $("#gvno_bascd").val();
						}
						 
						mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
						
						mv_InitBoolean = true;
						mv_Tab_Boolean = false;
						fn_Init();
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
				}
				
			} else {
				MessagePopup('OK','취소되었습니다.');
				return;
			}
		});
    } 
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
 	//function  : fn_GridCboxFormat(그리드 돋보기 버튼) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_GridCboxFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<button id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch(\'' + rowid + '\',\'' + colkey + '\'); return false;" class="tb_btn white srch"><i class="fa fa-search"></i></button>';
	}
 	
  	//**************************************
 	//function  : fn_GridCboxFormat(그리드 검색 버튼) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_GridCboxFormat2(val, options, rowdata) {
 		var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<button class="tb_btn" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch2(\'' + rowid + '\',\'' + colkey + '\'); return false;">개체이력조회</button>';
	}
    
  	//**************************************
 	//function  : fn_popSearch(송아지정보테이블 돋보기 버튼 클릭 이벤트) 
 	//paramater : gid, rowid, colkey 
 	// result   : N/A
 	//**************************************
    function fn_popSearch(rowid, colkey){
		/**
		 * 개체이력조회 팝업 클릭시 귀표번호 cell Save 처리 
		**/		
   	    var rowIndex = $('#calfGrid tr[id='+rowid+']')[0].rowIndex;
   	    var colIndex = $("#calfGrid").jqGrid("getGridParam", "colModel").findIndex((o,i)=>{if(o.name === 'SRA_INDV_AMNNO') return true;});
   	    $("#calfGrid").jqGrid('saveCell', rowIndex , colIndex);		

	    /******************************
	     * 송아지 귀표번호 검색 팝업
	     ******************************/
   	    var data = new Object();
	    var checkBoolean = true;
        data['auc_dt']           = fn_dateToData($("#auc_dt").val());   
        data['auc_obj_dsc']      = "1";
        data['sra_indv_amnno']   = $("#calfGrid").jqGrid('getCell', rowid, 'SRA_INDV_AMNNO');
        
        if(colkey == "POPSCH") {
        	checkBoolean = false;
        } else if(colkey == "SRA_INDV_AMNNO") {
        	checkBoolean = true;
        }
        
        fn_CallMmIndvPopup(data,checkBoolean,function(result){
    		if(result){
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_SRS_DSC', 			result.SRA_SRS_DSC);
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', 		result.SRA_INDV_AMNNO);
    			$("#calfGrid").jqGrid('setCell', rowid, 'INDV_SEX_C', 			result.INDV_SEX_C);
    			$("#calfGrid").jqGrid('setCell', rowid, 'BIRTH', 				result.BIRTH);
    			$("#calfGrid").jqGrid('setCell', rowid, 'KPN_NO', 				result.KPN_NO);
    			$("#calfGrid").jqGrid('setCell', rowid, 'MCOW_SRA_INDV_AMNNO', 	result.MCOW_SRA_INDV_AMNNO);
    			
    			var tempsra_indv_amnno = '410' + $("#sra_indv_amnno").val();
    			if(tempsra_indv_amnno != result.MCOW_SRA_INDV_AMNNO) {
    				MessagePopup('OK','출장우와 송아지가 친자관계가 아닙니다. 송아지귀표번호를 확인해 주세요.');
    			}
    		} else {
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_SRS_DSC', 			"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', 		"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'INDV_SEX_C', 			"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'BIRTH', 				"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'KPN_NO', 				"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'MCOW_SRA_INDV_AMNNO', 	"");
    		}
    	});
	}
 	
  	//**************************************
 	//function  : fn_popSearch2(송아지정보테이블 인터페이스 버튼 이벤트) 
 	//paramater : gid, rowid, colkey 
 	// result   : N/A
 	//**************************************
    function fn_popSearch2(rowid, colkey){
		/**
		 * 개체이력조회 팝업 클릭시 귀표번호 cell Save 처리 
		**/		
   	    var rowIndex = $('#calfGrid tr[id='+rowid+']')[0].rowIndex;
   	    var colIndex = $("#calfGrid").jqGrid("getGridParam", "colModel").findIndex((o,i)=>{if(o.name === 'SRA_INDV_AMNNO') return true;});
   	    $("#calfGrid").jqGrid('saveCell', rowIndex , colIndex);		
		
    	/******************************
	     * 송아지 귀표번호 검색(인터페이스) 팝업
	     ******************************/
   	    var data = new Object();
        data["sra_indv_amnno"] = $("#calfGrid").jqGrid('getCell', rowid, 'SRA_INDV_AMNNO');
        fn_CallIndvInfHstPopup(data, false, function(result){
        	if(result){
        		$("#calfGrid").jqGrid('setCell', rowid, 'SRA_SRS_DSC', 			result.SRA_SRS_DSC);
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', 		result.SRA_INDV_AMNNO);
    			$("#calfGrid").jqGrid('setCell', rowid, 'INDV_SEX_C', 			result.INDV_SEX_C);
    			$("#calfGrid").jqGrid('setCell', rowid, 'BIRTH', 				result.BIRTH);
    			$("#calfGrid").jqGrid('setCell', rowid, 'KPN_NO', 				result.KPN_NO);
    			$("#calfGrid").jqGrid('setCell', rowid, 'MCOW_SRA_INDV_AMNNO', 	result.MCOW_SRA_INDV_AMNNO);
                
    			var tempsra_indv_amnno = '410' + $("#sra_indv_amnno").val();
    			if(tempsra_indv_amnno != result.MCOW_SRA_INDV_AMNNO) {
    				MessagePopup('OK','출장우와 송아지가 친자관계가 아닙니다. 송아지귀표번호를 확인해 주세요.');
    			} 
        	} else {
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_SRS_DSC', 			"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'SRA_INDV_AMNNO', 		"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'INDV_SEX_C', 			"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'BIRTH', 				"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'KPN_NO', 				"");
    			$("#calfGrid").jqGrid('setCell', rowid, 'MCOW_SRA_INDV_AMNNO', 	"");
    		}
        });
 	}
 	
  //**************************************
 	//function  : fn_popInfHstPopup(귀표번호 인터페이스 버튼 이벤트) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_popInfHstPopup(chkBool){
    	var checkBoolean = chkBool;
        var cheackParam = $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
        var data =  new Object;
        
        data["sra_indv_amnno"] = cheackParam;
        
        fn_CallIndvInfHstPopup(data, checkBoolean, function(result){
        	if(result){
       			$("#sra_srs_dsc").val(result.SRA_SRS_DSC);
           		
           		if(!fn_isNull(result.SRA_INDV_AMNNO)) {
           			$("#sra_indv_amnno").val(result.SRA_INDV_AMNNO.substr(3, 12));
           		}
           		
           		$("#fhs_id_no").val(result.FHS_ID_NO);
           		$("#farm_amnno").val(result.FARM_AMNNO);
           		$("#ftsnm").val(fn_xxsDecode(result.FTSNM));
           		
           		if(!fn_isNull(result.CUS_MPNO)) {
                   	$("#ohse_telno").val(result.CUS_MPNO);
                   } else {
                   	$("#ohse_telno").val(result.OHSE_TELNO);
                   }
           		
           		if(!fn_isNull(result.ZIP)) {
           			$("#zip").val(result.ZIP.substr(0, 3) + "-" + result.ZIP.substr(3, 3));
           		}
           		
           		$("#dongup").val(fn_xxsDecode(result.DONGUP));
           		$("#dongbw").val(fn_xxsDecode(result.DONGBW));
           		$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
           		$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
           		$("#sog_na_trpl_c").val(result.NA_TRPL_C);
           		$("#indv_sex_c").val(result.INDV_SEX_C);
           		$("#birth").val(fn_toDate(result.BIRTH));
           		$("#indv_id_no").val(result.INDV_ID_NO);
           		$("#sra_indv_brdsra_rg_no").val(result.SRA_INDV_BRDSRA_RG_NO);
           		$("#rg_dsc").val(result.RG_DSC);
           		$("#kpn_no").val(result.KPN_NO);
           		$("#mcow_dsc").val(result.MCOW_DSC);
           		$("#mcow_sra_indv_amnno").val(result.MCOW_SRA_INDV_AMNNO);
           		
           		if(!fn_isNull(result.MATIME)) {
           			$("#matime").val(parseInt(result.MATIME));
           		}
           		
           		if(!fn_isNull(result.SRA_INDV_PASG_QCN)) {
           			$("#sra_indv_pasg_qcn").val(parseInt(result.SRA_INDV_PASG_QCN));
           		}
           		
           		$("#io_sogmn_maco_yn").val(result.MACO_YN);
           		$("#sra_farm_acno").val(result.SRA_FARM_ACNO);
        		
        		fn_FtsnmModify();
        		
        		fn_IndvInfSync();
                
                if(App_na_bzplc == '8808990687094'){
    				$("#ftsnm").focus();
       			}else {
	        		$("#vacn_dt").focus();
       			}
        	}
        });
 	}
    
    //**************************************
 	//function  : fn_Reset(초기화 후 기본셋팅) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_Reset() {
		if($("#chk_continue").is(":checked")) {
			fn_contrChBox(false, "chk_continue");
			$("#chk_continue1").attr("disabled", false);
			$("#fee_chk_yn").attr("disabled", false);
		} else if($("#chk_continue1").is(":checked")) {
			fn_contrChBox(false, "chk_continue1");
			$("#chk_continue").attr("disabled", false);
			$("#fee_chk_yn").attr("disabled", false);
		}
		
		$("#pb_Indvfhs").show();
		$("#chk_AucNoChg").show();
		$("#chk_continue").show();
		
		fn_InitSet();		
		
		if ($("#chack_on").is(":checked")) {
			$("#auc_prg_sq").focus().select();
		}
		else {
			$("#sra_indv_amnno").focus();
		}
		
		// 이미지 영역도 초기화
		$("#uploadImg").val("");
		$("#imagePreview").empty();
 	}
    
 	//**************************************
 	//function  : fn_InitRadioSet(라디오버튼 기본셋팅) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_InitRadioSet() {
 		fn_setChgRadio("auc_obj_dsc", "1");
		fn_setRadioChecked("auc_obj_dsc");
		$("#auc_obj_dsc").val("1");
		$("input[name='rd_gvno_bascd']:radio[value='0']").prop("checked", true);
		$("#gvno_bascd").val("0");
 	}
    
    //**************************************
 	//function  : fn_InitSet(초기화 후 기본셋팅) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_InitSet() {
 		$("#chk_AucNoChg").hide();
    	$("#pb_Indvfhs").hide();
    	$("#emp_auc_prg_sq").val("");
    	$("#calfGrid").jqGrid("clearGridData", true);

    	if(pageInfos.param != null) {
        	$("#chk_AucNoChg").hide();
        	$("#pb_Indvfhs").hide();

            $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());        
            $("#rc_dt").datepicker().datepicker("setDate", fn_getToday());
            $("#auc_chg_dt").datepicker().datepicker("setDate", fn_getToday());
            $("#birth").datepicker().datepicker("setDate", fn_getToday());
            $("#vacn_dt").datepicker().datepicker("setDate", fn_getToday());
            $("#brcl_isp_dt").datepicker().datepicker("setDate", fn_getToday());
            $("#afism_mod_dt").datepicker().datepicker("setDate", fn_getToday());
            $("#bovine_dt").datepicker().datepicker("setDate", fn_getToday());
        	
        	$("#hdn_auc_dt").val(pageInfos.param.auc_dt);
        	$("#hdn_auc_obj_dsc").val(pageInfos.param.auc_obj_dsc);
        	$("#hdn_oslp_no").val(pageInfos.param.oslp_no);
        	$("#auc_dt").val(pageInfos.param.auc_dt);
        	$("#auc_obj_dsc").val(pageInfos.param.auc_obj_dsc);
        	
        	fn_setChgRadio("auc_obj_dsc", pageInfos.param.auc_obj_dsc);
    		fn_setRadioChecked("auc_obj_dsc");
    		
    		mv_RunMode = 1;
    		fn_AucOnjDscModify("init");
        	fn_Search();
        	//fn_Search중 error시 pageInfos.param를 null로 변하는 로직이있어 param 이중체크
        	//에러시 신규기준으로 판단하고 세팅
        	if(pageInfos.param) mv_RunMode = 2;
        	
        } else {
        	// 실행모드 설정 (Window.mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정)
        	mv_RunMode = 1;
        }

		if(mv_RunMode == 1) {
			$("#sra_indv_amnno").attr("disabled", false);
			$("#pb_sra_indv_amnno").attr("disabled", false);
			$("#pb_IndvHst").attr("disabled", false);
			$("#pb_sra_indv_amnno").attr("disabled", false);
			
			mv_flg = "init";
			mv_vhc_shrt_c = $("#vhc_shrt_c").val();
			mv_vhc_drv_caffnm = $("#vhc_drv_caffnm").val();
			
			// 폼 초기화
			fn_InitFrm('frm_MhSogCow');
			
			// 탭 초기화
			$("#pb_tab2").hide();
			
			$("#auc_dt").attr("disabled", false);
	        $("#auc_chg_dt").attr("disabled", false);
	        fn_DisableAuc(false);
	        
	        setRowStatus = "insert";
	        
	        fn_ClearCal("init");
	        
	        $("#auc_dt").val(mv_auc_dt);                     						// 경매일자
	        $("#auc_chg_dt").val(mv_auc_chg_dt);                     				// 경매일자
	        $("#auc_obj_dsc").val(mv_auc_obj_dsc);                       			// 경매대상
	        $("#gvno_bascd").val(mv_gvno_bascd);                       				// 경매번호기준
	        $("#lvst_mkt_trpl_amnno").val(mv_lvst_mkt_trpl_amnno);     				// 수의사
	        
	        $("#vhc_shrt_c").val(mv_vhc_shrt_c); 									// 수송자
	        $("#vhc_drv_caffnm").val(mv_vhc_drv_caffnm); 							// 수송자명
	        $("#rc_dt").datepicker().datepicker("setDate", fn_getToday());
	        $("#sel_sts_dsc").val("1");												// 진행상태
	        $("#case_cow").val("1");												// 구분
	        
	     	// ★임실: 8808990660783 포항: 8808990679549 고성: 8808990656458  영광: 8808990811710 충주: 8808990656465 남원: 8808990227207  테스트: 8808990643625 경주 8808990659008
			// 친자확인결과 미확인 자동 셋팅
			if(App_na_bzplc=='8808990660783' || App_na_bzplc=='8808990679549' || App_na_bzplc=='8808990656458' || App_na_bzplc=='8808990811710' || App_na_bzplc=='8808990643625' || App_na_bzplc=='8808990659008') {
				$("#dna_yn").val("3");
			} else {
				// YCSONG 220203 : 친자확인결과(dna_yn) 초기화값을 정보없음으로 세팅하도록 수정
				$("#dna_yn").val("3");
			}
	        
	        fn_RcDtModify();
	        fn_IoSogmnMacoYnModify();
	        fn_TrpcsPyYnModify('init');
	        
		    fn_SelMhCalf();
		    mv_flg = "";
		    
			// 경매대상 관련 초기 셋팅
			var flag = fn_isDate(mv_auc_dt) ? "" : "init";
		    fn_AucOnjDscModify(flag);
			
		    if(fn_isNull($("#auc_dt").val())) {
		    	$("#auc_dt").focus();
		    } else {
		    	//시작 포커스 변경 - 2021-11-15(이지호 팀장 요청)
		    	//$("#auc_prg_sq").focus();
		    	$("#sra_indv_amnno").focus();
		    }
		    
		    $("#sra_sbid_am").val("0");
		    
		} else {
			$("#btn_Save").attr("disabled", false);
	    	$("#btn_Delete").attr("disabled", false);
	    	
	    	// ★충주: 8808990656465 함양산청 산청: 8808990674506  테스트: 8808990643625
	    	if (App_na_bzplc == '8808990656465' || App_na_bzplc == '8808990674506') {
	    		$("#sra_indv_amnno").attr("disabled", false);
	    		$("#pb_IndvHst").attr("disabled", false);
	    		$("#pb_sra_indv_amnno").attr("disabled", false);
	    	} else {
	    		$("#sra_indv_amnno").attr("disabled", true);
	    		$("#pb_IndvHst").attr("disabled", true);
	    		$("#pb_sra_indv_amnno").attr("disabled", true);
	        }
	    	$("#auc_dt").attr("disabled", true);
	    	fn_DisableAuc(true);
	    	
	    	// 송아지
	    	if($("#auc_obj_dsc").val() == "1") {
        		$("#firstBody").hide();
        		$("#secondBody").show();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();

        		if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        		} else if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}
        		$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]));
        	// 비육우	
        	} else if($("#auc_obj_dsc").val() == "2") {
        		$("#firstBody").hide();
        		$("#secondBody").hide();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();
        		
        		if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        			
        		} else if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}
        		$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]));
        	// 번식우
        	} else if($("#auc_obj_dsc").val() == "3") {
        		$("#firstBody").show();
        		$("#secondBody").hide();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();
        		
        		if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        			
        		} else if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}
        		$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]));
        		
        		// kg별
        		if (parent.envList[0]["NBFCT_AUC_UPR_DSC"] == "1"){
        			
        			// 경매차수 조회
    				var resultAucQcn = fn_SelAucQcn();
    				
    				if(resultAucQcn == null) {
    	    			MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
    	    			$("#btn_Save").attr("disabled", true);
    	    			$("#btn_Delete").attr("disabled", true);
    	    		} else {
    	    			mv_cut_am = resultAucQcn[0]["CUT_AM"];
    	                mv_sqno_prc_dsc = resultAucQcn[0]["SGNO_PRC_DSC"];
    	    		}
                }
        		
        	}
	    	if($("#io_sogmn_maco_yn").val() == "1") {
	    		$("#sra_pyiva").attr("disabled", false);
	    	} else {
	    		$("#sra_pyiva").attr("disabled", true);
	    	}
	    	if($("#trpcs_py_yn").is(":checked")) {
	    		$("#sra_trpcs").attr("disabled", true);
	    		$("#vhc_drv_caffnm").attr("disabled", true);
	    	} else {
	    		$("#sra_trpcs").attr("disabled", false);
	    		$("#vhc_drv_caffnm").attr("disabled", false);
	    	}
	    
			fn_SelMhCalf();
		}
		
		// 장성축협만 사용중 8808990817675
    	if(App_na_bzplc == "8808990817675") {
    		$("#case_cow").attr("disabled", false);
    	} else {
    		$("#case_cow").val("");
    		$("#case_cow").attr("disabled", true);
    	}
    	//2023.12.06 고흥축협 브랜드명 disabled 해제
    	//2024.02.14 영천축협 브랜드명 수정 추가
    	if(App_na_bzplc == "8808990779546" || App_na_bzplc == "8808990656687") {
    		$("#brandnm").attr("disabled", false);
    	}
		
    	if($("#auc_obj_dsc").val() == "3") {
 			if($("#ppgcow_fee_dsc").val() == "3" || $("#ppgcow_fee_dsc").val() =="4") {
 				$("#pb_tab2").show();
 			} else {
 				// ★경주: 8808990659008
 				if (App_na_bzplc == '8808990659008' && $("#ppgcow_fee_dsc").val() == "1") {
 					$("#pb_tab2").show();
 				} else {
 					$("#pb_tab2").hide();
 				}
 			}
 			
 			// 번식우
 			if($("#auc_obj_dsc").val() == "3") {
        		//2022.08.08 익산의 경우 값이 수정했을경우 수정한값으로 표기되게	        		
				//if(!arrPrnyJugNaBzplc.includes(App_na_bzplc)) {
			    //    if($("#ppgcow_fee_dsc").val() == "1" ||  $("#ppgcow_fee_dsc").val() == "3") {
		        //    	fn_contrChBox(true, "prny_jug_yn", "");
			    //    } else {
			    //    	fn_contrChBox(false, "prny_jug_yn", "");
			    //    }
		        //}

		  		// ★거창: 8808990659701
		        if(App_na_bzplc == "8808990659701") {
		            if($("#ppgcow_fee_dsc").val() == "2" || $("#ppgcow_fee_dsc").val() == "4") {
		                $("#afism_mod_dt").val("");
		             	$("#prny_mtcn").val("");
		             	fn_AfismModDtModify();
		            }
		        }
		    }
 			
 			// 번식우 선택시 임신감정여부 체크
 		    if($("#chk_continue").is(":checked")) {
 		    	fn_ChkContinue();
 			}
 		    if($("#chk_continue1").is(":checked")) {
 		    	fn_ChkContinue2();
 			}
 		}
		
		$("#hed_indv_no").val("410");
		if(fn_isNull($("#rc_dt").val())) {
			$("#rc_dt").datepicker().datepicker("setDate", fn_getToday());
		}
		fn_ClearReProduct();
		
 	}
 	
 	//**************************************
 	//function  : fn_SetData(조회된 데이터 바인딩) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_SetData(result) {
 		// -------------------- 출장우 정보 -------------------- //
 		$("#rd_auc_obj_dsc").val(result[0]["rd_auc_obj_dsc"]);
 		if(fn_isDate(result[0]["AUC_DT"])) {
 			$("#auc_dt").val(fn_toDate(result[0]["AUC_DT"]));
 		}
 		$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
 		// 경매번호 체크박스 X
 		
 		if(fn_isDate(result[0]["RC_DT"])) {
 			$("#rc_dt").val(fn_toDate(result[0]["RC_DT"]));
 		}
 		// 귀표번호1X 410 고정
 		$("#sra_indv_amnno").val(result[0]["SRA_INDV_AMNNO"]);
 		// 개체 이월 일자 X
 		$("#modl_no").val(result[0]["MODL_NO"]);
 		
 		$("#fhs_id_no").val(result[0]["FHS_ID_NO"]);
 		$("#farm_amnno").val(result[0]["FARM_AMNNO"]);
 		$("#ftsnm").val(fn_xxsDecode(result[0]["FTSNM"]));
 		$("#io_sogmn_maco_yn").val(result[0]["IO_SOGMN_MACO_YN"]);
 		$("#zip").val(result[0]["ZIP"]);
 		$("#dongup").val(fn_xxsDecode(result[0]["DONGUP"]));
 		$("#dongbw").val(fn_xxsDecode(result[0]["DONGBW"]));
 		
 		if(!fn_isNull(result[0]["CUS_MPNO"])) {
 			$("#ohse_telno").val(result[0]["CUS_MPNO"]);
 		} else {
 			$("#ohse_telno").val(result[0]["OHSE_TELNO"]);
 		}
 		
 		$("#sra_pd_rgnnm").val(fn_xxsDecode(result[0]["SRA_PD_RGNNM"]));
 		$("#sogmn_c").val(result[0]["SOGMN_C"]);
 		$("#sra_pdmnm").val(fn_xxsDecode(result[0]["SRA_PDMNM"]));
 		
 		$("#vhc_shrt_c").val(result[0]["VHC_SHRT_C"]);
 		$("#vhc_drv_caffnm").val(result[0]["VHC_DRV_CAFFNM"]);
 		if(result[0]["TRPCS_PY_YN"] == "1") {
 			fn_contrChBox(true, "trpcs_py_yn", "");
 			
 			$("#vhc_drv_caffnm").attr("disabled", true);
			$("#pb_vhc_drv_caffnm").attr("disabled", true);
			$("#sra_trpcs").attr("disabled", true);
			
 		} else {
 			fn_contrChBox(false, "trpcs_py_yn", "");
 			
 			$("#vhc_drv_caffnm").attr("disabled", false);
			$("#pb_vhc_drv_caffnm").attr("disabled", false);
			$("#sra_trpcs").attr("disabled", false);
 		}
 		
 		if(fn_isNull(result[0]["SRA_TRPCS"])) {
 			$("#sra_trpcs").val("0");
 		} else {
 			$("#sra_trpcs").val(result[0]["SRA_TRPCS"]);
 		}
 		if(fn_isNull(result[0]["SRA_PYIVA"])) {
 			$("#sra_pyiva").val("0");
 		} else {
 			$("#sra_pyiva").val(result[0]["SRA_PYIVA"]);
 		}
 		if(fn_isNull(result[0]["SRA_FED_SPY_AM"])) {
 			$("#sra_fed_spy_am").val("0");
 		} else {
 			$("#sra_fed_spy_am").val(result[0]["SRA_FED_SPY_AM"]);
 		}
 		$("#td_rc_cst").val(result[0]["TD_RC_CST"]);
 		if(result[0]["SRA_FED_SPY_YN"] == "1") {
 			fn_contrChBox(true, "sra_fed_spy_yn", "");
 		} else {
 			fn_contrChBox(false, "sra_fed_spy_yn", "");
 		}
 		// 축산사용사료금액X
 		
 		// -------------------- 개체 정보 -------------------- //
 		$("#indv_sex_c").val(result[0]["INDV_SEX_C"]);
 		if(fn_isDate(result[0]["BIRTH"])) {
 			$("#birth").val(fn_toDate(result[0]["BIRTH"]));
 		}
 		$("#indv_id_no").val(result[0]["INDV_ID_NO"]);
 		$("#sra_indv_brdsra_rg_no").val(result[0]["SRA_INDV_BRDSRA_RG_NO"]);
 		$("#rg_dsc").val(result[0]["RG_DSC"]);
 		
 		$("#kpn_no").val(result[0]["KPN_NO"]);
 		$("#mcow_dsc").val(result[0]["MCOW_DSC"]);
 		$("#mcow_sra_indv_amnno").val(result[0]["MCOW_SRA_INDV_AMNNO"]);
 		$("#matime").val(result[0]["MATIME"]);
 		$("#sra_indv_pasg_qcn").val(result[0]["SRA_INDV_PASG_QCN"]);
 		
 		$("#brandnm").val(result[0]["BRANDNM"]);
 		if(fn_isNull(result[0]["BLOOD_AM"])) {
 			$("#blood_am").val("0");
 		} else {
 			$("#blood_am").val(result[0]["BLOOD_AM"]);
 		}
 		
 		// -------------------- 중도매인 정보 -------------------- //
 		$("#trmn_amnno").val(result[0]["TRMN_AMNNO"]);
 		$("#sra_mwmnnm").val(fn_xxsDecode(result[0]["SRA_MWMNNM"]));
 		$("#lvst_auc_ptc_mn_no").val(result[0]["LVST_AUC_PTC_MN_NO"]);
 		if(fn_isNull(result[0]["SRA_SBID_UPR"])) {
 			$("#sra_sbid_upr").val("0");
 		} else {
 			$("#sra_sbid_upr").val(result[0]["SRA_SBID_UPR"]);
 		}
 		
 		if(fn_isNull(result[0]["SRA_SBID_AM"])) {
 			$("#sra_sbid_am").val("0");
 		} else {
 			$("#sra_sbid_am").val(fn_toComma(result[0]["SRA_SBID_AM"]));
 		}
 		$("#sel_sts_dsc").val(result[0]["SEL_STS_DSC"]);
 		
 		// -------------------- 기타 정보 -------------------- //
 		if(fn_isNull(result[0]["COW_SOG_WT"])) {
 			$("#cow_sog_wt").val("0");
 		} else {
 			$("#cow_sog_wt").val(result[0]["COW_SOG_WT"]);
 		}
 		if(fn_isNull(result[0]["LOWS_SBID_LMT_AM"])) {
 			$("#lows_sbid_lmt_am").val("0");
 			$("#lows_sbid_lmt_am_ex").val("0");
 		} else {
 			$("#lows_sbid_lmt_am").val(fn_toComma(result[0]["LOWS_SBID_LMT_AM"]));
 		}
 		if(fn_isDate(result[0]["VACN_DT"])) {
 			$("#vacn_dt").val(fn_toDate(result[0]["VACN_DT"]));
 		}
 		$("#lvst_mkt_trpl_amnno").val(result[0]["LVST_MKT_TRPL_AMNNO"]);
 		
 		if(fn_isDate(result[0]["BRCL_ISP_DT"])) {
 			$("#brcl_isp_dt").val(fn_toDate(result[0]["BRCL_ISP_DT"]));
 		}
 		if(result[0]["BRCL_ISP_CTFW_SMT_YN"] == "1") {
 			fn_contrChBox(true, "brcl_isp_ctfw_smt_yn", "");
 		} else {
 			fn_contrChBox(false, "brcl_isp_ctfw_smt_yn", "");
 		}
 		if(result[0]["RMHN_YN"] == "1") {
 			fn_contrChBox(true, "rmhn_yn", "");
 		} else {
 			fn_contrChBox(false, "rmhn_yn", "");
 		}
 		if(result[0]["SPAY_YN"] == "1") {
 			fn_contrChBox(true, "spay_yn", "");
 		} else {
 			fn_contrChBox(false, "spay_yn", "");
 		}
 		
 		$("#dna_yn").val(result[0]["DNA_YN"]);
 		
 		if(result[0]["DNA_YN_CHK"] == "1") {
 			fn_contrChBox(true, "dna_yn_chk", "");
 		} else {
 			fn_contrChBox(false, "dna_yn_chk", "");
 		}
 		$("#lwpr_chg_nt").val(result[0]["LWPR_CHG_NT"]);
 		
 		$("#rmk_cntn").val(fn_xxsDecode(result[0]["RMK_CNTN"]));
 		$("#case_cow").val(result[0]["CASE_COW"]);
 		if(result[0]["FEE_CHK_YN"] == "1") {
 			fn_contrChBox(true, "fee_chk_yn", "");
 		} else {
 			fn_contrChBox(false, "fee_chk_yn", "");
 		}
 		$("#fee_chk_yn_fee").val(result[0]["FEE_CHK_YN_FEE"]);
 		if(result[0]["SELFEE_CHK_YN"] == "1") {
 			fn_contrChBox(true, "selfee_chk_yn", "");
 		} else {
 			fn_contrChBox(false, "selfee_chk_yn", "");
 		}
 		$("#selfee_chk_yn_fee").val(result[0]["SELFEE_CHK_YN_FEE"]);
 		
 		$("#ppgcow_fee_dsc").val(result[0]["PPGCOW_FEE_DSC"]);
 		if(fn_isDate(result[0]["AFISM_MOD_DT"])) {
 			$("#afism_mod_dt").val(fn_toDate(result[0]["AFISM_MOD_DT"]));
 		}else{
 			$("#afism_mod_dt").val('');
 		} 		
 		if(result[0]["AFISM_MOD_CTFW_SMT_YN"] == "1") {
 			fn_contrChBox(true, "afism_mod_ctfw_smt_yn", "");
 		} else {
 			fn_contrChBox(false, "afism_mod_ctfw_smt_yn", "");
 		}
 		$("#mod_kpn_no").val(result[0]["MOD_KPN_NO"]);
 		
 		if(fn_isNull(result[0]["PRNY_MTCN"])) {
 			$("#prny_mtcn").val("0");
 		} else {
 			$("#prny_mtcn").val(result[0]["PRNY_MTCN"]);
 		}
 		if(result[0]["PRNY_JUG_YN"] == "1") {
 			fn_contrChBox(true, "prny_jug_yn", "");
 		} else {
 			fn_contrChBox(false, "prny_jug_yn", "");
 		}
 		if(result[0]["PRNY_YN"] == "1") {
 			fn_contrChBox(true, "prny_yn", "");
 		} else {
 			fn_contrChBox(false, "prny_yn", "");
 		}
 		if(result[0]["NCSS_JUG_YN"] == "1") {
 			fn_contrChBox(true, "ncss_jug_yn", "");
 		} else {
 			fn_contrChBox(false, "ncss_jug_yn", "");
 		}
 		if(result[0]["NCSS_YN"] == "1") {
 			fn_contrChBox(true, "ncss_yn", "");
 		} else {
 			fn_contrChBox(false, "ncss_yn", "");
 		}
 		
 		if(result[0]["MT12_OVR_YN"] == "1") {
 			fn_contrChBox(true, "mt12_ovr_yn", "");
 		} else {
 			fn_contrChBox(false, "mt12_ovr_yn", "");
 		}
 		if(fn_isNull(result[0]["MT12_OVR_FEE"])) {
 			$("#mt12_ovr_fee").val("0");
 		} else {
 			$("#mt12_ovr_fee").val(result[0]["MT12_OVR_FEE"]);
 		}
 		
 		if(fn_isDate(result[0]["BOVINE_DT"])) {
 			$("#bovine_dt").val(fn_toDate(result[0]["BOVINE_DT"]));
 		}
 		$("#re_product_1").val(result[0]["RE_PRODUCT_1"]);
 		$("#re_product_1_1").val(result[0]["RE_PRODUCT_1_1"]);
 		$("#re_product_2").val(result[0]["RE_PRODUCT_2"]);
 		$("#re_product_2_1").val(result[0]["RE_PRODUCT_2_1"]);
 		$("#re_product_3").val(result[0]["RE_PRODUCT_3"]);
 		$("#re_product_3_1").val(result[0]["RE_PRODUCT_3_1"]);
 		$("#re_product_4").val(result[0]["RE_PRODUCT_4"]);
 		$("#re_product_4_1").val(result[0]["RE_PRODUCT_4_1"]);
 		if(result[0]["EPD_YN"] == "1") {
 			fn_contrChBox(true, "epd_yn", "");
 		} else {
 			fn_contrChBox(false, "epd_yn", "");
 		}
 		
 		if(result[0]["FED_SPY_YN"] == "1") {
 			fn_contrChBox(true, "fed_spy_yn", "");
 		} else {
 			fn_contrChBox(false, "fed_spy_yn", "");
 		}
 		$("#re_product_11").val(result[0]["RE_PRODUCT_11"]);
 		$("#re_product_11_1").val(result[0]["RE_PRODUCT_11_1"]);
 		$("#re_product_12").val(result[0]["RE_PRODUCT_12"]);
 		$("#re_product_12_1").val(result[0]["RE_PRODUCT_12_1"]);
 		$("#re_product_13").val(result[0]["RE_PRODUCT_13"]);
 		$("#re_product_13_1").val(result[0]["RE_PRODUCT_13_1"]);
 		$("#re_product_14").val(result[0]["RE_PRODUCT_14"]);
 		$("#re_product_14_1").val(result[0]["RE_PRODUCT_14_1"]);
 		

 		$("#bdln_val").val(result[0]["BDLN_VAL"]);
 		$("#bdht_val").val(result[0]["BDHT_VAL"]);
 		
 		$("#brcl_isp_rzt_c").val(result[0]["BRCL_ISP_RZT_C"]);
 		$("#bovine_rsltnm").val(result[0]["BOVINE_RSLTNM"]);
 		$("#vacn_order").val(result[0]["VACN_ORDER"]);
 		
 		
 		
 		// -------------------- 히든 정보 -------------------- //
 		$("#oslp_no").val(result[0]["OSLP_NO"]);
 		$("#led_sqno").val(result[0]["LED_SQNO"]);
 		$("#sra_srs_dsc").val(result[0]["SRA_SRS_DSC"]);
 		$("#fir_lows_sbid_lmt_am").val(result[0]["FIR_LOWS_SBID_LMT_AM"]);
 		$("#sog_na_trpl_c").val(result[0]["SOG_NA_TRPL_C"]);
 		$("#io_mwmn_maco_yn").val(result[0]["IO_MWMN_MACO_YN"]);
 		$("#sra_farm_acno").val(result[0]["SRA_FARM_ACNO"]);
 		$("#pda_id").val(result[0]["PDA_ID"]);
 		
 		$("#hd_auc_prg_sq").val($("#auc_prg_sq").val());
 		// 브루셀라 접종결과 추후 추가 0:수기 1:음성 2:양성 9:미접종
 		if(result[0]["BRCL_ISP_RZT_C"] != null && result[0]["BRCL_ISP_RZT_C"] =="") {
 			$("#brcl_isp_rzt_c").val(result[0]["BRCL_ISP_RZT_C"]);
 		} else {
 			$("#brcl_isp_rzt_c").val("0");
 		}
 		
 		setRowStatus = "update";
 		
 		if(pageInfos.param != null) {
        	fn_setChgRadio("auc_obj_dsc", pageInfos.param.auc_obj_dsc);
    		fn_setRadioChecked("auc_obj_dsc");
    		
 			$("#emp_auc_prg_sq").val($("#auc_prg_sq").val());
 	    	$("#emp_sra_indv_amnno").val("410"+$("#sra_indv_amnno").val());
 	    	pageInfos.param = null;
        }
 		
 		if(fn_isNull($("#brcl_isp_dt").val())) {
 			// 브루셀라검사 조회
 	        fn_CallBrclIspSrch();
 		}
 	}
 	
 	//**************************************
 	//function  : fn_SelList(조회) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_SelList() {
    	 if(mv_RunMode == 1) {
    		 mv_InitBoolean = true;
    		 mv_Tab_Boolean = false;
    		 fn_Init();
    	 } else {
    		 var results = sendAjaxFrm("frm_Hdn", "/LALM0215_selList", "POST");
        	 var result;
            
             if(results.status == RETURN_SUCCESS){
             	result = setDecrypt(results);
                fn_SetData(result);
//                fn_selCowImg();              
             }else {
                 showErrorMessage(results);
                 mv_InitBoolean = true;
                 mv_Tab_Boolean = false;
        		 $("#btn_Delete").attr("disabled", true);
        		 /**
        		 * 20230321 jjw
        		 * 출장우내역 등록에서 데이터 삭제하고 
        		 * 탭이동해서 조회에서 삭제한 목록 재진입시
        		 * 무한 루프로 빠지는현상 확인
        		 **/
        		 pageInfos.param = null;
        		 
        		 fn_Init();
                 return;
             }
    	 }        
    }
 	
  	//**************************************
 	//function  : fn_SelPrgSq(경매순번 조회) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_SelPrgSq() {
    	 
		var results = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selPrgSq", "POST");
		var result;
		  
		if(results.status == RETURN_SUCCESS) {
			result = setDecrypt(results);
			if(result.length > 0) {
				if($("#gvno_bascd").val() == 0) {
					$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
					
				} else if ($("#gvno_bascd").val() == 1) {
					if(parseInt(result[0]["AUC_PRG_SQ"]) % 2 == 0) {
						$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
					} else {
						$("#auc_prg_sq").val(parseInt(result[0]["AUC_PRG_SQ"])+1);
					}
					
				} else if ($("#gvno_bascd").val() == 2) {
					if(parseInt(result[0]["AUC_PRG_SQ"]) % 2 == 1) {
						$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
					} else {
						$("#auc_prg_sq").val(parseInt(result[0]["AUC_PRG_SQ"])+1);
					}
				}
				
         	}
		}else {
            showErrorMessage(results);
            return;
        }
    }
 	
  	//**************************************
 	//function  : fn_GetPpgcowFeeDsc(임신구분 조회) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_GetPpgcowFeeDsc(result_param){
 		if (result_param["PPGCOW_FEE_DSC"] == "5") {
 			return 5;
 		}
 		if($("#ppgcow_fee_dsc").val() == result_param["PPGCOW_FEE_DSC"]) {
 			return $("#ppgcow_fee_dsc").val();
 		}
    	 
   		 var results = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selGetPpgcowFeeDsc", "POST");
       	 var result;
           
         if(results.status == RETURN_SUCCESS) {
         	result = setDecrypt(results);
            if(result.length == 0) {
         	   if(result_param["PPGCOW_FEE_DSC"] == 5) {
         		   return 5;
         	   } else {
         		   return -1;
         	   }
            }
            return -1;	 
   	 	}else {
            showErrorMessage(results);
            return;
        }
    }
 	
   	//**************************************
 	//function  : fn_SelAucQcn(경매차수내역 조회) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_SelAucQcn(){
    	 var results = sendAjaxFrm("frm_MhSogCow", "/Common_selAucQcn", "POST");
    	 var result = null;
        
         if(results.status == RETURN_SUCCESS) {
         	result = setDecrypt(results);
         	$("#ddl_qcn").val(result[0]["QCN"]);
         	mv_sgno_prc_dsc = result[0]["SGNO_PRC_DSC"];
         	fn_CreateAucQcnGrid(result);
         } else {
        	$("#ddl_qcn").val("");
         }
         
         return result;
    }
 	
  	//**************************************
 	//function  : fn_SelAucDt(경매일자 조회) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelAucDt(flag){
 		 
	    var srchData = new Object();
        srchData["auc_obj_dsc"] = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["flag"] = flag;
        
        var resultsAuc = sendAjax(srchData, "/Common_selAucDt", "POST");    
        var resultAuc;
        
        if(resultsAuc.status == RETURN_SUCCESS){
            resultAuc = setDecrypt(resultsAuc);
        }
        
	    $("#auc_dt").datepicker().datepicker("setDate", fn_toDate(resultAuc.AUC_DT));
                
    }
    
  	//**************************************
 	//function  : fn_SelFee(수수료코드 조회) 
 	//paramater : N/A 
 	// result   : Count
 	//**************************************
    function fn_SelFee(){
    	 
    	 var results = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selFee", "POST");
    	 var result;
    	 var Count = 0;
        
    	 if(results.status == RETURN_SUCCESS) {
    		 result = setDecrypt(results);
    		 fn_CreateMhFeeGrid(result);
    		 
    		 return result;
            
          } else {
        	 return null;
          }
                
    }
    
  	//**************************************
 	//function  : fn_SelMhCalf(송아지 조회) 
 	//paramater : N/A 
 	// result   : Count
 	//**************************************
    function fn_SelMhCalf() {
    	var results = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selMhCalf", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS){
        	result = setDecrypt(results);
        	fn_CreateCalfGrid(result);
        	rowId = $("#calfGrid").getGridParam("reccount");
        }
    }
    
    //**************************************
 	//function  : fn_ClearReProduct(ReProduct 초기값 셋팅) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_ClearReProduct() {
    	if($("#re_product_1").val() == '') $("#re_product_1").val("0");
		if($("#re_product_2").val() == '') $("#re_product_2").val("0");
		if($("#re_product_3").val() == '') $("#re_product_3").val("0");
		if($("#re_product_4").val() == '') $("#re_product_4").val("0");
		if($("#re_product_11").val() == '') $("#re_product_11").val("0");
		if($("#re_product_12").val() == '') $("#re_product_12").val("0");
		if($("#re_product_13").val() == '') $("#re_product_13").val("0");
		if($("#re_product_14").val() == '') $("#re_product_14").val("0");
    }
    
  	//**************************************
 	//function  : fn_ClearCal(달력 초기값 셋팅) 
 	//paramater : p_param(구분자) ex) "init" 
 	// result   : N/A
 	//**************************************
 	function fn_ClearCal(p_param) {
 		if(p_param == "init" && fn_isDate(mv_auc_dt)) {
 			$("#auc_dt").datepicker().datepicker("setDate", fn_toDate(mv_auc_dt));
 		} else {
 			$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
 		} 		
 		
 		$("#rc_dt").datepicker().datepicker("setDate", fn_getToday());
 		$("#auc_chg_dt").datepicker().datepicker("setDate", fn_getToday());
 		$("#birth").datepicker().datepicker("setDate", fn_getToday());
 		$("#vacn_dt").datepicker().datepicker("setDate", fn_getToday());
 		$("#brcl_isp_dt").datepicker().datepicker("setDate", fn_getToday());
 		$("#afism_mod_dt").datepicker().datepicker("setDate", fn_getToday());
 		$("#bovine_dt").datepicker().datepicker("setDate", fn_getToday());
 	}
 	
 	//**************************************
 	//function  : fn_AucOnjDscModify(경매대상 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_AucOnjDscModify(flag) {
 		
 		// 경매일 셋팅을 위한 조회
		fn_SelAucDt(flag);
 		
	    if (mv_RunMode == '1' && mv_flg == '') {
	    	$("#btn_Save").attr("disabled", false);
	    	$("#btn_Delete").attr("disabled", true);
	    	
	    	if(!fn_isNull($("#auc_dt").val())) {
	    		// 경매차수 조회
				var resultAucQcn = fn_SelAucQcn();
				
				if(resultAucQcn == null) {
	    			MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
	    			$("#btn_Save").attr("disabled", true);
	    		} else {
	    			mv_cut_am = resultAucQcn[0]["CUT_AM"];
	                mv_sqno_prc_dsc = resultAucQcn[0]["SGNO_PRC_DSC"];
	    		}
	    	} else {
	    		$("#btn_Save").attr("disabled", true);
	    	}
	    	
	    	fn_FrmClear();
	    	$("#calfGrid").jqGrid("clearGridData", true);
	    	$("#sra_sbid_am").val("0");

			var tmp_check_val = $("#auc_obj_dsc").val();
			
        	if(tmp_check_val == 1) {
        		$("#firstBody").hide();
        		$("#secondBody").show();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();
        		$("#ppgcow_fee_dsc").val("5");
        		
        		if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        			
        		} else if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}
        		
        	} else if(tmp_check_val == 2) {
        		$("#firstBody").hide();
        		$("#secondBody").hide();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();
        		
        		$("#ppgcow_fee_dsc").val("5");
        		
        		if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        			
        		} else if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}
        		
        	} else if(tmp_check_val == 3) {
        		$("#firstBody").show();
        		$("#secondBody").hide();
        		$("#thirdBody").show();
        		$("#pb_tab2").hide();
        		
        		// ★영천: 8808990656687 포항: 8808990679549   테스트: 8808990643625
        		// 20230920 : 영천축협 요청 임신감정여부 초기값 false로 설정
        		if (App_na_bzplc == '8808990656687' || App_na_bzplc == '8808990679549'){  
        			$("#ppgcow_fee_dsc").val("2");
	    			$("input:checkbox[id='prny_jug_yn']").prop("checked", false);
	    			fn_contrChBox(false, "prny_jug_yn", "");
	            }else{
	            	$("#ppgcow_fee_dsc").val("1");
	    			$("input:checkbox[id='prny_jug_yn']").prop("checked", true);
	    			fn_contrChBox(true, "prny_jug_yn", "");
	            	//경주축협일때 임신우 => 임신구분 여
	            	if (App_na_bzplc == '8808990659008'){
   		        		fn_contrChBox(true, "prny_yn", "");						   
				    }	    			
	            }
        		
        		if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "1000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
        			$("#sra_sbid_upr").attr("maxlength", "5");
        			$("#msg_Sbid3").text(" / (단위:천원)");
        			
        		} else if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "10000") {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
        			$("#sra_sbid_upr").attr("maxlength", "4");
        			$("#msg_Sbid3").text(" / (단위:만원)");
        		} else {
        			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
        			$("#sra_sbid_upr").attr("maxlength", "8");
        			$("#msg_Sbid3").text(" / (단위: 원)");
        		}        		
        	}
	    	
        	fn_GvnoBascdModify();
        	$("#hed_indv_no").val("410");
        	
        	// ★함평: 8808990656601 장흥: 8808990656533
        	if (App_na_bzplc == '8808990656601' || App_na_bzplc == '8808990656533') {  
        		$("#sra_indv_amnno").val("002");
	        }else{
	        	$("#sra_indv_amnno").val("");
	        }
        	
        	// ★세종공주: 8808990656588 테스트: 8808990643625
			//if (App_na_bzplc == '8808990656588') {
			//	
			//	var resultsTmpAucPrgSq = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selTmpAucPrgSq", "POST");        
			//      var resultTmpAucPrgSq;
			//      
			//      if(resultsTmpAucPrgSq.status == RETURN_SUCCESS){
			//      	resultTmpAucPrgSq = setDecrypt(resultsTmpAucPrgSq);
			//      	$("#auc_prg_sq").val(resultTmpAucPrgSq[0]["AUC_PRG_SQ"]);
			//      }else {
			//          showErrorMessage(resultsTmpAucPrgSq);
			//          return;
			//      }
			//}
	        
	    }
	    
	    if($("#chk_continue").is(":checked")) {
	    	fn_ChkContinue();
		}
	    if($("#chk_continue1").is(":checked")) {
	    	fn_ChkContinue2();
		} 	
 	}
 	
 	//**************************************
 	//function  : fn_ChkContinue(수수료미적용 연속등록 체크 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_ChkContinue() {
 		// 청도축협  수수료미적용 체크시 따로 미적용 체크와 생산자 변경을 하지 않고 입력하도록
 	    // ★청도: 8808990656571 테스트: 8808990643625
 		if (App_na_bzplc == '8808990656571'){  
 			if($("#chk_continue").is(":checked")) {
 				$("#chk_continue1").attr("disabled", true);
 				$("#fee_chk_yn").attr("disabled", true);
 				
 				var results = sendAjaxFrm("frm_MhSogCow", "/LALM0213_selList", "POST");        
 		        var result;
 		        
 		        if(results.status == RETURN_SUCCESS){
 		        	result = setDecrypt(results);
 		        	$("#sra_pdmnm").val(result[0]["FTSNM"]);
 		        	$("#sogmn_c").val(result[0]["FHS_ID_NO"]);
 		        	
 		        	fn_contrChBox(true, "fee_chk_yn");
 		        }else {
                    showErrorMessage(results);
                    return;
                }
 	            
 	        } else {
 	        	$("#chk_continue1").attr("disabled", false);
 				$("#fee_chk_yn").attr("disabled", false);
 				$("#sra_pdmnm").val("");
 				$("#sogmn_c").val("");
 				
 				fn_contrChBox(false, "fee_chk_yn");
 				$("#fee_chk_yn_fee").text("");
 				$("#sra_pdmnm").val($("#ftsnm").val());
 	        }
 	    }
 	}
 	
 	//**************************************
 	//function  : fn_ChkContinue2(출하수수료 연속등록 체크 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_ChkContinue2() {
 		// 청도축협  수수료미적용 체크시 따로 미적용 체크와 생산자 변경을 하지 않고 입력하도록
 	    // ★청도: 8808990656571 테스트: 8808990643625
 		if (App_na_bzplc == '8808990656571'){  
 			if($("#chk_continue1").is(":checked")) {
 				$("#chk_continue").attr("disabled", true);
 				$("#fee_chk_yn").attr("disabled", false);
 				fn_contrChBox(true, "fee_chk_yn");
 				fn_MacoFee();
 	            
 	        } else {
 	        	$("#chk_continue").attr("disabled", false);
 				$("#fee_chk_yn").attr("disabled", false);
 				fn_contrChBox(false, "fee_chk_yn");
 				$("#fee_chk_yn_fee").text("");
 	        }
 	    }
 		
 	}
 	
 	//**************************************
 	//function  : fn_MacoFee(조합원 수수료 적용) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_MacoFee() {
 		var resultsMacoFee = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selMacoFee", "POST");
        var resultMacoFee;
        
        if(resultsMacoFee.status == RETURN_SUCCESS){
        	resultMacoFee = setDecrypt(resultsMacoFee);
        	$("#fee_chk_yn_fee").val(result[0]["MACO_FEE_UPR"]);
        }else {
            showErrorMessage(resultsMacoFee);
            return;
        }
 	}
 	
 	//**************************************
 	//function  : fn_RcDtModify(접수일자 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_RcDtModify() {
 		if($("#auc_dt").val() == $("#rc_dt").val()) {
 			$("#td_rc_cst").val(parent.envList[0]["TD_RC_CST"]);
 		} else {
 			$("#td_rc_cst").val("0");
 		}
 	}
 	
 	//**************************************
 	//function  : fn_AfismModDtModify(접수일자 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_AfismModDtModify() {
 		//★6. 분만예정일 = 인공수정일자 + 285
 		if(!fn_isNull($("#afism_mod_dt").val())) {
 			$("#ptur_pla_dt").val(fn_getAddDay($("#afism_mod_dt").val(), 285));
 	 		$("#prny_mtcn").val(parseInt(fn_SpanDay($("#afism_mod_dt").val(), $("#auc_dt").val(), "Month")) + 1);
 		}
 	}
 	
 	//**************************************
 	//function  : fn_IoSogmnMacoYnModify(조합원구분 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_IoSogmnMacoYnModify() {
 		if($("#io_sogmn_maco_yn").val() == "1") {
			$("#sra_pyiva").attr("disabled", false);
			$("#sra_pyiva").val("");
		} else {
			$("#sra_pyiva").attr("disabled", true);
			$("#sra_pyiva").val("0");
		}
 	}
 	
 	//**************************************
 	//function  : fn_GvnoBascdModify(경매기준번호 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_GvnoBascdModify() {
    	if(mv_RunMode == "1") {
    		fn_setChgRadio("gvno_bascd", $("input[name='rd_gvno_bascd']:checked").val());
        	fn_SelPrgSq();
    	}
 	}
 	
 	//**************************************
 	//function  : fn_TrpcsPyYnModify(자가운송여부 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_TrpcsPyYnModify(flag) {
		if(flag == 'init' && na_bzplc=='8808990779546') fn_contrChBox(false, "trpcs_py_yn", "");
 		if($("#trpcs_py_yn").is(":checked")) {
 			fn_contrChBox(true, "trpcs_py_yn", "");
			
			$("#vhc_drv_caffnm").attr("disabled", true);
			$("#pb_vhc_drv_caffnm").attr("disabled", true);
			$("#sra_trpcs").attr("disabled", true);
			
			$("#vhc_shrt_c").val("");
			$("#vhc_drv_caffnm").val("");
			$("#sra_trpcs").val("0");
			
		} else {
			fn_contrChBox(false, "trpcs_py_yn", "");
			
			$("#vhc_drv_caffnm").attr("disabled", false);
			$("#pb_vhc_drv_caffnm").attr("disabled", false);
			$("#sra_trpcs").attr("disabled", false);
			
			$("#sra_trpcs").val("");
		}    
 	}
 	
 	//**************************************
 	//function  : fn_FtsnmModify(출하주 수정 시 변경) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_FtsnmModify() {
 		
   		if($("#auc_obj_dsc").val() == "3" && $("#ftsnm").val() != "" && $("#mod_kpn_no").val() == "" && setRowStatus == "insert" && App_na_bzplc == "8808990643625") {
   			var sra_indv_amnno  = "410" + $("#sra_indv_amnno").val();
   			var srchData = new Object();
   	    	
   			//인공수정KPN정보       
   	        srchData["ctgrm_cd"]  = "2900";
   	        srchData["SRA_INDV_AMNNO"] = sra_indv_amnno;
   	        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
   	        var result;
   	        
   	        if(results.status != RETURN_SUCCESS){
   	            showErrorMessage(results,'NOTFOUND');
   	            return;
   	        }else{
   	            result = setDecrypt(results);
   	            
   	            $("#mod_kpn_no").val($.trim(result.SRA_KPN_NO));
   	        }
   			
      	}
   		
   		if ($("#io_sogmn_maco_yn").val() == '1') {
   			$("#sra_pyiva").attr("disabled", false);
   	    } else {
   	    	$("#sra_pyiva").attr("disabled", true);
   	    	$("#sra_pyiva").val("0");
   	    }
 	}
 	
 	//**************************************
 	//function  : fn_FrmClear(Frm Clear) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_FrmClear() {
 		// 'auc_dt','rd_auc_obj_dsc','gvno_bascd','auc_prg_sq', 'ddl_qcn', 'rc_dt' 6개 빼고 초기화
 		var tmpAucDt     = $("#auc_dt").val();
 		var tmpAucObjDsc = $("#auc_obj_dsc").val();
 		var tmpGvnoBascd = $("#gvno_bascd").val();
 		var tmpAucPrgSq  = $("#auc_prg_sq").val();
 		var tmpDdlQcn    = $("#ddl_qcn").val();
 		var tmpRcDt      = $("#rc_dt").val();
 		
 		// 폼 초기화
		fn_InitFrm('frm_MhSogCow');
		$("#auc_dt").val(tmpAucDt);
		$("#auc_prg_sq").val(tmpAucPrgSq);
		$("#ddl_qcn").val(tmpDdlQcn);
		$("#rc_dt").val(tmpRcDt);
		
		$("#auc_obj_dsc").val(tmpAucObjDsc);
		fn_setChgRadio("auc_obj_dsc", tmpAucObjDsc);
		fn_setRadioChecked("auc_obj_dsc");
		
		$("#gvno_bascd").val(tmpGvnoBascd);
		$("input[name='rd_gvno_bascd']:radio[value='" + tmpGvnoBascd + "']").prop("checked", true);
 		
		$("#lvst_mkt_trpl_amnno").val(mv_lvst_mkt_trpl_amnno);
		$("#rcc_dt").datepicker().datepicker("setDate", fn_getToday());
		
		// ★임실: 8808990660783 포항: 8808990679549  고성: 8808990656458  영광: 8808990811710 충주: 8808990656465 남원: 8808990227207  테스트: 8808990643625 겅주 8808990659008
 	    if (App_na_bzplc == '8808990660783' || App_na_bzplc == '8808990679549' || App_na_bzplc == '8808990656458' || App_na_bzplc == '8808990811710' || App_na_bzplc == '8808990656465' || App_na_bzplc == '8808990227207' || App_na_bzplc == '8808990659008'){
 	    	$("#dna_yn").val("3");
 	    }else{
 	    // YCSONG 220203 : 친자확인결과(dna_yn) 초기화값을 정보없음으로 세팅하도록 수정
 	    	$("#dna_yn").val("3");
 	    }
		
 	   	fn_RcDtModify();
 	   	fn_IoSogmnMacoYnModify();
 	   	fn_TrpcsPyYnModify('init');
 	   	
 	    fn_SelMhCalf();
 		
 	}
 	
 	//**************************************
	//function  : fn_DisableAuc(경매대상 Disable 및 Enable) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_DisableAuc(p_boolean){		
			var rd_length = $("input[name='auc_obj_dsc_radio']").length;
			var disableItem = $("input[name='auc_obj_dsc_radio']");
            
			for(var i=0; i<rd_length; i++){
				itemNames = $(disableItem[i]).attr("id");
				
				if(p_boolean) {
					$("#"+itemNames).attr("disabled", true);    	  	
				} else {
					$("#"+itemNames).attr("disabled", false);      		
				}
			}   
	}
	
	/*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_GridAfismModDtChange
     * 2. 입 력 변 수 : v_selrow(그리드의 행 아이디)
     *                , v_ppgcow_fee_dsc(값)
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
    function fn_GridAfismModDtChange(v_selrow, v_afism_mod_dt){
    	if(fn_isDate(v_afism_mod_dt)){
    		var addday = fn_getAddDay(v_afism_mod_dt,285,'YYYYMMDD');
            $("#calfGrid").jqGrid('setCell', v_selrow, 'PTUR_PLA_DT', addday);
            var spaday = fn_SpanDay(v_afism_mod_dt, $("#calfGrid").jqGrid('getCell', v_selrow, 'AUC_DT'),'Month') + 1;
            $("#calfGrid").jqGrid('setCell', v_selrow, 'PRNY_MTCN', spaday);
            
            
        } else {
        	$("#calfGrid").jqGrid('setCell', v_selrow, 'PTUR_PLA_DT', null);
        	$("#calfGrid").jqGrid('setCell', v_selrow, 'PRNY_MTCN', null);
        }  
    	fn_GridPrnyMtcnChange(v_selrow, $("#calfGrid").jqGrid('getCell', v_selrow, 'PRNY_MTCN'));
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : fn_GridPrnyMtcnChange
     * 2. 입 력 변 수 : v_selrow(그리드의 행 아이디)
     *                , v_prny_mtcn(값)
     * 3. 출 력 변 수 : N/A
     * 4. 설 명       : 수정시 상태값과 행의 색상을 변경하는 함수
     ------------------------------------------------------------------------------*/
    function fn_GridPrnyMtcnChange(v_selrow, v_prny_mtcn){
        if (v_prny_mtcn > 0){
            $("#calfGrid").jqGrid('setCell', v_selrow, 'PRNY_JUG_YN', '1');
            $("#calfGrid").jqGrid('setCell', v_selrow, 'PRNY_YN', '1');
              

            var v_prny_mtcn =  '<임신' + v_prny_mtcn + '개월>';
            if ($("#calfGrid").jqGrid('getCell', v_selrow, 'RMK_CNTN') == ''){
                $("#calfGrid").jqGrid('setCell', v_selrow, 'RMK_CNTN', v_prny_mtcn);
            }else{
                $("#calfGrid").jqGrid('setCell', v_selrow, 'RMK_CNTN', $("#calfGrid").jqGrid('getCell', v_selrow, 'EX_RMK_CNTN') + v_prny_mtcn);
            }

        }else if (v_prny_mtcn <= 0 || v_prny_mtcn == '' ){
            $("#calfGrid").jqGrid('setCell', v_selrow, 'RMK_CNTN', $("#calfGrid").jqGrid('getCell', v_selrow, 'EX_RMK_CNTN'));
            $("#calfGrid").jqGrid('setCell', v_selrow, 'PRNY_YN', '0');
        }        
    }
    
  	//**************************************
	//function  : fn_CallBrclIspSrch(브루셀라검사 조회) 
	//paramater : N/A
	// result   : N/A
	//**************************************
    function fn_CallBrclIspSrch() {
    	var srchData = new Object();
    	var P_sra_indv_amnno = "";
    	
    	if($("#sra_indv_amnno").val().replace("-", "").length == 12) {
        	P_sra_indv_amnno = $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
		} else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
                $("#sra_indv_amnno").focus();
            });
			return;
		}

        srchData["trace_no"]     = P_sra_indv_amnno;
        srchData["option_no"]    = "7";
        
        var results = sendAjax(srchData, "/LALM0899_selRestApi", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS) {
        	$("#brcl_isp_rzt_c").val("9");
            return;
        } else {
            result = setDecrypt(results);
            $("#brcl_isp_dt").val(fn_toDate($.trim(result["insepctDt"])));
         	
            // 브루셀라 접종결과 추후 추가 0:수기 1:음성 2:양성 9:미접종 brcl_isp_rzt_c
            if($.trim(result["inspectYn"]) == "음성") {
            	$("#brcl_isp_rzt_c").val("1");
            } else if($.trim(result["inspectYn"]) == "양성") {
            	$("#brcl_isp_rzt_c").val("2");
            } else {
            	$("#brcl_isp_rzt_c").val("0");
            }
        	$("#brcl_isp_dt").val(fn_toDate($.trim(result["inspectDt"])));
        	
        	$("#vacn_order").val($.trim(result["vaccineorder"]));        	
        	$("#vacn_dt").val(fn_toDate($.trim(result["injectionYmd"])));
        	$("#bovine_dt").val(fn_toDate($.trim(result["tbcInspctYmd"])));
        	$("#bovine_rsltnm").val($.trim(result["tbcInspctRsltNm"]));
        }
    }
    
  	//**************************************
	//function  : fn_CallLsPtntInfSrch(축산연구원 친자확인 조회 인터페이스) 
	//paramater : N/A
	// result   : N/A
	//**************************************
    function fn_CallLsPtntInfSrch() {
    	var P_sra_indv_amnno = "";
		
		if($("#sra_indv_amnno").val().replace("-", "").length == 12) {
        	P_sra_indv_amnno = $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
		} else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
                $("#sra_indv_amnno").focus();
            });
			return;
		}
    	 
    	//개체이력정보
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["ctgrm_cd"]     = "4300";
        srchData["rc_na_trpl_c"] = "8808990768700";
        srchData["indv_id_no"]   = P_sra_indv_amnno;
        
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        
        if(results.status != RETURN_SUCCESS) {
        	MessagePopup('OK','친자확인 데이터 조회 실패.',null,function(){
        		// YCSONG 220203 : 친자확인 데이터 조회가 실패한 경우 친자확인결과(dna_yn) 정보없음으로 세팅하도록 수정
        		$("#dna_yn").val("3");
//         		$("#dna_yn").val("1");
            });
        } else {
            result = setDecrypt(results);
            if(fn_isNull($.trim(result.LS_PTNT_DSC))) {
            	// YCSONG 220203 : 친자확인 결과 데이터가 없는 경우 친자확인결과(dna_yn) 정보없음으로 세팅하도록 수정
            	$("#dna_yn").val("3");
//             	$("#dna_yn").val("1");
            } else if(result.LS_PTNT_DSC != "00" && result.LS_PTNT_DSC != "10" && result.LS_PTNT_DSC != "11" && result.LS_PTNT_DSC != "12" && result.LS_PTNT_DSC != "13") {
            	// YCSONG 220203 : 친자확인 결과 데이터가 일치(00), 완전불일치(10), 부불일치(11), 모불일치(12), 부or모불일치(13)이 아닌경우 정보없음으로 세팅하도록 수정
            	$("#dna_yn").val("3");
//             	$("#dna_yn").val("1");
            } else {
            	if(result.LS_PTNT_DSC == "00"){
            		$("#dna_yn").val("1");
            	} else if(result.LS_PTNT_DSC == "10"){
            		$("#dna_yn").val("2");
            	} else if(result.LS_PTNT_DSC == "11"){
            		$("#dna_yn").val("4");
            	} else if(result.LS_PTNT_DSC == "12"){
            		$("#dna_yn").val("5");
            	} else if(result.LS_PTNT_DSC == "13"){
            		$("#dna_yn").val("6");
            	}
            }
        }
    }
    
  	//**************************************
	//function  : fn_CallGeneBredrInfSrch(축산연구원 유전체분석 조회 인터페이스) 
	//paramater : N/A
	// result   : N/A
	//**************************************
    function fn_CallGeneBredrInfSrch(p_param) {
		var P_sra_indv_amnno = "";
		
		if($("#sra_indv_amnno").val().replace("-", "").length == 12) {
			if(fn_isNull(p_param)) {
				P_sra_indv_amnno = $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
			} else {
				P_sra_indv_amnno = p_param;
			}
        	
		} else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
                $("#sra_indv_amnno").focus();
            });
			return;
		}
    	 
    	//개체이력정보
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["ctgrm_cd"]     = "4200";
        srchData["rc_na_trpl_c"] = "8808990768700";
        srchData["indv_id_no"]   = P_sra_indv_amnno;
        
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        
        if(results.status != RETURN_SUCCESS) {
        	MessagePopup('OK','유전체분석 데이터 조회 실패.',null,function(){
            });
        } else {
            result = setDecrypt(results);
            if(fn_isNull(p_param)) {
            	if(!isNaN(parseFloat(result.GENE_BREDR_VAL2))) {
            		$("#re_product_1").val(parseFloat(result.GENE_BREDR_VAL2));
            	} else {
            		$("#re_product_1").val("");
            	}            	
                $("#re_product_1_1").val($.trim(result.GENE_EVL_RZT_DSC2));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL3))) {
            		$("#re_product_2").val(parseFloat(result.GENE_BREDR_VAL3));
            	} else {
            		$("#re_product_2").val("");
            	}                
                $("#re_product_2_1").val($.trim(result.GENE_EVL_RZT_DSC3));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL4))) {
            		$("#re_product_3").val(parseFloat(result.GENE_BREDR_VAL4));
            	} else {
            		$("#re_product_3").val("");
            	}
                $("#re_product_3_1").val($.trim(result.GENE_EVL_RZT_DSC4));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL5))) {
            		$("#re_product_4").val(parseFloat(result.GENE_BREDR_VAL5));
            	} else {
            		$("#re_product_4").val("");
            	}
                $("#re_product_4_1").val($.trim(result.GENE_EVL_RZT_DSC5));
                
            } else {
            	if(!isNaN(parseFloat(result.GENE_BREDR_VAL2))) {
            		$("#re_product_11").val(parseFloat(result.GENE_BREDR_VAL2));
            	} else {
            		$("#re_product_11").val("");
            	}            	
                $("#re_product_11_1").val($.trim(result.GENE_EVL_RZT_DSC2));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL3))) {
            		$("#re_product_12").val(parseFloat(result.GENE_BREDR_VAL3));
            	} else {
            		$("#re_product_12").val("");
            	}                
                $("#re_product_12_1").val($.trim(result.GENE_EVL_RZT_DSC3));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL4))) {
            		$("#re_product_13").val(parseFloat(result.GENE_BREDR_VAL4));
            	} else {
            		$("#re_product_13").val("");
            	}
                $("#re_product_13_1").val($.trim(result.GENE_EVL_RZT_DSC4));
                
                if(!isNaN(parseFloat(result.GENE_BREDR_VAL5))) {
            		$("#re_product_14").val(parseFloat(result.GENE_BREDR_VAL5));
            	} else {
            		$("#re_product_14").val("");
            	}
                $("#re_product_14_1").val($.trim(result.GENE_EVL_RZT_DSC5));
                
            }
            
        }
    }
    
    
  	//**************************************
	//function  : fn_CallAiakInfoSync(종축개량 데이터 연동) 
	//paramater : N/A
	// result   : N/A
	//**************************************
    function fn_CallAiakInfoSync(p_param) {
    	//개체이력정보
    	var srchData = new Object();
        srchData["INDV_BLD_DSC"]   = "0";
        
		var p_sra_indv_amnno = "";
		var mcowChk = 0;
		if(!fn_isNull(p_param)){
			mcowChk = 1;
			srchData["INDV_BLD_DSC"]   = "M";
			p_sra_indv_amnno = p_param;			
		}else if($("#sra_indv_amnno").val().replace("-", "").length == 12) {
			p_sra_indv_amnno = $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");        	
		} else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
                $("#sra_indv_amnno").focus();
            });
			return;
		}
    	 
    	var results = null;
    	var result = null;
    	
        srchData["SRA_INDV_AMNNO"]   = p_sra_indv_amnno;
        srchData["AUC_DT"]   = $('#auc_dt').val();
        srchData["CHG_RMK_CNTN"]   = "LALM0215["+srchData["INDV_BLD_DSC"]+"]";
        results = sendAjax(srchData, "/LALM0899_selAiakRestApi", "POST");
        
        if(results.status == RETURN_SUCCESS) {        	
            result = setDecrypt(results);
            if(arrNaBzplc.includes(na_bzplc)){
				if(mcowChk == '1'){
					$('#re_product_11').val(fn_isNum(result.EPD_VAL_1)?Number(result.EPD_VAL_1).toFixed(3):"");					
					$('#re_product_12').val(fn_isNum(result.EPD_VAL_2)?Number(result.EPD_VAL_2).toFixed(3):"");
					$('#re_product_13').val(fn_isNum(result.EPD_VAL_3)?Number(result.EPD_VAL_3).toFixed(3):"");					
					$('#re_product_14').val(fn_isNum(result.EPD_VAL_4)?Number(result.EPD_VAL_4).toFixed(3):"");
					$('#re_product_11_1').val(result.EPD_GRD_1);					
					$('#re_product_12_1').val(result.EPD_GRD_2);					
					$('#re_product_13_1').val(result.EPD_GRD_3);					
					$('#re_product_14_1').val(result.EPD_GRD_4);		
				}else{					
					$('#re_product_1').val(fn_isNum(result.EPD_VAL_1)?Number(result.EPD_VAL_1).toFixed(3):"");					
					$('#re_product_2').val(fn_isNum(result.EPD_VAL_2)?Number(result.EPD_VAL_2).toFixed(3):"");
					$('#re_product_3').val(fn_isNum(result.EPD_VAL_3)?Number(result.EPD_VAL_3).toFixed(3):"");					
					$('#re_product_4').val(fn_isNum(result.EPD_VAL_4)?Number(result.EPD_VAL_4).toFixed(3):"");
					$('#re_product_1_1').val(result.EPD_GRD_1);					
					$('#re_product_2_1').val(result.EPD_GRD_2);					
					$('#re_product_3_1').val(result.EPD_GRD_3);					
					$('#re_product_4_1').val(result.EPD_GRD_4);					
				}			
			}
        }
        return result;
    }
    
  	//**************************************
	//function  : maxLengthCheck(바이트 문자 입력가능 문자수 체크) 
	//paramater : id(tag id), title(tag title), maxLength(최대 입력가능 수 byte)
	// result   : Boolean
	//**************************************
	function maxLengthCheck(id, title, maxLength) {
		var obj = $("#"+id);
		if(maxLength == null) {
			maxLength = obj.attr("maxLength") != null ? obj.attr("maxLength") : 100;
		}
		
		if(Number(byteCheck(obj)) > Number(maxLength)) {
			MessagePopup("OK", title + "이(가) 입력가능문자수를 초과하였습니다. \n (영문, 숫자, 일반 특수문자 : " + maxLength + " / 한글, 한자, 기타 특수문자 : " + parseInt(maxLength/2, 10) + ").",function(res){
				obj.focus();
				return false;
			});
			
		} else {
			return true;
		}
	}
	
	//**************************************
	//function  : byteCheck(바이트수 반환) 
	//paramater : el(tag jquery object)
	// result   : number
	//**************************************
	function byteCheck(el) {
		var codeByte = 0;
		var Encode = fn_xxsEncode(el.val());
		for (var i = 0; i < Encode.length; i++) {
			var oneChar = Encode.charAt(i);
			var uniChar = escape(oneChar);
			if(uniChar.length == 1) {
				codeByte ++;
			} else if(uniChar.indexOf("%u") != -1) {
				codeByte += 2;
			} else if(uniChar.indexOf("%") != -1) {
				codeByte ++;
			} else {
				codeByte ++;
			}
		}
		return codeByte;
	}
	
	//**************************************
	//function  : fn_xxsEncode(특수문자 치환) 
	//paramater : p_str
	// result   : result
	//**************************************
	function fn_xxsEncode(p_str){
	    var result = "";
	    if(p_str != null && typeof p_str == 'string' && p_str != ""){
	    	result = p_str;
	        result = result.replace("&", "/&amp");
	        result = result.replace("#", "/&#35");
	        result = result.replace("<", "/&lt");
	        result = result.replace(">", "/&gt");
	        result = result.replace("(", "/&#40");
	        result = result.replace(")", "/&#41");
	        result = result.replace("\"", "/&quot");
	        result = result.replace("'", "/&#x27");      
	        return result;
	    }else{
	    	return p_str;
	    }
	}
	
	//**************************************
	// function  : fn_selCowImg(이미지 조회) 
	// paramater : event
	// result   : N/A
	//**************************************
	function fn_selCowImg(){
		var srchData = new Object();
		srchData["na_bzplc"] = localStorage.getItem("nhlvaca_na_bzplc");
		srchData["auc_dt"] = fn_dateToData($("#auc_dt").val());
		srchData["auc_obj_dsc"] = $("#auc_obj_dsc").val()
		srchData["oslp_no"] = $("#oslp_no").val();
		srchData["led_sqno"] = "1";
		srchData["sra_indv_amnno"] = "410" + $("#sra_indv_amnno").val();
		
		var results = sendAjax(srchData, "/LALM0215_selImgList", "POST");        
		var result;
		if(results.status != RETURN_SUCCESS){
            return;
        }else{      
            imgList = setDecrypt(results);
            if (imgList.length > 0) {
            	$("#imagePreview").empty();
	            let sHtml = '';
	      		for (const item of imgList) {
	      			sHtml += '	<div id="'+ item.FILE_NM +'"_"' + item.IMG_SQNO +'" class="fileDiv">';
//					sHtml += '		<button type="button" class="tb_btn delIndvImg">파일삭제</button>';
					sHtml += '		<img src="'+ item.FILE_URL +'" data-file="'+ item.FILE_NM +'" />';
					sHtml += '</div>';	
	      		}            	
	      		$("#imagePreview").append(sHtml);
            }
        }
	}

	//**************************************	
	// function  : fn_ImageFiles(이미지 등록) 
	// paramater : event
	// result   : N/A
	//**************************************
	function fn_ImageFiles(e){
		const uploadFiles = [];
		const files = e.currentTarget.files;
		const fileImg = $("div#imagePreview div.fileDiv");
		const imagePreview = document.querySelector("#imagePreview");
		
		// 파일 갯수 처리
		if ([...files].length > 8 || [...files].length + fileImg.length > 8) {
			MessagePopup('OK','이미지는 최대 8개까지 등록 가능합니다.');
			$("#uploadImg").val("");
			return;
		}
		
		// 파일 형식 체크
		[...files].forEach(file => {
			if (!file.type.match("image/.*")) {
				MessagePopup('OK','이미지 형식 파일만 등록할 수 있습니다.');
				$("#uploadImg").val("");
				return;
			}
			
//			if (file.size > 2000000) {
//				MessagePopup('OK','2MB이하의 이미지만 등록할 수 있습니다.');
//				$("#uploadImg").val("");
//				return;
//			}
			
			// 이미지 미리보기 처리
			if ([...files].length < 9 || [...files].length + fileImg.length < 9) {
				uploadFiles.push(file);
				const reader = new FileReader();
				reader.onload = (e) => {
					const preview = fn_CreateImgElement(e, file);
					$("#imagePreview").append(preview);
				};
				reader.readAsDataURL(file);
			}
		});
	}
	
	//**************************************
	// function  : fn_CreateImgElement(이미지 미리보기) 
	// paramater : event, file
	// result   : N/A
	//**************************************
	function fn_CreateImgElement(e, file) {
		let sHtml = '';

		sHtml += '	<div id="'+ file.name + '_' + file.size +'" class="fileDiv">';
		sHtml += '		<button type="button" class="tb_btn delIndvImg">파일삭제</button>';
		sHtml += '		<img src="'+ e.target.result +'" data-file="'+ file.name +'" />';
		sHtml += '</div>';

		return sHtml;						
	}
	
	//**************************************
	// function  : fn_UploadImage(이미지 등록 - base64 버전) 
	// paramater : event, file
	// result   : N/A
	//**************************************
//	function fn_UploadImage(data) {
//		var result;
//		var sendData = new Object();
//		sendData["na_bzplc"] = localStorage.getItem("nhlvaca_na_bzplc");
//		sendData["auc_dt"] = fn_dateToData($("#auc_dt").val());
//		sendData["auc_obj_dsc"] = $("#auc_obj_dsc").val()
//		sendData["oslp_no"] = fn_isNull(data.rtnData) ? $("#oslp_no").val() : data.rtnData;
//		sendData["led_sqno"] = "1";
//		sendData["sra_indv_amnno"] = "410" + $("#sra_indv_amnno").val();
//		
//		var files = [];
//// 		var fileList = $(".fileDiv").siblings("img");
//		var fileList = $(".fileDiv img")
//		$(fileList).each(function(){
//			var src = $(this).attr("src");
//// 			if (src.indexOf("base64") < 0) {
//// 				files.push(getBase64Image($(this)[0]));
//// 			} else {
//				files.push(src);
//// 			}
//		});
//		
//		sendData["files"] = files;
//		
//		var results = sendAjax(sendData, "/LALM0215_insImgPgm", "POST")
//		if(results.status != RETURN_SUCCESS){
//            showErrorMessage(results);
//            return false;
//        }else{      
//			return true;
//        }
//	}
	
	//**************************************
	// function  : fn_UploadImage(이미지 등록 - multipart버전) 
	// paramater : event, file
	// result   : N/A
	//**************************************
//	function fn_UploadImage(data) {
//		var result = false;
//		
//		const dataTransfer = new DataTransfer();
//		let trans = $("#uploadImg")[0].files;
//		let fileArray = Array.from(trans);
//		
//		var fileList = $(".fileDiv img");
//		$(fileList).each(function(){
//			var src = $(this).attr("src");
//			var fileNm = $(this).attr("data-file");
//			dataTransfer.items.add(dataURLtoFile(src, fileNm));
//		});
//		
//		$("#uploadImg")[0].files = dataTransfer.files;
//		
//		// formData 만들기
//		var formData = new FormData($("#frm_img")[0]);
//		
//		formData.append("na_bzplc", localStorage.getItem("nhlvaca_na_bzplc"));
//		formData.append("auc_dt", fn_dateToData($("#auc_dt").val()));
//		formData.append("auc_obj_dsc", $("#auc_obj_dsc").val());
//		formData.append("oslp_no", fn_isNull(data.rtnData) ? $("#oslp_no").val() : data.rtnData);
//		formData.append("led_sqno", "1");
//		formData.append("sra_indv_amnno", "410" + $("#sra_indv_amnno").val());
//		
//		Array.from($("#uploadImg")[0].files).map((e, i) => formData.append('file_'+i, e));
//		
//		$.ajax({
//            url: "/LALM0215_insImgPgm",
//            type: "POST",
//            enctype:"multipart/form-data",
//            processData:false,
//            contentType:false,
//            data: formData,
//            async: false,
//            headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
//            success:function(data) {    
//            	result = true;            
//            },
//            error:function(response){            
//				showErrorMessage(JSON.parse(response.responseText));
//				result = false;
//            }
//        }); 
//        return result;
//	}

	//**************************************
	// function  : fn_UploadImage(이미지 등록 - script버전) 
	// paramater : event, file
	// result   : N/A
	//**************************************
	function fn_UploadImage(data) {
		var result = true;
//		
//		var sendData = new Object();
//		sendData["na_bzplc"] = localStorage.getItem("nhlvaca_na_bzplc");
//		sendData["auc_dt"] = fn_dateToData($("#auc_dt").val());
//		sendData["auc_obj_dsc"] = $("#auc_obj_dsc").val()
//		sendData["oslp_no"] = fn_isNull(data.rtnData) ? $("#oslp_no").val() : data.rtnData;
//		sendData["led_sqno"] = "1";
//		sendData["sra_indv_amnno"] = "410" + $("#sra_indv_amnno").val();
//		
//		var uploadList = [];
//		
//		var upload = (async () => {
//		var fileList = $(".fileDiv img");
//			$(fileList).each(function(){
//				// 파일 파라메터 처리
//				var objectPath = [localStorage.getItem("nhlvaca_na_bzplc"), "410" + $("#sra_indv_amnno").val()];
//				var folderName = objectPath.join("/");
//				var fileDataUrl = $(this).attr("src");
//				var fileNm = $(this).attr("data-file");
//				var fileName = self.crypto.randomUUID();
//				var objectName = folderName + "/" + fileName + ".png";
//				
//				// upload file
//				await S3.putObject({Bucket: bucket_name, Key: objectName,ACL: 'public-read',// ACL을 지우면 전체 공개되지 않습니다.
//									Body: dataURLtoBlob(fileDataUrl)
//				})
//				.promise()
//				.then(() => {
//					var thumbnail = thumbNode.find("div." + name).find("canvas")[0].toDataURL("image/png");
//					var thumbObjectName = folderName + "/thumb/" + fileName + ".png";
//						S3.putObject({Bucket: bucket_name, Key: thumbObjectName, ACL: 'public-read',// ACL을 지우면 전체 공개되지 않습니다.
//									Body: dataURLtoBlob(thumbnail)
//					}).promise();
//				})
//				.then(()=>{
//					console.log("upload success");
//					var obj = new Object();
//					obj["filePath"] = folderName + "/";
//					obj["fileNm"] = fileName;
//					obj["fileExtNm"] = ".png"
//					uploadList.push(obj);
//				});
//			});
//		})();
//		
//		sendData["uploadList"] = uploadList
//		
//		upload.then(()=>{
//			$.ajax({
//	            url: "/LALM0215_insImgPgm",
//	            type: "POST",
//	            enctype:"multipart/form-data",
//	            processData:false,
//	            contentType:false,
//	            data: sendData,
//	            async: false,
//	            headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
//	            success:function(data) {    
//	            	result = true;            
//	            },
//	            error:function(response){            
//					showErrorMessage(JSON.parse(response.responseText));
//					result = false;
//	            }
//	        }); 
//		});
		
        return result;
	}
	
	function dataURLtoFile(dataurl, filename) {
		var arr = dataurl.split(','),
					mime = arr[0].match(/:(.*?);/)[1],
					bstr = atob(arr[1]),
					n = bstr.length
					u8arr = new Uint8Array(n);
					
		while(n--){
			u8arr[n] = bstr.charCodeAt(n);
		}
		
		return new File([u8arr], filename, {type:mime});
	}
	
	function getBase64Image(img) {
		  img.crossOrigin = 'anonymous';
// 		  img.crossOrigin = 'use-credentials';
		  var canvas = document.createElement("canvas");
		  canvas.width = img.width;
		  canvas.height = img.height;
		  var ctx = canvas.getContext("2d");
		  ctx.drawImage(img, 0, 0, img.width, img.height);
		  
		  $("#uploadImg").append(canvas);
		  
		  return canvas.toDataURL("image/png", 1);
	}
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
        
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateMhFeeGrid(data){
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                   1        2             3        4            5                   6             7        8            9            10        11       12          13            14 */
        var searchResultColNames = ["경매대상구분", "적용일자", "수수료코드/명", "수수료명", "분계업무구분", "축산경제통합수수료코드", "수수료적용대상", "적용방식", "조합원수수료", "비조합원수수료", "가감구분", "낙찰구분", "번식우구분", "축산거래수수료"];        
        var searchResultColModel = [						         	
                                     {name:"AUC_OBJ_DSC",		index:"AUC_OBJ_DSC",		width:15, align:'center'},                                     
                                     {name:"APL_DT",			index:"APL_DT",				width:15, align:'center'},
                                     {name:"NA_FEE_C",			index:"NA_FEE_C",			width:15, align:'center'},
                                     {name:"SRA_FEENM",			index:"SRA_FEENM",			width:15, align:'center'},
                                     {name:"JNLZ_BSN_DSC",		index:"JNLZ_BSN_DSC",		width:15, align:'center'},
                                     {name:"SRA_NA_FEE_C",		index:"SRA_NA_FEE_C",		width:15, align:'center'},
                                     {name:"FEE_APL_OBJ_C",		index:"FEE_APL_OBJ_C",		width:15, align:'center'},
                                     {name:"AM_RTO_DSC",		index:"AM_RTO_DSC",			width:15, align:'center'},
                                     {name:"MACO_FEE_UPR",		index:"MACO_FEE_UPR",		width:15, align:'center'},
                                     {name:"NMACO_FEE_UPR",		index:"NMACO_FEE_UPR",		width:15, align:'center'},
                                     {name:"ANS_DSC",			index:"ANS_DSC",			width:15, align:'center'},
                                     {name:"SBID_YN",			index:"SBID_YN",			width:15, align:'center'},
                                     {name:"PPGCOW_FEE_DSC",	index:"PPGCOW_FEE_DSC",		width:15, align:'center'},
                                     {name:"SRA_TR_FEE",		index:"SRA_TR_FEE",    		width:15, align:'center'}
                                    ];
            
        $("#mhFeeGrid").jqGrid("GridUnload");
                
        $("#mhFeeGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      220,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 1,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                return;
           },
        });
        
        $("#mhFeeGrid").jqGrid("setLabel", "rn","No");
        
    }
    
  	//그리드 생성
    function fn_CreateAucQcnGrid(data){
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                       1              2         3      4           5            6              7        8          9 */
        var searchResultColNames = ["경제통합사업장코드", "경매대상구분코드", "경매일자", "차수", "기초한도금액", "절사단위금액", "단수처리구분코드", "마감여부", "삭제여부"];        
        var searchResultColModel = [						 
        							 {name:"NA_BZPLC",       	index:"NA_BZPLC",       width:15, align:'center'},        	
                                     {name:"AUC_OBJ_DSC",		index:"AUC_OBJ_DSC",	width:15, align:'center'},                                     
                                     {name:"AUC_DT",			index:"AUC_DT",			width:15, align:'center'},
                                     {name:"QCN",        		index:"QCN",        	width:15, align:'center'},
                                     {name:"BASE_LMT_AM",       index:"BASE_LMT_AM",    width:15, align:'center'},
                                     {name:"CUT_AM",        	index:"CUT_AM",        	width:15, align:'center'},
                                     {name:"SGNO_PRC_DSC",		index:"SGNO_PRC_DSC",	width:20, align:'center'},
                                     {name:"DDL_YN",       		index:"DDL_YN",      	width:20, align:'center'},
                                     {name:"DEL_YN",			index:"DEL_YN",    		width:15, align:'center'}
                                    ];
            
        $("#aucQcnGrid").jqGrid("GridUnload");
                
        $("#aucQcnGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      220,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 1,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                return;
           },
        });
        
        $("#aucQcnGrid").jqGrid("setLabel", "rn","No");
        
    }
  	
  	// TAB2 송아지 그리드 생성
    function fn_CreateCalfGrid(data){              
    	var v_before_BIRTH;
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                        1    2   3       4         5         6              8         9        10          11              12        13        14          15     16 */
        var searchResultColNames = ["", "송아지귀표번호", "", "", "개체성별", "생년월일", "KPN번호", "경매대상구분코드", "경매일자", "원표번호", "등록일련번호", "축산축종구분코드", "전송여부", "삭제여부", "어미귀표번호", "중량"];        
        var searchResultColModel = [ 						 
        							 {name:"_STATUS_",           	index:"_STATUS_",           	width:10,   align:'center'},
        							 {name:"SRA_INDV_AMNNO",		index:"SRA_INDV_AMNNO",			width:150,  align:'center', editable:true},
        							 {name:"POPSCH",                index:"POPSCH",                 width:15,   align:'center', sortable: false, formatter :fn_GridCboxFormat },
        							 {name:"POPSCH2",               index:"POPSCH2",                width:50,   align:'center', sortable: false, formatter :fn_GridCboxFormat2},
        							 {name:"INDV_SEX_C",     		index:"INDV_SEX_C",     		width:150,  align:'center', editable:true, edittype:"select", formatter:"select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"BIRTH",            		index:"BIRTH",            		width:150,  align:'center', editable:true, formatter:'gridDateFormat',
                                         editoptions:{
                                             dataInit:function(e){$(e).datepicker({
                                                 onSelect:function(text,obj){
                                                     var v_selrow = $("#calfGrid").getGridParam('selrow');
                                                     var v_VACN_DT = $(this).val();   
                                                     $("#calfGrid").jqGrid("saveCell", v_selrow, fn_GridColByName('calfGrid','BIRTH'));
                                                     fn_setGridStatus('calfGrid',v_selrow, v_before_BIRTH , v_VACN_DT);
                                                 }
                                             }).addClass('date');},
                                             maxlength:"10",
                                             dataEvents:[
                                             {type:'keyup',fn:function(e){
                                                 var v_selrow = $("#calfGrid").getGridParam('selrow');
                                                 var v_VACN_DT = $(this).val();   
                                                 if(fn_isDate(v_VACN_DT)){
                                                     $("#calfGrid").jqGrid("saveCell", v_selrow, fn_GridColByName('calfGrid','VACN_DT'));                                                        
                                                 }
                                                 fn_setGridStatus('calfGrid',v_selrow, v_before_BIRTH , v_VACN_DT);
                                             }}]
                                         }
                                  	 },
                                     {name:"KPN_NO",				index:"KPN_NO",					width:150, align:'center', editable:true,
                                    	 editoptions:{
                                             maxlength:"9",
                                          }
                                     },
                                     {name:"AUC_OBJ_DSC",    		index:"AUC_OBJ_DSC",    		width:150, align:'center', hidden:true},
                                     {name:"AUC_DT",    			index:"AUC_DT",     			width:150, align:'center', hidden:true},
                                     {name:"OSLP_NO",    			index:"OSLP_NO",     			width:150, align:'center', hidden:true},
                                     {name:"RG_SQNO",    			index:"RG_SQNO",     			width:150, align:'center', hidden:true},
                                     {name:"SRA_SRS_DSC",    		index:"SRA_SRS_DSC",    		width:150, align:'center', hidden:true},
                                     {name:"TMS_YN",    			index:"TMS_YN",     			width:150, align:'center', hidden:true},
                                     {name:"DEL_YN",    			index:"DEL_YN",     			width:150, align:'center', hidden:true},
                                     {name:"MCOW_SRA_INDV_AMNNO",   index:"MCOW_SRA_INDV_AMNNO",	width:150, align:'center', hidden:true},
                                     {name:"COW_SOG_WT",    		index:"COW_SOG_WT",     		width:150, align:'right', editable:true}
                                    ];
            
        $("#calfGrid").jqGrid("GridUnload");
                
        $("#calfGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            cellEdit:    true,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            cellsubmit:  "clientArray",
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  
                
                if(cellname == 'BIRTH') {
                	v_before_BIRTH = value;
                } else {
                	$("#"+rowid+"_"+cellname).on('blur',function(e){
                		$("#calfGrid").jqGrid("saveCell", iRow, iCol);
                		
                		if($("#calfGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                            return;
                        } else {
                            if($(this).val() != value){
                                $("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                            }
                        }
                	}).on('keydown',function(e){
                		var code = e.keyCode || e.which;
                        if(code == 13){
                        	e.preventDefault();
                        	
                        	if(cellname == 'SRA_INDV_AMNNO') {
                        		fn_popSearch(rowid, cellname);
                        	} else {
                        		$("#calfGrid").jqGrid("saveCell", iRow, iCol);
                                
                                if($("#calfGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                                    return;
                                } else {
                                    if($(this).val() != value){
                                        $("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                                    }
                                }
                        	}
                        }                        
                    });
                }                    
                                 
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        
    }
  
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
 	//function  : fn_CallFtsnmPopup(출하주 팝업 호출) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_CallFtsnmPopup(p_param) {
 		var checkBoolean = p_param;
 		var data = new Object();
 		data['ftsnm'] = $("#ftsnm").val();
 		if(!p_param) {
 			data = null;
 		}
        
        
        fn_CallFtsnm0127Popup(data,checkBoolean,function(result) {
        	if(result){
        		$("#fhs_id_no").val(result.FHS_ID_NO);
        		$("#farm_amnno").val(result.FARM_AMNNO);
        		$("#ftsnm").val(fn_xxsDecode(result.FTSNM));
        		
        		if(!fn_isNull(result.CUS_MPNO)) {
                	$("#ohse_telno").val(result.CUS_MPNO);
                } else {
                	$("#ohse_telno").val(result.OHSE_TELNO);
                }
        		
        		if(!fn_isNull(result.ZIP)) {
        			$("#zip").val(result.ZIP.substr(0, 3) + "-" + result.ZIP.substr(3, 3));
        		}
        		
        		$("#dongup").val(fn_xxsDecode(result.DONGUP));
        		$("#dongbw").val(fn_xxsDecode(result.DONGBW));
        		$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
        		$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));

        		if(result.SRA_FED_SPY_YN == 1) {
        			fn_contrChBox(true, "sra_fed_spy_yn");
        		} else {
        			fn_contrChBox(false, "sra_fed_spy_yn");
        		}

                if (fn_isNull($("#sogmn").val)) {
                    $("#sog_na_trpl_c").val(result.NA_TRPL_C);
                }
                
                $("#io_sogmn_maco_yn").val(result.MACO_YN);
                $("#sra_farm_acno").val(result.SRA_FARM_ACNO);
                
                if(!fn_isNull($("#fhs_id_no").val()) && !fn_isNull($("#indv_sex_c").val()) && !fn_isNull($("#birth").val())) {
	                if(App_na_bzplc == '8808990687094'){
	    				$("#ftsnm").focus();
	       			}else {
		        		$("#vacn_dt").focus();
	       			}
            	} else if(!fn_isNull($("#fhs_id_no").val()) && fn_isNull($("#indv_sex_c").val()) && fn_isNull($("#birth").val())) {
            		$("#indv_sex_c").val("0");
            		//$("#indv_sex_c").focus();
            	}
                fn_FtsnmModify();
             	$('#ftsnm').blur();
             } else {
            	 $("#fhs_id_no").val("");
         		 $("#farm_amnno").val("");
         		 $("#ftsnm").val("");
         		 $("#ohse_telno").val("");
         		 $("#zip").val("");
         		 $("#dongup").val("");
         		 $("#dongbw").val("");
         		 $("#sra_pdmnm").val("");
         		 $("#sra_pd_rgnnm").val("");
         		 fn_contrChBox(false, "sra_fed_spy_yn");
                 $("#sog_na_trpl_c").val("");
                 $("#io_sogmn_maco_yn").val("");
                 $("#sra_farm_acno").val("");
                 
                 if(!fn_isNull($("#fhs_id_no").val()) && !fn_isNull($("#indv_sex_c").val()) && !fn_isNull($("#birth").val())) {
	                if(App_na_bzplc == '8808990687094'){
	    				$("#ftsnm").focus();
	       			}else {
		        		$("#vacn_dt").focus();
	       			}
             	 } else if(!fn_isNull($("#fhs_id_no").val()) && fn_isNull($("#indv_sex_c").val()) && fn_isNull($("#birth").val())) {
             		$("#indv_sex_c").val("0");
             		//$("#indv_sex_c").focus();
             	 }
             	 $('#ftsnm').blur();
             }
         });
 	}
	
  	//**************************************
 	//function  : fn_CallIndvInfSrch(개체정보검색 전 셋팅) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
	function fn_CallIndvInfSrch() {
		var P_sra_indv_amnno = "";
		
 		if($("#sra_indv_amnno").val().replace("-", "").length == 12) {
        	P_sra_indv_amnno = $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
        	$("#re_indv_no").val($("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", ""));
        			   
        	var resultsTmpIndv = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selTmpIndvAmnnoPgm", "POST");   
        	var resultTmpIndv;
        	
            if(resultsTmpIndv.status == RETURN_SUCCESS) {
            	resultTmpIndv = setDecrypt(resultsTmpIndv);
            	
            	if(resultTmpIndv.length == 1) {
            		fn_CallIndvInfSrchPopup(true, P_sra_indv_amnno);
            	}
            } else {
            	var cheackParam = $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
	           	if(cheackParam.length == 15) {
	           		// 개체 인터페이스 호출
	           		fn_popInfHstPopup(true);
	           		
	        		if(fn_isNull($("#sra_indv_amnno").val())) {
	        			MessagePopup('OK','등록된개체가 없습니다 중간의 개체정보를 입력하여 저장해주세요.');
	        			$("#rg_dsc").val("09");
	        			$("#mcow_dsc").val("09");
	        			// 정합성체크 해제
	                    // ★함평: 8808990656601
	        			if (App_na_bzplc == "8808990656601") {
	                        $("#matime").val("1");
	                        $("#sra_indv_pasg_qcn").val("1");
	                    }
	        		}
	           	}
            }
            
        } else {
        	P_sra_indv_amnno = $("#sra_indv_amnno").val().replace("-", "");
        	$("#re_indv_no").val($("#sra_indv_amnno").val().replace("-", ""));
        	fn_CallIndvInfSrchPopup(true, P_sra_indv_amnno);
		}
	}
	
	//**************************************
 	//function  : fn_CallIndvInfSrchPopup(개체정보검색팝업 호출) 
 	//paramater : p_param(true, false), P_sra_indv_amnno(sra_indv_amnno Value)
 	// result   : N/A
 	//**************************************
	function fn_CallIndvInfSrchPopup(p_param, P_sra_indv_amnno) {
		var checkBoolean = p_param;
 		var data = new Object();
 		
 		if(!p_param) {
 			data = null;
 		} else {
 			data['sra_indv_amnno'] = P_sra_indv_amnno;
 		}
 		
 		fn_CallMmIndvPopup(data,p_param,function(result) {
        	if(result) {
        		$("#sra_srs_dsc").val(result.SRA_SRS_DSC);
                $("#sra_indv_amnno").val(result.SRA_INDV_AMNNO.substr(3, 12));
                $("#fhs_id_no").val(result.FHS_ID_NO);
                $("#farm_amnno").val(result.FARM_AMNNO);
                $("#ftsnm").val(fn_xxsDecode(result.FTSNM));
                
                if(!fn_isNull(result.CUS_MPNO)) {
                	$("#ohse_telno").val(result.CUS_MPNO);
                } else {
                	$("#ohse_telno").val(result.OHSE_TELNO);
                }
                
                if(!fn_isNull(result.ZIP)) {
           			$("#zip").val(result.ZIP.substr(0, 3) + "-" + result.ZIP.substr(3, 3));
           		}
                
                $("#dongup").val(fn_xxsDecode(result.DONGUP));
                $("#dongbw").val(fn_xxsDecode(result.DONGBW));
                $("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
                $("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
                $("#sog_na_trpl_c").val(result.NA_TRPL_C);
                $("#indv_sex_c").val(result.INDV_SEX_C);
                $("#birth").val(fn_toDate(result.BIRTH));
                $("#indv_id_no").val(result.INDV_ID_NO);
                $("#sra_indv_brdsra_rg_no").val(result.SRA_INDV_BRDSRA_RG_NO);
                $("#rg_dsc").val(result.RG_DSC);
                $("#kpn_no").val(result.KPN_NO);
                $("#mcow_dsc").val(result.MCOW_DSC);
                $("#mcow_sra_indv_amnno").val(result.MCOW_SRA_INDV_AMNNO);
                $("#matime").val(result.MATIME);
                $("#sra_indv_pasg_qcn").val(result.SRA_INDV_PASG_QCN);
                $("#io_sogmn_maco_yn").val(result.MACO_YN);
                $("#sra_farm_acno").val(result.SRA_FARM_ACNO);
                if(result.SRA_FED_SPY_YN == 1) {
                	fn_contrChBox(true, "sra_fed_spy_yn");
                } else {
                	fn_contrChBox(false, "sra_fed_spy_yn");
                }
                
                fn_CallIndvInfSrchSet();
                
                fn_FtsnmModify();
             }
        });
 	}
	
	//**************************************
 	//function  : fn_CallIndvInfSrchSet(개체정보검색 팝업 후 세팅) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
 	function fn_CallIndvInfSrchSet() {
 		var resultsFhsIdNo = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selFhsIdNo", "POST");        
        var resultFhsIdNo;
        
        if(resultsFhsIdNo.status == RETURN_SUCCESS) {
        	resultFhsIdNo = setDecrypt(resultsFhsIdNo);
        	if(resultFhsIdNo.length == 1) {
        		
        		$("#fhs_id_no").val(resultFhsIdNo[0]["FHS_ID_NO"]);
                $("#farm_amnno").val(resultFhsIdNo[0]["FARM_AMNNO"]);
                $("#ftsnm").val(fn_xxsDecode(resultFhsIdNo[0]["FTSNM"]));
                
                if(!fn_isNull(resultFhsIdNo[0]["CUS_MPNO"])) {
                	$("#ohse_telno").val(resultFhsIdNo[0]["CUS_MPNO"]);
                } else {
                	$("#ohse_telno").val(resultFhsIdNo[0]["OHSE_TELNO"]);
                }
                
                if(!fn_isNull(resultFhsIdNo[0]["ZIP"])) {
           			$("#zip").val(resultFhsIdNo[0]["ZIP"]);
           		}
                
                $("#dongup").val(fn_xxsDecode(resultFhsIdNo[0]["DONGUP"]));
                $("#dongbw").val(fn_xxsDecode(resultFhsIdNo[0]["DONGBW"]));
                $("#sra_pdmnm").val(fn_xxsDecode(resultFhsIdNo[0]["FTSNM"]));
                $("#sra_pd_rgnnm").val(fn_xxsDecode(resultFhsIdNo[0]["DONGUP"]));
                $("#sog_na_trpl_c").val(resultFhsIdNo[0]["NA_TRPL_C"]);
                $("#sra_farm_acno").val(resultFhsIdNo[0]["SRA_FARM_ACNO"]);
                
                if(fn_isNull($("#fhs_id_no").val())) {
                	$("#ftsnm").focus();
                } else {
                	// SetFocus ★제주: 8808990656618
                	if(App_na_bzplc == "8808990656618") {
                        $("#lows_sbid_lmt_am_ex").focus();
                    }else if(App_na_bzplc == '8808990687094'){
    					$("#ftsnm").focus();
       				} else {
                    	$("#vacn_dt").focus();
                    }
                }
                
             	// 청도축협  수수료미적용 체크시 따로 미적용 체크와 생산자 변경을 하지 않고 입력하도록
                // ★청도: 8808990656571
             	if(App_na_bzplc == "8808990656571") {
             		if($("#chk_continue").is(":checked")) {
             			var resultsSelTmpFhsNm = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selTmpFhsNm", "POST");        
             	        var resultSelTmpFhsNm;
             	        
             	        if(resultsSelTmpFhsNm.status == RETURN_SUCCESS) {
             	        	resultSelTmpFhsNm = setDecrypt(resultsSelTmpFhsNm);
             	           if(resultSelTmpFhsNm.length == 1) {
             	        	  $("#sra_pdmnm").val(resultSelTmpFhsNm[0]["FTSNM"]);
             	        	  $("#sogmn_c").val(resultSelTmpFhsNm[0]["FHS_ID_NO"]);
             	        	  fn_contrChBox(true, "fee_chk_yn", "");
             	        	  $("#fee_chk_yn_fee").val("0");
             	           }
             	        }else {
             	            showErrorMessage(resultsSelTmpFhsNm);
             	            return;
             	        }
             		}
                }
                
             	mv_InitBoolean = false;
                
             	// 테스트 : 8808990643625 상주 : 8808990657639
                if(App_na_bzplc == "8808990657639") {
                	fn_CallFtsnmPopup(true);
                }
                fn_FtsnmModify();
        	}
        } else {
        	if(!fn_isNull($("#fhs_id_no").val())) {
            	// SetFocus ★제주: 8808990656618
            	if(App_na_bzplc == "8808990656618") {
                    $("#lows_sbid_lmt_am_ex").focus();
                }else if(App_na_bzplc == '8808990687094'){
    				$("#ftsnm").focus();
       			}else {
	        		$("#vacn_dt").focus();
       			}
            } else {
            	$("#ftsnm").focus();
            }
            	
         	// 청도축협  수수료미적용 체크시 따로 미적용 체크와 생산자 변경을 하지 않고 입력하도록
            // ★청도: 8808990656571
         	if(App_na_bzplc == "8808990656571") {
         		if($("#chk_continue").is(":checked")) {
         			var resultsSelTmpFhsNm = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selTmpFhsNm", "POST");        
         	        var resultSelTmpFhsNm;
         	        
         	        if(resultsSelTmpFhsNm.status == RETURN_SUCCESS) {
         	        	resultSelTmpFhsNm = setDecrypt(resultsSelTmpFhsNm);
         	           if(resultSelTmpFhsNm.length == 1) {
         	        	  $("#sra_pdmnm").val(resultSelTmpFhsNm[0]["FTSNM"]);
         	        	  $("#sogmn_c").val(resultSelTmpFhsNm[0]["FHS_ID_NO"]);
         	        	  fn_contrChBox(true, "fee_chk_yn", "");
         	        	  $("#fee_chk_yn_fee").val("0");
         	           }
         	        }else {
                        showErrorMessage(resultsSelTmpFhsNm);
                        return;
                    }
         		}
            }
            
         	mv_InitBoolean = false;
            
         	// 테스트 : 8808990643625 상주 : 8808990657639
            if(App_na_bzplc == "8808990657639") {
            	fn_CallFtsnmPopup(true);
            }
        }
        
        fn_IndvInfSync();
        
 	}
    
    //**************************************
 	//function  : fn_CallMmFhsPopup(생산자 팝업) 
 	//paramater : p_param(object), p_flg(단건 리턴여부)
 	// result   : N/A
 	//**************************************
	function fn_CallMmFhsPopup(p_param,p_flg,callback){
		var pgid = 'LALM0215P';
		var menu_id = $("#menu_info").attr("menu_id");
		
		if(p_flg){
			var result;
			var resultData = sendAjax(p_param, "/LALM0215P_selList", "POST");
			    
			if(resultData.status != RETURN_SUCCESS){
				showErrorMessage(resultData,'NOTFOUND');
			} else {      
				result = setDecrypt(resultData);
			}
			
			if(result != null && result.length == 1){
				callback(result[0]);
			} else {
				parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
					callback(result);
				});
			}
		} else {
			parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
				callback(result);
			});
		}
	}
 	
 	function fn_IndvInfSync(){        		
		// 브루셀라검사 조회
	    fn_CallBrclIspSrch();
		// 친자확인 조회
		fn_CallLsPtntInfSrch();
		//유전체 분석 조회
		fn_CallGeneBredrInfSrch();
		//어미귀표번호가 존재할 시 어미유전체 조회
		if(!fn_isNull($("#mcow_sra_indv_amnno").val())){
	    	fn_CallGeneBredrInfSrch($("#mcow_sra_indv_amnno").val());
	    }
	    fn_SelBhCross();
		//종축개량 데이터 연동
		fn_CallAiakInfoSync();
		if((arrNaBzplc.includes(App_na_bzplc)) && !fn_isNull($("#mcow_sra_indv_amnno").val())){
			fn_CallAiakInfoSync($("#mcow_sra_indv_amnno").val());
		}
 	}
 	
	function fn_SelBhCross() {
		if ($("#auc_obj_dsc").val() != "3") return;												// 번식우가 아닌 경우
		if ($("#ppgcow_fee_dsc").val() != "1" && $("#ppgcow_fee_dsc").val() != "3") return;		// 임신우, 임신우+송아지가 아닌 경우
		
		var srchData = new Object();
		var resultsBhCross = null;
		var resultBhCross = null;
		
		srchData["ctgrm_cd"]  = "2400";
		srchData["mcow_sra_indv_eart_no"] = $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
		resultsBhCross = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
		if(resultsBhCross.status != RETURN_SUCCESS){
			showErrorMessage(resultsBhCross,'NOTFOUND');
			return;
		}
		else {
			resultBhCross = setDecrypt(resultsBhCross);
			if (resultBhCross.length > 0) {
				console.log(resultBhCross);
				var crossSort = resultBhCross.sort(function(pre,next){return next.CRSBD_DT - pre.CRSBD_DT;});
				$('#ppgcow_fee_dsc').val('1').change();
				$('#mod_kpn_no').val($.trim(crossSort[0].SRA_KPN_NO));				
				$('#afism_mod_dt').val($.trim(crossSort[0].CRSBD_DT)).focusout().change();
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//  팝업 종료
	////////////////////////////////////////////////////////////////////////////////
    