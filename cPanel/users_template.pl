#!/usr/bin/perl
#
# A template file for actions that must be run on all users
#

opendir(USERS, '/var/cpanel/users') or die('Nu pot citi lista de utilizatori.');
while( my $user = readdir(USERS) ) {
    next if( $user =~ /\./ );
    print "$user\n";
    # Add the action. E.g.:
    # system("/usr/local/cpanel/bin/dkim_keys_install $user");
}
closedir(USERS);
