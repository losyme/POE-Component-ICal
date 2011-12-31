#######
##
##----- LOSYME
##----- POE::Component::ICal
##----- Schedule POE events using rfc2445 recurrences
##----- tests::tidy
##
########################################################################################################################

package tests::tidy;

use strict;
use warnings;
use Test::More;
use Carp;
use base qw(Exporter);

our @EXPORT
= qw
(
    t_start
    t_prerequisites
    t_load
    t_end
);

sub import
{
    my $class = shift;
    my ($option, $cmd_name, @args) = @_;
    
    if (defined $option and $option eq 'execute' and defined $cmd_name)
    {
        my %cmds
        = (
              start         => \&t_start
            , prerequisites => \&t_prerequisites
            , load          => \&t_load
            , end           => \&t_end
        ); 
        
        croak "Unknown command: $cmd_name" unless exists $cmds{$cmd_name};
        return $cmds{$cmd_name}(@args); 
    }
    
    $class->export_to_level(1, $class, @_);
}

sub t_start
{
    plan(tests => 1);
    diag("\n===START", '=' x 72);
    diag("Perl $]\n$^X\n", '-' x 80);
    ok(1);
}

sub t_prerequisites
{
    my $requires;

    if ( -f 'META.yml' )
    {
        eval <<'YAML'
            use YAML;
            my $prereqs = YAML::LoadFile( 'META.yml' );
            $requires = $prereqs->{requires};
YAML
    }

    plan(skip_all => 'META.yml not present') unless defined $requires;
    plan(tests => 1);
    
    my $title = scalar(keys %$requires) . ' module(s) are required';
    
    diag("\n", $title, "\n", ':' x length $title);

    for my $module (keys %$requires)
    {
        eval "use $module ()";
        
        if ($@)
        {
            diag("====> WARNING: $module not found <====");
        }
        else
        {
            diag("Using $module - v".( $module->VERSION or ${"${module}::VERSION"} or ''));
        }
    }
    
    diag(':' x 80);
    
    ok(1);
}

sub t_load
{
    my @modules = @_;
    
    plan(tests => scalar @modules);
    
    my $l_name = 0;
    my $l_version = 0;
    
    my $l;
    my $used = {};
    
    foreach my $module (@modules)
    {
        use_ok($module) or BAIL_OUT;
        
        no strict 'refs';
        $used->{$module} = ${"${module}::VERSION"};
        use  strict 'refs';
        
        $l = length $module;
        $l_name = $l if $l > $l_name;
        $l = length $used->{$module};
        $l_version = $l if $l > $l_version;
    }
    
    diag("\n", '-' x ($l_name + $l_version + 13));
    
    while (my ($name, $version) = each %$used)
    {
        diag
        (  
              ' ' x 3
            , $name
            , ' ' x ($l_name - length( $name ))
            , ' - v'
            , $used->{$name}
            , ' ' x (3 + $l_version - length $used->{$name})
            , '---'
        );
    }
    
    diag('-' x ($l_name + $l_version + 13));
}

sub t_end
{
    plan(tests => 1);
    diag("\n===END", '=' x 74);
    ok(1);
}

1;

####### END ############################################################################################################
