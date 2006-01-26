use strict;
use Module::Build;

my $build = Module::Build->new(
    module_name => 'Module::CPANTS::Analyse',
    license     => 'perl',
    requires    => {
        'Class::Accessor'=>'0.19',
        'Archive::Any'=>'0.06',
        'CPAN::DistnameInfo'=>'0.06',
        'Pod::Simple::Checker'=>'2.02',
        'YAML'=>'0.39',
        'Module::ExtractUse'=>'0.17',
        'Module::Pluggable'=>'2.96',
    },
    script_files=>[qw(bin/cpants_lint.pl)],
    create_makefile_pl=>'passthrough',
);


$build->create_build_script;

