module PhysicalVectors

using Reexport
using LinearAlgebra
@reexport using StaticArrays

@reexport import LinearAlgebra:
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



include("signatures.jl")
include("metric.jl")
include("vector.jl")




end
