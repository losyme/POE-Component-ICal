#######
##
##----- LOSYME
##----- POE::Component::ICal
##----- Schedule POE events using rfc2445 recurrences
##----- 98_distribution.t
##
########################################################################################################################

use strict;
use warnings;
use Test::More;

eval 'use Test::Distribution';
plan(skip_all => "Test::Distribution required for checking distribution") if $@;

####### END ############################################################################################################
