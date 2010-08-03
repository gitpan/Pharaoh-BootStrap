package Pharaoh::BootStrap 3.0;

use 5.12.0;
use warnings;
use utf8;
use open IO => ':utf8';

BEGIN {
    use FindBin qw($Bin $Script);
    $0 = $Bin . '/' . $Script;
    chdir $Bin;
    chdir($main::project_path) if $main::project_path;

    if (!$main::pharaoh_path && $main::pharaoh_config && -e $main::pharaoh_config) {
        $main::pharaoh_path = do $main::pharaoh_config || die $@;
    }

    push @INC, ('lib/') if -e 'lib/';
    push @INC, ($main::pharaoh_path) if -e $main::pharaoh_path;
}

1;
