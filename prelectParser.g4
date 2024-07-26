parser grammar prelectParser;

options { tokenVocab = prelectLexer; }

parse: formulaic* EOF;

formulaicTrain: formulaic (TrainLink formulaic)*;

formulaic: field | number;

field: (module Dot)? id;
module: Id;
id: Id;

number: int | dec | hex | oct;
int: Int;
dec: Dec;
hex: Hex;
oct: Oct;
