// CONSTANTS
var managemyid_host = "dartmouth.managemyid.com";
var managemyid_main_page = "https://dartmouth.managemyid.com/student/welcome.php";
var managemyid_login_page = "https://dartmouth.managemyid.com/student/login.php";
var transaction_history_url = 'https://dartmouth.managemyid.com/student/svc_history_view.php';
var current_balance_page_url = 'https://dartmouth.managemyid.com/student/welcome.php';
var main_ddstown_site_url = "http://hacktown.cs.dartmouth.edu/ddstown/viewer";

// GLOBALS
var current_balance_page_html = '';
var transaction_history_page_html = '';
var current_balance_page_html_ready = false;
var transaction_history_page_html_ready = false;

// sends the user to the given url, with given data in post
function send_user_by_post(url, data){
    form = $('<form method="post" action="' + url + '"></form>');
    for (var name in data){
        value = data[name];
        value = value.replace('"', '\"');
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

// wait until our managemyid page AJAX requests are done
// then send them along to ddstown
function send_them_to_our_server_when_ready(){
    if(current_balance_page_html_ready && transaction_history_page_html_ready){
        console.log(current_balance_page_html);
        send_them_to_our_server_with_data();
    }
    else{
        setTimeout("send_them_to_our_server_when_ready()",10)
    }
}

// send them along to ddstown
function send_them_to_our_server_with_data(){
    post_data = {
        'current_balance_html' : current_balance_page_html,
        'transaction_history_html' : transaction_history_page_html,
    };
    send_user_by_post(main_ddstown_site_url, post_data);
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
        }
        else{
            say_were_taking_info();
            get_current_balance_page_html();
            get_transaction_history_page_html();
            send_them_to_our_server_when_ready();
        }
        break;
    // if they're not on managemyid already
    // tell them we're sending them and that they should log in and then press this button again
    // then send 'em there
    default:
        alert('Sending you to managemyid. Log in (make an account if you don\'t already have one). Then press the bookmarklet you just pressed one more time.');
        window.location.href = managemyid_main_page;
        break;
}
