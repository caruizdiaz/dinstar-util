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
3. crontab (optional)

Installation and configuration
=================

1. Clone the repository 
2. setup the database connection
<pre>
    # mysql 
    mysql> create database dinstar;

    # mysql dinstar < sql/dinstar.sql
</pre>
3. Edit db.pm file with your database credentials
<pre>
    use constant DB         => 'dinstar';
    use constant USER       => 'root';
    use constant PWD        => '';
    use constant HOST       => 'localhost';
</pre>
4. Test the script execution
<pre>
    Usage:
        dinstar-ports-parser.pl <ip> <user> <password> <number-of-ports>

    # perl dinstar-ports-parser.pl 192.168.111.99 admin admin 8
</pre>

6. Get to your database client and check if the rows were inserted properly

<pre>
    select * from port;
</pre>
