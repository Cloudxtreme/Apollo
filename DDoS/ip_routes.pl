#!/usr/bin/perl

use Net::Whois::RIS;
use Net::Subnet;

# Hash key pentru subneturi, ca sa stiu cate IP-uri
# apar in fiecare subnet
my %subnets = ();

# Pentru whois
my $sub = Net::Whois::RIS->new();
my $route;

# Citesc IP-urile
if( open(IPS, 'list.txt') ) {
  while( my $ip = <IPS> ) {
    chomp($ip);
    if( &in_hash($ip) ) {
      $subnets{$route}++;
    } else {
      $sub->getIPInfo($ip);
      $route = $sub->getRoute();
      $subnets{$route} = 1;
    }
  }
  close(IPS);
}

# Sortez hash-ul dupa numarul de aparitii
my @keys = sort { $subnets{$b} <=> $subnets{$a} } keys(%subnets);

# Afisez rezultatul
print "-------Subnet-------+-IP--\n";
foreach my $key ( @keys ) {
  # Afisez subneturile care au mai mult de 5 IP-uri
  printf(" %18s | %3d \n",$key,$subnets{$key}) if( $subnets{$key} > 5 );

}
print '-' x 26 . "\n";


# Verific daca IP-ul apare in %subnets
sub in_hash {
  my $ip = shift;
  for( keys %subnets ) {
    return 1 if( subnet_matcher( $_ )->( $ip ) );
  }
  return 0;
}
