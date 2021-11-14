
package College;

use strict;
use warnings qw(all);

sub new { 
  my( $type ) = shift(@_);

  my $self = { @_ };

  return bless( $self, $type );

} # new

1;

__END__
  
