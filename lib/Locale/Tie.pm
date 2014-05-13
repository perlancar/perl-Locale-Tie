package Locale::Tie;

use 5.010001;
use strict;
use warnings;

use POSIX qw();

use Exporter qw(import);
our @EXPORT_OK = qw(
                       $LANG
               );

# VERSION
# DATE

our $LANG; tie $LANG, 'Locale::Tie::SCALAR' or die "Can't tie \$LANG";

{
    package Locale::Tie::SCALAR;
    use Carp;

    sub TIESCALAR {
        bless [], $_[0];
    }

    sub FETCH {
        POSIX::setlocale(0);
    }

    sub STORE {
        unless (POSIX::setlocale(&POSIX::LC_ALL, $_[1])) {
            carp "Can't setlocale to $_[1]";
        }
    }
}

1;
#ABSTRACT: Get/set locale via (localizeable) variables

=head1 SYNOPSIS

 use Locale::Tie qw($LANG);
 say "Current locale is ", $LANG; # -> en_US.UTF-8
 {
     local $LANG = 'id_ID';
     printf "%.2f\n", 12.34;  # -> 12,34
 }
 printf "%.2f\n", 12.34; # -> 12.34


=head1 DESCRIPTION

This module is inspired by L<File::chdir>, using a tied scalar variable to
get/set stuffs. One benefit of this is being able to use Perl's "local" with it,
effectively setting something locally.


=head1 EXPORTS

They are not exported by default, but exportable.

=head2 $LANG


=head1 TODO

Support $LC_ALL, $LC_COLLATE, $LC_NUMERIC, etc.


=head1 SEE ALSO

L<POSIX>

L<Locale::Scope>

