#######
##
##----- LOSYME
##----- POE::Component::ICal
##----- Schedule POE events using rfc2445 recurrences
##----- Build.PL
##
########################################################################################################################

use strict;
use Module::Build;

Module::Build->new(
      module_name        => 'POE::Component::ICal' 
    , license            => 'perl' 
    , dist_author        => 'Loïc TROCHET <losyme@gmail.com>' 
    , dist_version_from  => 'lib/POE/Component/ICal.pm'
    , add_to_cleanup     => [ 'POE-Component-ICal-*' ]
    , configure_requires
      => {
          'Module::Build' => 0 
      }
    , build_requires
      => {
          'Test::More' => 0
      }
    , requires
      => {
          'Carp'                     => 0
        , 'DateTime'                 => 0
        , 'DateTime::Event::ICal'    => 0
        , 'POE'                      => 0
        , 'POE::Component::Schedule' => 0
      } 
)->create_build_script;

####### END ############################################################################################################
