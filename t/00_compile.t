use strict;
use Test::More 0.98;
use Data::Printer;

use_ok $_ for qw(
    AltiGen::Config
);

my $conf = new_ok( 
    'AltiGen::Config' , 
    [
        conf_files => [ '/home/ben/projects/AltiGen-Config/xt/extra_conf.yaml' ]
    ] , 
    'New AltiGen::Config object' 
);

p $conf->conf;

done_testing;

