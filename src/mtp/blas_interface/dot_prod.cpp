#include <mtp/blas_interface/setup.h>
#include <mtp/blas_interface/dot_prod.h>
#include <mtp/blas_interface/sum.h>

#if MTP_HAVE_BLAS_GENERIC
extern "C" {
    double MTP_BLAS_MANGLE(ddot)(int * n, double * dx, int * incx, double * dy, int * incy);
}
#endif

double my_funny_dot(const std::vector<double> & v1, const std::vector<double> & v2) {

    int n = v1.size();
    int incx = 1;
    int incy = 1;
    double * x = const_cast<double *>(&v1.at(0));
    double * y = const_cast<double *>(&v2.at(0));

    #if MTP_HAVE_CBLAS
    double retval = cblas_ddot(n, x, incx, y, incy);
    #endif

    #if MTP_HAVE_BLAS_GENERIC
    double retval = MTP_BLAS_MANGLE(ddot)(&n, x, &incx, y, &incy);
    #endif

    retval = retval / my_sum(v1);
    return retval;

}