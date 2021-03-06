#!/usr/bin/perl -w
#parse_gencode.pl

my $gtf = shift @ARGV;
my $keepfile = shift @ARGV;
my %keep;
if ($keepfile) {
    open KP, "<$keepfile" or die $!;
    while (my $line = <KP>) {
	chomp($line);
	$inc{$line} = 1;
    }
}
open OUT, ">genenames.txt" or die $!;
print OUT join("\t",'chrom','start','end','ensembl','symbol','type'),"\n";
open GCODE, "<$gtf" or die $!;
while (my $line = <GCODE>) {
    chomp($line);
    next if ($line =~ m/^#/);
    my ($chrom,$source,$feature,$start,$end,$filter,$phase,$frame,$info) = 
	split(/\t/,$line);
    next unless ($feature eq 'gene');
    $info =~ s/\"//g;
    my %hash;
    foreach $a (split(/;\s*/,$info)) {
	my ($key,$val) = split(/ /,$a);
	$hash{$key} = $val;
    }
    $hash{gene_id} =~ s/\.\d+//;
    if ($keepfile) {
	next unless $inc{$hash{gene_name}};
    }
    print OUT join("\t",$chrom,$start,$end,$hash{gene_id},$hash{gene_name},$hash{gene_type}),"\n";
}
