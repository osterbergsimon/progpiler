package grammar.Absyn; // Java Package generated by the BNF Converter.

public class Tint extends Type {

  public Tint() { }

  public <R,A> R accept(grammar.Absyn.Type.Visitor<R,A> v, A arg) { return v.visit(this, arg); }

  public boolean equals(Object o) {
    if (this == o) return true;
    if (o instanceof grammar.Absyn.Tint) {
      return true;
    }
    return false;
  }

  public int hashCode() {
    return 37;
  }


}
