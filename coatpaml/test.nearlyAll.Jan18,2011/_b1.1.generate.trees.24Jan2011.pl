#generate taxon -> tree hash

use strict; use warnings; 

BEGIN {
    push(@INC,"/home/hqin/lib/perl/", "/Users/hongqin/lib/perl");
};

my $HOME = $ENV{'HOME'};   #$print "\$HOME=$HOME\n"; 
#use lib '/Users/hongqin/lib/perl'; 
use Util; use FASTAshort; 
my $debug= 10 ;
use Bio::TreeIO;

open(IN,"<labeled.trees.v2.nwk"); my @lines = <IN>; close (IN);
my @labeledLines = @lines; 
open(OUT, ">_t2.nwk");
foreach my $line (@lines) {
  chomp $line; 
  $line =~ s/\;\s+$/\;\n/g; #remove extra space after semicolon
  $line =~ s/\#\d+//g; #branch labels
  #$line =~ s/\s+//g; #remove extrace 
  my $rightnum = $line =~ tr/\)/\)/; 
  my $leftnum  = $line =~ tr/\(/\(/;
  if ($rightnum == $leftnum) { 
     print OUT $line."\n"; 
   } else {
     print "\nuneven tree::$line \n"; exit; 
   }
}
close(OUT);

#my $treeio = Bio::TreeIO->new(-format => 'newick', -file =>'truncated2.nwk');
my $treeio = Bio::TreeIO->new(-format => 'newick', -file =>'_t2.nwk');  #THIS DOES NOT WORK? bioperl cannot parse labeled branches?
#my $tree = $treeio->next_tree;
#my $out = Bio::TreeIO->new(-file => '>_test', -format => 'tabtree');

my %taxons2tree; 

my $count = 0; 
while( my $tree = $treeio->next_tree ) {
   #$out->write_tree($tree);
   my @nodes = $tree->get_nodes(-order => 'b|breadth' );
   my @leaves = $tree->get_leaf_nodes; 
   my $number_nodes = $tree->number_nodes; 
 
  #foreach my $node ( @nodes) {
  #   #print OUT $node->id.', ';      #.$node->to_string()." ,"; 
  # } 

   #print OUT "Tree $count:";
   my @lnids;
   foreach my $ln (@leaves){
     my $tmp = $ln->id; 
     $tmp =~ s/\s+//g; #remove spaces
     push (@lnids, $tmp); 
     # @lnids = sort @lnids; 
   }
   @lnids = order_big2small_array( @lnids);

   if($debug) {
     print ">\$count=$count $labeledLines[$count] \@leaves(@lnids)\n"; 
   }                        

   my $longline = $lnids[0]; 
   foreach my $i (1 .. $#lnids ) {
      $longline .= ":$lnids[$i]";
   }
   if (! exists($taxons2tree{$longline}) ) {
     chomp $labeledLines[$count]; 
     $taxons2tree{$longline} = $labeledLines[$count];   ####  match two files, not a good idea. 
   } else {
      print "Duplicates: $count: $lines[$count]\n; "
   }
   $count = $count + 1; 
}	 

showHashTable(\%taxons2tree);
write_hash2file(\%taxons2tree, "_taxon-tree.hash.b.tab", "\t");

exit;