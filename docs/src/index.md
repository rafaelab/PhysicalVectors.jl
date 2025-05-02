# PhysicalVectors.jl



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



## Development notes

I was tempted to implement specific physical quantities such as `PositionVector`, `VelocityVector`, etc.
While this would be great for dispatching, it also creates some complications that would require loads of lines of code to fix, as well as some advanced macros.
Therefore, the basic types are really `VectorSpatial` (for ND vectors), and `VectorLorentz` (for (N + 1)D vectors, where N is the number of spatial dimensions).
Nevertheless, convenient types that I use a lot such as `FourMomentum`, `FourPosition`, `FourVelocity`, and `FourCurrentDensity` are provided.


## To-do list

- Implement coordinate systems (spherical, cylindrical, etc).
- Compute some useful quantities such as rapidity, from the four-vectors. 

