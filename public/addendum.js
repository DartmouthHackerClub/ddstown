// if you include this on all ddstown pages (in addition to the bookmarklet injecting this in some cases)
// then we'll get bannerstudent data for free

// NOTE: if this flag is on, we won't actually send the data along. we'll just log it to the console.
DEBUG = true;


// CONSTANTS
var managemyid_host = "dartmouth.managemyid.com";
var banner_host = "banner.dartmouth.edu";
var ddstown_host = "hacktown.cs.dartmouth.edu";
var managemyid_main_page = "https://dartmouth.managemyid.com/student/welcome.php";
var managemyid_login_page = "https://dartmouth.managemyid.com/student/login.php";
var transaction_history_url = 'https://dartmouth.managemyid.com/student/svc_history_view.php';
var banner_page_url = 'https://banner.dartmouth.edu/banner/groucho/kap_ar_dash.entry_point';
var current_balance_page_url = 'https://dartmouth.managemyid.com/student/welcome.php';
//var main_ddstown_site_url = "http://hacktown.cs.dartmouth.edu/ddstown/viewer";
var main_ddstown_site_url = "http://dds.1337.cx/reports";

// GLOBALS
var current_balance_page_html = '';
var transaction_history_page_html = '';
var banner_page_html = '';
var current_balance_page_html_ready = false;
var transaction_history_page_html_ready = false;
var banner_page_html_ready = false;

// sends the user to the given url, with given data in post
function send_user_by_post(url, data){
    form = $('<form method="post" action="' + url + '"></form>');
    for (var name in data){
        value = data[name];
        value = Base64.encode(value);
        form.append($('<input type="hidden" name="' + name + '" value="' + value + '">'));
    }
    form.submit();
}

// see if an html str is the login page
function is_login_page(html){
    return html.indexOf('Forgot My Password') >= 0;
}

function handle_they_must_log_in(){
    alert("Woops! You're not logged in. Redirecting you to login.");
    window.location.href = managemyid_login_page;
}

function handle_error_getting_html(page, e){
    error_message_str = e.statusText + ' ' + String(e.status);
    alert("Error getting " + page + " page! Super lame. Sorry. " + error_message_str);
    console.log(e);
}

// get the transaction history page's html and put it in a global
function get_transaction_history_page_html(){
    transaction_history_post_data = {
        'FromMonth' : '01',
        'FromDay' : '4',
        'FromYear' : '2012',
        'ToMonth' : '02',
        'ToDay' : '4',
        'ToYear' : '2012',
        'plan' : 'S_All_',
        'submit' : 'Submit',
        };
    $.post(transaction_history_url, transaction_history_post_data,function(return_data) {
        //only do something on success or error
    })
    .success(function(return_data){
        if(is_login_page(return_data)){
            handle_they_must_log_in();
        }
        else{
            transaction_history_page_html = return_data;
            transaction_history_page_html_ready = true;
        }
    })
    .error(function(return_data){
        handle_error_getting_html("transaction history", return_data);
    });
}

// get the current balance page's html and put it in a global
function get_current_balance_page_html(){
    $.get(current_balance_page_url, function(return_data) {
        //only do something on success or error
    })
    .success(function(return_data){
        if(is_login_page(return_data)){
            handle_they_must_log_in();
        }
        else{
            current_balance_page_html = return_data;
            current_balance_page_html_ready = true;
        }
    })
    .error(function(return_data){
        handle_error_getting_html("current balance", return_data);
    });
}

// get the bannerstudent longer-form transaction history
function get_banner_page(){
    banner_page_post_data = {
        'dateBegin' : '11-17-89',
        'dateEnd' : '',
        // seems that we can get by without these
        //'v_empid' : 'a DND number'
        //'AcctDesc' : 'some number'
        'p_page' : '3',
        };
    $.post(banner_page_url, banner_page_post_data, function(return_data) {
        //only do something on success or error
    })
    .success(function(return_data){
        banner_page_html = return_data;
        console.log(banner_page_html);
        banner_page_html_ready = true;
    })
    .error(function(return_data){
        handle_error_getting_html("banner page", return_data);
    });
}

// wait until our managemyid page AJAX requests are done
// then send them along to ddstown
function send_them_to_our_server_with_data_when_ready(waiting_on){
    ready = false;
    if(waiting_on == 'managemyid'){
        ready = current_balance_page_html_ready && transaction_history_page_html_ready;
    }
    else if(waiting_on == 'bannerstudent'){
        ready = banner_page_html_ready;
    }
    if(ready){
        console.log(current_balance_page_html);
        send_them_to_our_server_with_data();
    }
    else{
        setTimeout("send_them_to_our_server_with_data_when_ready('" + waiting_on + "')",10)
    }
}

// send them along to ddstown
function send_them_to_our_server_with_data(){
    post_data = {
        'current_balance_html' : current_balance_page_html,
        'transaction_history_html' : transaction_history_page_html,
        'banner_page_html' : banner_page_html,
    };
    if(DEBUG){
        console.log(post_data);
        console.log(main_ddstown_site_url);
    }
    else{
        send_user_by_post(main_ddstown_site_url, post_data);
    }

}

// run right before we start grabbing HTML pages with AJAX
function say_were_taking_info(){
    css = ' \
        body {text-align: center; font-family: helvetica; font-size: 20pt} \
        h1 {text-align: center;} \
        h2 {font-size: .8em} \
        ';
    html = ' \
        <h1> \
        Stand by for DDStown... \
        </h1> \
<img src="http://www.nasa.gov/multimedia/videogallery/ajax-loader.gif" \> \
        <br /> \
        <h2> \
        Collecting your DDS usage data... \
        </h2> \
        ';
    show_only_this_html_and_css(html, css);
}

// run when they click the bookmarklet from any page other than managemyid
function say_were_taking_them_to_managemyid(){
    css = ' \
        body {text-align: center; font-family: helvetica; font-size: 20pt} \
        h1 {text-align: center;} \
        h2 {font-size: .8em} \
        button {font-size: 3em} \
        ';
    html = ' \
        <h1> \
        Taking you to ManageMyID... \
        </h1> \
        <h2> \
        NOTE: We\'re going to get your DDS usage data from there. We WILL store it on our servers. If you\'re embarrassed about how many Odwallas you buy or for some other reason DO NOT want us to have your DDS spending data, then just stop here. By clicking the button below, you\'re saying that you\'re cool with this. \
        </h2> \
        <p> \
            When you get to ManageMyID, log in if you\'re not already logged in. Then press this bookmarklet (what brought you here) again. \
        </p> \
        <button>Let\'s do this &raquo;</button> \
        ';
    show_only_this_html_and_css(html, css);
    $('button').click(send_them_to_managemyid);
}

function send_them_to_managemyid(){
    window.location.href = managemyid_main_page;
}

function show_only_this_html_and_css(html, css){
    css = '<style type="text/css">' + css + '</style>';
    $(document.body).empty();
    $("head :not(script)").remove();
    $(document.head).append($(css));
    $(document.body).append($(html));
}

// MAIN
host = $(location).attr('host');
href = $(location).attr('href') 
switch(host){
    // if they're on managemyid already:
    // we can get the data we want without XSS problems
    // so do that, then send them to ddstown
    case managemyid_host:
        // if they're on the login page
        // tell them to log in!
        if(href == managemyid_login_page){
            alert('Dude, log in!');
            try{
                $('form').css({'background-color': 'yellow', 'font-size' : '1.2em'});
            }
            catch(e){
                console.log(e);
            }
        }
        // if they aren't on the login page: let's do this!
        else{
            say_were_taking_info();
            get_current_balance_page_html();
            get_transaction_history_page_html();
            send_them_to_our_server_with_data_when_ready('managemyid');
        }
        break;
    case banner_host:
        say_were_taking_info();
        get_banner_page();
        send_them_to_our_server_with_data_when_ready('bannerstudent');
        break;
    case ddstown_host:
        get_banner_page();
        send_them_to_our_server_with_data_when_ready('bannerstudent');
        break;
    // if they're not on managemyid already
    // tell them we're sending them and that they should log in and then press this button again
    // then send 'em there
    default:
        try{
            say_were_taking_them_to_managemyid();
        }
        catch(e){
            console.log(e)
            alert('Sending you to managemyid. Log in (make an account if you don\'t already have one). Then press the bookmarklet you just pressed one more time. We WILL store the DDS usage data that we get from your managemyID profile. If you\'re not cool with that, just don\'t press the bookmarklet again after hitting "OK" below');
            send_them_to_managemyid();
        }
        break;
}

var Base64 = {

// private property
_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

// public method for encoding
encode : function (input) {
    var output = "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;

    input = Base64._utf8_encode(input);

    while (i < input.length) {

        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }

        output = output +
        this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
        this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

    }

    return output;
},

// private method for UTF-8 encoding
_utf8_encode : function (string) {
    string = string.replace(/\r\n/g,"\n");
    var utftext = "";

    for (var n = 0; n < string.length; n++) {

        var c = string.charCodeAt(n);

        if (c < 128) {
            utftext += String.fromCharCode(c);
        }
        else if((c > 127) && (c < 2048)) {
            utftext += String.fromCharCode((c >> 6) | 192);
            utftext += String.fromCharCode((c & 63) | 128);
        }
        else {
            utftext += String.fromCharCode((c >> 12) | 224);
            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
            utftext += String.fromCharCode((c & 63) | 128);
        }

    }

    return utftext;
}
}
