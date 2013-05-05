use strict;
use warnings;

use Net::Telnet;
my $telnet = new Net::Telnet ( Timeout=>10,
				Errmode=>'die');
$telnet->open('192.168.2.104');
$telnet->waitfor('/Username:$/i');
$telnet->print('admin');
$telnet->waitfor('/password:$/i');
$telnet->print('admin');
$telnet->waitfor('/ROS>$/i');

my @output = $telnet->print("en");

print @output;
@output = $telnet->waitfor('/ROS#$/i');

print @output;
@output = $telnet->print("sh mobile 0");

@output = $telnet->waitfor('/ROS#$/i');
print @output;
