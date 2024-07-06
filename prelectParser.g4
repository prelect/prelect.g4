parser grammar prelectParser;

options { tokenVocab = prelectLexer; }

parse: (patchDef | freeFormulaic)* EOF;

freeFormulaic: formulaicPiped pipeTerm?;

formulaDef: batch? CurlyOpen formulaicPiped CurlyClose;
formulaicPiped: formulaic piped?;
pipeTerm: replace | return;
return: Bang Bang;
replace: Bang;

piped: (CommaPipe | SemicolonPipe) alias? formulaicPiped;
alias: name Assign;

formulaic: field | table | number | literal | message | input | model | caught | placeholder | nulll | formulaCall | exceptional;

formulaCall: formulaName formulaCallItem* ParenClose;
formulaName: (field ParenOpen | FormulaChar+);
formulaCallItem: alias? formulaic | pattern;
input: Input;
model: Model;
caught: Caught;
placeholder: Placeholder;

matcher: ((field | literal | number | formulaCall | pattern | nulll ) Assign) | path;

table: (batch tableData) | batch | tableData;
tableData: tableRow+;
tableRow: TableOpen tableField* TableClose;
tableField: formulaic;

xCatch: tableRow;
watch: BraceOpen formulaic BraceClose;
params: ParenOpen ((name Assign)? formulaic)* ParenClose;
exceptional: matcher ParenOpen watch? (xCatch params | xCatch | params ) ParenClose;

patchDef: matcher snatch? pCatch? (batch hatch | batch | hatch);
snatch: BraceOpen field BraceClose;
pCatch: TableOpen (type | nulll) TableClose;

batch: ParenOpen batchItem* ParenClose;
batchItem: type? prot? priv? batchName nullable? mutable? unique? (Assign batchDefault)?;
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
	(TypeCustom typeName) (ParenOpen formulaCallItem* ParenClose)?;
typeTable: TypeTable;
typeBoolean: TypeBoolean;
typeString: TypeString;
typeFormulaic: TypeFormulaic;
typeName: Name;

name: Name;
module: Name;
field: ParentCall* (module Dot)? name;

number: decimalInteger | decimal | hexInteger | octalInteger;
decimalInteger: DecimalInteger;
decimal: Decimal;
hexInteger: HexInteger;
octalInteger: OctalInteger;

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

pattern: PATTERN_Open (patternPart | patternField)* PATTERN_Close;

patternPart: PATTERN_Part+;
patternField: PATTERN_FieldOpen formulaic? CurlyClose;

literal: LITERAL_OPEN (literalPart | literalField)* L_LiteralClose;
literalPart: L_LiteralPart+;
literalField: L_LiteralFieldOpen formulaic? CurlyClose;

message: MESSAGE_OPEN messageContent M_MessageClose messageParams?;
messageContent: M_MessageContent*;
messageParams: batch;
