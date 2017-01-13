#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp;

my $text = read_file(shift @ARGV);

sub replace_with_numbers
{
    my $is_number = shift;
    my $i = 1;

    while ($text =~ $is_number)
    {
        $text =~ s/$is_number/$i/;
        $i++;
    }
}

replace_with_numbers qr/(?<=\[)NUMBER(?=\])/;
replace_with_numbers qr/NUMBER(?=\.)/;
print $text;
