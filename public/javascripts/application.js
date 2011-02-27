// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function clickableLabel(){
    $("input[data-clickable=true]").each(function(){
        var label = $("label[for="+$(this).attr("id")+"]").addClass("clickable").click(function(){ $(this).toggleClass("checked")});
        if($(this).attr("checked")) label.click();
    }).css("visibility", "hidden").css("width", "1px"); //w operze nie moze byc hide()
}

function clickableLabelClear(){
    $("input[data-clickable=true]:checked").each(function(){
        $("label[for=" + $(this).attr("id") + "]").click();
        $(this).click();
    });
    return !true;
}

function sizableFieldset(){
    $("fieldset[data-sizable=true] > legend").each(function(){
        $(this).click(function(){ $(this).parent().children().not(":first").toggle("fast")});
    });//.click(); //odznaczyc jesli maja sie chowac sekcje
}