grammar VarLang;

import ArithLang; //Import all rules from Arithlang grammar.
 
 // New elements in the Grammar of this Programming Language
 //  - grammar rules start with lowercase

 // We are redefining programs to be zero or more define declarations
 // followed by an optional expression.
 program returns [Program ast]
   		locals [ArrayList<DefineDecl> defs, Exp expr]
   		@init { $defs = new ArrayList<DefineDecl>(); $expr = new UnitExp(); } :
  		// (def=definedecl { $defs.add($def.ast); } )*
  		(def=definedecl { $defs.add($def.ast); } )*
          (e=exp { $expr = $e.ast; } )?
  		{ $ast = new Program($defs, $expr); }
  		;

 exp returns [Exp ast]: 
		v=varexp { $ast = $v.ast; }
		| n=numexp { $ast = $n.ast; }
        | a=addexp { $ast = $a.ast; }
        | s=subexp { $ast = $s.ast; }
        | m=multexp { $ast = $m.ast; }
        | d=divexp { $ast = $d.ast; }
        | l=letexp { $ast = $l.ast; }
        ;

 varexp returns [VarExp ast]: 
 		id=Identifier { $ast = new VarExp($id.text); }
 		;

 letexp returns [LetExp ast]
        locals [ArrayList<String> names = new ArrayList<String>(), ArrayList<Exp> value_exps = new ArrayList<Exp>()] :
 		'(' Let 
 			'(' ( '(' id=Identifier e=exp ')' { $names.add($id.text); $value_exps.add($e.ast); } )+  ')'
 			body=exp 
 			')' { $ast = new LetExp($names, $value_exps, $body.ast); }
 		;



 definedecl returns [DefineDecl ast] :
 		'(' Define
 			id=Identifier
 			e=exp
 			')' { $ast = new DefineDecl($id.text, $e.ast); }
    ;


 // Lexical Specification of this Programming Language
 //  - lexical specification rules start with uppercase



// Hints to wrote define macro grammar.
// (define (macro_name argument1, argument2, ...) expression)

