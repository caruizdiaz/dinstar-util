#!/usr/bin/perl 

#
# (C) Carlos Ruiz Diaz
# 
# carlos.ruizdiaz@gmail.com
# http://caruizdiaz.com
#

use strict;
use warnings;

require 'db.pm';

sub main()
{
	my $ip	= $ARGV[0];
	my $user = $ARGV[1];
	my $pwd	= $ARGV[2];
	my $ports = $ARGV[3];

	if (	!defined $ip	||
	    	!defined $user	||
	    	!defined $pwd  	||
	    	!defined $ports) {
		usage();
	}
	

	open(HR, "curl --user $user:$pwd http://$ip/enSysInfo.htm 2> /dev/null |") or die "Error connecting: $!\n";
	my $dbh	= connect_to_db();

	my @lines = <HR>;
	my $lines = join('', @lines);

	if ($lines =~ m/unauthorized/ig) {	
		die("Invalid user/password\n");
	}
	
	$lines =~ s/[\n|\r|\t]+//g;

	my $i	= 0;

#	delete_previous($dbh, $ip);

	for ($i = 0; $i < $ports; $i++) {

		if ($lines !~ m/<tr id=\"idWIAPort$i\" style=\"display:none\">(.+?)<\/tr>/gi) {
			last;
		}

		my $row = parse_row($1);
		
		$row->{'ip'}	= $ip;

		insert_port_status($dbh, $row);

	}

}

sub parse_row($)
{
	my $row 	= shift;
	my $row_info	= {};

	$row =~ s/\s+/ /g;
	$row =~ m/<td>(.+?)<\/td>\s*<td>(.+?)<\/td>\s*<td>(.*?)<\/td>\s*<td>(.+?)<\/td>\s*<td>(.+?)<\/td>\s*<td>(.*?)<\/td>/g;

	$row_info->{'port'} = $1; 
	$row_info->{'type'} = $2; 
	$row_info->{'imsi'} = $3; 
	$row_info->{'status'} = $4; 
	$row_info->{'limit'} = $5; 
	$row_info->{'carrier'} = $6; 

	$row =~ m/image\/signal"\+'(\d)'\+".gif'/gi;
	$row_info->{'signal'} = $1; 
	
	$row =~ m/<td>(.*?)<\/td>\s*<td>(.+?)<\/td>\s*<td>(.+?)<\/td>\s*<td>(.*?)<\/td>\s*$/g;	

	$row_info->{'asr'} = $1;
	$row_info->{'acd'} = $2;
	$row_info->{'pdd'} = $3;


	return $row_info;

}

sub usage
{
         die("Usage:\n\t$0 <ip> <user> <password> <number-of-ports>\n");

}

main();
