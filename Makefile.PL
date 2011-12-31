use strict;
use ExtUtils::MakeMaker;
eval 'use ExtUtils::MakeMaker::Coverage';

WriteMakefile
(
      NAME          => 'POE::Component::ICal'
    , LICENSE       => 'perl'
    , AUTHOR        => 'Loïc TROCHET <losyme@gmail.com>'
    , VERSION_FROM  => 'lib/POE/Component/ICal.pm'
    , ABSTRACT_FROM => 'lib/POE/Component/ICal.pm'
    , PL_FILES      => {}
    , dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', }
    , clean         => { FILES => 'POE-Component-ICal-*' }
    , PREREQ_PM
      => {
######### requires
          'Carp'                     => 0
        , 'DateTime'                 => 0
        , 'DateTime::Event::ICal'    => 0
        , 'POE'                      => 0
        , 'POE::Component::Schedule' => 0
######### build_requires
        , 'Test::More'               => 0
      }
);
