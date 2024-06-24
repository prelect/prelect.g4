import fs from "fs";

import antlr4 from 'antlr4';
import Lexer from '../dist/prelectLexer.js';
import Parser from '../dist/prelectParser.js';

export default class Test {
  constructor() {
    const folder = "./test/syntax/";

    const files = fs.readdirSync(folder);

    files.forEach((file) => {
      console.log(file);
      const input = fs.readFileSync(folder + file, "utf8");

      const chars = new antlr4.InputStream(input);
      const lexer = new Lexer(chars);
      const tokens = new antlr4.CommonTokenStream(lexer);
      const parser = new Parser(tokens);
      const tree = parser.parse();
    });
  }
}

const test = new Test();
