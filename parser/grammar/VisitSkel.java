package grammar;
import grammar.Absyn.*;
/*** BNFC-Generated Visitor Design Pattern Skeleton. ***/
/* This implements the common visitor design pattern.
   Tests show it to be slightly less efficient than the
   instanceof method, but easier to use. 
   Replace the R and A parameters with the desired return
   and context types.*/

public class VisitSkel
{
  public class ProgramVisitor<R,A> implements Program.Visitor<R,A>
  {
    public R visit(grammar.Absyn.PDefs p, A arg)
    {
      /* Code For PDefs Goes Here */

      for (Def x : p.listdef_) {
      }

      return null;
    }

  }
  public class DefVisitor<R,A> implements Def.Visitor<R,A>
  {
    public R visit(grammar.Absyn.DFun p, A arg)
    {
      /* Code For DFun Goes Here */

      p.type_.accept(new TypeVisitor<R,A>(), arg);
      //p.id_;
      for (Arg x : p.listarg_) {
      }
      for (Stm x : p.liststm_) {
      }

      return null;
    }

  }
  public class ArgVisitor<R,A> implements Arg.Visitor<R,A>
  {
    public R visit(grammar.Absyn.ADecl p, A arg)
    {
      /* Code For ADecl Goes Here */

      p.type_.accept(new TypeVisitor<R,A>(), arg);
      //p.id_;

      return null;
    }

  }
  public class StmVisitor<R,A> implements Stm.Visitor<R,A>
  {
    public R visit(grammar.Absyn.SExp p, A arg)
    {
      /* Code For SExp Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.SDecl p, A arg)
    {
      /* Code For SDecl Goes Here */

      p.type_.accept(new TypeVisitor<R,A>(), arg);
      //p.id_;

      return null;
    }
    public R visit(grammar.Absyn.SDecls p, A arg)
    {
      /* Code For SDecls Goes Here */

      p.type_.accept(new TypeVisitor<R,A>(), arg);
      //p.id_;
      for (String x : p.listid_) {
      }

      return null;
    }
    public R visit(grammar.Absyn.SInit p, A arg)
    {
      /* Code For SInit Goes Here */

      p.type_.accept(new TypeVisitor<R,A>(), arg);
      //p.id_;
      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.SReturn p, A arg)
    {
      /* Code For SReturn Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.SWhile p, A arg)
    {
      /* Code For SWhile Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);
      p.stm_.accept(new StmVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.SBlock p, A arg)
    {
      /* Code For SBlock Goes Here */

      for (Stm x : p.liststm_) {
      }

      return null;
    }
    public R visit(grammar.Absyn.SIfElse p, A arg)
    {
      /* Code For SIfElse Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);
      p.stm_1.accept(new StmVisitor<R,A>(), arg);
      p.stm_2.accept(new StmVisitor<R,A>(), arg);

      return null;
    }

  }
  public class ExpVisitor<R,A> implements Exp.Visitor<R,A>
  {
    public R visit(grammar.Absyn.EInt p, A arg)
    {
      /* Code For EInt Goes Here */

      //p.integer_;

      return null;
    }
    public R visit(grammar.Absyn.EDouble p, A arg)
    {
      /* Code For EDouble Goes Here */

      //p.double_;

      return null;
    }
    public R visit(grammar.Absyn.EString p, A arg)
    {
      /* Code For EString Goes Here */

      //p.string_;

      return null;
    }
    public R visit(grammar.Absyn.ETrue p, A arg)
    {
      /* Code For ETrue Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.EFalse p, A arg)
    {
      /* Code For EFalse Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.EId p, A arg)
    {
      /* Code For EId Goes Here */

      //p.id_;

      return null;
    }
    public R visit(grammar.Absyn.ECall p, A arg)
    {
      /* Code For ECall Goes Here */

      //p.id_;
      for (Exp x : p.listexp_) {
      }

      return null;
    }
    public R visit(grammar.Absyn.EPIncr p, A arg)
    {
      /* Code For EPIncr Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EPDecr p, A arg)
    {
      /* Code For EPDecr Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EIncr p, A arg)
    {
      /* Code For EIncr Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EDecr p, A arg)
    {
      /* Code For EDecr Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.ENeg p, A arg)
    {
      /* Code For ENeg Goes Here */

      p.exp_.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EMul p, A arg)
    {
      /* Code For EMul Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EDiv p, A arg)
    {
      /* Code For EDiv Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EAdd p, A arg)
    {
      /* Code For EAdd Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.ESub p, A arg)
    {
      /* Code For ESub Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.ELt p, A arg)
    {
      /* Code For ELt Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EGt p, A arg)
    {
      /* Code For EGt Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.ELEq p, A arg)
    {
      /* Code For ELEq Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EGEq p, A arg)
    {
      /* Code For EGEq Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EEq p, A arg)
    {
      /* Code For EEq Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.ENEq p, A arg)
    {
      /* Code For ENEq Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EAnd p, A arg)
    {
      /* Code For EAnd Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EOr p, A arg)
    {
      /* Code For EOr Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }
    public R visit(grammar.Absyn.EAss p, A arg)
    {
      /* Code For EAss Goes Here */

      p.exp_1.accept(new ExpVisitor<R,A>(), arg);
      p.exp_2.accept(new ExpVisitor<R,A>(), arg);

      return null;
    }

  }
  public class TypeVisitor<R,A> implements Type.Visitor<R,A>
  {
    public R visit(grammar.Absyn.Tbool p, A arg)
    {
      /* Code For Tbool Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.Tdouble p, A arg)
    {
      /* Code For Tdouble Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.Tint p, A arg)
    {
      /* Code For Tint Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.Tstring p, A arg)
    {
      /* Code For Tstring Goes Here */


      return null;
    }
    public R visit(grammar.Absyn.Tvoid p, A arg)
    {
      /* Code For Tvoid Goes Here */


      return null;
    }

  }
}