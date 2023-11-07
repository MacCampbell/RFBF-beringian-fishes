#! /usr/bin/perl -w

my $sep ="/t";
my $length = 500; #minimum seq len

my $infile=shift;
my @result = ReadInFasta($infile);

foreach my $seq (@result) {
  my @a = split("/t", $seq);
  my $len =length($a[1]);
  if ($len > $length) {
      print ">$a[0]\n$a[1]\n";
  }
}

sub ReadInFasta{
    my $infile = shift;
    my @line;
    my $i = -1;
    my @result = ();
    my @seqName = ();
    my @seqDat = ();

    open (INFILE, "<$infile") || die "Can't open $infile\n";

    while (<INFILE>) {
        chomp;
        if (/^>/) {  # name line in fasta format
            $i++;
            s/^>\s*//; s/^\s+//; s/\s+$//;
            $seqName[$i] = $_;
            $seqDat[$i] = "";
        } else {
            s/^\s+//; s/\s+$//;
            s/\s+//g;                  # get rid of any spaces
            next if (/^$/);            # skip empty line
            s/[uU]/T/g;                  # change U to T
            $seqDat[$i] = $seqDat[$i] . uc($_);
        }

        # checking no occurence of internal separator $sep.
        die ("ERROR: \"$sep\" is an internal separator.  Line $. of " .
             "the input FASTA file contains this charcter. Make sure this " . 
             "separator character is not used in your data file or modify " .
             "variable \$sep in this script to some other character.\n")
            if (/$sep/);

    }
    close(INFILE);

    foreach my $i (0..$#seqName) {
        $result[$i] = $seqName[$i] . $sep . $seqDat[$i];
    }
return (@result);
}

