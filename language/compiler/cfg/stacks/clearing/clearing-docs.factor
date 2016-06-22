USING: compiler.cfg compiler.cfg.instructions help.markup
help.syntax kernel sequences strings ;
IN: compiler.cfg.stacks.clearing

ARTICLE: "compiler.cfg.stacks.clearing" "Uninitialized stack location clearing"
"A compiler pass that inserts " { $link ##replace-imm } " instructions front of unsafe " { $link ##peek } " instructions in the " { $link cfg } ". Consider the following sequence of instructions."
{ $code
  "##inc d: 2"
  "##peek RCX d: 2"
}
"The ##peek can cause a stack underflow and then there will be two uninitialized locations on the data stack that can't be traced. To counteract that, this pass modifies the instruction sequence so that it becomes:"
{ $code
  "##inc d: 2"
  "##replace-imm 17 d: 0"
  "##replace-imm 17 d: 1"
  "##peek RCX d: 2"
} ;

HELP: dangerous-insn?
{ $values { "state" "a stack state" } { "insn" insn } { "?" boolean } }
{ $description "Checks if the instruction is dangerous (can cause a stack underflow). " }
{ $examples
  { $example
    "USING: compiler.cfg.instructions compiler.cfg.registers compiler.cfg.stacks.clearing prettyprint ;"
    "{ { 0 { } } { 0 { } } } T{ ##peek { loc d: 0 } } dangerous-insn? ."
    "t"
  }
  { $example
    "USING: compiler.cfg.instructions compiler.cfg.registers compiler.cfg.stacks.clearing prettyprint ;"
    "{ { 0 { } } { 2 { } } } T{ ##peek { loc r: 0 } } dangerous-insn? ."
    "f"
  }
} ;


about: "compiler.cfg.stacks.clearing"