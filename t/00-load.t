#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Pharaoh::BootStrap' ) || print "Bail out!
";
}

diag( "Testing Pharaoh::BootStrap $Pharaoh::BootStrap::VERSION, Perl $], $^X" );
