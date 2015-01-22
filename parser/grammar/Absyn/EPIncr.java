package grammar.Absyn; // Java Package generated by the BNF Converter.

public class EPIncr extends Exp {
  public final Exp exp_;

  public EPIncr(Exp p1) { exp_ = p1; }

  public <R,A> R accept(grammar.Absyn.Exp.Visitor<R,A> v, A arg) { return v.visit(this, arg); }

  public boolean equals(Object o) {
    if (this == o) return true;
    if (o instanceof grammar.Absyn.EPIncr) {
      grammar.Absyn.EPIncr x = (grammar.Absyn.EPIncr)o;
      return this.exp_.equals(x.exp_);
    }
    return false;
  }

  public int hashCode() {
    return this.exp_.hashCode();
  }


}