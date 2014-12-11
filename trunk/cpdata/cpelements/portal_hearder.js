function _get_jqgrid_cloums(domid, unset_data) {
    var names = jQuery("#" + domid).jqGrid("getGridParam", "colNames");
    var models = jQuery("#" + domid).jqGrid("getGridParam", "colModel");
    var temp = new Array();
    $.each(names, function(i, name) {
        var kk = models[i].name;
        if (unset_data) {
            if (!in_array(kk, unset_data)) {
                temp[kk] = name;
            }
        } else {
            temp[kk] = name;
        }
    });
    return temp;
}
function call_jqgrid_search_filter_data(obj, append_data) {
    $.extend($(obj).jqGrid("getGridParam", "postData"), append_data);
    $(obj).jqGrid("setGridParam", {
        search: true
    }).trigger("reloadGrid", [{page: 1}]);
}
function onclick_select_radio(obj) {
    $(obj).parent().click();
}
function _set_dialog_success(msg) {
    return _set_dialog_msg(msg, 'success');
}
function _set_dialog_notice(msg) {
    return _set_dialog_msg(msg, 'notice');
}
function _set_dialog_error(msg) {
    return _set_dialog_msg(msg, 'error');
}
function _set_dialog_warning(msg) {
    return _set_dialog_msg(msg, 'warning');
}
function js_location(url) {
    window.setTimeout(function() {
        window.location.href = url;
    }, 2000);
}
function _set_dialog_msg(msg, flag) {
    flag = !flag ? 'notice' : flag;
    var config = {
        notice: '<div class="alertcon"><span style="position:relative; top:9px;"><img width="32" height="32" border="0" src="portal/dialog/img/i.png"></span>&nbsp;<span>',
        error: '<div class="alertcon"><span style="position:relative; top:9px;"><img width="32" height="32" border="0" src="portal/dialog/img/fail.png"></span>&nbsp;<span>',
        warning: '<div class="alertcon"><span style="position:relative; top:9px;"><img width="32" height="32" border="0" src="portal/dialog/img/hits.png"></span>&nbsp;<span>',
        success: '<div class="alertcon"><span style="position:relative; top:9px;"><img width="32" height="32" border="0" src="portal/dialog/img/succ.png"></span>&nbsp;<span>'
    };
    return config[flag] + msg + '</span></div>';
}
function show_window(title, url, width, height, content, ___close_function___, __append_data__) {
    var dialog = art.dialog({
        title: title,
        width: width,
        height: height,
        padding: '10px 1px',
        lock: true,
        callback: ___close_function___,
        fixed: true
    });
    __append_data__ = __append_data__ ? __append_data__ : {};
    if (url && !content) {
        $.ajax({
            type: "get",
            url: url,
            async: false,
            cache: false,
            data: __append_data__,
            success: function(data) {
                dialog.content(data);
            }
        });
        return false;
    }
    if (!url && content) {
        dialog.content(content);
        return false;
    }
    if (url && content) {
        $.ajax({
            type: "get", url: url, async: false, cache: false,
            data: __append_data__,
            success: function(data) {
                dialog.content(data + content);
            }
        });
    }
}
function show_dialog_close(msg, time, ___close_function___) {
    (function(d) {
        d['okValue'] = '确定';
        d['cancelValue'] = '取消';
        d['title'] = '系统提示';
    })(art.dialog.defaults);
    var tip = '系统提示';
    time = !time ? 2000 : time;
    $(function() {
        art.dialog({
            esc: false,
            callback: ___close_function___,
            time: time,
            title: tip,
            width: 300,
            height: 25,
            content: msg,
            lock: true,
            fixed: true
        });
    });
}
function show_dialog(msg, title, w, h, ___close_function___) {
    (function(d) {
        d['okValue'] = '确定';
        d['cancelValue'] = '取消';
        d['title'] = '系统提示';
    })(art.dialog.defaults);
    var ww = w ? w : 300;
    var hh = h ? h : 25;
    var tip = '系统提示';
    var tt = title ? title : tip;
    /*         $(function(){ */
    art.dialog({
        esc: false,
        callback: ___close_function___,
        title: tt,
        width: ww,
        height: hh,
        content: msg,
        lock: true,
        fixed: true
    });
    /*         }); */
}
/*
 模拟windows的confirm 提示 支持回调方法
 show_confirm('测试信息',function(){
 alert('执行成功了');
 });
 */
function show_confirm(msg, sucess_function, title, w, h) {
    var ww = w ? w : 350;
    var hh = h ? h : 25;
    var tip = '系统提示';
    var tt = title ? title : tip;
    $(function() {
        art.dialog({
            title: tt,
            esc: false,
            lock: true,
            content: msg,
            width: ww,
            height: hh,
            fixed: true,
            button: [{
                    value: '确定',
                    callback: sucess_function
                },
                {
                    value: '取消',
                    callback: function() {

                    }
                }]
        });
    });
}

function dialogalert(msg, title, w, h) {
    return show_dialog(msg, title, w, h);
}
function _hide_button(o) {
    var url = '<samp id="adv_show_loading">执行中...</samp>';
    $(o).after(url);
    $(o).hide();
}
function _hide_button_a(o) {
    var url = '<samp id="adv_show_loading" style="display:block;">Loading...</samp>';
    $(o).after(url);
    $(o).hide();
}
function _show_button(o) {
    $("#adv_show_loading").remove();
    $(o).show();
}
function _set_border_color_over(obj) {
    $(obj).addClass('focus_filed');
}
function _set_border_color_out(obj) {
    $(obj).removeClass('focus_filed');
}
function _set_border_color() {
    $(".selectbox").hover(function() {
        $(this).addClass('focus_filed');
    }, function() {
        $(this).removeClass('focus_filed');
    });
}
;
/*设置input默认值*/
function _set_default_val(obj, lang_search_a) {
    obj.val(lang_search_a);
    var val = $(obj).val();
    $(obj).blur(function() {
        if ($(this).val() == '') {
            $(this).val(lang_search_a);
        }
    }).focus(function() {
        if ($(this).val() == lang_search_a)
            $(this).val('');
    });
}


//获取URL地址栏中的某个参数的值
function QueryString(fieldName)
{
    var urlString = document.location.search;
    if (urlString != null)
    {
        var typeQu = fieldName + "=";
        var urlEnd = urlString.indexOf(typeQu);
        if (urlEnd != -1)
        {
            var paramsUrl = urlString.substring(urlEnd + typeQu.length);
            var isEnd = paramsUrl.indexOf('&');
            if (isEnd != -1)
            {
                return paramsUrl.substring(0, isEnd);
            }
            else
            {
                return paramsUrl;
            }
        }
        else
        {
            return null;
        }
    }
    else
    {
        return null;
    }
}