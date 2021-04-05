#include <cstdlib>
#include <cmath>
#include <vector>
#include <mtp/blas_interface/dot_prod.h>

int main() {

    std::vector<double> vec1{7.3, 1.0};
    std::vector<double> vec2{2.0, 3.0};

    const double correct_value = ( 7.3 * 2.0 + 1.0 * 3.0 ) / ( 7.3 + 1.0 );

    if ( std::fabs( correct_value - my_funny_dot(vec1, vec2) ) > 1.0e-12 ) {
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;

}