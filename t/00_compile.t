use strict;
use Test::More 0.98;
use Data::Printer;
use FindBin qw($Bin);

use_ok $_ for qw(
    WHOSGONNA::Config
);

my $conf = new_ok( 
    'WHOSGONNA::Config' , 
    [
        conf_files => [ "$Bin/../xt/extra_conf.yaml" ]
    ] , 
    'New WHOSGONNA::Config object' 
);

p $conf->conf;

done_testing;

