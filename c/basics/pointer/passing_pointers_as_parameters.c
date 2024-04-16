#include <stdio.h>

void decompose(double x, long *int_part, double *frac_part) {
  *int_part = (long)x;
  *frac_part = x - *int_part;
}

int main() {
  double x = 3.14159;
  long int_part;
  double frac_part;

  decompose(x, &int_part, &frac_part);

  printf("int_part = %ld, frac_part = %f\n", int_part,
         frac_part); // int_part = 3, frac_part = 0.141590

  return 0;
}