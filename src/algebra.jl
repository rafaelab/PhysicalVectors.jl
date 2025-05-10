export
	dot,
	cross,
	norm2,
	norm,
	norm²

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	dot

Defines the `dot` function, which is typically used to compute the dot product of two vectors. 
This is a placeholder definition and should be extended with specific methods for the desired types.
"""
function dot end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	cross

Defines the `cross` function commonly used for vector products. 
This is a placeholder definition and should be extended with specific methods for the desired types.
"""
function cross end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	norm2(v::AbstractPhysicalVector{D, T}) -> T
	norm2(v::AbstractPhysicalVector{D, T}, m::AbstractMetric{D, U}) -> T
	norm²(args...) -> T

Compute the squared norm of a Lorentz vector `v` using the default metric. 
The norm is defined as the square root of the dot product of the vector with itself.

# Input
- `v::AbstractPhysicalVector`: the vector
- `m::AbstractMetric`: the metric used to compute the dot product (optional)

# Output
- `T`: The computed norm2 of the Lorentz vector
"""
@inline norm2(v::AbstractPhysicalVector) = dot(v, v)

@inline norm2(v::AbstractPhysicalVector{D, T}, m::AbstractMetric{D, U}) where {D, T, U} = begin
	return dot(v, v, m)
end

const norm² = norm2


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
@inline norm(v::AbstractPhysicalVector) = sqrt(norm²(v))

@inline norm(v::AbstractPhysicalVector, metric::AbstractMetric) = sqrt(norm²(v, metric))


# ----------------------------------------------------------------------------------------------- #
#