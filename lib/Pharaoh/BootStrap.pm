package Pharaoh::BootStrap 0.01;

use strict;
use warnings;
use utf8;
use FindBin();
use Cwd();

our $CO = {};

($FindBin::RealBin) = $FindBin::RealBin =~ /^(.*)$/;    #untaint
chdir $FindBin::RealBin;

$CO->{ROOT_PATH} = $main::CO->{ROOT_PATH} || $FindBin::RealBin;
eval { $CO->{ROOT_PATH} = &Cwd::abs_path($CO->{ROOT_PATH}) . '/'; };
die "ROOT_PATH error! $@" if $@;
($CO->{ROOT_PATH}) = $CO->{ROOT_PATH} =~ /^(.*)$/;      #untaint
chdir($CO->{ROOT_PATH});
delete $main::CO->{ROOT_PATH} if $main::CO->{ROOT_PATH};

if ($main::CO->{CONFIG}) {
    for my $file (@{ $main::CO->{CONFIG} }) {
        merge($CO, &load_config($file));
    }
}
merge($CO, $main::CO);

$CO->{SCRIPT_FILENAME} = $FindBin::RealScript;
$CO->{SCRIPT_PATH}     = &Cwd::abs_path($FindBin::RealBin) . '/';

eval { $CO->{PHARAOH_PATH} = $CO->{PHARAOH_PATH} ? (&Cwd::abs_path($CO->{PHARAOH_PATH}) . '/') : $ENV{PHARAOH_PATH} ? (&Cwd::abs_path($ENV{PHARAOH_PATH}) . '/') : ''; };
die "PHARAOH_PATH error! $@" if $@;
unshift @INC, $CO->{PHARAOH_PATH} if $CO->{PHARAOH_PATH};

#modify @INC
my $NEW_INC = {};
my $order   = 1;
map { $NEW_INC->{ &Cwd::abs_path($_) . '/' } = ++$order; } reverse @INC;

$NEW_INC->{ $CO->{PHARAOH_PATH} . 'lib/' } = ++$order;
$NEW_INC->{ $CO->{PHARAOH_PATH} } = ++$order;

if ($CO->{INC}) {
    foreach my $path (grep { -d $_ } reverse @{ $CO->{INC} }) {
        $NEW_INC->{ &Cwd::abs_path($path) . '/' } = ++$order;
    }
}

$NEW_INC->{ $CO->{ROOT_PATH} . 'lib/' } = ++$order if $CO->{ROOT_PATH};
$NEW_INC->{ $CO->{ROOT_PATH} } = ++$order if $CO->{ROOT_PATH};
$NEW_INC->{ $CO->{SCRIPT_PATH} . 'lib/' } = ++$order;
$NEW_INC->{ $CO->{SCRIPT_PATH} } = ++$order;

@INC = sort { $NEW_INC->{$b} <=> $NEW_INC->{$a} } keys %$NEW_INC;

sub i18n {
    return [@_];
}

sub load_config {
    my $filename = shift;

    my $config = do $filename;
    die "$filename: $!" if $!;
    die "$filename: $@" if $@;

    return $config;
}

sub merge {
    my $a = shift;
    my $b = shift;

    foreach my $key (keys %{$b}) {
        if (ref($b->{$key}) eq 'HASH') {
            $a->{$key} = {} unless (ref($a->{$key}) eq 'HASH');
            merge($a->{$key}, $b->{$key});
        }
        elsif (ref($b->{$key}) eq 'ARRAY') {
            $a->{$key} = [];
            @{ $a->{$key} } = @{ $b->{$key} };
        }
        else {
            $a->{$key} = $b->{$key};
        }
    }

    return defined wantarray ? $a : undef;
}

1;
__END__

=head1 NAME

Pharaoh::BootStrap - Pharaoh bootstrap module.

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

    #!/usr/bin/perl

    package main;

    BEGIN {
        use Getopt::Euclid qw (:minimal_keys);    #remove, if Getopt::Euclid not used
        our $CO = {
            ROOT_PATH    => '',                   #project root path, absolute or related to script startup directory
            PHARAOH_PATH => '',                   #absolute path to Pharaoh framework
            INC          => [],                   #additional libraries paths, absolute or related to root path
            CONFIG       => [],                   #local configuration files as (absolute or relative to root path)
            ...                                   #additional configuration keys
        };
    }

Local $CO will be merged with global $CO during project startup.

=head1 AUTHOR

Dmytro Zagashev, C<< <zdm at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-pharaoh-bootstrap at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Pharaoh-BootStrap>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Pharaoh::BootStrap

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Pharaoh-BootStrap>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Pharaoh-BootStrap>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Pharaoh-BootStrap>

=item * Search CPAN

L<http://search.cpan.org/dist/Pharaoh-BootStrap/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Dmytro Zagashev.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
