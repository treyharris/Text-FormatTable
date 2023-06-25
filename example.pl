use strict;
use warnings;

use lib 'lib';

use Term::ANSIColor;
use Text::FormatTable;

{
  my $table = Text::FormatTable->new('r|l');
  $table->head('a', 'b');
  $table->rule('=');
  $table->row('this a test, a nice test', 'a test!');
  $table->rule;
  $table->row('you mean it\'s really a test?', 'yep');
  $table->rule('=');
  print $table->render(20);
}

print "\n", "-" x 78, "\n\n";


{
  my $table = Text::FormatTable->new('r|l');
  $table->head('a', 'b');
  $table->rule('=');
  $table->row(
    'this a ' . colored(['bright_blue'], 'test, a nice') . ' test',
    'a test you can count on!',
  );
  $table->rule;
  $table->row('you mean it\'s really a test?', 'yep');
  $table->rule('=');
  print $table->render(20);
}
