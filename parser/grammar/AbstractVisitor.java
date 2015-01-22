package grammar;
import grammar.Absyn.*;
/** BNFC-Generated Abstract Visitor */
public class AbstractVisitor<R,A> implements AllVisitor<R,A> {
/* Program */
    public R visit(grammar.Absyn.PDefs p, A arg) { return visitDefault(p, arg); }
    public R visitDefault(grammar.Absyn.Program p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }
/* Def */
    public R visit(grammar.Absyn.DFun p, A arg) { return visitDefault(p, arg); }
    public R visitDefault(grammar.Absyn.Def p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }
/* Arg */
    public R visit(grammar.Absyn.ADecl p, A arg) { return visitDefault(p, arg); }
    public R visitDefault(grammar.Absyn.Arg p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }
/* Stm */
    public R visit(grammar.Absyn.SExp p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SDecl p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SDecls p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SInit p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SReturn p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SWhile p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SBlock p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.SIfElse p, A arg) { return visitDefault(p, arg); }
    public R visitDefault(grammar.Absyn.Stm p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }
/* Exp */
    public R visit(grammar.Absyn.EInt p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EDouble p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EString p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ETrue p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EFalse p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EId p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ECall p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EPIncr p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EPDecr p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EIncr p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EDecr p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ENeg p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EMul p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EDiv p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EAdd p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ESub p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.ELt p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EGt p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ELEq p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.EGEq p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EEq p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.ENEq p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EAnd p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EOr p, A arg) { return visitDefault(p, arg); }

    public R visit(grammar.Absyn.EAss p, A arg) { return visitDefault(p, arg); }







    public R visitDefault(grammar.Absyn.Exp p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }
/* Type */
    public R visit(grammar.Absyn.Tbool p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.Tdouble p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.Tint p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.Tstring p, A arg) { return visitDefault(p, arg); }
    public R visit(grammar.Absyn.Tvoid p, A arg) { return visitDefault(p, arg); }
    public R visitDefault(grammar.Absyn.Type p, A arg) {
      throw new IllegalArgumentException(this.getClass().getName() + ": " + p);
    }

}
