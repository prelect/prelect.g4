# PRELECT.g4

## Description

This is the antlr4-compatible EBNF syntax for the PRELECT programming language
project.

## Testing

Install [ANTLR](https://www.antlr.org/) on your system by any means necessary.

Create a nested syntax tree of some sample code you've written to `./test.xpl`

    antlr4-parse ./prelectLexer.g4 ./prelectParser.g4 parse ./test.xpl -tree

Visualize the syntax tree.

    antlr4-parse ./prelectLexer.g4 ./prelectParser.g4 parse ./test.xpl -gui
