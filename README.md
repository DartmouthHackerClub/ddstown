




DDSTOWN
=======
This is a site that gives users userful info about their DDS usage.

It's a little weird in that it needs to be launched from a bookmarklet.

We get the user to log in to managemyid and then grab her data from the browser and send it to our back-end.

This way we don't have to store their managemyid password or anything.

However, we /do/ store people's usage data. For analytics.



Parts
====

bookmarklet/
------------
The code for the bookmarklet.

There's one html page that actually has the bookmarklet link that the user should drag in to her favorites bar. But this just pulls in some other javascript. The other javascript it pulls in is also in this dir (addendum.js). (Conveniently, the bookmarklet also pulls in jquery!)

addendum.js does this, or something like it:
* log the person in to managemyid
** just send to login page?
** open up an iframe and have them log in through it?
* send 2 background/ajax requests
** GET: the current balance page
** POST: the transaction_history page (needs to send the right form data to get a full transaction history)
* send the user to our rails back-end, via post, including the in

rails/
------
the back-end code.

* takes the html for the two pages from managemyid
* parses the raw data out of them
* stores that raw data
** ties it to a user so that we know it's the same person when we get their data again
** but probably just uses a hash of the name as the identifier, so that we can protect anonymity
* computes some useful information from the raw data
* passes that useful information to the rails front-end view


front_end/
----------
the front-end code.

* displays useful information about DDS usage

sample_data/
------------
sample data

Interfaces
==========
NOTE: READ THIS. EACH TEAM SHOULD HAVE A GOOD SENSE OF WHAT THEIR PART INPUTS AND OUTPUTS
communicate early and often with the team(s) that you interface with
bookmarklet:
------------
input: user clicks it :)
output: a post request to our rails back-end, containing two fields:
    current_balance_html: the full html of the "Current Balance" page from ManageMyID
    transaction_history_html: the full html of the  "Transaction History" page (after form submission) from ManageMyID
    sample versions of both of these pages are in sample_data/

rails/
------
input: the output from the bookmarklet (see above)
output: sends the right values/data to a rails view
        
front_end/
----------
should be clear by now.
the front_end team should feel free to ignore rails initially and simply build a static html/js page with hard-coded data. we can convert it to a rails view easily later.

Game Plan
=========
* make sure everyone is on the same page for this design
* break in to teams
* hack
* eat pizza
* ????
* profit
* probably we'll want to ditch our initial 3-directory code layout once we're actually stitching the pieces together
** the front_end goes in rails' views dir, and the bookmarklet payload/"addendum" goes in rails' "static files" dir.
* advertise on bored@baker
* advertise elsewhere

If people want to spin off and do non-tech stuff (thinking about advertising this, etc), that could be cool.
