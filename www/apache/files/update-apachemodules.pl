#!/opt/local/bin/perl
# 
# update-apachemodules.pl - Apache module installation for darwinports
# Copyright (C) Benoit Chesneau <bchesneau@mac.com>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. 
#
#




require 5.003;
use strict;
no strict 'vars';


#
# config var
#

my 	$prefix			=	"__PREFIX";
my	$modules_path	=	"libexec/__NAME";
my	$modulesd_path	=	"etc/__NAME/modules.d";
my	$config_path	=	"etc/__NAME";
my	$config_file	=	"httpd.conf";


#
# main
#

my $file='';
my %modconf;
my @lmd = ();
my @amd = ();
my @imd = ();



#parse files
opendir (REP, "$prefix/$modulesd_path") or die " $modulesd_path doesn't exist";
while (defined ($file = readdir(REP))) {
	next if $file=~ /^\.\.?$/;
	%modconf = parse_conffile($file);
	
	if ($modconf{'name'}) {
		
		my $cname='';
		if ((!$modconf{'cname'}) || ($modconf{'cname'} eq '')) {
			$cname='mod_' . $modconf{'name'} . '.c';
		} else {
			$cname=$modconf{'cname'};
		}
		
		if (($modconf{'load'}) && ($modconf{'load'} eq 'no')) {
			push (@lmd, sprintf('#LoadModule %-18s %s', $modconf{'name'} . "_module",  "$modules_path/" . $modconf{'dso_name'} . ".so"));
			push (@amd, sprintf('#AddModule %s', $cname));
		} else {
			push (@lmd, sprintf('LoadModule %-18s %s',$modconf{'name'} . "_module", "$modules_path/" . $modconf{'dso_name'} . ".so"));
			push (@amd, sprintf('AddModule %s', $cname));
		}
		
		if ($modconf{'conf_file'}) {
			push (@imd, sprintf("Include '$prefix/$config_path/extras-conf/%s'", $modconf{'conf_file'}));
		}
	}
		
	
	print "Parsed " . $modconf{"name"} . "\n";
}
closedir (REP);


# activate modules (code based on apache apxs)

if (not -f "$prefix/$config_path/$config_file") {
	print STDERR "Error: Config file $config_file not foud!\n";
	exit(1);
}

open (FP, "< $prefix/$config_path/$config_file") or die "can't open $config_file \n";
my $content = join ('', <FP>);
close (FP);

if ($content !~ m|\n#?\s*LoadModule\s+|) {
	print STDERR "Error: Activation failed for custom $config_file file.\n";
	print STDERR "Error: At least one `LoadModule' directive already has to exist.\n";
	exit(1);
}

foreach $lmd (@lmd) {
	
	print $lmd . "\n";
	if (substr($lmd,0,1) eq "#") {
		substr($lmd, 0, 1) = "";
		$c = '#';
	}
	
	
	if ($content !~ m|\n#?\s*$lmd|) {
		# check for open <containers>, so that the new LoadModule
		# directive always appears *outside* of an <container>.

		my $before = ($content =~ m|^(.*\n)#?\s*LoadModule\s+[^\n]+\n|s)[0];

		# the '()=' trick forces list context and the scalar
		# assignment counts the number of list members (aka number
		# of matches) then
		my $cntopen = () = ($before =~ m|^\s*<[^/].*$|mg);
		my $cntclose = () = ($before =~ m|^\s*</.*$|mg);

		if ($cntopen == $cntclose) {
		    # fine. Last LoadModule is contextless.
		    $content =~ s|^(.*\n#?\s*LoadModule\s+[^\n]+\n)|$1$c$lmd\n|s;
		} elsif ($cntopen < $cntclose) {
		    print STDERR 'Configuration file is not valid. There are '
				 . "sections closed before opened.\n";
		    exit(1);
		} else {
		    # put our cmd after the section containing the last
		    # LoadModule.
		    my $found =
		    $content =~ s!\A (               # string and capture start
				  (?:(?:
				    ^\s*             # start of conf line with a
				    (?:[^<]|<[^/])   # directive which does not
						     # start with '</'

				    .*(?:$)\n        # rest of the line.
						     # the '$' is in parentheses
						     # to avoid misinterpreting
						     # the string "$\" as
						     # perl variable.

				    )*               # catch as much as possible
						     # of such lines. (including
						     # zero)

				    ^\s*</.*(?:$)\n? # after the above, we
						     # expect a config line with
						     # a closing container (</)

				  ) {$cntopen}       # the whole pattern (bunch
						     # of lines that end up with
						     # a closing directive) must
						     # be repeated $cntopen
						     # times. That's it.
						     # Simple, eh? ;-)

				  )		  # capture end
				 !$1$c$lmd\n!mx;

		    unless ($found) {
		        print STDERR 'Configuration file is not valid. There '
				     . "are sections opened and not closed.\n";
		        exit(1);
		    }
		}
	} else {
		# replace already existing LoadModule line
		$content =~ s|^(.*\n)#?\s*$lmd[^\n]*\n|$1$c$lmd\n|s;
    }
   	$lmd =~ m|LoadModule\s+(.+?)_module.*|;
    #print STDERR "[$what module `$1' in $config_file]\n";
       
}

my $amd;
foreach $amd (@amd) {
	if (substr($amd,0,1) eq "#") {
		substr($amd, 0, 1) = "";
		$c = '#';
	}
	
	if ($content !~ m|\n#?\s*$amd|) {
		# check for open <containers> etc. see above for explanations.

		my $before = ($content =~ m|^(.*\n)#?\s*AddModule\s+[^\n]+\n|s)[0];
		my $cntopen = () = ($before =~ m|^\s*<[^/].*$|mg);
		my $cntclose = () = ($before =~ m|^\s*</.*$|mg);

		if ($cntopen == $cntclose) {
		    $content =~ s|^(.*\n#?\s*AddModule\s+[^\n]+\n)|$1$c$amd\n|s;
		} elsif ($cntopen < $cntclose) {
		    # cannot happen here, but who knows ...
		    print STDERR 'Configuration file is not valid. There are '
				 . "sections closed before opened.\n";
		    exit(1);
		} else {
		    unless ($content =~ s!\A((?:(?:^\s*(?:[^<]|<[^/]).*(?:$)\n)*
					  ^\s*</.*(?:$)\n?){$cntopen})
					 !$1$c$amd\n!mx) {
			# cannot happen here, anyway.
			print STDERR 'Configuration file is not valid. There '
				     . "are sections opened and not closed.\n";
			exit(1);
		    }
		}
	} else {
		# replace already existing AddModule line
		$content =~ s|^(.*\n)#?\s*$amd[^\n]*\n|$1$c$amd\n|s;
	}
}
	

my $imd;
foreach $imd (@imd) {
	if ($content !~ m|\n#?\s*$imd|) {
		$content .= $imd;
	}
}


	
	
if (@lmd or @amd) {
	if (open(FP, "> $prefix/$config_path/$config_file.new")) {
		print FP $content;
		close(FP);
		
		system ("cp $prefix/$config_path/$config_file $prefix/$config_path/$config_file.bak");
		system ("cp $prefix/$config_path/$config_file.new $prefix/$config_path/$config_file");
		#push(@cmds, "del \"$prefix/$config_path/$config_file.new\"");
	} else {
	    print STDERR "Error: unable to open configuration file\n";
    }
}
#
# subs
#


sub parse_conffile () {
	$file = shift;
	my %data;
	
	open (CONFFILE, "$prefix/$modulesd_path/$file") or die "can't open $file \n";
	while (<CONFFILE>) {
		chomp;
		s/#.*//;
		s/^\s+//;
		s/\s+$//;
		next unless length;
		my ($k,$v) = split(/\s*=\s*/,$_, 2);
		$data{$k}=$v;
	}
	close (CONFFILE)	;
	return %data;	
			
}



