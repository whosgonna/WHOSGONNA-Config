package AltiGen::Config;
use 5.008001;
use strict;
use warnings;
use Moo;
use Config::Any;
use Hash::Merge 'merge';
use FindBin qw($Bin $Script);
use File::Spec::Functions;
use File::Basename;

our $VERSION = "v0.0.1";



has 'etc_dirs' => (
    is => 'ro',
    required => 1,
    default => sub{
        return [
            '/etc',
            '/usr/local/etc'
        ];
    }
);

has _local_dir => (
    is => 'ro',
    default => sub {
        return $Bin
    },
);


has local_conf_prefix => (
    is => 'ro',
    default => 'local_'
);

has local_conf_suffix => (
    is => 'ro',
    default => '_local'
);

has additional_conf_stems => (
    is => 'ro'
);

has conf_files => (
    is => 'ro',
);

has home_dir => (
    is => 'ro',
    default => './',
);

has _basename => (
    is => 'lazy',
);

sub _build__basename {
    my $self = shift;
    my $fullname = catfile($Bin,$Script);
    my ($name,$path,$suffix) = fileparse($fullname, qr/\.[^.]*/ );
    return $name;
    #return {
    #    name   => $name,
    #    path   => $path,
    #    suffix => $suffix,
    #};
}

has conf_file_aliases => (
    is => 'ro',
    default => sub {
        return ( 
            [qw(
                conf
                config
                configuration
            )] 
        );
    }
);

has conf_stems => (
    is => 'lazy',
);

sub _build_conf_stems {
    my $self = shift;
    my $stems;
    my $basename   = $self->_basename;
    my $local_conf = $self->local_conf_prefix . $basename;
    my $conf_local  = $basename . $self->local_conf_suffix; 

    for my $etc_dir ( @{ $self->etc_dirs} ) {
        my $stem = catfile( $etc_dir, $basename );
        push @$stems, catfile( $etc_dir, $basename );
        push @$stems, catfile( $etc_dir, $local_conf );
        push @$stems, catfile( $etc_dir, $conf_local );
    }

    push @$stems, catfile( $ENV{HOME}, $basename );
    push @$stems, catfile( $ENV{HOME}, $local_conf );
    push @$stems, catfile( $ENV{HOME}, $conf_local );

    for my $alias ( @{ $self->conf_file_aliases } ) {
        push @$stems, catfile( $Bin, $alias );
        push @$stems, catfile( $Bin, ( $self->local_conf_prefix . $alias ) );
        push @$stems, catfile( $Bin, ( $alias . $self->local_conf_suffix ) );
    }

    return $stems;

}


has _conf_any => (
    is => 'lazy',
);

sub _build__conf_any {
    my $self = shift;
    
    my $conf_any = Config::Any->load_stems({ 
        stems => $self->conf_stems,
        use_ext => 1,
    });
    
    if ( $self->conf_files ){
        my $contents = Config::Any->load_files({
            files           => $self->conf_files,
            use_ext         => 1,
            flatten_to_hash => 1,
        });
        push ( @$conf_any, $contents );
    }
    

    return $conf_any;
}

sub make_config {
    my $args = shift;

    my $conf = AltiGen::Config->new( $args );

}


has conf => (
    is => 'lazy',
);

sub _build_conf {
    my $self = shift;
    my $conf;

    for my $individual_conf ( @{ $self->_conf_any } ) {
        my ($filename, $sections) = %$individual_conf;
        $conf = merge( $sections, $conf);
    }
    return $conf;
}

1;
__END__

=encoding utf-8

=head1 NAME

AltiGen::Config - It's new $module

=head1 SYNOPSIS

    use AltiGen::Config;

=head1 DESCRIPTION

AltiGen::Config is ...

=head1 LICENSE

Copyright (C) Ben Kaufman.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Ben Kaufman E<lt>ben.kaufman@altigen.comE<gt>

=cut

