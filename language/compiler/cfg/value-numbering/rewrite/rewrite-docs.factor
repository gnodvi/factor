USING: help.markup help.syntax kernel math ;
in: compiler.cfg.value-numbering.rewrite

HELP: vreg-immediate-arithmetic?
{ $values { "vreg" "vreg" } { "?" boolean } }
{ $description "Checks if the 'vreg' is an immediate value in " { $link fixnum } " range." } ;

ARTICLE: "compiler.cfg.value-numbering.rewrite" "Value numbering utilities"
"Value numbering utilities" ;

about: "compiler.cfg.value-numbering.rewrite"
