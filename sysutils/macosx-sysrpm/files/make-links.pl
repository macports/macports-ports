#!/usr/bin/perl

my $outputdir = shift @ARGV;

foreach my $path (@ARGV) {

    if($path =~ m/^-F(.*)$/) {
	my $frameworkdir = $1;
	opendir(DIR, $frameworkdir) || die("Could not open $frameworkdir: $!");

	@frameworks = readdir(DIR);
	closedir(DIR);

	@frameworks = map { s/\.framework$//; $_; } @frameworks;

	foreach my $f (@frameworks) {
	    if($f eq "." || $f eq "..") { next; }

	    my $install_name = `otool -DX $frameworkdir/$f.framework/$f` || next;
	    chomp $install_name;

	    print "$install_name\n";
	    system("ln -sf $install_name $outputdir/$f");

	}

    } if($path =~ m/^-L(.*)$/) {
        my $libdir = $1;
        print "libdir $libdir\n";
	opendir(DIR, $libdir) || die("Could not open $libdir: $!");

	@libs = readdir(DIR);
	closedir(DIR);

	@libs = map { s/\.dylib$// &&  $_ ; } @libs;

	foreach my $f (@libs) {
	    if($f eq "." || $f eq ".." || $f eq "") { next; }

	    my $install_name = `otool -DX $libdir/$f.dylib` || next;
	    chomp $install_name;

	    print "$install_name\n";
	    system("ln -sf $install_name $outputdir/$f.dylib");

	}
    }

}
