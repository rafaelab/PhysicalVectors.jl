module PhysicalVectors

using LinearAlgebra
using PhysicalConstants.CODATA2022
using StaticArrays
using Unitful

import LinearAlgebra:
	Diagonal,
	I,
	norm,
	dot,
	cross,
	transpose,
	adjoint,
	inv,
	det,
	eigvals,
	eigvecs,
	eigen


include("unitsConstants.jl")
include("signatures.jl")
include("metric.jl")
include("vector.jl")




end
