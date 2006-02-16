use strict;
use Module::Build;

my $build = Module::Build->new(
    module_name => 'Module::CPANTS::Analyse',
    license     => 'perl',
    requires    => {
        'Class::Accessor'=>'0.19',
        'Archive::Any'=>'0.06',
    },
    create_makefile_pl=>'passthrough',
);


$build->create_build_script;

