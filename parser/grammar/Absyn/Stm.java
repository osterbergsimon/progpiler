package grammar.Absyn; // Java Package generated by the BNF Converter.

public abstract class Stm implements java.io.Serializable {
  public abstract <R,A> R accept(Stm.Visitor<R,A> v, A arg);
  public interface Visitor <R,A> {
    public R visit(grammar.Absyn.SExp p, A arg);
    public R visit(grammar.Absyn.SDecl p, A arg);
    public R visit(grammar.Absyn.SDecls p, A arg);
    public R visit(grammar.Absyn.SInit p, A arg);
    public R visit(grammar.Absyn.SReturn p, A arg);
    public R visit(grammar.Absyn.SWhile p, A arg);
    public R visit(grammar.Absyn.SBlock p, A arg);
    public R visit(grammar.Absyn.SIfElse p, A arg);

  }

}
