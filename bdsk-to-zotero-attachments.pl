#!/usr/bin/perl
#
#bdsk-zotero-attachments.pl
#converts 1 BibTeX file to another BibTeX file that can be imported into Zotero with its attachments intact.
#020130205 Peter M. Carlton (pcarlton@icems.kyoto-u.ac.jp)
#Licensed under CC attribution-sharealike http://creativecommons.org/licenses/by-sa/3.0/

use strict;
use warnings;

my $fname = shift;
my $newname=shift;

my $basedir=`dirname $fname`;
chomp($basedir);
my $tmpname="/tmp/b64.encoded";
open IN,$fname;
open OUT,">$newname";
foreach my $line (<IN>) {
open TMP,">$tmpname";
chomp($line);
    if ($line =~ /Bdsk-File/) {
        my $extrabracket=($line =~ /}}/)?1:0;
        my $comma=($line =~ /},/)?1:0;
        my $num=$line;$num =~ s/.*Bdsk-File-//;$num =~ s/\s.*//;
        $line =~ s/.*{//;
        $line =~ s/}.*//;
#       $line =~ s/==/=/;
        print TMP $line;
        system("base64 -D -i $tmpname -o $tmpname.dec");
        system("plutil -convert xml1 $tmpname.dec");
my $decoded=`grep -A 3 relative $tmpname.dec | tail -n 2 | head -n 1`;
        my $testtype=$decoded;$testtype=~s/<string>//;$testtype=~s/<\/string>//;$testtype=~s/\t//g;$testtype=$basedir.'/'.$testtype;
        chomp $testtype;
        $decoded =~ s/<string>/Local-Zo-Url-$num = {$basedir\//;
        $decoded =~ s/<\/string>/}/;
        chomp($decoded);
        $decoded .= "," if $comma;
        if (-d $testtype) {print "Ignoring attached directory $testtype\n";}
        print OUT $decoded,"\n" unless -d $testtype;
        print OUT "}" if $extrabracket;
    }
    else {
      print OUT $line,"\n";
    }
    close TMP;
  }

close IN;
close OUT;
