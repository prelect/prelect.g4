lexer grammar prelectLexer;

channels { COMMENTS, HASHBANG }

BraceOpen: '<';
BraceClose: '>';

ParenOpen: '(';
ParenClose: ')';

TableOpen: '[';
TableClose: ']';

FormulaChar: [-~!@#$%^&*_+=|<\\./?]+ ParenOpen;

Input: '%%%%%';
Model: '%%%%';
Matched: '%%%';
Context: '%%';
Placeholder: '%';
Star: '*';
Bang: '!';
Dot: '.';
Assign: ':';
Comma: ',';
Semicolon: ';';
ParentCall: '\\\\';

Nulll: '~';
TypeCustom: '@';
TypeFormulaic: '@@';
TypeTable: '#';
TypeBoolean: '&';
TypeString: '$';

HexInteger: '-'? '0' [xX] [0-9a-fA-F]+;
OctalInteger: '-'? '0' [0-7]+;
DecimalInteger: '-'? ('0' ~[8-9] | [1-9]+);

Decimal: '-'? [1-9] ('.' [0-9]* Exponent? | [0-9]+ Exponent? | [0-9] Exponent?);

fragment Exponent: [eE] [+-]? [0-9]+;

Name: ([\p{L}_-] [\p{L}\p{N}_-]*) | '"' ~["\r\n\p{Zl}]*  '"';

Ws: [\p{White_Space}] -> skip;

Comment: '##' ~[\r\n\p{Zl}]+ -> channel(COMMENTS);
HashBang: '#!' ~[\r\n\p{Zl}]+ -> channel(HASHBANG);

ANNOTATION_OPEN: '#:' -> pushMode(ANNOTATION);

CurlyOpen: '{' -> pushMode(DEFAULT_MODE);
CurlyClose: '}' -> popMode;

PATH_Relative_Open: '//' -> pushMode(PATH);
PATH_Root_Open: '/' -> pushMode(PATH);
PATH_Parent_Open: '../' -> pushMode(PATH);
PATH_Current_Open: './' -> pushMode(PATH);

PATTERN_Open: '\\' -> pushMode(PATTERN);
LITERAL_OPEN: '\'' -> pushMode(LITERAL);
MESSAGE_OPEN: '`' -> pushMode(MESSAGE);

mode ANNOTATION;
ANNOTATION_CONTENT: (':' ~[#] | ~[:])+;
ANNOTATION_CLOSE: ':#' -> popMode;

mode PATH;
PATH_Name: PATH_Literal+;
PATH_Dig: '//';
PATH_Dir: '/';
PATH_Esc: '\\:';
PATH_FieldEsc: '\\{';
PATH_FieldOpen: '{' -> pushMode(DEFAULT_MODE);
PATH_Literal: PATH_Esc | PATH_FieldEsc | ~[/:{];
PATH_Close: ':' -> popMode;

mode PATTERN;
PATTERN_Part: PATTERN_Literal+;
PATTERN_Esc: '\'\\';
PATTERN_FieldEsc: '\'{';
PATTERN_FieldOpen: '{' -> pushMode(DEFAULT_MODE);
PATTERN_Literal: PATTERN_Esc | PATTERN_FieldEsc | ~[^{\\];
PATTERN_Close: '\\' -> popMode;

mode LITERAL;
L_LiteralPart: L_LiteralLiteral+;
L_LiteralEsc: '\'\'';
L_LiteralFieldEsc: '\'{';
L_LiteralFieldOpen: '{' -> pushMode(DEFAULT_MODE);
L_LiteralLiteral: L_LiteralEsc | L_LiteralFieldEsc | ~['{];
L_LiteralClose: '\'' -> popMode;

mode MESSAGE;
M_MessageEsc: '\'`';
M_MessageContent: (M_MessageEsc | ~[`])+;
M_MessageClose: '`' -> popMode;
