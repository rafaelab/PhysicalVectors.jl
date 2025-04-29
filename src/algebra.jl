# ----------------------------------------------------------------------------------------------- #
#
@doc """
	norm(v::AbstractPhysicalVector{D, T}) -> T
	norm(v::AbstractPhysicalVector{D, T}, m::AbstractMetric{D, U}) -> T

Compute the norm of a Lorentz vector `v` using the default metric. 
The norm is defined as the square root of the dot product of the vector with itself.

# Input
- `v::VectorLorentz`: the Lorentz vector whose norm is to be computed.

# Output
- `T`: The computed norm of the Lorentz vector
"""
@inline norm(v::AbstractPhysicalVector) = sqrt(dot(v, v))

@inline norm(v::AbstractPhysicalVector{D, T}, m::AbstractMetric{D, U}) where {D, T, U} = begin
	return sqrt(dot(v, v, m))
end


# ----------------------------------------------------------------------------------------------- #
#