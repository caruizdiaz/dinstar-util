#
# (C) Carlos Ruiz Diaz
# 
# carlos.ruizdiaz@gmail.com
# http://caruizdiaz.com
#

use strict;
use warnings;

use DBI;

use constant DB         => 'dinstar';
use constant USER       => 'root';
use constant PWD        => '';
use constant HOST       => 'localhost';

sub connect_to_db()
{
        my $dsn = 'DBI:mysql:'.DB;

        return DBI->connect($dsn, USER, PWD) || die "Could not connect to database: $DBI::errstr";
}


sub delete_previous($$)
{
	my ($dbh, $ip) = @_;

	$dbh->do("DELETE FROM port WHERE ip = '$ip'");
}

sub row_exists($$)
{
	my($dbh, $row) = @_;
	my $qh	= $dbh->prepare("SELECT * FROM port WHERE ip = '$row->{ip}' AND port = '$row->{port}'");
	$qh->execute();

	return $qh->fetch();
}

sub insert_port_status($$)
{
	my($dbh, $row) = @_;

	if (!row_exists($dbh, $row)) {
		$dbh->do("INSERT INTO `port` VALUES('$row->{ip}', '$row->{port}', '$row->{type}', '$row->{imsi}', '$row->{status}', '$row->{limit}', '$row->{carrier}', '$row->{signal}', '$row->{asr}', '$row->{acd}', '$row->{pdd}', NULL)") || print "$DBI::errstr\n";
	}
	else {
		$dbh->do("UPDATE `port` SET `type` = '$row->{type}', imsi = '$row->{imsi}', `status` = '$row->{status}', `limit` = '$row->{limit}', carrier = '$row->{carrier}', `signal` = '$row->{signal}', asr = '$row->{asr}', acd = '$row->{acd}', pdd = '$row->{pdd}', last_update = CURRENT_TIMESTAMP WHERE ip = '$row->{ip}' AND `port` = '$row->{port}'") || print "$DBI::errstr\n";
	}
}

sub check_ports_signal($$)
{
	my($dbh, $ip, $threshold) = @_;

	my $query       = $dbh->prepare("SELECT * FROM `port` WHERE ip = '$ip' AND `status` <> 'No SIM Card' AND `signal` <= $threshold AND pdd > 0") or return undef;

	return retrieve_rows($query);
}

sub check_ports_asr($$)
{
        my($dbh, $ip, $threshold) = @_;

        my $query       = $dbh->prepare("SELECT * FROM `port` WHERE ip = '$ip' AND `status` <> 'No SIM Card' AND asr <= $threshold and pdd > 0") or return undef;

        return retrieve_rows($query);
}

sub check_ports_pdd($$)
{
        my($dbh, $ip, $threshold) = @_;

        my $query       = $dbh->prepare("SELECT * FROM `port` WHERE ip = '$ip' AND `status` <> 'No SIM Card' AND pdd >= $threshold") or return undef;

        return retrieve_rows($query);
}

sub check_ports_limit($$)
{
        my($dbh, $ip, $threshold) = @_;

        my $query       = $dbh->prepare("SELECT * FROM `port` WHERE ip = '$ip' AND `status` <> 'No SIM Card' AND `limit` <= $threshold") or return undef;

        return retrieve_rows($query);
}

sub retrieve_rows($)
{
	my $query 	= shift;

	$query->execute() or return undef;

        my @rows;

        while ( my $row = $query->fetchrow_hashref() ) {

                push(@rows, $row);
        }

        return @rows;
}


1;
