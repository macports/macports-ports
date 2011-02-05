#!/usr/bin/env perl

# This script recompiles CSS::Parse::CompiledGrammar because of an uncorrected
# bug in CSS 1.08 spawned by an old Parse::RecDescent bug. See
# https://rt.cpan.org/Public/Bug/Display.html?id=53948
#
# Script by paul@city-fan.org (found in the bug ticket referenced above)
# and included in the MacPorts Project port p5-css by Larry Gilbert
# <l2g@macports.org>.

use Parse::RecDescent;
use CSS::Parse::PRDGrammar;
$Parse::RecDescent::skip = '';
$::RD_AUTOACTION = 'print "token: ".shift @item; print " : @item\n"';
Parse::RecDescent->Precompile($CSS::Parse::PRDGrammar::GRAMMAR, "CSS::Parse::CompiledGrammar");
