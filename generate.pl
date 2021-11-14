#!/bin/env perl 

use lib qw(.);

use College;
use Data::Dumper;
use FileHandle;
use Text::CSV;

use Getopt::Long;

my $options = {};

sub WriteDraft { 
  my( $name, $text ) = @_;

  $name =~ s/\s//g;

  my $filename = sprintf( "%s/%s.txt\n", $options->{'outdir'}, $name );

  my $fh = FileHandle->new(">$filename") 
    or die sprintf( "Error: Unable to write file %s\n", $filename );

  $fh->printf( "%s\n", $text );

  $fh->close();

  return;

} # WriteDraft

sub Draft { 
  my( $college, $update, $link, $ending ) = @_;

  my $text;

  my $update = `/bin/cat $options->{'update'}`;

  chomp($update);

  if ( $college->{'asst'} ) { 
    $text .= sprintf( "Dear Coaches %s, %s\n", $college->{'head'}, $college->{'asst'} );

  } else { 
    $text .= sprintf( "\n" );
    $text .= sprintf( "Dear Coach %s\n", $college->{'head'} );

  } 

  $text .= sprintf( "\n" );
  $text .= sprintf( "%s\n", $update );

    # include <link>

  if ( $link ) { 

    $text .= sprintf( "\n" );
    $text .= sprintf( "  %s\n", $link );
    $text .= sprintf( "\n" );

  } # if ( $link )

    # concatenate <ending>

  my $ending = `/bin/cat $options->{'ending'}`;
  chomp($ending);

  if ( $options->{'nickname'} ) { 

    unless ( $college->{'nickname'} =~ /s$/o ) { 
      $college->{'nickname'} .= 's';
    } 

    $ending .= sprintf( " Go %s!", $college->{'nickname'} );

  } # if ( $options->{'nickname'} )

  $text .= $ending;

  WriteDraft( $college->{'name'}, $text );

  return;

} # Draft

sub main { 

  GetOptions(
    'ending=s' => \$options->{'ending'},
    'link=s'   => \$options->{'link'},
    'nickname' => \$options->{'nickname'},
    'outdir=s' => \$options->{'outdir'},
    'update=s' => \$options->{'update'},
  );
  
  unless ( -f $options->{'update'} ) { 
    die sprintf( "Error: No intro file provided\n" );
  }
  
  unless ( -f $options->{'ending'} ) { 
    die sprintf( "Error: No ending file provided\n" );
  }
  
  unless ( $options->{'outdir'} ) { 
    die sprintf( "Error: No directory provided\n" );
  } 
  
  if ( -d $options->{'outdir'} ) { 
    my $cmdbuf = sprintf( "/bin/rm -rf %s", $options->{'outdir'} );
    printf( "exec: %s\n", $cmdbuf );
    system($cmdbuf);
  } 

  unless ( mkdir( $options->{'outdir'}, 0777 ) ) { 
    die sprintf( "Error: Unable to create directory: %s\n", $options->{'outdir'} );
  } 

  my $filename = '/Users/frazerworley/Desktop/Colleges.csv';

  my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });

  open my $fh, "<:encoding(utf8)", $filename or die "test.csv: $!";

  while ( my $row = $csv->getline($fh) ) {

    next unless ( $row->[0] );

    my $college = 
      College->new(
        'name'       => $row->[0],
        'nickname'   => $row->[1],
        'head'       => $row->[2],
        'head_email' => $row->[3],
        'asst'       => $row->[4],
        'asst_email' => $row->[5]
      );

    Draft( $college, $options->{'update'}, $options->{'link'}, $options->{'ending'} );

  } # while ( my $row = $csv->getline($fh) )

  close $fh;

} # main 

main();

