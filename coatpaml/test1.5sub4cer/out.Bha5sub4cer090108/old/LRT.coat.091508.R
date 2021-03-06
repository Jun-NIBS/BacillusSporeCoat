#LRT use 2 *(loglikelihood1 - loglikelihood2)

#my @Htres = ( 
#"(Bha,(Bpu,(Bli,(Bam,(Bmo,Bsu)))),(Bwe,(Bce,Ban,Bth)));", #H0
#"(Bha,(Bpu,(Bli,(Bam ,(Bmo #1,Bsu #1)))),(Bwe,(Bce,Ban,Bth)));", #H1a
#"(Bha,(Bpu,(Bli,(Bam #1,(Bmo #1,Bsu #1)#1))),(Bwe,(Bce,Ban,Bth)));", #H1b
#"(Bha,(Bpu,(Bli #1,(Bam #1,(Bmo #1,Bsu #1)#1)#1)),(Bwe,(Bce,Ban,Bth)));", #H1c
#"(Bha,(Bpu #1,(Bli #1,(Bam #1,(Bmo #1,Bsu #1)))),(Bwe,(Bce,Ban,Bth)));", #H1d
#"(Bha,(Bpu,(Bli,(Bam,(Bmo,Bsu)))),(Bwe,(Bce,Ban #1,Bth)));", #H2a
#"(Bha,(Bpu,(Bli,(Bam,(Bmo,Bsu)))),(Bwe,(Bce #1,Ban #1,Bth #1)));", #H2b
#"(Bha,(Bpu,(Bli,(Bam,(Bmo,Bsu)))),(Bwe #1,(Bce #1,Ban #1,Bth #1)#1));", #H2c
#"(Bha,(Bpu,(Bli #2,(Bam #2,(Bmo #2,Bsu #2)#2)#2)),(Bwe #1,(Bce #1,Ban #1,Bth #1)#1));", #H3a
#"(Bha,(Bpu #2,(Bli #2,(Bam #2,(Bmo #2,Bsu #2)#2)#2)#2),(Bwe #1,(Bce #1,Ban #1,Bth #1)#1));" #H3b
# "(Bha,(Bpu ,(Bli,(Bam ,(Bmo ,Bsu )) ) ),(Bwe #2,(Bce #2,Ban #1,Bth #2)#2) );", #H3c
# "(Bha,(Bpu ,(Bli#3, (Bam #3,(Bmo #3 ,Bsu #3)#3) #3) ),(Bwe #2,(Bce #2,Ban #1,Bth #2)#2) );" #H4a
#);

 tb = read.table( "out.Bha5sub4cer090108.csv", header=F
 #   colClasses=c("chr","chr","int","chr","chr","num","num")
  );
 tb[,1] = as.character( tb[,1] );

 bgs = unique( tb[,1]);

 labels = c("bg","p.H0.H1a", "p.H0.H1b","p.H0.H1c","p.H0.H1d","p.H0.H2a","p.H0.H2b","p.H0.H2c", "p.H1c.H3a","pH2c.H3a","p.H2c.H3b", "p.H2a.H3c", "p.H3c.H4a", "p.H0.H3a", "p.H0.3b", "p.H0.H3c");
 out = data.frame( matrix(nrow=length(bgs), ncol=length(labels) )); 
 names( out ) = labels;
 out$bg = bgs;

 for( j in 1:length(bgs) ) {
  bg = bgs[j];
  sub = tb[ tb[,1] == bg,]
  for( i in 2:8 ) {
    out[ out$bg==bg,i] = round( pchisq( 2*(sub[i,6] - sub[1,6]), df=1,low=F), 4); ##??
  }

  for( i in 9:11 ) {
    out[ out$bg==bg,i+5] = round( pchisq( 2*(sub[i,6] - sub[1,6]), df=2,low=F), 4); ##??
  }


  i=9 #"p.H1c.H3a",
  out[ out$bg==bg,i] = round( pchisq( 2*(sub[i,6] - sub[4,6]), df=1,low=F), 4); ##??
  i=9  #"pH2c.H3a",
  out[ out$bg==bg,i+1] = round( pchisq( 2*(sub[i,6] - sub[8,6]), df=1,low=F), 4); ##??  

  i=10; # "p.H2c.H3b"
  out[ out$bg==bg,i+1] = round( pchisq( 2*(sub[i,6] - sub[8,6]), df=1,low=F), 4); ##??
  i=11; # "p.H2a.H3c"
  out[ out$bg==bg,i+1] = round( pchisq( 2*(sub[i,6] - sub[6,6]), df=1,low=F), 4); ##??
  i=12; # "p.H3c.H4a"
  out[ out$bg==bg,i+1] = round( pchisq( 2*(sub[i,6] - sub[11,6]), df=1,low=F), 4); ##??


  ps = (out[j,2:16] < 0.01)
  x = ps[ps==TRUE]
  out$sig[j] = length(x);
  #out$sig[j] = ifelse( min(out[j,2:8])<0.05, 1 ,0 )
}

out2 = out;
for( row in 1:length(out2[,1]) ){
  for ( col in 2:16 ) {
    out2[row,col] = ifelse( out[row,col]< 0.05, out[row,col], '');
  }
  tmp1 = ifelse( (out[row,"p.H0.H1c"] < 0.05) & (out[row,"p.H1c.H3a"] < 0.05 ), 1, 0)
  tmp2 = ifelse( (out[row,"p.H0.H2c"] < 0.05) & (out[row,"p.H2c.H3a"] < 0.05 ), 1, 0)
  tmp3 = ifelse( (out[row,"p.H0.H2c"] < 0.05) & (out[row,"p.H2c.H3b"] < 0.05 ), 1, 0)
  tmp = c(tmp1, tmp2, tmp3);
  out2$flag[row] = sum( tmp );
}

out3 = out2[out2$flag>0,]
write.csv(out3, "chisq.coat.Bha5sub4cer.091508.small.csv")

out2 = out;
for( row in 1:length(out2[,1]) ){
  for ( col in 2:16 ) {
    out2[row,col] = ifelse( out[row,col]< 0.05, out[row,col], '');
  }
}

out2;

idtab = read.table("/home/hqin/coat.protein07/key.data/BGcoat.csv", header=T, sep="\t");
idtab$NCBI = as.character( idtab$NCBI );
idtab$Gene = as.character( idtab$Gene );

out2$name = idtab$Gene[ match( out2$bg, idtab$NCBI) ];

write.csv(out2, "chisq.coat.Bha5sub4cer.091508.csv")


q("yes");

