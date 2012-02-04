#######
##
##----- LOSYME
##----- POE::Component::ICal
##----- Schedule POE events using rfc2445 recurrences
##----- Makefile.PL
##
########################################################################################################################

use strict;
use ExtUtils::MakeMaker;

WriteMakefile
(
      NAME          => 'POE::Component::ICal'
    , LICENSE       => 'perl'
    , AUTHOR        => 'Loïc TROCHET <losyme@gmail.com>'
    , VERSION_FROM  => 'lib/POE/Component/ICal.pm'
    , ABSTRACT      => 'Schedule POE events using rfc2445 recurrences.'
    , clean         => { FILES => 'POE-Component-ICal-*' }
    , META_MERGE    => { resources => { repository  => 'https://github.com/losyme/POE-Component-ICal' }}
    , BUILD_REQUIRES
      => {
          'Test::More' => 0
      }
    , PREREQ_PM
      => {
          'Carp'                     => 0
        , 'DateTime'                 => 0
        , 'DateTime::Event::ICal'    => 0
        , 'POE'                      => 0
        , 'POE::Component::Schedule' => 0
      }
);

####### END ############################################################################################################
