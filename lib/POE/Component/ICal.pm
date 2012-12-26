package POE::Component::ICal;
# ABSTRACT: Schedule POE events using rfc2445 recurrences

use strict;
use warnings;

use Carp qw(croak);
use DateTime;
use DateTime::Event::ICal;
use POE::Kernel;

use POE::Component::Schedule;
use base qw(POE::Component::Schedule);

my $_schedules = {};

=method verify($ical)

This method allows to verify the validity of a rfc2445 recurrence.

=over

=item I<Parameters>

C<$ical> - HASHREF - The rfc2445 recurrence.

=item I<Return value>

Three cases:

    my $ical = { freq => 'secondly', interval => 2 };
    POE::Component::ICal->verify( $ical );

In case of not validity, an exception is raised.

    my $is_valid = POE::Component::ICal->verify( $ical );

A true or false value is returned.

    my ($is_valid, $value) = POE::Component::ICal->verify( $ical );

In case of not validity, $value contains the error message otherwise a L<DateTime::Set> instance.

=back

=cut

sub verify
{
    my ($class, $ical) = @_;

    if (defined wantarray)
    {
        my $set;
        eval { $set = DateTime::Event::ICal->recur(%$ical); };
        my $is_valid = not $@;
        return wantarray ? ($is_valid, $is_valid ? $set : $@) : $is_valid;
    }

    DateTime::Event::ICal->recur(%$ical);
    return 1;
}

=method add_schedule($schedule, $event, $ical, @args)

This method add a schedule.

=over

=item I<Parameters>

C<$schedule> - SCALAR - The schedule name.

C<$event> - SCALAR - The event name.

C<$ical> - HASHREF - The rfc2445 recurrence.

C<@args> - optional - The optional list of the arguments.

=item I<Return value>

A schedule handle. See L<POE::Component::Schedule>.

=item I<Remarks>

The schedule name must be unique by session.

When the rfc2445 parameter C<dtstart> is not specify, this method add it with the C<DateTime-E<gt>now()> value.

=item I<Example>

    POE::Component::ICal->add_schedule
    (
          'tick'                                         # schedule name
        , clock => { freq => 'secondly', interval => 1 } # event name => ical
        , 'tick'                                         # ARG0 (Optional)
        , \$tick_count                                   # ARG1 (Optional)
    );
    POE::Component::ICal->add_schedule
    (
          'tock'                                         # schedule name
        , clock => { freq => 'secondly', interval => 2 } # event name => ical
        , 'tock'                                         # ARG0 (Optional)
        , \$tock_count                                   # ARG1 (Optional)
    );

=back

=cut

sub add_schedule
{
    my ($class, $shedule, $event, $ical, @args) = @_;

    $ical->{dtstart} = DateTime->now unless exists $ical->{dtstart};

    my ($is_valid, $value) = $class->verify($ical);
    croak $value unless $is_valid;

    my $session = POE::Kernel->get_active_session;
    return $_schedules->{$session->ID}->{$shedule} = $class->SUPER::add($session, $event => $value, @args);
}

=method add($event, $ical, @args)

This method calls C<add_schedule()> with schedule name equal to event name.

=over

=item I<Parameters>

C<$event> - SCALAR - The event name.

C<$ical> - HASHREF - The rfc2445 recurrence.

C<@args> - optional - The optional list of the arguments.

=item I<Return value>

See C<add_schedule()>.

=item I<Remarks>

See C<add_schedule()>.

=item I<Example>

    POE::Component::ICal->add_schedule('tick', tick => { freq => 'secondly', interval => 5 });
    POE::Component::ICal->add(                 tick => { freq => 'secondly', interval => 5 });

=back

=cut

sub add
{
    my ($class, $event, $ical, @args) = @_;
    return $class->add_schedule($event, $event, $ical, @args);
}

=method remove( $schedule )

This method remove a schedule.

=over

=item I<Parameters>

C<$schedule> - SCALAR - The schedule name.

=item I<Example>

    POE::Component::ICal->add_schedule('tock', clock => { freq => 'secondly', interval => 1 });
    POE::Component::ICal->remove('tock');

    POE::Component::ICal->add(tick => { freq => 'secondly', interval => 1 });
    POE::Component::ICal->remove('tick');

=back

=cut

sub remove
{
    my ($class, $schedule) = @_;
    delete $_schedules->{POE::Kernel->get_active_session->ID}->{$schedule};
}

=method remove_all

This method remove all schedules from the active session.

=cut

sub remove_all
{
    delete $_schedules->{POE::Kernel->get_active_session->ID};
}

1;

__END__

=pod

=head1 SYNOPSIS

    use strict;
    use warnings;
    use POE;
    use POE::Component::ICal;

    my $count = 5;

    POE::Session->create
    (
        inline_states =>
        {
            _start => sub
            {
                print "_start\n";
                $_[HEAP]{count} = $count;
                POE::Component::ICal->add(tick => { freq => 'secondly', interval => 1 });
            },
            tick => sub
            {
                print "tick: ' . --$_[HEAP]{count}\n";
                POE::Component::ICal->remove('tick') if $_[HEAP]{count} == 0;
            },
            _stop => sub
            {
                print "_stop\n";
            }
        }
    );

    POE::Kernel->run;

=head1 DESCRIPTION

This component extends L<POE::Component::Schedule> by adding an easy way to specify event schedules
using rfc2445 recurrence.

See L<DateTime::Event::ICal> for the syntax, the list of the authorized parameters and their use.

=head1 SEE ALSO

The section 4.3.10 of rfc2445: L<http://www.apps.ietf.org/rfc/rfc2445.html>.

=encoding utf8

=cut
