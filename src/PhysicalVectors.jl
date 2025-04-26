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


using .PhysicalVectors
import .PhysicalVectors: FourPosition, FourMomentum

# Create a FourPosition
pos = FourPosition([1.0, 2.0, 3.0, 4.0])
println(pos.vector)  # Output: VectorLorentz(SVector(1.0, 2.0, 3.0, 4.0))

# Create a FourMomentum
mom = FourMomentum([1.0, 2.0, 3.0, 4.0])
println(mom.vector)  # Output: VectorLorentz(MVector(1.0, 2.0, 3.0, 4.0))

# Access properties
println(pos.t)  # Output: 4.0 (temporal component)
println(mom.x)  # Output: 1.0 (spatial component)