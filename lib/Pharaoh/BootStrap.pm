package Pharaoh::BootStrap 4.01;

use 5.14.1;
use warnings;
use utf8;
use namespace::autoclean;
use open IO => ':utf8';

BEGIN {
    use FindBin;
    $0 = $FindBin::Bin . '/' . $FindBin::Script;
    $FindBin::Bin =~ /(.*)/;
    $FindBin::Bin = $1;
    chdir $FindBin::Bin;
    chdir($main::project_path) if $main::project_path;

    if (ref $main::pharaoh_path eq 'SCALAR' && -e $$main::pharaoh_path) {
        $main::pharaoh_path = do $$main::pharaoh_path || die $@;
    }

    @INC = grep { $_ ne '.' } @INC;
    unshift @INC, $main::pharaoh_path if ($main::pharaoh_path && -d $main::pharaoh_path);
    unshift @INC, @main::libs         if (@main::libs);
    unshift @INC, '.';
}

=head1 NAME

Pharaoh::BootStrap - Pharaoh bootstrap module.

=head1 VERSION

Version 4.01

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

#!/usr/bin/perl

    package main;

    use 5.14.1;
    use warnings;
    use utf8;
    use open IO => ':utf8';

    BEGIN {
        use Getopt::Euclid qw (:minimal_keys);
        our $project_path = '../';                                     #project root path, absolute or related to script startup directory
        our $pharaoh_path = \'lib/pharaoh.pm';                         #absolute path to Pharaoh framework or scalar reference to pharaoh.pm file
        our @libs         = qw(lib/);                                  #additional libraries paths, absolute or related to $project_path
        our @config       = qw(lib/cfg_common.pm lib/cfg_local.pm);    #local configuration files
        our $config       = {};                                        #inline configuration
        require Pharaoh::BootStrap;
    }

    use Pharaoh::Core 4.00;

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

1;
