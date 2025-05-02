# PhysicalVectors.jl


[![Build Status](https://github.com/rafaelab/PhysicalVectors.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/rafaelab/PhysicalVectors.jl/actions)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://rafaelab.github.io/PhysicalVectors.jl/index.html)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)


PhysicalVectors.jl is a Julia package for representing and manipulating physical vectors in various geometric spaces, such as Euclidean and Lorentzian spaces. 
It provides a flexible and efficient framework for working with vectors that have physical or geometric interpretations.

The vectors can be implemented in any dimension. 
For instance, a `VectorLorentz` can be implemented in 1+1D, which enables a wide range of analyses.

This package is closely related to [PhysicalVectors](https://github.com/rafaelab/PhysicalVectors.jl), which is currently under development (private).
Functionalities such as Lorentz boosts, for example, are being implemented directly in this other package.


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

Vectors can be defined in any dimension desired.
```julia
x = VectorSpatial(1., 0.) ## 2D vector
```

In the case of "four" vectors (which can be in any dimension), the last entry correspond to the temporal part.
It has to be defined in a consistent way with respect to the spatial part, with the `c`s.
```julia
X = FourPosition(1e10, 0, 0, c)
x = getSpatialPart(X)
ct = getTemporalPart(X)
```
Note that `c` is explicitly defined as a constant, referring to the speed of light in S.I. units.

A few operations based on four-vectors and the metric are implemented by default, including inner product.
```julia
V = VectorLorentz(3., 0., 0., 1.)
g = MetricMinkowski(4)
v = dot(V, v, g)
```

All vectors accept basic arithmetic operations.
```julia
x1 = VectorSpatial(1., 2., 0.)
x2 = VectorSpatial(0., 0., 1.)
x = x1 + x2 # VectorSpatial(1., 2., 1.)
y = 2. * x1 # VectorSpatial(2., 4., 0.)
```


Although this has not yet been explicitly tested, `Unitful` quantities should also be accepted as input, although there are currently no checks preventing inconsistencies such as:
```julia
X = FourPosition(u"kg", 0, 0, c)
```



## Development notes

I was tempted to implement specific physical quantities such as `PositionVector`, `VelocityVector`, etc.
While this would be great for dispatching, it also creates some complications that would require loads of lines of code to fix, as well as some advanced macros.
Therefore, the basic types are really `VectorSpatial` (for ND vectors), and `VectorLorentz` (for (N + 1)D vectors, where N is the number of spatial dimensions).
Nevertheless, convenient types that I use a lot such as `FourMomentum`, `FourPosition`, `FourVelocity`, and `FourCurrentDensity` are provided.


## To-do list

- Implement coordinate systems (spherical, cylindrical, etc).
- Compute some useful quantities such as rapidity, from the four-vectors. 

