/**
 * Define a grammar called FtiExpr
 */
grammar FtiExpr;

options {

}

@header {

}

CONST_STRING : DQuote ( EscSeq | ~["\r\n\\] )* DQuote	;
NEAR   : N E A R	;
SENTENCE_HEAD : '^' ;
SENTENCE_TAIL : '$' ;
OPT_AND       : '&' ;
OPT_OR        : '|' ;
OPT_NOT       : '-' ;
NUMBER	:
	'0'
	|	[1-9] DecDigit*
	; 

ID: [a-zA-Z] ([a-zA-Z] | DecDigit | '_')*  ;// Identifier   
STRING  : NameChar + ;
WS	: ( Hws | Vws )+ -> skip;
    
contains_param:
	contains_expr 
	|contains_expr ':' fti_optstring
	;
    
fti_optstring :	
          fti_opt
	| fti_opt '&' fti_optstring
	;
	
fti_opt:
    ID  '=' string_value 
	;

/*�߼����㡢���š��򵥱��ʽ*/

/*�������ʽ*/
contains_expr:
       contains_string
     | CONST_STRING '/' NUMBER 
     | func_near_expr
     | '(' contains_expr ')'
     | contains_expr  contains_expr
     | contains_expr OPT_AND contains_expr
     | contains_expr OPT_OR contains_expr
     | contains_expr OPT_NOT contains_expr
	 ;
	 
/*�ַ���ƥ����ʽ*/
contains_string:
       string_value
     | SENTENCE_HEAD string_value
     | SENTENCE_HEAD string_value SENTENCE_TAIL
     | string_value SENTENCE_TAIL
	;	

/*�ַ���ƥ��*/
string_value:
      ID
     | STRING 
     | CONST_STRING
     | NUMBER
     ;
     
/*Near����*/
func_near_expr:
     NEAR '(' '(' near_term_list ')' ',' NUMBER near_order ')'
     ;	 

/*Nearƥ�������һ�������������ִ�������һ�����Ϸ��ԣ����һ��Near����һ�����򱨴�*/
near_term_list:	 near_term 
	 | near_term ',' near_term_list 
	 ;     

/*��ͨ���ַ���ƥ�䣨�Զ�ת��Ϊ����ƥ�䣩����Near����*/
near_term:
     func_near_expr
	 | contains_string
	 ;	 
	 
/*Near�������*/
near_order:	 
	 | ',' NUMBER 
	 ;	 

fragment DQuote : '"'	;
fragment Esc    : '\\'	;

fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];

fragment DecDigits	: DecDigit+	;
fragment DecDigit	: [0-9]		;

fragment HexDigits	: HexDigit+	;
fragment HexDigit	: [0-9a-fA-F]	;

fragment Hws		: [ \t]		;
fragment Vws		: '\r'? [\n\f]	;

fragment NameChar
   : NameStartChar
   | '0'..'9'
   | '_'
   | '\u00B7'
   | '\u0300'..'\u036F'
   | '\u203F'..'\u2040'
   ;
fragment NameStartChar
   : 'A'..'Z' | 'a'..'z'
   | '\u00C0'..'\u00D6'
   | '\u00D8'..'\u00F6'
   | '\u00F8'..'\u02FF'
   | '\u0370'..'\u037D'
   | '\u037F'..'\u1FFF'
   | '\u200C'..'\u200D'
   | '\u2070'..'\u218F'
   | '\u2C00'..'\u2FEF'
   | '\u3001'..'\uD7FF'
   | '\uF900'..'\uFDCF'
   | '\uFDF0'..'\uFFFD'
   ;

fragment UnicodeEsc
	:	'u' (HexDigit (HexDigit (HexDigit HexDigit?)?)?)?
	;

// Any kind of escaped character that we can embed within ANTLR literal strings.
fragment EscSeq
	:	Esc
		( [btnfr"'\\]	// The standard escaped character set such as tab, newline, etc.
		| UnicodeEsc	// A Unicode escape sequence
		| .		// Invalid escape character
		| EOF		// Incomplete at EOF
		)
	;

