// Andreas, 2015-02-11

int main () {
  int x = 0;
  x++;
  printInt(x++);
  return x;
  printInt (x++); // dead code
}
