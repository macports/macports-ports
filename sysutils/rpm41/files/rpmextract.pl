#!/usr/bin/perl

##
# rpmextract.pl - pure Perl extracter for RPM (or SRPM) packages
# Shantonu Sen - <ssen@opendarwin.org>
#
# Based on rpm2cpio.sh, from the RPM 4.1.x distribution. That script
# depends on non-portable od(1) presence and syntax
##

use strict;
use Fcntl qw(:seek :DEFAULT);

my $file;

if($#ARGV == -1) {
    $file = *STDIN;
} else {
    sysopen($file, $ARGV[0], O_RDONLY) || die("Can't open input $ARGV[0]");
}

binmode($file);

sysseek($file, 104, SEEK_CUR) || die("Can't seek on input");

my $buffer;

sysread($file, $buffer, 4) || die("Can't read from input");
my $il = unpack("N", $buffer);

sysread($file, $buffer, 4) || die("Can't read from input");
my $dl = unpack("N", $buffer);

#print STDERR "sig il: $il dl $dl\n";

my $sigsize=8 + 16*$il + $dl;
my $o=$sigsize+(8- ($sigsize % 8)) % 8;

sysseek($file, $o, SEEK_CUR) || die("Can't seek on input");

sysread($file, $buffer, 4) || die("Can't read from input");
my $il = unpack("N", $buffer);

sysread($file, $buffer, 4) || die("Can't read from input");
my $dl = unpack("N", $buffer);

#print STDERR "hdr il: $il dl $dl\n";

my $hdrsize=16*$il+$dl;

sysseek($file, $hdrsize, SEEK_CUR) || die("Can't seek on input");

my $loc = sysseek($file, 0, SEEK_CUR);
#print STDERR "Location is $loc\n";

my $bs=4096;
while($bs > 0) {
    $bs = sysread($file, $buffer, $bs);
    syswrite(STDOUT, $buffer);
}
