// CONSTANTS
var managemyid_host = "dartmouth.managemyid.com";
var managemyid_main_page = "https://dartmouth.managemyid.com/student/welcome.php";
var transaction_history_url = 'https://dartmouth.managemyid.com/student/svc_history_view.php';
var current_balance_page_url = 'https://dartmouth.managemyid.com/student/welcome.php';
var main_ddstown_site_url = "http://hacktown.cs.dartmouth.edu/ddstown/viewer";

// GLOBALS
var current_balance_page_html = '';
var transaction_history_page_html = '';

// sends the user to the given url, with given data in post
function send_user_by_post(url, data){
    form = $('<form method="post" action="' + url + '"></form>');
    for (var name in data){
        value = data[name];
        form.append($('<input type="hidden" name="' + name + '" value="' + value + '">'));
    }
    form.submit();
}

// get the transaction history page's html and put it in a global
function get_transaction_history_page_html(){
    //TODO: see if we got an error. handle it.
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
        transaction_history_page_html = return_data;
    });
}

// get the current balance page's html and put it in a global
function get_current_balance_page_html(){
    //TODO: see if we got an error. handle it.
    $.get(current_balance_page_url, function(return_data) {
        current_balance_page_html = return_data;
    });
}

function current_balance_page_html_ready(){
    return current_balance_page_html != '';
}

function transaction_history_page_html_ready(){
    return transaction_history_page_html != '';
}

// wait until our managemyid page AJAX requests are done
// then send them along to ddstown
function send_them_to_our_server_when_ready(){
    if(current_balance_page_html_ready() && transaction_history_page_html_ready()){
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

// MAIN
host = $(location).attr('host');
switch(host){
    // if they're on managemyid already:
    // we can get the data we want without XSS problems
    // so do that, then send them to ddstown
    case managemyid_host:
        get_current_balance_page_html();
        get_transaction_history_page_html();
        send_them_to_our_server_when_ready();
        break;
    // if they're not on managemyid already
    // tell them we're sending them and that they should log in and then press this button again
    // then send 'em there
    default:
        alert('Sending you to managemyid. Log in (make an account if you don\'t already have one). Then press the bookmarklet you just pressed one more time.');
        window.location.href = managemyid_main_page;
        break;
}
