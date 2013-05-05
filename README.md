Dinstar utilities
=================

Dinstar equipment doesn't offer you any kind of monitoring tool apart from the web management page. Although there is a 
telnet interface which you can, somehow, automate to give you information, this job is rather an obstacle than a solution.

With the scripts on this repository, you can setup a basic monitoring system using a intermediate database and a screen 
scrapping script which connects to the webmin page of every gateway you want and writes down the parsed html information
to a database which you can consult later using whatever tool you prefer.

The tool I preferred was Nagios, but it doesn't work all by itself so I wrote another four scripts to take care of the ASR,
PDD, Time Limit and port signal captured all by the main script.

You can, however, choose to ignore the Nagios scripts since they are completely independent one from another.

Dependencies
=================

1. perl
2. curl
