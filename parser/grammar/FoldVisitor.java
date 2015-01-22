package grammar;

import grammar.Absyn.*;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

/** BNFC-Generated Fold Visitor */
public abstract class FoldVisitor<R,A> implements AllVisitor<R,A> {
    public abstract R leaf(A arg);
    public abstract R combine(R x, R y, A arg);

/* Program */
    public R visit(grammar.Absyn.PDefs p, A arg) {
      R r = leaf(arg);
      for (Def x : p.listdef_) {
        r = combine(x.accept(this,arg), r, arg);
      }
      return r;
    }

/* Def */
    public R visit(grammar.Absyn.DFun p, A arg) {
      R r = leaf(arg);
      r = combine(p.type_.accept(this, arg), r, arg);
      for (Arg x : p.listarg_) {
        r = combine(x.accept(this,arg), r, arg);
      }
      for (Stm x : p.liststm_) {
        r = combine(x.accept(this,arg), r, arg);
      }
      return r;
    }

/* Arg */
    public R visit(grammar.Absyn.ADecl p, A arg) {
      R r = leaf(arg);
      r = combine(p.type_.accept(this, arg), r, arg);
      return r;
    }

/* Stm */
    public R visit(grammar.Absyn.SExp p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SDecl p, A arg) {
      R r = leaf(arg);
      r = combine(p.type_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SDecls p, A arg) {
      R r = leaf(arg);
      r = combine(p.type_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SInit p, A arg) {
      R r = leaf(arg);
      r = combine(p.type_.accept(this, arg), r, arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SReturn p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SWhile p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      r = combine(p.stm_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.SBlock p, A arg) {
      R r = leaf(arg);
      for (Stm x : p.liststm_) {
        r = combine(x.accept(this,arg), r, arg);
      }
      return r;
    }
    public R visit(grammar.Absyn.SIfElse p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      r = combine(p.stm_1.accept(this, arg), r, arg);
      r = combine(p.stm_2.accept(this, arg), r, arg);
      return r;
    }

/* Exp */
    public R visit(grammar.Absyn.EInt p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.EDouble p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.EString p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.ETrue p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.EFalse p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.EId p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.ECall p, A arg) {
      R r = leaf(arg);
      for (Exp x : p.listexp_) {
        r = combine(x.accept(this,arg), r, arg);
      }
      return r;
    }
    public R visit(grammar.Absyn.EPIncr p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EPDecr p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EIncr p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EDecr p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.ENeg p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EMul p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EDiv p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EAdd p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.ESub p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.ELt p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EGt p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.ELEq p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EGEq p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EEq p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.ENEq p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EAnd p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EOr p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }
    public R visit(grammar.Absyn.EAss p, A arg) {
      R r = leaf(arg);
      r = combine(p.exp_1.accept(this, arg), r, arg);
      r = combine(p.exp_2.accept(this, arg), r, arg);
      return r;
    }

/* Type */
    public R visit(grammar.Absyn.Tbool p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.Tdouble p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.Tint p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.Tstring p, A arg) {
      R r = leaf(arg);
      return r;
    }
    public R visit(grammar.Absyn.Tvoid p, A arg) {
      R r = leaf(arg);
      return r;
    }


}
