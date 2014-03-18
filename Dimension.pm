#!/usr/bin/perl

package Dimension;
use 5.12.0;
use strict;
use warnings;

# $stringify is a regexp (like '^-march=') to convert compiler argument (like '-march=qqq') into the corresponding part of the name of the output file (like 'qqq').
# the $stringify regexp is used as a pattern in s/// substitution operator.
# $items is an arrayref of compiler arguments (like [undef, '-march=zzz', '-march=qqq']) that represents current dimension.
sub new {
	my ($class, $stringify, $items) = @_;

	my $self = {
		stringify => $stringify,
		items => $items,
	};
	bless($self, $class);

	return $self;
}

sub getItems {
	my ($self) = @_;

	return $self->{items};
}

# apply the regexp and produce part of the output file name
sub toStr {
	my ($self, $item) = @_;
	if (not defined($item)) {
		return 'none';
	}
	return ($item =~ s/$self->{stringify}//gr);
}

# produce part of the compiler argument list
sub toArg {
	my ($self, $item) = @_;
	my @ret = ( $item // () );

	return @ret;
}

# produce all possible combinations of arguments across various dimensions
sub walkDimensions {
	my (@dimens) = @_;
	my $dimen = pop(@dimens);
	my @points;

	if (defined($dimen)) {
		foreach my $point (walkDimensions(@dimens)) {
			my $pstr = defined($point) ? "$point->{str}-" : '';
			my $parg = defined($point) ? $point->{arg} : [];
			foreach my $q (@{$dimen->getItems()}) {
				my %point = (
					str => $pstr.$dimen->toStr($q),
					arg => [ @{$parg}, $dimen->toArg($q)],
				);
				push(@points, \%point);
			}
		}
	}
	else {
		@points = ( undef );
	}

	return @points;
}

1;
