#include <iostream>
#include <vector>
#include <mtp/blas_interface/dot_prod.h>

int main() {

    std::vector<double> vec1{7.3, 2.2, -1.5, 2.8};
    std::vector<double> vec2{1.1, 5.6, 11.0, 4.9};

    std::cout << "my funny dot product is " << my_funny_dot(vec1, vec2) << std::endl;

    return 0;

}