use Test;
BEGIN { plan tests => 4 };
use Text::FormatTable;
ok(1); # If we made it this far, we're ok.

{
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
}

# Test behavior with ANSI-colored header
{
    my $colortable = Text::FormatTable->new('l l l');
    my $RED = "\e[31m";
    my $RESET = "\e[0m";
    $colortable->head('foo', $RED . 'bar' . $RESET, 'bat');
    $colortable->rule('=');
    $colortable->row(qw(a b c));
    my $output = $colortable->render();
    my ($rule) = ($output =~ /(=+)/);
    ok(length($rule), length("foo bar bat"));
}

# Test behavior with ANSI-colored row data
{
    my $colortable = Text::FormatTable->new('l l l');
    my $RED = "\e[31m";
    my $RESET = "\e[0m";
    $colortable->head('foo', 'bar', 'bat');
    $colortable->rule('=');
    $colortable->row('a', $RED . 'b' . $RESET, 'c');
    my $output = $colortable->render();
    my ($rule) = ($output =~ /(=+)/);
    ok(length($rule), length("foo bar bat"));
}
