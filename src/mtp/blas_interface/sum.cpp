#include <mtp/blas_interface/sum.h>

double my_sum(const std::vector<double> & v) {
    double retval = 0.0;
    for ( auto x : v ) {
        retval += x;
    }
    return retval;
}