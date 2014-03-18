#!/usr/bin/perl
use 5.12.2;
use strict;
use warnings;
use Dimension;


# we're going to produce all possible combinations of the elements of the following dimensions.
# for example,
#	@dimensions = (
#		Dimension->new('^gcc-', ['gcc-4.7', 'gcc-4.8']),
#		Dimension->new('^-O', [undef, '-O2', '-O3', '-Ofast']),
#	);
# will produce the following combinations:
#   1) gcc-4.7 # undef expands to nothing
#   2) gcc-4.7 -O2
#   3) gcc-4.7 -O3
#   4) gcc-4.7 -Ofast
#   5) gcc-4.8 # undef example to nothing
#   6) gcc-4.8 -O2
#   7) gcc-4.8 -O3
#   8) gcc-4.8 -Ofast
my @dimensions = (
	# Dimension->new(regexp_to_convert_argument_to_a_part_of_output_filename,
	#	[array_of_arguments_to_try])

	# compilers should go first
	Dimension->new('-linux-gnueabi-gcc$',
		['arm-gentoo-linux-gnueabi-gcc', 'armv5te-hardfloat-linux-gnueabi-gcc']),
	Dimension->new('^-mfloat-abi=',
		[undef, '-mfloat-abi=soft', '-mfloat-abi=softfp', '-mfloat-abi=hard']),
	Dimension->new('^-mfpu=',
		[undef, '-mfpu=vfp', '-mfpu=neon', '-mfpu=vfpv3-d16']),
	Dimension->new('^-march=',
		[undef, '-march=armv5te']),
	Dimension->new('^-O',
		['-O2', '-O3']),
	Dimension->new('\.c$',
		['test.c']),
);


# generic compilation and link flags
my @cflags = ( '-std=gnu99', '-Wall' );
my @ldflags = ( '-static' );

foreach my $point (Dimension::walkDimensions(@dimensions)) {
	my @cmd = (@{$point->{arg}}, @cflags, @ldflags, '-o', $point->{str}.'.out');
	local $, = " ";
	say @cmd;
	system(@cmd);
}
