# Parser for _naive_ C

_Naive_ C Parser developed for Compilers class.

Project comprised of two components:
- A lexical analyzer, written in _Flex_, which can be found here: [_mycc.l_](source/mycc.l)
- A syntax analyzer, or parser, written in _Bison_, which can be found here: [_mycc.y_](source/mycc.y)

# Objective

The main purpose of this parser is to parse through and detect errors in small snippets of C code.

The reasoning behind the naming is the parser only analyzes a small subset of C, aka _naive_ C, containing everything from:
- types, such as __int__ and __char__
- variable, structure and function declarations
- arithmetic and conditional operators
- __if/else__ statements
- __while__ and __do/while__ statements
- __for__ statements
- __return__ statements
