lexer grammar prelectLexer;

channels { COMMENTS, HASHBANG }

Context: '%%';
Placeholder: '%';

Comma: ',';
Assign: ':';
Bang: '!';
Star: '*';

BraceOpen: '<';
BraceClose: '>';

BrackOpen: '[';
BrackClose: ']';

ParenOpen: '(';
ParenClose: ')';

FormulaChar: [-~!@#$%^&*_+=|<\\./?]+ ParenOpen;

TrainLink: ';';
Dot: '.';
ParentCall: '\\\\';

Nulll: '~';
TypeCustom: '@';
TypeFormulaic: '@@';
TypeTable: '#';
TypeBoolean: '&';
TypeString: '$';

Dec: Int Dot [0-9] [0-9]* Expo? | Dot [0-9] [0-9]* Expo? | Int Expo?;
fragment Expo: [eE] [+-]? [0-9]+;

Hex: '0' [xX] ('0' | [1-9a-fA-F] [0-9a-fA-F]*);
Oct: '0' [0-7] [_0-7]*;
Int: '0' ~[0-9] | ([+-]? [1-9] [0-9]*);

NameShort: [_\p{L}\p{N}]+;
NameQuoteOpen: '"' -> pushMode(NAME_QUOTE);

Ws: [\p{White_Space}] -> skip;

Comment: '##' ~[\r\n\p{C}]+ -> channel(COMMENTS);
HashBang: '#!' ~[\r\n\p{C}]+ -> channel(HASHBANG);

AnnotationOpen: '#:' -> pushMode(ANNOTATION);

mode NAME_QUOTE;
NameQuote: ('\\"' | ~["\p{C}])+;
NameQuoteClose: '"' -> popMode;

mode ANNOTATION;
Annotation: (':' ~[#] | ~[:\p{C}])+;
AnnotationClose: ':#' -> popMode;
