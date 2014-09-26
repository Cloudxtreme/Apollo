#!/usr/bin/perl
#
# Check if the main IP of the server
# is listed in any of the @blst blacklists;
#

use strict;
use warnings;

my $msg  =  '';
my $host =  `/bin/hostname`;
   chomp $host;
my $ip   =  `/bin/hostname -i`;
   chomp $ip;
my $re   =  $ip;
   $re   =~ s/([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/$4.$3.$2.$1/;
my $rdns =  `dig +short -x $ip`;
my @blst =  ("cbl.abuseat.org", "dnsbl.sorbs.net", "bl.spamcop.net", "zen.spamhaus.org");

foreach my $list (@blst) {
   my $res = `/usr/bin/dig +short -t A $re.$list`;
   $msg .= "$list\n" if( length $res >= 9 );
}

if( length $msg >= 5 ) {
   open(MAIL, "|/usr/sbin/sendmail -t");
      print MAIL "To: me\@example.net\n";
      print MAIL "From: root\@$host\n";
      print MAIL "Subject: [$host] Blacklist report\n";
      print MAIL "Content-type: text/plain\n\n";
      print MAIL "Serverul $host este listat in urmatoarele blacklisturi:\n\n$msg";
   close(MAIL);
}
