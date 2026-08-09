#!perl -w

use strict;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More tests => 4;
use Module::Pluggable::Object;

# Default ('alpha'): globally sorted regardless of search_path order
{
    my $finder = Module::Pluggable::Object->new(
        search_path => ["MyTest::Plugin", "MyTest::Extend::Plugin"],
        search_dirs => ["$FindBin::Bin/lib"],
    );
    is_deeply(
        [$finder->plugins],
        [qw(MyTest::Extend::Plugin::Bar MyTest::Plugin::Bar MyTest::Plugin::Foo MyTest::Plugin::Quux::Foo)],
        'default sort_results is alpha',
    );
}

# Explicit 'alpha' is the same as the default
{
    my $finder = Module::Pluggable::Object->new(
        search_path  => ["MyTest::Plugin", "MyTest::Extend::Plugin"],
        search_dirs  => ["$FindBin::Bin/lib"],
        sort_results => 'alpha',
    );
    is_deeply(
        [$finder->plugins],
        [qw(MyTest::Extend::Plugin::Bar MyTest::Plugin::Bar MyTest::Plugin::Foo MyTest::Plugin::Quux::Foo)],
        "sort_results => 'alpha' explicitly",
    );
}

# 'path': results come back in search_path discovery order, not alphabetical
{
    my $finder = Module::Pluggable::Object->new(
        search_path  => ["MyTest::Plugin", "MyTest::Extend::Plugin"],
        search_dirs  => ["$FindBin::Bin/lib"],
        sort_results => 'path',
    );
    is_deeply(
        [$finder->plugins],
        [qw(MyTest::Plugin::Bar MyTest::Plugin::Foo MyTest::Plugin::Quux::Foo MyTest::Extend::Plugin::Bar)],
        "sort_results => 'path' preserves search_path order",
    );
}

# 0: no sort applied at all, but the same set of plugins is still returned
{
    my $finder = Module::Pluggable::Object->new(
        search_path  => ["MyTest::Plugin", "MyTest::Extend::Plugin"],
        search_dirs  => ["$FindBin::Bin/lib"],
        sort_results => 0,
    );
    is_deeply(
        [sort $finder->plugins],
        [qw(MyTest::Extend::Plugin::Bar MyTest::Plugin::Bar MyTest::Plugin::Foo MyTest::Plugin::Quux::Foo)],
        "sort_results => 0 still returns the full unsorted set",
    );
}
