package grammar.Absyn; // Java Package generated by the BNF Converter.

public class ETrue extends Exp {

  public ETrue() { }

  public <R,A> R accept(grammar.Absyn.Exp.Visitor<R,A> v, A arg) { return v.visit(this, arg); }

  public boolean equals(Object o) {
    if (this == o) return true;
    if (o instanceof grammar.Absyn.ETrue) {
      return true;
    }
    return false;
  }

  public int hashCode() {
    return 37;
  }


}
