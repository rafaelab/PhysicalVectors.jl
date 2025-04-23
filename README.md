# PhysicalVectors.jl


PhysicalVectors.jl is a Julia package for representing and manipulating physical vectors in various geometric spaces, such as Euclidean and Lorentzian spaces. 
It provides a flexible and efficient framework for working with vectors that have physical or geometric interpretations.


## Features

- Support for Euclidean and Lorentzian vector spaces.
- Abstract and concrete vector types (`VectorEuclid`, `VectorLorentz`, etc.).
- Integration with `StaticArrays.jl` for efficient static vector operations.
- Support for custom metrics and dot products.
- Extensible framework for defining new vector types.


## Installation

To install the package, use the Julia package manager:
 ```julia
using Pkg
Pkg.add("https://github.com/rafaelab/PhysicalVectors.jl")
```

This package is not in Julia's registry yet, until it is fully debugged.


## Examples


```julia
v = VectorLorentz(3., 0., 0., 1.)
g = MetricMinkowski(4)

v2 = dot(v, v, g)
```