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
	cross

	
include("unitsConstants.jl")
include("common.jl")
include("signatures.jl")
include("metric.jl")
include("vector.jl")
include("algebra.jl")




end
