/**
 * grid_common.js 정리
 * 함수의 사용여부, 사용처, 사용방법, 예제 등을 정리
 */
// 함수 선언
var btGrid = function() {};

// 크리에이트그리드 함수 / 표 생성 시작
// jsp 화면에서 btGrid.createGrid('grid1', colname, colmodel, setting) 
// 이런 형태로 전달 받는다
btGrid.createGrid = function(gid, colnm, colmdl, setting) {
    //전달받은 그리드 아이디
    var grid = $('#' + gid);
    // 페이저 아이디
    var pageDiv = $('#' + gid).next().attr('id');
    // ? 여기서 부터는 변수?
    var lastsel;
    var lastcol;
    var scrollleft = 0;
    var scrollflag = false;
    var vRowNum = 1000000000;
    var vRowList = [];
    var vScroll = 1;
    var vPgbuttons = false;
    var vShrinkToFit = false;
    var vRownumbers = true;
    var vMultiselect = false;
    var vMultiboxonly = false;
    var vMultiselectWidth = 20;
    var vSortname = 'id';
    var vSortorder = 'asc';
    var vAutowidth = true;
    var vFooterrow = false;
    var vResizeing = true;
    var vResizeHeight = 0;
    var vCellEdit = false;
    var vFrozen = false;
    var vGrouping = false;
    var vGroupingsum = false;
    var vColsetting = true;
    var vExportflg = true;
    var vSortable = true;
    var vWidth = 0;
    var vHeight = 0;
    var vPgflg = false;
    var vQueryPagingGrid = false;
    var vSearchInit = true;

    // setting 으로 받은게 있는지 검사
    if (typeof setting !== 'undefined') {
        // 페이징 처리를 할건지
        if (setting.pgflg === true) {
            // ? 한번에 조회할 로우 수가 있는지
            if (typeof setting.rowNum !== 'undefined')
                vRowNum = setting.rowNum;
            else
                vRowNum = 100;
            // ? 페이지당 보여줄 로우수가 있는지
            if (typeof setting.rowList !== 'undefined')
                vRowList = setting.rowList;
            else
                vRowList = [1, 100, 200, 300, 500, 1000];
            vScroll = false;
            vPgbuttons = true;
            vPgflg = true;
        }
        // ? 이제 settings에서 받은 값들을 조사해서
        // 있으면 세팅 해주고 없으면 위에 선언값 사용
        if (typeof setting.rowNum !== 'undefined')
            vRowNum = setting.rowNum;
        if (typeof setting.shrinkToFit !== 'undefined')
            vShrinkToFit = setting.shrinkToFit;
        if (typeof setting.rownumbers !== 'undefined')
            vRownumbers = setting.rownumbers;
        if (typeof setting.multiselect !== 'undefined')
            vMultiselect = setting.multiselect;
        if (typeof setting.multiboxonly !== 'undefined')
            vMultiboxonly = setting.multiboxonly;
        if (typeof setting.multiselectWidth !== 'undefined')
            vMultiselectWidth = setting.multiselectWidth;
        if (typeof setting.sortname !== 'undefined')
            vSortname = setting.sortname;
        if (typeof setting.sortorder !== 'undefined')
            vSortorder = setting.sortorder;
        if (typeof setting.autowidth !== 'undefined')
            vAutowidth = setting.autowidth;
        if (typeof setting.resizeing !== 'undefined')
            vResizeing = setting.resizeing;
        if (typeof setting.footerrow !== 'undefined')
            vFooterrow = setting.footerrow;
        if (typeof setting.cellEdit !== 'undefined')
            vCellEdit = setting.cellEdit;
        if (typeof setting.sortable !== 'undefined')
            vSortable = setting.sortable;
        if (typeof setting.grouping !== 'undefined')
            vGrouping = setting.grouping;
        if (typeof setting.groupingsum !== 'undefined')
            vGroupingsum = setting.groupingsum;
        if (typeof setting.colsetting !== 'undefined')
            vColsetting = setting.colsetting;
        if (typeof setting.exportflg !== 'undefined')
            vExportflg = setting.exportflg;
        if (typeof setting.width !== 'undefined')
            vWidth = setting.width;
        if (typeof setting.height !== 'undefined')
            vHeight = setting.height;
        if (typeof setting.resizeHeight !== 'undefined')
            vResizeHeight = setting.resizeHeight;
        if (typeof setting.queryPagingGrid !== 'undefined')
            vQueryPagingGrid = setting.queryPagingGrid;
        if (typeof setting.searchInit !== 'undefined')
            vSearchInit = setting.searchInit;
        if (typeof setting.frozen !== 'undefined') {
            vFrozen = setting.frozen;
            if (vFrozen === true) {
                vScroll = false;
                vSortable = false;
            }
        }
    }
    // '/' 문자 뒤 URL의 경로를 값으로 하는 DOMString입니다.
    var pathurl = $(location).attr('pathname');
    // ? 팝업 설정
    // wname에 popupname이 있으면 넣고 아니면 url
    var wname;
    var popupname = grid.parent().parent().attr('id');
    if (fn_empty(popupname) == false) {
        if (popupname.substring(0, 2) == 'p_')
            wname = popupname;
        else
            wname = pathurl;
    } else {
        wname = pathurl;
    }
    // localStorage 읽기 전용 속성을 사용하면 Document 출처의 Storage 객체에 접근할 수 있습니다.
    // 저장한 데이터는 브라우저 세션 간에 공유됩니다.
    // localStorage는 sessionStorage와 비슷하지만, localStorage의 데이터는 만료되지 않고
    // sessionStorage의 데이터는 페이지 세션이 끝날 때, 즉 페이지를 닫을 때 사라지는 점이 다릅니다.
    var v_gridinfo = JSON.parse(localStorage.getItem(wname + gid));
    var newcolname = [];
    var newcolmodel = [];
    var colidx = 0;
    // v_gridinfo에 값이 있다면
    if (fn_empty(v_gridinfo) == false) {
        // 해당주소의 그리드 생성 옵션(콜 모델)값의 name값을 key값으로 변경
        $.each(v_gridinfo, function(rkey, rval) {
            $.each(colmdl, function(key, val) {
                if (val.name == rval.COLKEY) {
                    newcolname.push(rval.COLNAME);
                    newcolmodel.push(val);
                    if (rval.COLHIDDEN == 'true')
                        newcolmodel[colidx].hidden = true;
                    else
                        newcolmodel[colidx].hidden = false;
                    newcolmodel[colidx].width = rval.COLWIDTH;
                    colidx += 1;
                }
            });
        });
    } else {
        newcolname = colnm;
        newcolmodel = colmdl;
    }
    // $("#grid1").jqGrid('something', function(){
    //     source code~~~
    // }) 형식의 정의
    grid.jqGrid({
        datatype: 'local',
        colNames: newcolname,
        colModel: newcolmodel,
        cellEdit: vCellEdit,
        cellsubmit: 'clientArray',
        editurl: 'clientArray',
        rowNum: vRowNum,
        rowList: vRowList,
        scroll: vScroll,
        pager: pageDiv,
        pginput: false,
        pgbuttons: vPgbuttons,
        gridview: true,
        autowidth: vAutowidth,
        shrinkToFit: vShrinkToFit,
        rownumbers: vRownumbers,
        multiselect: vMultiselect,
        multiboxonly: vMultiboxonly,
        multiselectWidth: vMultiselectWidth,
        loadonce: true,
        sortname: vSortname,
        sortorder: vSortorder,
        sortable: vSortable,
        viewrecords: true,
        footerrow: vFooterrow,
        userDataOnFooter: true,
        height: 'auto',
        queryPagingGrid: vQueryPagingGrid,
        autoencode : true
    });
    // 리사이즈 가능여부 확인
    if (vResizeing == true) {
        $(window).bind('resize', function(event) {
            // 하단에 작성된 메소드를 불러온다.
            btGrid.gridResizing(gid, vResizeHeight, vHeight);
        }).trigger('resize');
    } else {
        // 리사이즈 불가시엔 지정된 사이즈로 생성
        grid.setGridWidth(vWidth);
        grid.setGridHeight(vHeight);
    }
    // ? jqgrid 로드가 끝날때 페이징 처리 호출
    grid.bind('jqGridLoadComplete', function(e, data) {
        btGrid.gridpaging(grid, 2, this.p.pager, this.p.page, this.p.lastpage);
    });
    // ? jqgrid 행 삽입 후 처리
    grid.bind('jqGridAfterInsertRow', function(e, rowid) {
        lastcol = 0;
        var flg = false;
        var colmodel = grid.jqGrid('getGridParam', 'colModel');
        for (var i = 0, len = colmodel.length; i < len; i++) {
            var f = $.each(colmodel[i], function(k, v) {
                if (k == 'editable' && v == true) {
                    lastcol = i;
                    flg = true;
                }
            });
            if (flg)
                return;
        }
    });
    // ? jqgrid 행 선택후 처리
    // ? saveRow 편집중인 행을 저장처리 하고 수정할수 있게 세팅
    grid.bind('jqGridSelectRow', function(e, rowid, status) {
        if ($('#jqg_' + gid + '_' + rowid).is(':disabled')) {
            $('#jqg_' + gid + '_' + rowid).removeAttr('checked');
        }
        // ? saveRow는 edit 중인 row를 저장하고 다른행을 선택할수 있게 해준다.
        grid.jqGrid('saveRow', lastsel);
        btGrid.gridEditRow(gid, rowid);
        lastsel = rowid;
        // rowid가 빈값이 아니라면
        if (fn_empty(lastcol) == false) {
            var colmodel = grid.jqGrid('getGridParam', 'colModel');
            // 로우의 데이터를 가지고 와서 수정과 값이 있는곳에 포커스 및 선택을 한다.
            $.each(colmodel[lastcol], function(key, val) {
                if (key == 'editable' && val == true) {
                    $('td #' + rowid + '_' + colmodel[lastcol].name).focus();
                    $('td #' + rowid + '_' + colmodel[lastcol].name).select();
                    return false;
                }
            });
        }
    });
    // ? 셀 선택 이벤트 처리
    grid.bind('jqGridCellSelect', function(e, rowid, iCol, cellcontent) {
        lastcol = iCol;
    });
    // ? 그리드 전체 선택 처리 / 로우의 셀을 전체 선택인지, 로우들을 전체 선택인지 확인 필요
    grid.bind('jqGridSelectAll', function(e, aRowids, status) {
        if (status) {
            // ? 사용불가인 체크박스를 가지고 와서 체크되어 있으면 체크된 아이디를 반환
            var cbs = $('tr.jqgrow > td > input.cbox:disabled', grid[0]);
            cbs.removeAttr('checked');
            grid[0].p.selarrrow = grid.find('tr.jqgrow:has(td > input.cbox:checked)').map(function() {
                return this.id;
            }).get();
        }
    });
    // colkey 변수에 전달받은 newcolmodel의 name값을 key값으로 전환
    var colkey;
    $.each(newcolmodel, function(k, v) {
        if ((fn_empty(v.hidden) == true || v.hidden == false) && v.editable == true) {
            colkey = v.name;
        }
    });
    // 키다운 이벤트 처리
    // keycode 9는 tab을 의미
    // 현재 로우를 기준으로 다음줄이 없으면 넘어가지 않음
    grid.keydown(function(e) {
        if (e.keyCode == '9') {
            // ? 이벤트 발생 지점의 name이 저장한 컬렴명과 같으면
            if ($(e.target).attr('name') == colkey) {
                // ? 선택된 로우의 셀들의 값을 가져온다
                var selrow = grid.jqGrid('getGridParam', 'selrow');
                // ? 현재 행(tr)의 다음 아이디(행번호)를 찾는다.
                var nextrowid = grid.find('tr#' + selrow).next().attr('id');
                // ? 다음행이 있다면
                if (fn_empty(nextrowid) === false) {
                    // ? 다음행을 선택
                    grid.jqGrid('setSelection', nextrowid);
                    return false;
                }
            }
        }
    });
    // frozen은 grid 고정 옵션
    // 사용시 sort edit 등을 사용할수 없으므로 안쓰일 거라고 생각됨
    if (vFrozen == true) {
        $('.ui-jqgrid-bdiv').scroll(function(e) {
            // ? scrollLeft()라는 함수로 크르롤 생성
            // ? 기본적으로 frozen 옵션은 제거하는 것으로 판단됨
            var scrollPosition = grid.closest('.ui-jqgrid-bdiv').scrollLeft();
            if (scrollleft != scrollPosition) {
                if (scrollPosition == 0) {
                    grid.jqGrid('destroyFrozenColumns');
                    scrollflag = false;
                } else if (scrollflag == false) {
                    grid.jqGrid('destroyFrozenColumns');
                    grid.jqGrid('setFrozenColumns');
                    $('.ui-jqgrid-htable.ui-common-table').attr('style', 'width:1px');
                    $('.frozen-bdiv.ui-jqgrid-bdiv').css('overflow', 'hidden');
                    scrollflag = true;
                }
            }
            scrollleft = scrollPosition;
        });
    }
    // 정렬 이벤트 처리
    // 테이블 헤드(컬럼명)를 클릭하면 정렬
    if (vSortable) {
        // ? 컬럼명 영역 클릭하면 처리할 프로세스
        $('#gbox_' + gid + ' .ui-jqgrid-htable th').click(function(e) {
            // ? 그리드 전체의 로우를 저장(jqgrid상에서)하는 것으로 보임
            var flag = btGrid.gridSaveRow(gid);
            // ? 모든 로우가 saveRow 된 상태일 경우 정렬 처리
            if (flag == true) {
                var col = e.target.id;
                var colname = col.substring(col.lastIndexOf('_') + 1, col.length);
                grid.jqGrid('sortGrid', colname);
            }
        });
    }
    // ? 그리드 상단 버튼영역 처리
    // jqgrid의 사전 정의된 버튼 기능들 
    //  1) Add New Row 상단에 있음
    //  2) Edit Selected Row 미확인
    //  3) View Selected Row 미확인
    //  4) Delete Selected Row 상단에 있음
    //  5) Find Records 미확인
    //  6) Reload Grid 상단아니구 하단에 있음
    // 실제로 사용되는 부분은 약간 다르다...
    grid.jqGrid('navGrid', '#' + pageDiv, {
        add: false,
        edit: false,
        del: false,
        search: vSearchInit,
        refresh: vSearchInit
    }, {}, {}, {}, {
        multipleSearch: true
    });
    // ? 그리드 하단 버튼영역 처리
    // 코드상 title부분의 내용이 그리드 하단의 버튼과 같음
    if (vColsetting == true) {
        // 리셋 버튼 설정
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: '',
            title: 'Reset Column',
            buttonicon: 'grid_reset',
            onClickButton: function() {
                if (confirm('Want to rset the column?\n*CAUTION : Reloaded the page.') == true) {
                    localStorage.removeItem(wname + gid);
                    var sendData = {
                        'paramData': {
                            'WINDOWNAME': wname,
                            'GRIDID': gid
                        }
                    };
                    var url = '/common/delGridInfoAll.do';
                    fn_ajax(url, false, sendData, function(data, xhr) {
                        location.reload();
                    });
                }
            }
        });
        // 컬럼 수정 버튼
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: '',
            title: 'Edit Column',
            buttonicon: 'grid_edit',
            onClickButton: function() {
                grid.jqGrid('columnChooser', {
                    dialog_opts: {
                        height: 450
                    },
                    done: function(perm) {
                        if (perm) {
                            grid.jqGrid('remapColumns', perm, true);
                            var colmodel = grid.jqGrid('getGridParam', 'colModel');
                            var colNames = grid.jqGrid('getGridParam', 'colNames');
                            var saveModel = [];
                            var inx = 0;
                            for (var i = 0, len = colmodel.length; i < len; i++) {
                                if (colmodel[i].name != 'rn' && colmodel[i].name != 'cb') {
                                    saveModel.push({
                                        'WINDOWNAME': wname,
                                        'GRIDID': gid,
                                        'COLKEY': colmodel[i].name,
                                        'COLNAME': colNames[i],
                                        'COLHIDDEN': colmodel[i].hidden.toString(),
                                        'COLWIDTH': colmodel[i].width,
                                        'COLINX': inx
                                    });
                                    inx += 1;
                                }
                            }
                            var sendData = {
                                'gridinfoList': saveModel
                            };
                            var url = '/common/saveGridInfo.do';
                            fn_ajax(url, false, sendData, function(data, xhr) {
                                localStorage.setItem(wname + gid, JSON.stringify(saveModel));
                            });
                        }
                    }
                });
            }
        });
        // 컬럼 저장 버튼
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: '',
            title: 'Save Column',
            buttonicon: 'grid_save',
            onClickButton: function() {
                if (confirm('Want to save the order and size of the columns?') == true) {
                    var colmodel = grid.jqGrid('getGridParam', 'colModel');
                    var colNames = grid.jqGrid('getGridParam', 'colNames');
                    var saveModel = [];
                    var inx = 0;
                    for (var i = 0, len = colmodel.length; i < len; i++) {
                        if (colmodel[i].name != 'rn' && colmodel[i].name != 'cb') {
                            saveModel.push({
                                'WINDOWNAME': wname,
                                'GRIDID': gid,
                                'COLKEY': colmodel[i].name,
                                'COLNAME': colNames[i],
                                'COLHIDDEN': colmodel[i].hidden.toString(),
                                'COLWIDTH': colmodel[i].width,
                                'COLINX': inx
                            });
                            inx += 1;
                        }
                    }
                    var sendData = {
                        'gridinfoList': saveModel
                    };
                    var url = '/common/saveGridInfo.do';
                    fn_ajax(url, false, sendData, function(data, xhr) {
                        localStorage.setItem(wname + gid, JSON.stringify(saveModel));
                    });
                }
            }
        });
    }
    //2017.09.01 엑셀 파일명에 그리드 우측의 단위표시도 함께 포함되는 것을 막기 위해 그리드 타이틀 영역의 첫번째 Text만 가져오도록 변경 (수정자: bci) 
    //if(vExportflg===true){grid.jqGrid('navButtonAdd','#'+pageDiv,{caption:'',title:'엑셀저장',buttonicon:'gridexeclsave',onClickButton:function(){btGrid.gridSaveRow(gid);var newcolModel=[];var colModel=$('#'+gid).jqGrid('getGridParam','colModel');var colName=$('#'+gid).jqGrid('getGridParam','colNames');var gridData=$('#'+gid).jqGrid('getGridParam','data');var title=$('#'+gid).parent().parent().parent().parent().prev().children().text().replace('*','').trim();title=fn_empty(title)?'Excel':title;if(gridData.length==0){alert('검색된 데이터가 없습니다.');return false;}
    if (vExportflg === true) {
    	debugger;
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: '',
            title: 'Save Excel',
            buttonicon: 'gridexeclsave',
            onClickButton: function() {
                btGrid.gridSaveRow(gid);
                var newcolModel = [];
                var colModel = $('#' + gid).jqGrid('getGridParam', 'colModel');
                var colName = $('#' + gid).jqGrid('getGridParam', 'colNames');
                var gridData = $('#' + gid).jqGrid('getGridParam', 'data');
                var title = $('#' + gid).parent().parent().parent().parent().prev().children().first().text().replace('*', '').trim();
                title = fn_empty(title) ? 'Excel' : title;
                if (gridData.length == 0) {
                    alert('No Data Found.');
                    return false;
                }
                for (var i = 0, len = colModel.length; i < len; i++) {
                    if (colModel[i].hidden === true) {
                        continue;
                    }
                    if (colModel[i].colmenu === false) {
                        continue;
                    }
                    var rowdata = {};
                    if(colModel[i].name != 'CHK'){
	                    rowdata['label'] = colName[i];
	                    rowdata['name'] = colModel[i].name;
	                    rowdata['width'] = colModel[i].width;
	                    rowdata['align'] = fn_empty(colModel[i].align) ? 'left' : colModel[i].align;
	                    rowdata['formatter'] = fn_empty(colModel[i].formatter) ? '' : colModel[i].formatter;
                    }
                    newcolModel.push(rowdata);
                    if (colModel[i].formatter == 'select') {
                        $('#' + gid).jqGrid('setColProp', colModel[i].name, {
                            unformat: gridUnfmt
                        });
                    }
                }
                var rowNumtemp = $('#' + gid).jqGrid('getGridParam', 'rowNum');
                var scrolltemp = $('#' + gid).jqGrid('getGridParam', 'scroll');
                var pgbuttonstemp = $('#' + gid).jqGrid('getGridParam', 'pgbuttons');
                $('#' + gid).jqGrid('setGridParam', {
                    rowNum: 1000000000,
                    scroll: 1,
                    pgbuttons: false
                });
                var gridDatatemp = $('#' + gid).getRowData();
                $('#' + gid).jqGrid('setGridParam', {
                    rowNum: rowNumtemp,
                    scroll: scrolltemp,
                    pgbuttons: pgbuttonstemp
                });
                $('#' + gid).trigger('reloadGrid');
                for (vari = 0,
                len = colModel.length; i < len; i++) {
                    if (colModel[i].formatter == 'select') {
                        $('#' + gid).jqGrid('setColProp', colModel[i].name, {
                            unformat: null
                        });
                    }
                }
                var param = {
                    'colModel': newcolModel,
                    'gridData': gridDatatemp,
                    'title': title
                };
                fn_ajax('/common/saveGridExcel.do', true, param, function(data, xhr) {
                    var exceldata = base64DecToArr(data.exceldata);
                    var filename = title + '.xlsx';
                    var blob = new Blob([exceldata],{
                        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                    });
                    if (typeof window.navigator.msSaveBlob !== 'undefined') {
                        window.navigator.msSaveBlob(blob, filename);
                    } else {
                        var URL = window.URL || window.webkitURL;
                        var downloadUrl = URL.createObjectURL(blob);
                        if (filename) {
                            var a = document.createElement('a');
                            if (typeof a.download === 'undefined') {
                                window.location = downloadUrl;
                            } else {
                                a.href = downloadUrl;
                                a.download = filename;
                                document.body.appendChild(a);
                                a.click();
                            }
                        } else {
                            window.location = downloadUrl;
                        }
                        setTimeout(function() {
                            URL.revokeObjectURL(downloadUrl);
                        }, 100);
                    }
                });
            }
        });
    }
    // ? 그룹화 처리 
    if (vGrouping == true) {
        // 그룹만들기 버튼
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: 'Group',
            title: 'GROUP',
            buttonicon: 'disabled',
            onClickButton: function() {
                var colName = grid.jqGrid('getGridParam', 'colNames');
                var colModel = grid.jqGrid('getGridParam', 'colModel');
                var newcolName = [];
                var newcolModel = [];
                for (var i = 0, len = colModel.length; i < len; i++) {
                    if (fn_empty(colModel[i].hidden) == true || colModel[i].hidden == false) {
                        if (colModel[i].name != 'rn' && colModel[i].name != 'cb') {
                            newcolModel.push(colModel[i]);
                            newcolName.push(colName[i]);
                        }
                    }
                }
                var params = {
                    'colName': newcolName,
                    'colModel': newcolModel,
                    'grpsumflg': vGroupingsum,
                    'gridId': gid
                };
                framePopupOpen('/comm/p_gridgroup.do', 'p_gridgroup', params);
            }
        });
        // 그룹 해제 버튼
        grid.jqGrid('navButtonAdd', '#' + pageDiv, {
            caption: 'Ungroup',
            title: 'UNGROUP',
            buttonicon: 'disabled',
            onClickButton: function() {
                grid.jqGrid('groupingRemove');
                grid.trigger('reloadGrid');
            }
        });
    }
    // 페이징 처리 관련 로직
    if (vQueryPagingGrid || vPgflg) {
        $('#' + pageDiv).find('.ui-pg-selbox').unbind('change');
        $('#' + pageDiv).find('.ui-pg-selbox').bind('change', function(e) {
            grid[0].p.rowNum = this.value;
        });
    }
    $('span.ui-icon.disabled').remove();
}
// 첫번째는 여기서 끝

// 그리드 페이징 처리 이벤트
btGrid.gridpaging = function(grid, max_page, pager, page, lastpage) {
    // ? 하단에 쓰일 myPageRefresh 선언
    var i, myPageRefresh = function(e) {
        var newPage = $(e.target).text();
        grid.trigger("reloadGrid", [{
            page: newPage
        }]);
        e.preventDefault();
    };
    // ? 페이저 관련으로 추정
    // ? 초기설정영역 제거
    $(pager + '_center td.myPager').remove();
    // ? 이전 / 다음 영역 선언
    var pagerPrevTD = $('<td>', {
        class: "myPager"
    })
    // ? 이전페이지 관련 변수 초기화
      , prevPagesIncluded = 0
      , pagerNextTD = $('<td>', {
        class: "myPager"
    })
    // ? 다음페이지 관련 변수 초기화
      , nextPagesIncluded = 0
      // ? 시작페이지를 지정하는 방식으로 추정
      , totalStyle = grid[0].p.pginput === false
      , startIndex = totalStyle ? page - max_page * 2 + 2 : page - max_page;
    for (i = startIndex; i <= lastpage && (totalStyle ? (prevPagesIncluded + nextPagesIncluded < max_page * 2 + 1) : (nextPagesIncluded < max_page)); i++) {
        if (i <= 0) {
            continue;
        }
        var link = $('<a>', {
            href: '#',
            click: myPageRefresh
        });
        link.text(String(i));
        if (i < page || totalStyle) {
            if (i === page) {
                var linkN = '<span style="font-weight:bold; color:blue;">' + i + '</span>';
                if (prevPagesIncluded > 0) {
                    pagerPrevTD.append('<span>&nbsp;&nbsp;</span>');
                }
                pagerPrevTD.append(linkN);
                prevPagesIncluded++;
            } else {
                if (prevPagesIncluded > 0) {
                    pagerPrevTD.append('<span>&nbsp;&nbsp;</span>');
                }
                pagerPrevTD.append(link);
                prevPagesIncluded++;
            }
        } else {
            if (nextPagesIncluded > 0 || (totalStyle && prevPagesIncluded > 0)) {
                pagerNextTD.append('<span>&nbsp;&nbsp;</span>');
            }
            pagerNextTD.append(link);
            nextPagesIncluded++;
        }
    }
    if (prevPagesIncluded > 0) {
        $(grid[0].p.pager + '_center td[id^="prev"]').after(pagerPrevTD);
    }
    if (nextPagesIncluded > 0) {
        $(grid[0].p.pager + '_center td[id^="next"]').before(pagerNextTD);
    }
}
// 쿼리 페이징
btGrid.gridQueryPaging = function(grid, searchFnName, gridData) {
    var rowsPerPage = $(grid[0].p.pager).find('.ui-pg-selbox').val();
    var totalRec = 0;
    var lastpage = 0;
    var page = 1;
    if (gridData.length > 0) {
        totalRec = gridData[0].TOTAL_COUNT;
        page = gridData[0].CURRENT_PAGE;
        lastpage = Math.ceil(gridData[0].TOTAL_COUNT / rowsPerPage);
    }
    var i, myPageRefresh = function(e) {
        var newPage = $(e.target).text();
        grid.trigger("reloadGrid", [{
            page: newPage
        }]);
        e.preventDefault();
    };
    $(grid[0].p.pager + '_center td.myPager').remove();
    var pagerPrevTD = $('<td>', {
        class: "myPager"
    })
      , prevPagesIncluded = 0
      , pagerNextTD = $('<td>', {
        class: "myPager"
    })
      , nextPagesIncluded = 0
      , totalStyle = grid[0].p.pginput === false
      , startIndex = totalStyle ? page - 2 * 2 + 2 : page - 2;
    for (i = startIndex; i <= lastpage && (totalStyle ? (prevPagesIncluded + nextPagesIncluded < 2 * 2 + 1) : (nextPagesIncluded < 2)); i++) {
        if (i <= 0) {
            continue;
        }
        var link = $('<a>', {
            href: '#',
            click: myPageRefresh
        });
        link.text(String(i));
        if (i < page || totalStyle) {
            if (i === page) {
                var linkN = '<span style="font-weight:bold; color:blue;">' + i + '</span>';
                if (prevPagesIncluded > 0) {
                    pagerPrevTD.append('<span>&nbsp;&nbsp;</span>');
                }
                pagerPrevTD.append(linkN);
                prevPagesIncluded++;
            } else {
                if (prevPagesIncluded > 0) {
                    pagerPrevTD.append('<span>&nbsp;&nbsp;</span>');
                }
                pagerPrevTD.append('<a href="javascript:void(0);" onclick="' + searchFnName + '(' + i + ');">' + i + '</a>');
                prevPagesIncluded++;
            }
        } else {
            if (nextPagesIncluded > 0 || (totalStyle && prevPagesIncluded > 0)) {
                pagerNextTD.append('<span>&nbsp;&nbsp;</span>');
            }
            pagerNextTD.append(link);
            nextPagesIncluded++;
        }
    }
    if (prevPagesIncluded > 0) {
        $(grid[0].p.pager + '_center td[id^="prev"]').after(pagerPrevTD);
        if (page !== 1) {
            $(grid[0].p.pager + '_center td[id^="first"]').removeClass('ui-state-disabled');
            $(grid[0].p.pager + '_center td[id^="first"]').find('span').attr('onClick', searchFnName + '(1);');
            $(grid[0].p.pager + '_center td[id^="prev"]').removeClass('ui-state-disabled');
            $(grid[0].p.pager + '_center td[id^="prev"]').find('span').attr('onClick', searchFnName + '(' + (page - 1) + ');');
        } else {
            $(grid[0].p.pager + '_center td[id^="first"]').find('span').removeAttr('onClick');
            $(grid[0].p.pager + '_center td[id^="prev"]').find('span').removeAttr('onClick');
        }
        if (page !== lastpage) {
            $(grid[0].p.pager + '_center td[id^="last"]').removeClass('ui-state-disabled');
            $(grid[0].p.pager + '_center td[id^="last"]').find('span').attr('onClick', searchFnName + '(' + lastpage + ');');
            $(grid[0].p.pager + '_center td[id^="next"]').removeClass('ui-state-disabled');
            $(grid[0].p.pager + '_center td[id^="next"]').find('span').attr('onClick', searchFnName + '(' + (page + 1) + ');');
        } else {
            $(grid[0].p.pager + '_center td[id^="last"]').find('span').removeAttr('onClick');
            $(grid[0].p.pager + '_center td[id^="next"]').find('span').removeAttr('onClick');
        }
    }
    if (nextPagesIncluded > 0) {
        $(grid[0].p.pager + '_center td[id^="next"]').before(pagerNextTD);
    }
    $(grid[0]).find("td.jqgrid-rownum").each(function(i, rows) {
        $(this).html(i + 1 + ((page - 1) * rowsPerPage));
    });
    $(grid[0].p.pager).find('.ui-paging-info').html('Total : ' + fn_comma(totalRec) + '');
}
// 한번에 보여줄 그리드수를 지정하는 함수
// 결과는 empty string
// 실제 사용된 부분은 btGrid.getGridRowSel('grid1_pager') 이지만 페이저를 사용하지 않아서 확인불가
// 게시판에서 확인결과 페이저가 들어가 있으므로 페이저의 한번에 볼 페이지수 관련이 맞음
btGrid.getGridRowSel = function(gridPagerID) {
    var rtnVal = $('#' + gridPagerID).find('.ui-pg-selbox').val();
    if (fn_empty(rtnVal)) {
        rtnVal = '';
    }
    return rtnVal;
}
// 그리드 사이즈를 조정하는 함수
// ? btGrid.gridResizing('partnerGrid'); 실 사용은 gridid만 입력
// ? griddiv는 console상 최상위(document)로 파악됨
btGrid.gridResizing = function(gridid, heightSize, height) {
    var griddiv = $('#' + gridid).parent().parent().parent().parent().parent();
    // ? 바디영역의 그리드를 제외한 부분들의 높이를 모두 더해서 저장
    if (heightSize === 0) {
        heightSize = $('.ct_grid_top_wrap').outerHeight(true) + $('.pop_grid_top_wrap').outerHeight(true) + griddiv.find('.ui-jqgrid-hdiv.ui-state-default.ui-corner-top').outerHeight(true) + griddiv.find('.ui-jqgrid-sdiv').outerHeight(true) + griddiv.find('.ui-jqgrid-pager.ui-state-default.ui-corner-bottom').outerHeight(true) + 3;
    }
    // ? 전체영역의 넓이에서 - 2
    $('#' + gridid).setGridWidth(griddiv.width() - 2);
    if (height == 0) {
        $('#' + gridid).setGridHeight(griddiv.height() - heightSize);
    } else {
        $('#' + gridid).setGridHeight(height);
    }
}
// ? saveRow
// 인라인 에디팅 중 다른 행으로 넘어가면
// 기존에 변경된 것이 원래대로 복원되면서 다른 행으로 이동한다(설명 : http://1004lucifer.blogspot.com/2019/05/jqgrid-inline.html)
// saveRow는 변경된 것을 저장하고 다른 행이로 이동하는 방법
// ? 이긴 한데 실제 사용된 부분에선 그냥 저장하든 수정후 저장하든 false가 나온다.
btGrid.gridSaveRow = function(gridID) {
    var flag = false;
    var ids = $('#' + gridID).jqGrid('getDataIDs');
    for (var i = 0, len = ids.length; i < len; i++) {
        var flg = $('#' + gridID).jqGrid('saveRow', ids[i]);
        if (flg === true) {
            flag = true;
        }
    }
    return flag;
}
// ? 그리드 콤보박스 포맷
// ? 사용되긴 하지만 함수형식으로 사용되지는 않고
// ? colmodel에서 formatter의 옵션으로만 사용된다.
// ? 리턴값의 html태그 사용이 목적으로 추정
function gridCboxFormat(val, options, rowdata) {
    var gid = options.gid;
    var rowid = options.rowId;
    var colkey = options.colModel.name;
    return '<input style="margin-left:1px;" type="checkbox" id="' + gid + '_' + rowid + '_' + colkey + '" ' + (val == '1' ? 'checked="checked"' : '') + 'onclick="grid_cbox_onclick(\'' + gid + '\',\'' + rowid + '\',\'' + colkey + '\')" />';
}
// ? 그리드 언 포맷
// ? 실 사용 결과 그냥 아무것도 없는 칸이 나옴
// ? 데이터가 없거나 비워두어야 하는 칸에 사용 된다고 추정
function gridUnfmt(cellvalue, options, cell) {
    return cellvalue;
}
// ? 그리드 포맷
function gridRedoFmt(cellvalue, options, cell) {
    var arrdata =options.colModel.editoptions.value.split(';');
    for(var i=0;i<arrdata.length;i++){
        var data = arrdata[i].split(':');
        if(data[1] == cellvalue) {          
            return data[0];
        }
    }
}
// ? 그리드 애드 로우
// ? 행을 추가할 그리드아이디, 추가할 위치, 더할 데이터
btGrid.gridAddRow = function(gridID, position, data) {
    // ? 그리드 아이디들(행번호)
    // ? 현재 그리드의 아이디들을 배열로 리턴 하고 데이터가 없다면 빈 배열을 리턴한다.
    var ids = $('#' + gridID).jqGrid('getDataIDs');
    var newrowid;
    // ? id가 하나라도 있다면
    if (ids.length > 0) {
        // ? 파라미터에 위치 정보를 확인
        if (position == 'first') {
            if (ids[0].indexOf('new') >= 0) {
                newrowid = 'new' + (Number(ids[0].replace('new', '')) + 1);
            } else {
                newrowid = 'new' + Number(ids.length + 1);
            }
        } else {
            if (ids[ids.length - 1].indexOf('new') >= 0) {
                newrowid = 'new' + (Number(ids[ids.length - 1].replace('new', '')) + 1);
            } else {
                newrowid = 'new' + Number(ids.length + 1);
            }
        }
        // ? 데이터가 하나도 없으면
    } else {
        newrowid = 'new' + Number(ids.length + 1);
    }
    $('#' + gridID).jqGrid('addRow', {
        'rowID': newrowid,
        'initdata': data,
        'position': position
    });
    return newrowid;
}
// ? 그리드 에디트 로우
// ? 전달받은 그리드와 선택된 행에 edit 가능하게 변경
btGrid.gridEditRow = function(gridID, selrow) {
    $('#' + gridID).jqGrid('editRow', selrow, true);
}
// ? 그리드 딜리트 로우
// ? 현재 사용하는 화면은 없고 dlframe 선택후 삭제하는 방식으로 처리
// ? 화면에 표기된 로우를 그리드상에서 삭제하는 메소드로 추정
btGrid.gridDelRow = function(gid, selrow, focusflg) {
    if (selrow != null) {
        var nextRowid = $('#' + gid).find('tr#' + selrow).next().attr('id');
        var prevRowid = $('#' + gid).find('tr#' + selrow).prev().attr('id');
        $('#' + gid).jqGrid('delRowData', selrow);
        if (fn_empty(focusflg) === true || focusflg === true) {
            if (fn_empty(nextRowid) === false) {
                $('#' + gid).jqGrid('setSelection', nextRowid);
            } else {
                if (fn_empty(prevRowid) === false) {
                    $('#' + gid).jqGrid('setSelection', prevRowid);
                }
            }
        }
    }
}
// ? 겟 그리드 데이터
// ? 플래그를 안주면 전체 행 데이터
// ? 플래그를 주면 선택된 셀 데이터를 리턴
btGrid.getGridData = function(gridID, pageflg) {
    btGrid.gridSaveRow(gridID);
    var r = $('#' + gridID).getRowData();
    if (fn_empty(pageflg) == false) {
        if (pageflg == true) {
            r = $('#' + gridID).jqGrid('getGridParam', 'data');
        }
    }
    return r;
}
// ? 64진법 -> 유닛6
// ? 사용되지 않음
// ? 유닛6는 찾지 못함
function b64ToUint6(nChr) {
    return nChr > 64 && nChr < 91 ? nChr - 65 : nChr > 96 && nChr < 123 ? nChr - 71 : nChr > 47 && nChr < 58 ? nChr + 4 : nChr === 43 ? 62 : nChr === 47 ? 63 : 0;
}
// ? 64진법 -> 배열로 전환
// ? 사용된 곳은 엑셀 저장에서 url을 넘길때 array로 변환하여 전송
// ? 실제 데이터만 매개변수로 사용되고 블록 사이즈는 지정 되지 않음
function base64DecToArr(sBase64, nBlocksSize) {
    var sB64Enc = sBase64.replace(/[^A-Za-z0-9\+\/]/g, "")
      , nInLen = sB64Enc.length
      , nOutLen = nBlocksSize ? Math.ceil((nInLen * 3 + 1 >> 2) / nBlocksSize) * nBlocksSize : nInLen * 3 + 1 >> 2
      , taBytes = new Uint8Array(nOutLen);
    for (var nMod3, nMod4, nUint24 = 0, nOutIdx = 0, nInIdx = 0; nInIdx < nInLen; nInIdx++) {
        nMod4 = nInIdx & 3;
        nUint24 |= b64ToUint6(sB64Enc.charCodeAt(nInIdx)) << 18 - 6 * nMod4;
        if (nMod4 === 3 || nInLen - nInIdx === 1) {
            for (nMod3 = 0; nMod3 < 3 && nOutIdx < nOutLen; nMod3++,
            nOutIdx++) {
                taBytes[nOutIdx] = nUint24 >>> (16 >>> nMod3 & 24) & 255;
            }
            nUint24 = 0;
        }
    }
    return taBytes;
}
// ? 리로드 그리드
// ? 그리드 새로고침
function reloadGrid(gridid, gridData) {
    clearGrid(gridid);
    $('#' + gridid).jqGrid('setGridParam', {
        data: gridData
    });
    $('#' + gridid).trigger('reloadGrid');
}
// ? 클리어 그리드
// ? 그리드 지우기
function clearGrid(gridid) {
    $('#' + gridid).jqGrid('clearGridData');
}