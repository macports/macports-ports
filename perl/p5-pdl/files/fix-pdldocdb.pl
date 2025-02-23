#!/usr/bin/env perl

use strict;
use warnings;

my ( $src_file, $dst_file, $cur_path, $new_path ) = @ARGV;
usage() unless $src_file && $dst_file && -e $src_file;
usage() unless $cur_path && $new_path;

sub usage {
    warn "usage: $0 <input pdldoc.db> <output pdldoc.db>\n";
    warn "          <current path> <path after install>\n";
    warn @_;
    exit 1;
}

my $hash = ensuredb( { File => [$src_file], Scanned => [], } );
fix_directories($hash);
savedb( { Outfile => $dst_file }, $hash );

sub fix_directories {
    my ($hash) = @_;

    for my $key (%$hash) {
        next unless exists $hash->{$key}->{File};
        $hash->{$key}->{File} =~ s{^$cur_path}{$new_path};
    }
}

# Taken from PDL::Doc with minor modifications
sub ensuredb {
    my ($this) = @_;
    while ( my $fi = pop @{ $this->{File} } ) {
        open IN, $fi
          or die "can't open database $fi, scan docs first";
        binmode IN;
        my ( $plen, $txt );
        while ( read IN, $plen, 2 ) {
            my ($len) = unpack "S", $plen;
            read IN, $txt, $len;
            my ($sym, @a) = split chr(0), $txt;
            push @a, '' if @a % 2; # Ensure an even number of elements
            $this->{SYMS}->{$sym} = {@a};
        }
        close IN;
        push @{ $this->{Scanned} }, $fi;
    }
    return $this->{SYMS};
}

sub savedb {
    my ( $this, $hash ) = @_;
    ## my $hash = $this->ensuredb();

    open OUT, ">$this->{Outfile}"
      or die "can't write to symdb $this->{Outfile}";
    binmode OUT;
    while ( my ( $key, $val ) = each %$hash ) {
        next unless scalar(%$val);
        my $txt = "$key" . chr(0) . join( chr(0), %$val );
        print OUT pack( "S", length($txt) ) . $txt;
    }
}

