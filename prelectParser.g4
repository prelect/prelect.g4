parser grammar prelectParser;

options { tokenVocab = prelectLexer; }

parse: (patchDef | freeFormulaic)* EOF;

freeFormulaic: formulaicPiped pipeTerm?;

formulaDef: batch? CurlyOpen formulaicPiped CurlyClose;
formulaicPiped: formulaic piped?;
pipeTerm: replace | return;
return: Bang Bang;
replace: Bang;

piped: (Comma | Semicolon) alias? formulaicPiped;
alias: name Assign;

formulaic: field | table | number | literal | message | input | model | matched | context | placeholder | nulll | formulaCall | exceptional;

formulaCall: formulaName formulaCallItem? (Comma formulaCallItem)* ParenClose;
formulaName: (field ParenOpen | FormulaChar+ | braceFormula);
formulaCallItem: alias? formulaic | pattern;
braceFormula: ((assign | greaterThan) ParenOpen) | greaterEqual;
assign: BraceClose BraceClose;
greaterEqual: BraceClose FormulaChar;
greaterThan: BraceClose;

input: Input;
model: Model;
matched: Matched;
context: Context;
placeholder: Placeholder;

matcher: ((field | literal | number | formulaCall | pattern | nulll ) Assign) | path;

table: (batch tableData) | batch | tableData;
tableData: tableRow+;
tableRow: TableOpen tableField? (Comma tableField)* TableClose;
tableField: formulaic;

catch_: BraceOpen formulaic BraceClose;
snatch: TableOpen formulaic watch? TableClose;
watch: Bang;
params: ParenOpen (alias? formulaic)? (Comma alias? formulaic)* ParenClose;
exceptional: matcher ParenOpen snatch? catch_? params? ParenClose;

patchDef: matcher attach? catchType? batch? hatch annotation?;
attach: TableOpen field TableClose;
catchType: BraceOpen (type | nulll) BraceClose;

batch: ParenOpen batchItem? (Comma batchItem)* ParenClose;
batchItem: type? prot? priv? batchName nullable? mutable? unique? (Assign batchDefault)? annotation?;
batchDefault: formulaic | formulaDef | nulll;
prot: Bang;
priv: Bang;
nullable: Nulll;
mutable: Star;
unique: TableOpen Star TableClose;
batchName: Name;
nulll: Nulll;

hatch: CurlyOpen hatchItem* CurlyClose;
hatchItem: formulaicPiped pipeTerm?;

type: typeFormulaic | typeString | typeBoolean | typeTable |
	(TypeCustom typeName) (ParenOpen formulaCallItem? (Comma formulaCallItem)* ParenClose)?;
typeTable: TypeTable;
typeBoolean: TypeBoolean;
typeString: TypeString;
typeFormulaic: TypeFormulaic;
typeName: Name;

name: Name;
module: Name;
parentCall: ParentCall;
field: parentCall* (module Dot)? name;

number: decimalInteger | decimal | hexInteger | octalInteger;
decimalInteger: DecimalInteger;
decimal: Decimal;
hexInteger: HexInteger;
octalInteger: OctalInteger;

annotation: ANNOTATION_OPEN annotationContent ANNOTATION_CLOSE;
annotationContent: ANNOTATION_CONTENT;

path: pathOpen pathSection ((pathDirect | pathDig) pathSection)* PATH_Close;
pathSection: pathName | pathField | pathName pathField;
pathOpen: pathRelativeOpen | pathRootOpen | pathParentOpen | pathCurrentOpen;
pathRelativeOpen: PATH_Relative_Open;
pathRootOpen: PATH_Root_Open;
pathParentOpen: PATH_Parent_Open;
pathCurrentOpen: PATH_Current_Open;
pathName: PATH_Name+;
pathDirect: PATH_Dir;
pathDig: PATH_Dig;
pathField: PATH_FieldOpen formulaic? CurlyClose;

pattern: PATTERN_Open (patternPart | patternField)* PATTERN_Close patternModifiers?;
patternModifiers: Name;

patternPart: PATTERN_Part+;
patternField: PATTERN_FieldOpen formulaic? CurlyClose;

literal: LITERAL_OPEN (literalPart | literalField)* L_LiteralClose;
literalPart: L_LiteralPart+;
literalField: L_LiteralFieldOpen formulaic? CurlyClose;

message: MESSAGE_OPEN messageContent M_MessageClose locale? messageParams?;
messageContent: M_MessageContent*;
locale: BraceOpen formulaic BraceClose;
messageParams: batch;
