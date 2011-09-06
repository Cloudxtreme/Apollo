#!/usr/bin/perl
#
# Nume: flushCache.pl
# 
# Defragmenteaza cache-ul queryurilor
#

# Modulele de care avem nevoie
use DBI;
use strict;
use warnings;

# Ma conectez la DBI
my $dsn = "DBI:mysql:mysql;mysql_read_default_file=$ENV{HOME}/.my.cnf";
my $dbh = DBI->connect( $dsn, undef, undef, {RaiseError => 1} )
          or die( DBI->errstr );

# Curat cacheul
my $sth = $dbh->prepare( q{FLUSH QUERY CACHE;} );
   $sth->execute();

# Eliberez resursele
$sth->finish();
$dbh->disconnect();
