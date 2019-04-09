use strict;
use Test::More 0.98;
use Data::Printer;

use_ok $_ for qw(
    AltiGen::Config
);

my $conf = new_ok( 'AltiGen::Config' , [] , 'New AltiGen::Config object' );

p $conf->conf;

done_testing;

