lexer grammar prelectLexer;

channels { COMMENTS, HASHBANG }

TrainLink: ';';
Dot: '.';

Dec: Int '.' [0-9] [0-9]* Expo? | '.' [0-9] [0-9]* Expo? | Int Expo?;
Expo: [eE] [+-]? [0-9]+;

Hex: '0' [xX] ('0' | [1-9a-fA-F] [0-9a-fA-F]*);
Oct: '0' [0-7] [_0-7]*;
Int: '0' ~[0-9] | [1-9] [0-9]*;

Id: [_\p{L}\p{N}]+;

Ws: [\p{White_Space}] -> skip;

Comment: '##' ~[\r\n\p{Zl}]+ -> channel(COMMENTS);
HashBang: '#!' ~[\r\n\p{Zl}]+ -> channel(HASHBANG);

ANNOTATION_OPEN: '#:' -> pushMode(ANNOTATION);

mode ANNOTATION;
ANNOTATION_CONTENT: (':' ~[#] | ~[:])+;
ANNOTATION_CLOSE: ':#' -> popMode;
