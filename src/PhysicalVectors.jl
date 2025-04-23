module PhysicalVectors

using Reexport
@reexport using StaticArrays

@reexport import LinearAlgebra:
	Diagonal,
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


# using .PhysicalVectors


# v = VectorLorentz(1., 2., 3.3, 2.)

# u = VectorEuclid(@MVector([1., 2., 3.]))

# PhysicalVectors.getSpatialPart(v)

# # size(v)

# # v[2] = 10.

# # v