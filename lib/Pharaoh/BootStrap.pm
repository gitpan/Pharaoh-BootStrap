package Pharaoh::BootStrap 4.04;

use 5.14.1;
use warnings;
use utf8;
use open IO => ':utf8';
use namespace::autoclean;

BEGIN {
	use Cwd;
    use FindBin;
    $0 = $FindBin::Bin . '/' . $FindBin::Script;
    $FindBin::Bin =~ /(.*)/;
    $FindBin::Bin = $1;
    chdir $FindBin::Bin;
    chdir($main::root_path) if $main::root_path;

    if (ref $main::pharaoh_path eq 'SCALAR') {
		die 'Pharaoh path config was not found!' unless -e $$main::pharaoh_path;
        $main::pharaoh_path = do $$main::pharaoh_path || die $@;
    }

	my $NEW_INC = {};
	my $order = 1;
    map {
		my $path = &Cwd::abs_path($_) . '/';
		$NEW_INC->{$path} = ++$order;
	} reverse @INC;

	if ($main::pharaoh_path && -d $main::pharaoh_path)
	{
		my $path = &Cwd::abs_path($main::pharaoh_path) . '/';
		$NEW_INC->{$path . 'lib/'} = ++$order;
		$NEW_INC->{$path} = ++$order;
	}
	
	foreach my $path (grep {-d $_} reverse @main::libs){
		my $path = &Cwd::abs_path($path) . '/';
		$NEW_INC->{$path} = ++$order;
	}

	{
		my $path = &Cwd::getcwd . '/';
		$NEW_INC->{$path . 'lib/'} = ++$order;
		$NEW_INC->{$path} = ++$order;
	}

	{
		my $path = &Cwd::abs_path($FindBin::Bin) . '/';
		$NEW_INC->{$path . 'lib/'} = ++$order;
		$NEW_INC->{$path} = ++$order;
	}

	@INC = sort {$NEW_INC->{$b} <=> $NEW_INC->{$a}} keys %$NEW_INC;
}

=head1 NAME

Pharaoh::BootStrap - Pharaoh bootstrap module.

=head1 VERSION

Version 4.04

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

    #!/usr/bin/perl

    package main;

    use 5.14.1;
    use warnings;
    use utf8;
    use open IO => ':utf8';
    use namespace::autoclean;
    
    BEGIN {
        use Getopt::Euclid qw (:minimal_keys);
        our $root_path    = '../';                                              #project root path, absolute or related to script startup directory
        our $pharaoh_path = \'lib/pharaoh.pm';                                  #absolute path to Pharaoh framework or scalar reference to pharaoh.pm file
        our @libs         = qw(lib/);                                           #additional libraries paths, absolute or related to root path
        our $config       = [ 'lib/cfg_common.pm', 'lib/cfg_local.pm', {} ];    #local configuration files as SCALAR (absolute or relative to root path), or inline config as HASH ref
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
