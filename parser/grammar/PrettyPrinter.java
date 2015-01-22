package grammar;
import grammar.Absyn.*;

public class PrettyPrinter
{
  //For certain applications increasing the initial size of the buffer may improve performance.
  private static final int INITIAL_BUFFER_SIZE = 128;
  //You may wish to change the parentheses used in precedence.
  private static final String _L_PAREN = new String("(");
  private static final String _R_PAREN = new String(")");
  //You may wish to change render
  private static void render(String s)
  {
    if (s.equals("{"))
    {
       buf_.append("\n");
       indent();
       buf_.append(s);
       _n_ = _n_ + 2;
       buf_.append("\n");
       indent();
    }
    else if (s.equals("(") || s.equals("["))
       buf_.append(s);
    else if (s.equals(")") || s.equals("]"))
    {
       backup();
       buf_.append(s);
       buf_.append(" ");
    }
    else if (s.equals("}"))
    {
       _n_ = _n_ - 2;
       backup();
       backup();
       buf_.append(s);
       buf_.append("\n");
       indent();
    }
    else if (s.equals(","))
    {
       backup();
       buf_.append(s);
       buf_.append(" ");
    }
    else if (s.equals(";"))
    {
       backup();
       buf_.append(s);
       buf_.append("\n");
       indent();
    }
    else if (s.equals("")) return;
    else
    {
       buf_.append(s);
       buf_.append(" ");
    }
  }


  //  print and show methods are defined for each category.
  public static String print(grammar.Absyn.Program foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Program foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.ListDef foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.ListDef foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.Def foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Def foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.ListArg foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.ListArg foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.ListStm foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.ListStm foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.Arg foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Arg foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.Stm foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Stm foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.Exp foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Exp foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.ListExp foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.ListExp foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.Type foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.Type foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String print(grammar.Absyn.ListId foo)
  {
    pp(foo, 0);
    trim();
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  public static String show(grammar.Absyn.ListId foo)
  {
    sh(foo);
    String temp = buf_.toString();
    buf_.delete(0,buf_.length());
    return temp;
  }
  /***   You shouldn't need to change anything beyond this point.   ***/

  private static void pp(grammar.Absyn.Program foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.PDefs)
    {
       grammar.Absyn.PDefs _pdefs = (grammar.Absyn.PDefs) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_pdefs.listdef_, 0);
       if (_i_ > 0) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.ListDef foo, int _i_)
  {
     for (java.util.Iterator<Def> it = foo.iterator(); it.hasNext();)
     {
       pp(it.next(), 0);
       if (it.hasNext()) {
         render("");
       } else {
         render("");
       }
     }
  }

  private static void pp(grammar.Absyn.Def foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.DFun)
    {
       grammar.Absyn.DFun _dfun = (grammar.Absyn.DFun) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_dfun.type_, 0);
       pp(_dfun.id_, 0);
       render("(");
       pp(_dfun.listarg_, 0);
       render(")");
       render("{");
       pp(_dfun.liststm_, 0);
       render("}");
       if (_i_ > 0) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.ListArg foo, int _i_)
  {
     for (java.util.Iterator<Arg> it = foo.iterator(); it.hasNext();)
     {
       pp(it.next(), 0);
       if (it.hasNext()) {
         render(",");
       } else {
         render("");
       }
     }
  }

  private static void pp(grammar.Absyn.ListStm foo, int _i_)
  {
     for (java.util.Iterator<Stm> it = foo.iterator(); it.hasNext();)
     {
       pp(it.next(), 0);
       if (it.hasNext()) {
         render("");
       } else {
         render("");
       }
     }
  }

  private static void pp(grammar.Absyn.Arg foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.ADecl)
    {
       grammar.Absyn.ADecl _adecl = (grammar.Absyn.ADecl) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_adecl.type_, 0);
       pp(_adecl.id_, 0);
       if (_i_ > 0) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.Stm foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.SExp)
    {
       grammar.Absyn.SExp _sexp = (grammar.Absyn.SExp) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_sexp.exp_, 0);
       render(";");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SDecl)
    {
       grammar.Absyn.SDecl _sdecl = (grammar.Absyn.SDecl) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_sdecl.type_, 0);
       pp(_sdecl.id_, 0);
       render(";");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SDecls)
    {
       grammar.Absyn.SDecls _sdecls = (grammar.Absyn.SDecls) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_sdecls.type_, 0);
       pp(_sdecls.id_, 0);
       render(",");
       pp(_sdecls.listid_, 0);
       render(";");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SInit)
    {
       grammar.Absyn.SInit _sinit = (grammar.Absyn.SInit) foo;
       if (_i_ > 0) render(_L_PAREN);
       pp(_sinit.type_, 0);
       pp(_sinit.id_, 0);
       render("=");
       pp(_sinit.exp_, 0);
       render(";");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SReturn)
    {
       grammar.Absyn.SReturn _sreturn = (grammar.Absyn.SReturn) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("return");
       pp(_sreturn.exp_, 0);
       render(";");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SWhile)
    {
       grammar.Absyn.SWhile _swhile = (grammar.Absyn.SWhile) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("while");
       render("(");
       pp(_swhile.exp_, 0);
       render(")");
       pp(_swhile.stm_, 0);
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SBlock)
    {
       grammar.Absyn.SBlock _sblock = (grammar.Absyn.SBlock) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("{");
       pp(_sblock.liststm_, 0);
       render("}");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.SIfElse)
    {
       grammar.Absyn.SIfElse _sifelse = (grammar.Absyn.SIfElse) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("if");
       render("(");
       pp(_sifelse.exp_, 0);
       render(")");
       pp(_sifelse.stm_1, 0);
       render("else");
       pp(_sifelse.stm_2, 0);
       if (_i_ > 0) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.Exp foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.EInt)
    {
       grammar.Absyn.EInt _eint = (grammar.Absyn.EInt) foo;
       if (_i_ > 15) render(_L_PAREN);
       pp(_eint.integer_, 0);
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EDouble)
    {
       grammar.Absyn.EDouble _edouble = (grammar.Absyn.EDouble) foo;
       if (_i_ > 15) render(_L_PAREN);
       pp(_edouble.double_, 0);
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EString)
    {
       grammar.Absyn.EString _estring = (grammar.Absyn.EString) foo;
       if (_i_ > 15) render(_L_PAREN);
       printQuoted(_estring.string_);
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ETrue)
    {
       grammar.Absyn.ETrue _etrue = (grammar.Absyn.ETrue) foo;
       if (_i_ > 15) render(_L_PAREN);
       render("true");
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EFalse)
    {
       grammar.Absyn.EFalse _efalse = (grammar.Absyn.EFalse) foo;
       if (_i_ > 15) render(_L_PAREN);
       render("false");
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EId)
    {
       grammar.Absyn.EId _eid = (grammar.Absyn.EId) foo;
       if (_i_ > 15) render(_L_PAREN);
       pp(_eid.id_, 0);
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ECall)
    {
       grammar.Absyn.ECall _ecall = (grammar.Absyn.ECall) foo;
       if (_i_ > 15) render(_L_PAREN);
       pp(_ecall.id_, 0);
       render("(");
       pp(_ecall.listexp_, 0);
       render(")");
       if (_i_ > 15) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EPIncr)
    {
       grammar.Absyn.EPIncr _epincr = (grammar.Absyn.EPIncr) foo;
       if (_i_ > 14) render(_L_PAREN);
       pp(_epincr.exp_, 15);
       render("++");
       if (_i_ > 14) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EPDecr)
    {
       grammar.Absyn.EPDecr _epdecr = (grammar.Absyn.EPDecr) foo;
       if (_i_ > 14) render(_L_PAREN);
       pp(_epdecr.exp_, 15);
       render("--");
       if (_i_ > 14) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EIncr)
    {
       grammar.Absyn.EIncr _eincr = (grammar.Absyn.EIncr) foo;
       if (_i_ > 13) render(_L_PAREN);
       render("++");
       pp(_eincr.exp_, 14);
       if (_i_ > 13) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EDecr)
    {
       grammar.Absyn.EDecr _edecr = (grammar.Absyn.EDecr) foo;
       if (_i_ > 13) render(_L_PAREN);
       render("--");
       pp(_edecr.exp_, 14);
       if (_i_ > 13) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ENeg)
    {
       grammar.Absyn.ENeg _eneg = (grammar.Absyn.ENeg) foo;
       if (_i_ > 13) render(_L_PAREN);
       render("-");
       pp(_eneg.exp_, 14);
       if (_i_ > 13) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EMul)
    {
       grammar.Absyn.EMul _emul = (grammar.Absyn.EMul) foo;
       if (_i_ > 12) render(_L_PAREN);
       pp(_emul.exp_1, 12);
       render("*");
       pp(_emul.exp_2, 13);
       if (_i_ > 12) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EDiv)
    {
       grammar.Absyn.EDiv _ediv = (grammar.Absyn.EDiv) foo;
       if (_i_ > 12) render(_L_PAREN);
       pp(_ediv.exp_1, 12);
       render("/");
       pp(_ediv.exp_2, 13);
       if (_i_ > 12) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EAdd)
    {
       grammar.Absyn.EAdd _eadd = (grammar.Absyn.EAdd) foo;
       if (_i_ > 11) render(_L_PAREN);
       pp(_eadd.exp_1, 11);
       render("+");
       pp(_eadd.exp_2, 12);
       if (_i_ > 11) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ESub)
    {
       grammar.Absyn.ESub _esub = (grammar.Absyn.ESub) foo;
       if (_i_ > 11) render(_L_PAREN);
       pp(_esub.exp_1, 11);
       render("-");
       pp(_esub.exp_2, 12);
       if (_i_ > 11) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ELt)
    {
       grammar.Absyn.ELt _elt = (grammar.Absyn.ELt) foo;
       if (_i_ > 9) render(_L_PAREN);
       pp(_elt.exp_1, 9);
       render("<");
       pp(_elt.exp_2, 10);
       if (_i_ > 9) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EGt)
    {
       grammar.Absyn.EGt _egt = (grammar.Absyn.EGt) foo;
       if (_i_ > 9) render(_L_PAREN);
       pp(_egt.exp_1, 9);
       render(">");
       pp(_egt.exp_2, 10);
       if (_i_ > 9) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ELEq)
    {
       grammar.Absyn.ELEq _eleq = (grammar.Absyn.ELEq) foo;
       if (_i_ > 9) render(_L_PAREN);
       pp(_eleq.exp_1, 9);
       render("<=");
       pp(_eleq.exp_2, 10);
       if (_i_ > 9) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EGEq)
    {
       grammar.Absyn.EGEq _egeq = (grammar.Absyn.EGEq) foo;
       if (_i_ > 9) render(_L_PAREN);
       pp(_egeq.exp_1, 9);
       render(">=");
       pp(_egeq.exp_2, 10);
       if (_i_ > 9) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EEq)
    {
       grammar.Absyn.EEq _eeq = (grammar.Absyn.EEq) foo;
       if (_i_ > 8) render(_L_PAREN);
       pp(_eeq.exp_1, 8);
       render("==");
       pp(_eeq.exp_2, 9);
       if (_i_ > 8) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.ENEq)
    {
       grammar.Absyn.ENEq _eneq = (grammar.Absyn.ENEq) foo;
       if (_i_ > 8) render(_L_PAREN);
       pp(_eneq.exp_1, 8);
       render("!=");
       pp(_eneq.exp_2, 9);
       if (_i_ > 8) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EAnd)
    {
       grammar.Absyn.EAnd _eand = (grammar.Absyn.EAnd) foo;
       if (_i_ > 4) render(_L_PAREN);
       pp(_eand.exp_1, 4);
       render("&&");
       pp(_eand.exp_2, 5);
       if (_i_ > 4) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EOr)
    {
       grammar.Absyn.EOr _eor = (grammar.Absyn.EOr) foo;
       if (_i_ > 3) render(_L_PAREN);
       pp(_eor.exp_1, 3);
       render("||");
       pp(_eor.exp_2, 4);
       if (_i_ > 3) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.EAss)
    {
       grammar.Absyn.EAss _eass = (grammar.Absyn.EAss) foo;
       if (_i_ > 2) render(_L_PAREN);
       pp(_eass.exp_1, 3);
       render("=");
       pp(_eass.exp_2, 2);
       if (_i_ > 2) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.ListExp foo, int _i_)
  {
     for (java.util.Iterator<Exp> it = foo.iterator(); it.hasNext();)
     {
       pp(it.next(), 0);
       if (it.hasNext()) {
         render(",");
       } else {
         render("");
       }
     }
  }

  private static void pp(grammar.Absyn.Type foo, int _i_)
  {
    if (foo instanceof grammar.Absyn.Tbool)
    {
       grammar.Absyn.Tbool _tbool = (grammar.Absyn.Tbool) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("bool");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.Tdouble)
    {
       grammar.Absyn.Tdouble _tdouble = (grammar.Absyn.Tdouble) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("double");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.Tint)
    {
       grammar.Absyn.Tint _tint = (grammar.Absyn.Tint) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("int");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.Tstring)
    {
       grammar.Absyn.Tstring _tstring = (grammar.Absyn.Tstring) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("string");
       if (_i_ > 0) render(_R_PAREN);
    }
    else     if (foo instanceof grammar.Absyn.Tvoid)
    {
       grammar.Absyn.Tvoid _tvoid = (grammar.Absyn.Tvoid) foo;
       if (_i_ > 0) render(_L_PAREN);
       render("void");
       if (_i_ > 0) render(_R_PAREN);
    }
  }

  private static void pp(grammar.Absyn.ListId foo, int _i_)
  {
     for (java.util.Iterator<String> it = foo.iterator(); it.hasNext();)
     {
       pp(it.next(), 0);
       if (it.hasNext()) {
         render(",");
       } else {
         render("");
       }
     }
  }


  private static void sh(grammar.Absyn.Program foo)
  {
    if (foo instanceof grammar.Absyn.PDefs)
    {
       grammar.Absyn.PDefs _pdefs = (grammar.Absyn.PDefs) foo;
       render("(");
       render("PDefs");
       render("[");
       sh(_pdefs.listdef_);
       render("]");
       render(")");
    }
  }

  private static void sh(grammar.Absyn.ListDef foo)
  {
     for (java.util.Iterator<Def> it = foo.iterator(); it.hasNext();)
     {
       sh(it.next());
       if (it.hasNext())
         render(",");
     }
  }

  private static void sh(grammar.Absyn.Def foo)
  {
    if (foo instanceof grammar.Absyn.DFun)
    {
       grammar.Absyn.DFun _dfun = (grammar.Absyn.DFun) foo;
       render("(");
       render("DFun");
       sh(_dfun.type_);
       sh(_dfun.id_);
       render("[");
       sh(_dfun.listarg_);
       render("]");
       render("[");
       sh(_dfun.liststm_);
       render("]");
       render(")");
    }
  }

  private static void sh(grammar.Absyn.ListArg foo)
  {
     for (java.util.Iterator<Arg> it = foo.iterator(); it.hasNext();)
     {
       sh(it.next());
       if (it.hasNext())
         render(",");
     }
  }

  private static void sh(grammar.Absyn.ListStm foo)
  {
     for (java.util.Iterator<Stm> it = foo.iterator(); it.hasNext();)
     {
       sh(it.next());
       if (it.hasNext())
         render(",");
     }
  }

  private static void sh(grammar.Absyn.Arg foo)
  {
    if (foo instanceof grammar.Absyn.ADecl)
    {
       grammar.Absyn.ADecl _adecl = (grammar.Absyn.ADecl) foo;
       render("(");
       render("ADecl");
       sh(_adecl.type_);
       sh(_adecl.id_);
       render(")");
    }
  }

  private static void sh(grammar.Absyn.Stm foo)
  {
    if (foo instanceof grammar.Absyn.SExp)
    {
       grammar.Absyn.SExp _sexp = (grammar.Absyn.SExp) foo;
       render("(");
       render("SExp");
       sh(_sexp.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.SDecl)
    {
       grammar.Absyn.SDecl _sdecl = (grammar.Absyn.SDecl) foo;
       render("(");
       render("SDecl");
       sh(_sdecl.type_);
       sh(_sdecl.id_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.SDecls)
    {
       grammar.Absyn.SDecls _sdecls = (grammar.Absyn.SDecls) foo;
       render("(");
       render("SDecls");
       sh(_sdecls.type_);
       sh(_sdecls.id_);
       render("[");
       sh(_sdecls.listid_);
       render("]");
       render(")");
    }
    if (foo instanceof grammar.Absyn.SInit)
    {
       grammar.Absyn.SInit _sinit = (grammar.Absyn.SInit) foo;
       render("(");
       render("SInit");
       sh(_sinit.type_);
       sh(_sinit.id_);
       sh(_sinit.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.SReturn)
    {
       grammar.Absyn.SReturn _sreturn = (grammar.Absyn.SReturn) foo;
       render("(");
       render("SReturn");
       sh(_sreturn.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.SWhile)
    {
       grammar.Absyn.SWhile _swhile = (grammar.Absyn.SWhile) foo;
       render("(");
       render("SWhile");
       sh(_swhile.exp_);
       sh(_swhile.stm_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.SBlock)
    {
       grammar.Absyn.SBlock _sblock = (grammar.Absyn.SBlock) foo;
       render("(");
       render("SBlock");
       render("[");
       sh(_sblock.liststm_);
       render("]");
       render(")");
    }
    if (foo instanceof grammar.Absyn.SIfElse)
    {
       grammar.Absyn.SIfElse _sifelse = (grammar.Absyn.SIfElse) foo;
       render("(");
       render("SIfElse");
       sh(_sifelse.exp_);
       sh(_sifelse.stm_1);
       sh(_sifelse.stm_2);
       render(")");
    }
  }

  private static void sh(grammar.Absyn.Exp foo)
  {
    if (foo instanceof grammar.Absyn.EInt)
    {
       grammar.Absyn.EInt _eint = (grammar.Absyn.EInt) foo;
       render("(");
       render("EInt");
       sh(_eint.integer_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EDouble)
    {
       grammar.Absyn.EDouble _edouble = (grammar.Absyn.EDouble) foo;
       render("(");
       render("EDouble");
       sh(_edouble.double_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EString)
    {
       grammar.Absyn.EString _estring = (grammar.Absyn.EString) foo;
       render("(");
       render("EString");
       sh(_estring.string_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ETrue)
    {
       grammar.Absyn.ETrue _etrue = (grammar.Absyn.ETrue) foo;
       render("ETrue");
    }
    if (foo instanceof grammar.Absyn.EFalse)
    {
       grammar.Absyn.EFalse _efalse = (grammar.Absyn.EFalse) foo;
       render("EFalse");
    }
    if (foo instanceof grammar.Absyn.EId)
    {
       grammar.Absyn.EId _eid = (grammar.Absyn.EId) foo;
       render("(");
       render("EId");
       sh(_eid.id_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ECall)
    {
       grammar.Absyn.ECall _ecall = (grammar.Absyn.ECall) foo;
       render("(");
       render("ECall");
       sh(_ecall.id_);
       render("[");
       sh(_ecall.listexp_);
       render("]");
       render(")");
    }
    if (foo instanceof grammar.Absyn.EPIncr)
    {
       grammar.Absyn.EPIncr _epincr = (grammar.Absyn.EPIncr) foo;
       render("(");
       render("EPIncr");
       sh(_epincr.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EPDecr)
    {
       grammar.Absyn.EPDecr _epdecr = (grammar.Absyn.EPDecr) foo;
       render("(");
       render("EPDecr");
       sh(_epdecr.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EIncr)
    {
       grammar.Absyn.EIncr _eincr = (grammar.Absyn.EIncr) foo;
       render("(");
       render("EIncr");
       sh(_eincr.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EDecr)
    {
       grammar.Absyn.EDecr _edecr = (grammar.Absyn.EDecr) foo;
       render("(");
       render("EDecr");
       sh(_edecr.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ENeg)
    {
       grammar.Absyn.ENeg _eneg = (grammar.Absyn.ENeg) foo;
       render("(");
       render("ENeg");
       sh(_eneg.exp_);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EMul)
    {
       grammar.Absyn.EMul _emul = (grammar.Absyn.EMul) foo;
       render("(");
       render("EMul");
       sh(_emul.exp_1);
       sh(_emul.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EDiv)
    {
       grammar.Absyn.EDiv _ediv = (grammar.Absyn.EDiv) foo;
       render("(");
       render("EDiv");
       sh(_ediv.exp_1);
       sh(_ediv.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EAdd)
    {
       grammar.Absyn.EAdd _eadd = (grammar.Absyn.EAdd) foo;
       render("(");
       render("EAdd");
       sh(_eadd.exp_1);
       sh(_eadd.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ESub)
    {
       grammar.Absyn.ESub _esub = (grammar.Absyn.ESub) foo;
       render("(");
       render("ESub");
       sh(_esub.exp_1);
       sh(_esub.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ELt)
    {
       grammar.Absyn.ELt _elt = (grammar.Absyn.ELt) foo;
       render("(");
       render("ELt");
       sh(_elt.exp_1);
       sh(_elt.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EGt)
    {
       grammar.Absyn.EGt _egt = (grammar.Absyn.EGt) foo;
       render("(");
       render("EGt");
       sh(_egt.exp_1);
       sh(_egt.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ELEq)
    {
       grammar.Absyn.ELEq _eleq = (grammar.Absyn.ELEq) foo;
       render("(");
       render("ELEq");
       sh(_eleq.exp_1);
       sh(_eleq.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EGEq)
    {
       grammar.Absyn.EGEq _egeq = (grammar.Absyn.EGEq) foo;
       render("(");
       render("EGEq");
       sh(_egeq.exp_1);
       sh(_egeq.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EEq)
    {
       grammar.Absyn.EEq _eeq = (grammar.Absyn.EEq) foo;
       render("(");
       render("EEq");
       sh(_eeq.exp_1);
       sh(_eeq.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.ENEq)
    {
       grammar.Absyn.ENEq _eneq = (grammar.Absyn.ENEq) foo;
       render("(");
       render("ENEq");
       sh(_eneq.exp_1);
       sh(_eneq.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EAnd)
    {
       grammar.Absyn.EAnd _eand = (grammar.Absyn.EAnd) foo;
       render("(");
       render("EAnd");
       sh(_eand.exp_1);
       sh(_eand.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EOr)
    {
       grammar.Absyn.EOr _eor = (grammar.Absyn.EOr) foo;
       render("(");
       render("EOr");
       sh(_eor.exp_1);
       sh(_eor.exp_2);
       render(")");
    }
    if (foo instanceof grammar.Absyn.EAss)
    {
       grammar.Absyn.EAss _eass = (grammar.Absyn.EAss) foo;
       render("(");
       render("EAss");
       sh(_eass.exp_1);
       sh(_eass.exp_2);
       render(")");
    }
  }

  private static void sh(grammar.Absyn.ListExp foo)
  {
     for (java.util.Iterator<Exp> it = foo.iterator(); it.hasNext();)
     {
       sh(it.next());
       if (it.hasNext())
         render(",");
     }
  }

  private static void sh(grammar.Absyn.Type foo)
  {
    if (foo instanceof grammar.Absyn.Tbool)
    {
       grammar.Absyn.Tbool _tbool = (grammar.Absyn.Tbool) foo;
       render("Tbool");
    }
    if (foo instanceof grammar.Absyn.Tdouble)
    {
       grammar.Absyn.Tdouble _tdouble = (grammar.Absyn.Tdouble) foo;
       render("Tdouble");
    }
    if (foo instanceof grammar.Absyn.Tint)
    {
       grammar.Absyn.Tint _tint = (grammar.Absyn.Tint) foo;
       render("Tint");
    }
    if (foo instanceof grammar.Absyn.Tstring)
    {
       grammar.Absyn.Tstring _tstring = (grammar.Absyn.Tstring) foo;
       render("Tstring");
    }
    if (foo instanceof grammar.Absyn.Tvoid)
    {
       grammar.Absyn.Tvoid _tvoid = (grammar.Absyn.Tvoid) foo;
       render("Tvoid");
    }
  }

  private static void sh(grammar.Absyn.ListId foo)
  {
     for (java.util.Iterator<String> it = foo.iterator(); it.hasNext();)
     {
       sh(it.next());
       if (it.hasNext())
         render(",");
     }
  }


  private static void pp(Integer n, int _i_) { buf_.append(n); buf_.append(" "); }
  private static void pp(Double d, int _i_) { buf_.append(d); buf_.append(" "); }
  private static void pp(String s, int _i_) { buf_.append(s); buf_.append(" "); }
  private static void pp(Character c, int _i_) { buf_.append("'" + c.toString() + "'"); buf_.append(" "); }
  private static void sh(Integer n) { render(n.toString()); }
  private static void sh(Double d) { render(d.toString()); }
  private static void sh(Character c) { render(c.toString()); }
  private static void sh(String s) { printQuoted(s); }
  private static void printQuoted(String s) { render("\"" + s + "\""); }
  private static void indent()
  {
    int n = _n_;
    while (n > 0)
    {
      buf_.append(" ");
      n--;
    }
  }
  private static void backup()
  {
     if (buf_.charAt(buf_.length() - 1) == ' ') {
      buf_.setLength(buf_.length() - 1);
    }
  }
  private static void trim()
  {
     while (buf_.length() > 0 && buf_.charAt(0) == ' ')
        buf_.deleteCharAt(0); 
    while (buf_.length() > 0 && buf_.charAt(buf_.length()-1) == ' ')
        buf_.deleteCharAt(buf_.length()-1);
  }
  private static int _n_ = 0;
  private static StringBuilder buf_ = new StringBuilder(INITIAL_BUFFER_SIZE);
}

