#!/usr/bin/perl
#
# Util cand trec un server cPanel de pe DSO pe FastCGI.
# Pune ownerul corect pe fisiere ca sa scapam de nobody.
#

# In /var/cpanel/users exista cate un fisier pentru
# fiecare cont de hosting.
opendir(USERS, '/var/cpanel/users') or die('Bitch!');
while( my $dir = readdir(USERS) ) {
    next if( $dir =~ /\./ );
    print "$dir\n";
    system("chown -R $dir:nobody /home/$dir/public_html/");
}
closedir(USERS);
