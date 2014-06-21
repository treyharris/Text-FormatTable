use Test;
BEGIN { plan tests => 5 };
use Text::FormatTable;
ok(1); # If we made it this far, we're ok.

use strict;
use warnings;
use utf8;

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
      a| b       c  
====================
 this a| oh,     yep
test, a| cool, a    
   nice| test!      
   test|            
-------+------------
    you| yes, it z  
   mean| is.        
   it's|            
 really|            
a test?|            
====================
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

# rt34546, warnings when column has zero length
{
    my $warning;
    local $SIG{__WARN__} = sub { $warning = $_[0] };
    
    my $table = Text::FormatTable->new('l l');
    $table->head('foo', q{});
    my $output = $table->render();
    ok(not defined $warning);
}

# line folding using Text::LineFold
{
    my @format = (' 14l ', ' 20L ', ' 30r ', ' 40R ');
    my $table  = Text::FormatTable->new( '|' . ( join '|', @format ) . '|' );
    my @text   = ();
    push @text,
q(This document is intended to give you a quick overview of the Perl programming language, along with pointers to further documentation. It is intended as a "bootstrap" guide for those who are new to the language, and provides just enough information for you to be able to read other peoples' Perl and understand roughly what it's doing, or write your own simple scripts.);
    push @text,
q(この文書は Perl プログラミング言語の簡単な概要を伝えて、更なる 文書へのポインタを示すことを目的としています。 これはこの言語を知らない人のためへの「自習」ガイドを目的としていて、 他の人の Perl を読んで何をしているかを大まかに理解したり、 自分自身で簡単なスクリプトを書くことができるようになるために 十分な情報を提供しています。);
    $table->rule('-');
    $table->head(@format);
    foreach my $text (@text) {
        $table->rule('-');
        $table->row( map { $text } ( 0 .. $#format ) );
    }
    $table->rule('-');
    my $is       = $table->render();
    my $shouldbe = <<'END';
+----------------+----------------------+--------------------------------+------------------------------------------+
| 14l            | 20L                  |                            30r |                                      40R |
+----------------+----------------------+--------------------------------+------------------------------------------+
| This document  |                      |   This document is intended to |                                          |
| is intended to |                      |   give you a quick overview of |                                          |
| give you a     |                      | the Perl programming language, |                                          |
| quick overview |                      | along with pointers to further |                                          |
| of the Perl    |                      |  documentation. It is intended |                                          |
| programming    |                      |     as a "bootstrap" guide for |                                          |
| language,      |                      |       those who are new to the |                                          |
| along with     |                      |    language, and provides just |                                          |
| pointers to    |                      |  enough information for you to |                                          |
| further        |                      | be able to read other peoples' |                                          |
| documentation. |                      |    Perl and understand roughly |                                          |
| It is intended | This document is     | what it's doing, or write your |                                          |
| as a           | intended to give you |            own simple scripts. |                                          |
| "bootstrap"    | a quick overview of  |                                |                                          |
| guide for      | the Perl programming |                                |                                          |
| those who are  | language, along with |                                |                                          |
| new to the     | pointers to further  |                                |                                          |
| language, and  | documentation. It is |                                |                                          |
| provides just  | intended as a        |                                |                                          |
| enough         | "bootstrap" guide    |                                |                                          |
| information    | for those who are    |                                |                                          |
| for you to be  | new to the language, |                                |  This document is intended to give you a |
| able to read   | and provides just    |                                |   quick overview of the Perl programming |
| other peoples' | enough information   |                                | language, along with pointers to further |
| Perl and       | for you to be able   |                                |       documentation. It is intended as a |
| understand     | to read other        |                                |  "bootstrap" guide for those who are new |
| roughly what   | peoples' Perl and    |                                |       to the language, and provides just |
| it's doing, or | understand roughly   |                                | enough information for you to be able to |
| write your own | what it's doing, or  |                                |  read other peoples' Perl and understand |
| simple         | write your own       |                                |   roughly what it's doing, or write your |
| scripts.       | simple scripts.      |                                |                      own simple scripts. |
+----------------+----------------------+--------------------------------+------------------------------------------+
| この文書は     |                      | この文書は Perl プログラミング |                                          |
| Perl プログラ  |                      | 言語の簡単な概要を伝えて、更な |                                          |
| ミング言語の簡 |                      |  る 文書へのポインタを示すこと |                                          |
| 単な概要を伝え |                      |  を目的としています。 これはこ |                                          |
| て、更なる 文  |                      |   の言語を知らない人のためへの |                                          |
| 書へのポインタ |                      |   「自習」ガイドを目的としてい |                                          |
| を示すことを目 |                      |  て、 他の人の Perl を読んで何 |                                          |
| 的としていま   | この文書は Perl プロ | をしているかを大まかに理解した |                                          |
| す。 これはこ  | グラミング言語の簡単 |  り、 自分自身で簡単なスクリプ |                                          |
| の言語を知らな | な概要を伝えて、更な | トを書くことができるようになる |                                          |
| い人のためへの | る 文書へのポインタ  |  ために 十分な情報を提供してい |                                          |
| 「自習」ガイド | を示すことを目的とし |                         ます。 |                                          |
| を目的としてい | ています。 これはこ  |                                |                                          |
| て、 他の人の  | の言語を知らない人の |                                |                                          |
| Perl を読んで  | ためへの「自習」ガイ |                                |                                          |
| 何をしているか | ドを目的としていて、 |                                | この文書は Perl プログラミング言語の簡単 |
| を大まかに理解 | 他の人の Perl を読ん |                                |  な概要を伝えて、更なる 文書へのポインタ |
| したり、 自分  | で何をしているかを大 |                                |  を示すことを目的としています。 これはこ |
| 自身で簡単なス | まかに理解したり、   |                                | の言語を知らない人のためへの「自習」ガイ |
| クリプトを書く | 自分自身で簡単なスク |                                |  ドを目的としていて、 他の人の Perl を読 |
| ことができるよ | リプトを書くことがで |                                | んで何をしているかを大まかに理解したり、 |
| うになるために | きるようになるために |                                | 自分自身で簡単なスクリプトを書くことがで |
| 十分な情報を提 | 十分な情報を提供して |                                |  きるようになるために 十分な情報を提供し |
| 供しています。 | います。             |                                |                               ています。 |
+----------------+----------------------+--------------------------------+------------------------------------------+
END
    ok( $is, $shouldbe );
}
