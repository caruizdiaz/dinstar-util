#!/usr/bin/perl

#
# (C) Carlos Ruiz Diaz
# 
# carlos.ruizdiaz@gmail.com
# http://caruizdiaz.com
#

use strict;
use warnings;

require '../db.pm';

use constant NAGIOS_OK		=> 0;
use constant NAGIOS_WARNING	=> 1;
use constant NAGIOS_CRITICAL	=> 2;
use constant NAGIOS_UNKNOWN	=> 3;

sub main
{
	my $conf	= parse_params();
	my $dbh 	= connect_to_db();
	
	if (!defined $dbh) {
		exit(NAGIOS_UNKNOWN);
	}

	my @critical_ports	= check_ports_pdd($dbh, $$conf{host}, $$conf{critical});

	for (@critical_ports) {
		print "Very high PDD on port #$_->{port}: $_->{pdd}\n";
	}

	if ($#critical_ports + 1 > 0) {
		exit(NAGIOS_CRITICAL);
	}

	my @warning_ports	= check_ports_pdd($dbh, $$conf{host}, $$conf{warning});

	for (@warning_ports) {
		print "High PDD on port #$_->{port}: $_->{pdd}\n";
	}

	if ($#warning_ports + 1 > 0) {
		exit(NAGIOS_WARNING);
	}

	exit(NAGIOS_OK);
}

sub parse_params()
{
	my $conf	= {};
	for (@ARGV) {
		if (m/^-h(.+)$/g) {
			$$conf{host}	= $1;
		}
		elsif (m/^-w(\d+)$/gi) {
			$$conf{warning}	= $1;
		}
		elsif (m/^-c(\d+)$/gi) {
			$$conf{critical}	= $1;
		}
		else {
			usage();
		}
	}
	
	if (!defined $$conf{host} || !defined $$conf{warning} || !defined $$conf{critical}) {
		usage();
	}	

	return $conf;
}

sub usage
{
	 die("Usage:\n\t$0 -h<host> -w<warning-value> -c<critial-value>\n");

}

main();


