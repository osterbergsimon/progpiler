package grammar;
import grammar.Absyn.*;
/** BNFC-Generated Composition Visitor
*/

public class ComposVisitor<A> implements
  grammar.Absyn.Program.Visitor<grammar.Absyn.Program,A>,
  grammar.Absyn.Def.Visitor<grammar.Absyn.Def,A>,
  grammar.Absyn.Arg.Visitor<grammar.Absyn.Arg,A>,
  grammar.Absyn.Stm.Visitor<grammar.Absyn.Stm,A>,
  grammar.Absyn.Exp.Visitor<grammar.Absyn.Exp,A>,
  grammar.Absyn.Type.Visitor<grammar.Absyn.Type,A>
{
/* Program */
    public Program visit(grammar.Absyn.PDefs p, A arg)
    {
      ListDef listdef_ = new ListDef();
      for (Def x : p.listdef_) {
        listdef_.add(x.accept(this,arg));
      }

      return new grammar.Absyn.PDefs(listdef_);
    }

/* Def */
    public Def visit(grammar.Absyn.DFun p, A arg)
    {
      Type type_ = p.type_.accept(this, arg);
      String id_ = p.id_;
      ListArg listarg_ = new ListArg();
      for (Arg x : p.listarg_) {
        listarg_.add(x.accept(this,arg));
      }
      ListStm liststm_ = new ListStm();
      for (Stm x : p.liststm_) {
        liststm_.add(x.accept(this,arg));
      }

      return new grammar.Absyn.DFun(type_, id_, listarg_, liststm_);
    }

/* Arg */
    public Arg visit(grammar.Absyn.ADecl p, A arg)
    {
      Type type_ = p.type_.accept(this, arg);
      String id_ = p.id_;

      return new grammar.Absyn.ADecl(type_, id_);
    }

/* Stm */
    public Stm visit(grammar.Absyn.SExp p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.SExp(exp_);
    }
    public Stm visit(grammar.Absyn.SDecl p, A arg)
    {
      Type type_ = p.type_.accept(this, arg);
      String id_ = p.id_;

      return new grammar.Absyn.SDecl(type_, id_);
    }
    public Stm visit(grammar.Absyn.SDecls p, A arg)
    {
      Type type_ = p.type_.accept(this, arg);
      String id_ = p.id_;
      ListId listid_ = p.listid_;

      return new grammar.Absyn.SDecls(type_, id_, listid_);
    }
    public Stm visit(grammar.Absyn.SInit p, A arg)
    {
      Type type_ = p.type_.accept(this, arg);
      String id_ = p.id_;
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.SInit(type_, id_, exp_);
    }
    public Stm visit(grammar.Absyn.SReturn p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.SReturn(exp_);
    }
    public Stm visit(grammar.Absyn.SWhile p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);
      Stm stm_ = p.stm_.accept(this, arg);

      return new grammar.Absyn.SWhile(exp_, stm_);
    }
    public Stm visit(grammar.Absyn.SBlock p, A arg)
    {
      ListStm liststm_ = new ListStm();
      for (Stm x : p.liststm_) {
        liststm_.add(x.accept(this,arg));
      }

      return new grammar.Absyn.SBlock(liststm_);
    }
    public Stm visit(grammar.Absyn.SIfElse p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);
      Stm stm_1 = p.stm_1.accept(this, arg);
      Stm stm_2 = p.stm_2.accept(this, arg);

      return new grammar.Absyn.SIfElse(exp_, stm_1, stm_2);
    }

/* Exp */
    public Exp visit(grammar.Absyn.EInt p, A arg)
    {
      Integer integer_ = p.integer_;

      return new grammar.Absyn.EInt(integer_);
    }
    public Exp visit(grammar.Absyn.EDouble p, A arg)
    {
      Double double_ = p.double_;

      return new grammar.Absyn.EDouble(double_);
    }
    public Exp visit(grammar.Absyn.EString p, A arg)
    {
      String string_ = p.string_;

      return new grammar.Absyn.EString(string_);
    }
    public Exp visit(grammar.Absyn.ETrue p, A arg)
    {

      return new grammar.Absyn.ETrue();
    }
    public Exp visit(grammar.Absyn.EFalse p, A arg)
    {

      return new grammar.Absyn.EFalse();
    }
    public Exp visit(grammar.Absyn.EId p, A arg)
    {
      String id_ = p.id_;

      return new grammar.Absyn.EId(id_);
    }
    public Exp visit(grammar.Absyn.ECall p, A arg)
    {
      String id_ = p.id_;
      ListExp listexp_ = new ListExp();
      for (Exp x : p.listexp_) {
        listexp_.add(x.accept(this,arg));
      }

      return new grammar.Absyn.ECall(id_, listexp_);
    }
    public Exp visit(grammar.Absyn.EPIncr p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.EPIncr(exp_);
    }
    public Exp visit(grammar.Absyn.EPDecr p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.EPDecr(exp_);
    }
    public Exp visit(grammar.Absyn.EIncr p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.EIncr(exp_);
    }
    public Exp visit(grammar.Absyn.EDecr p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.EDecr(exp_);
    }
    public Exp visit(grammar.Absyn.ENeg p, A arg)
    {
      Exp exp_ = p.exp_.accept(this, arg);

      return new grammar.Absyn.ENeg(exp_);
    }
    public Exp visit(grammar.Absyn.EMul p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EMul(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EDiv p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EDiv(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EAdd p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EAdd(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.ESub p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.ESub(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.ELt p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.ELt(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EGt p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EGt(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.ELEq p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.ELEq(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EGEq p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EGEq(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EEq p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EEq(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.ENEq p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.ENEq(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EAnd p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EAnd(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EOr p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EOr(exp_1, exp_2);
    }
    public Exp visit(grammar.Absyn.EAss p, A arg)
    {
      Exp exp_1 = p.exp_1.accept(this, arg);
      Exp exp_2 = p.exp_2.accept(this, arg);

      return new grammar.Absyn.EAss(exp_1, exp_2);
    }

/* Type */
    public Type visit(grammar.Absyn.Tbool p, A arg)
    {

      return new grammar.Absyn.Tbool();
    }
    public Type visit(grammar.Absyn.Tdouble p, A arg)
    {

      return new grammar.Absyn.Tdouble();
    }
    public Type visit(grammar.Absyn.Tint p, A arg)
    {

      return new grammar.Absyn.Tint();
    }
    public Type visit(grammar.Absyn.Tstring p, A arg)
    {

      return new grammar.Absyn.Tstring();
    }
    public Type visit(grammar.Absyn.Tvoid p, A arg)
    {

      return new grammar.Absyn.Tvoid();
    }

}