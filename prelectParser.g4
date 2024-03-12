parser grammar prelectParser;

// add .. range operator
// add join operators
// 

options { tokenVocab = prelectLexer; }

parse: (patchDef | freeFormulaic)* EOF;

freeFormulaic: formulaicPiped;

formulaDef: batch? CurlyOpen formulaicPiped CurlyClose;
formulaicPiped: formulaic piped?;
piped: Pipe alias? formulaicPiped;
alias: Name Assign;

formulaic: field | table | range | number | string | context | caught | placeholder | nulll | formulaCall | exceptional;

formulaCall: parentCall? formulaName formulaCallItem* ParenClose;
formulaName: (field ParenOpen | FormulaChar+);
formulaCallItem: (name Assign)? formulaic | pattern;
parentCall: ParentCall;
context: Context;
caught: Caught;
placeholder: Placeholder;

matcher: ((field | string | number | formulaCall | pattern | nulll ) Assign) | path;

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
pCatch: TableOpen type TableClose;

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
hatchItem: formulaicPiped;

type: typeFormulaic | nulll | typeString | typeBoolean | typeTable |
	(TypeCustom typeName) (ParenOpen formulaCallItem* ParenClose)?;
typeTable: TypeTable;
typeBoolean: TypeBoolean;
typeString: TypeString;
typeFormulaic: TypeFormulaic;
typeName: Name;

name: Name;
module: Name;
dot: '.';
field: (module dot)? name;


number: decimalInteger | decimal | hexInteger | octalInteger;
range: Range;
decimalInteger: DecimalInteger;
decimal: Decimal;
hexInteger: HexInteger;
octalInteger: OctalInteger;

path: pathOpen pathSection ((pathDirect | pathDig) pathSection)* PATH_Close;
pathSection: pathName | pathField | pathName pathField;
pathOpen: pathRelaOpen | pathRootOpen | pathCurrOpen;
pathRelaOpen: PATH_Rela_Open;
pathRootOpen: PATH_Root_Open;
pathCurrOpen: PATH_Curr_Open;
pathName: PATH_Name+;
pathDirect: PATH_Dir;
pathDig: PATH_Dig;
pathField: PATH_FieldOpen formulaic? CurlyClose;

pattern:
	PATTERN_Open
	(patternPart | patternField)*
	PATTERN_Close;

patternPart: PATTERN_Part+;
patternField: PATTERN_FieldOpen formulaic? CurlyClose;

string: StringOpen (stringPart | stringField)* S_StringClose;
stringPart: S_StringPart+;
stringField: S_StringFieldOpen formulaic? CurlyClose;
