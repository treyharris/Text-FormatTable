use Test;
BEGIN { plan tests => 2 };
use Text::FormatTable;
ok(1); # If we made it this far, we're ok.

my $table = Text::FormatTable->new('r| l l');
$table->head('a', 'b', 'c');
$table->rule('=');
$table->row('this a test, a nice test', 'oh, cool, a test!', 'yep');
$table->rule;
$table->row('you mean it\'s really a test?', 'yes, it is.', 'z');
$table->rule('=');
my $is = $table->render(15);

my $shouldbe = <<'END';
     a| b     c  
=================
this a| oh,   yep
 test,| cool,    
a nice| a        
  test| test!    
------+----------
   you| yes,  z  
  mean| it       
  it's| is.      
really|          
     a|          
 test?|          
=================
END

ok($is, $shouldbe);
