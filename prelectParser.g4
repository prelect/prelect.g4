parser grammar prelectParser;

options { tokenVocab = prelectLexer; }

parse: formulaic* EOF;

formulaicTrain: formulaic (train formulaic)*;
train: trainPass | trainNext;
trainPass: Comma;
trainNext: Semicolon;

formulaic: id | number;

id: Id;

number: int | dec | hex | oct;
int: Int;
dec: Dec;
hex: Hex;
oct: Oct;
