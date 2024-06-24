lexer grammar prelectLexer;

channels { COMMENTS, ANNOTATIONS, HASHBANG }

BraceOpen: '<';
BraceClose: '>';

ParenOpen: '(';
ParenClose: ')';

TableOpen: '[';
TableClose: ']';

FormulaChar: ('..' | [-~!@#$%^&_+*=<>?/]+) ParenOpen;

Input: '%%%%';
Model: '%%%';
Caught: '%%';
Placeholder: '%';
Star: '*';
Bang: '!';
Assign: ':';
CommaPipe: ',';
SemicolonPipe: ';';
ParentCall: '\\\\';

Nulll: '~';
TypeCustom: '@';
TypeFormulaic: '@@';
TypeTable: '#';
TypeBoolean: '&';
TypeString: '$';

HexInteger: '-'? '0' [xX] HexDigit (HexDigit | ',')*;
OctalInteger: '-'? '0' OctalDigit (OctalDigit | ',')*;
DecimalInteger: '0' | [1-9] (DecimalDigit | ',')* | DecimalDigit+ ExponentPart;

DecimalSigned: '-'? DecimalInteger;

Decimal: '-'? [1-9] (
        '.' DecimalDigit* ExponentPart?
        | DecimalDigit+ ExponentPart?
        | DecimalInteger ExponentPart?
    )?;

Name: [\p{L}_-] [\p{L}\p{N}_-]*;

Dot: '.';

fragment DecimalDigit: [0-9];
fragment HexDigit: [0-9a-fA-F];
fragment OctalDigit: [0-7];
fragment ExponentPart: [eE] [+-]? DecimalDigit+;

Ws: [\p{White_Space}] -> skip;
Comment: '##' ~[\r\n\p{Zl}]+ -> channel(COMMENTS);
Annotation: '#:' ~[\r\n\p{Zl}]+ -> channel(ANNOTATIONS);
HashBang: '#!' ~[\r\n\p{Zl}]+ -> channel(HASHBANG);

CurlyOpen: '{' -> pushMode(DEFAULT_MODE);
CurlyClose: '}' -> popMode;

PATH_Relative_Open: '//' -> pushMode(PATH);
PATH_Root_Open: '/' -> pushMode(PATH);
PATH_Parent_Open: '../' -> pushMode(PATH);
PATH_Current_Open: './' -> pushMode(PATH);

PATTERN_Open: '^' -> pushMode(PATTERN);

StringOpen: '`' -> pushMode(STRING);

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
PATTERN_Esc: '\\^';
PATTERN_FieldEsc: '\\{';
PATTERN_FieldOpen: '{' -> pushMode(DEFAULT_MODE);
PATTERN_Literal: PATTERN_Esc | PATTERN_FieldEsc | ~[^{];
PATTERN_Modifiers: [a-zA-Z];
PATTERN_Close: '^' PATTERN_Modifiers* -> popMode;

mode STRING;
S_StringPart: S_StringLiteral+;
S_StringEsc: '\\`';
S_StringFieldEsc: '\\{';
S_StringFieldOpen: '{' -> pushMode(DEFAULT_MODE);
S_StringLiteral: S_StringEsc | S_StringFieldEsc | ~[`{];
S_StringClose: '`' -> popMode;
