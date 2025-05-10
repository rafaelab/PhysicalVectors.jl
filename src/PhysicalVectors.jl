module PhysicalVectors

using LinearAlgebra
using Random
using StaticArrays
using Unitful
using Cosmonstants
using Cosmonstants.Constants

import LinearAlgebra:
	Diagonal,
	I,
	norm,
	dot,
	cross

import Random:
	AbstractRNG


	
include("unitsConstants.jl")
include("common.jl")
include("signatures.jl")
include("metric.jl")
include("vector.jl")
include("algebra.jl")
# include("random.jl")

end
