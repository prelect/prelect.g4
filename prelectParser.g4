parser grammar prelectParser;

options { tokenVocab = prelectLexer; }

annotation: Annotation;

batch: ParenOpen batchItem? (Comma batchItem)* Comma? ParenClose;
batchItem: type? prot? priv? name nullable? mutable? unique? (Assign batchDefault)? annotation?;
batchDefault: formulaic | /*formulaDef | */ nulll;
prot: Bang;
priv: Bang;
nullable: Nulll;
mutable: Star;
unique: BrackOpen Star BrackClose;
nulll: Nulll;

type: typeFormulaic | typeString | typeBoolean | typeTable |
	(TypeCustom name) (ParenOpen formulaCallItem? (Comma formulaCallItem)* Comma? ParenClose)?;
typeTable: TypeTable;
typeBoolean: TypeBoolean;
typeString: TypeString;
typeFormulaic: TypeFormulaic;

formulaCall: formulaName formulaCallItem? (Comma formulaCallItem)* Comma? ParenClose;
formulaName: (field ParenOpen | FormulaChar+ | braceFormula);
formulaCallItem: alias? formulaic /*| pattern */;
braceFormula: ((assign | greaterThan) ParenOpen) | greaterEqual;
assign: BraceClose BraceClose;
greaterEqual: BraceClose FormulaChar;
greaterThan: BraceClose;

context: Context;
placeholder: Placeholder;

parse: formulaicTrain* EOF;

formulaicTrain: formulaic (TrainLink formulaic)*;

formulaic: formulaCall | table | field | number;

table: batch? tableData;
tableData: tableRow+;
tableRow: BrackOpen tableField? (Comma tableField)* BrackClose;
tableField: formulaic;

field: (parent Dot)? id;
parent: name;
id: name;

alias: name Assign;

name: nameShort | NameQuoteOpen nameQuote NameQuoteClose;
nameShort: NameShort;
nameQuote: NameQuote;

number: int | dec | hex | oct;
int: Int;
dec: Dec;
hex: Hex;
oct: Oct;
