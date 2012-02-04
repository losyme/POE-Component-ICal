POE::Component::ICal
====================

Schedule [POE](http://search.cpan.org/~rcaputo/POE-1.350/lib/POE.pm) events using rfc2445 recurrences.

Description
-----------

This component extends [POE::Component::Schedule](http://search.cpan.org/~dolmen/POE-Component-Schedule-0.95/lib/POE/Component/Schedule.pm) by adding an easy way to specify event schedules
using rfc2445 recurrence.

See [DateTime::Event::ICal](http://search.cpan.org/~fglock/DateTime-Event-ICal-0.10/lib/DateTime/Event/ICal.pm) for the syntax, the list of the authorized parameters and their use.

See also the section 4.3.10 of [rfc2445](<http://www.apps.ietf.org/rfc/rfc2445.html>).

Synopsis
--------

    use strict;
    use warnings;
    use 5.010;
    use POE;
    use POE::Component::ICal;
    
    my $count = 5;
    
    POE::Session->create
    (
        inline_states =>
        {
            _start => sub
            {
                say "_start";
                $_[HEAP]{count} = $count;
                POE::Component::ICal->add(tick => { freq => 'secondly', interval => 1 });
            },
            tick => sub
            {
                say "tick: ' . --$_[HEAP]{count}";
                POE::Component::ICal->remove('tick') if $_[HEAP]{count} == 0;
            },
            _stop => sub
            {
                say "_stop";
            }
        }
    );
    
    POE::Kernel->run;

Author
------

Lo&iuml;c TROCHET <losyme@gmail.com>

Copyright and license
---------------------

Copyright &copy; 2011 by Lo&iuml;c TROCHET.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See [http://dev.perl.org/licenses/](http://dev.perl.org/licenses/) for more information.
    