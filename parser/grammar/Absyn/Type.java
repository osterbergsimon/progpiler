package grammar.Absyn; // Java Package generated by the BNF Converter.

public abstract class Type implements java.io.Serializable {
  public abstract <R,A> R accept(Type.Visitor<R,A> v, A arg);
  public interface Visitor <R,A> {
    public R visit(grammar.Absyn.Tbool p, A arg);
    public R visit(grammar.Absyn.Tdouble p, A arg);
    public R visit(grammar.Absyn.Tint p, A arg);
    public R visit(grammar.Absyn.Tstring p, A arg);
    public R visit(grammar.Absyn.Tvoid p, A arg);

  }

}