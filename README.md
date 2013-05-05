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

    # mysql dinstar &#60; sql/dinstar.sql
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
        dinstar-ports-parser.pl &#60;ip&#62; &#60;user&#62; &#60;password&#62; &#60;number-of-ports&#62;

    # perl dinstar-ports-parser.pl 192.168.111.99 admin admin 8
</pre>

6. Get to your database client and check if the rows were inserted properly
<pre>
    select * from port;

+---------------+------+------+-----------------+-------------------+----------+---------------------+--------+------+------+------+---------------------+
| ip            | port | type | imsi            | status            | limit    | carrier             | signal | asr  | acd  | pdd  | last_update         |
+---------------+------+------+-----------------+-------------------+----------+---------------------+--------+------+------+------+---------------------+
| 192.168.2.104 |    7 | GSM  | 744051200052261 | Mobile Registered | No Limit | Personal            | 4      |   80 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    6 | GSM  | 744051200052266 | Mobile Registered | No Limit | Personal            | 4      |   80 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    5 | GSM  | 744040010366020 | Mobile Registered | No Limit | Telecel Paraguay    | 3      |   54 |  207 |    6 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    4 | GSM  | 744020008182383 | Mobile Registered | No Limit | Hutchison Paraguay  | 4      |   90 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    3 | GSM  |                 | No SIM Card       | No Limit |                     | 0      |    0 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    2 | GSM  |                 | No SIM Card       | No Limit |                     | 0      |    0 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    1 | GSM  |                 | No SIM Card       | No Limit |                     | 0      |    0 |    0 |    0 | 2013-04-07 11:22:13 |
| 192.168.2.104 |    0 | GSM  |                 | No SIM Card       | No Limit |                     | 0      |    0 |    0 |    0 | 2013-04-07 11:22:13 |

</pre>

7. If you want to contanstaly check for updates, you can put the script in a crontab to run every 5 minutes or so.
<pre>
    */5 * * * * perl /root/dinstar-util/dinstar-ports-parser.pl 192.168.111.99 admin admin 8
</pre>

Nagios installation
=================

1. Put the scripts in the plugins directory
2. Setup the new commands in the command.cfg file using the parameters you want
   Example:
<pre>
    define command{
        command_name    check-dinstar-limit
        command_line    $USER1$/check-dinstar-limit -h$HOSTADDRESS$ -w30 -c15
        }
</pre>
3. Setup a new checking in your service.cfg file
4. Restart nagios

I don't want to get into much detail on Nagios configuration since there are plenty of material out there to setup plugins.
If you are willing to use these scripts I'm pretty sure you alrealy know how to use and configure Nagios ;)
