package grammar;

import grammar.Absyn.*;

/** BNFC-Generated All Visitor */
public interface AllVisitor<R,A> extends
  grammar.Absyn.Program.Visitor<R,A>,
  grammar.Absyn.Def.Visitor<R,A>,
  grammar.Absyn.Arg.Visitor<R,A>,
  grammar.Absyn.Stm.Visitor<R,A>,
  grammar.Absyn.Exp.Visitor<R,A>,
  grammar.Absyn.Type.Visitor<R,A>
{}
