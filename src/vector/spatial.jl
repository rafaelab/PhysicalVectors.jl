# ----------------------------------------------------------------------------------------------- #
# 
export 
	VectorSpatial,
	norm2,
	norm²

# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	VectorSpatial{D, T, V <: StaticVector{D, T}}

A structure representing a spatial vector in a physical vector space.\\ 
It is parameterised by:\\
- `D`: dimensionality of the vector \\
- `T`: element type of the vector \\
- `V`: sub-type of `StaticVector{D, T}` representing the underlying static vector \\

# Fields
- `vector::V`: the underlying static vector storing the data.

# Available constructors
- `VectorSpatial(v::StaticVector{D, T})`
- `VectorSpatial(v::AbstractVector{T})`
- `VectorSpatial(vs::Vararg{<: Number})`
"""
struct VectorSpatial{D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
	vector::V
end

@physicalVectorConstructors VectorSpatial


# ----------------------------------------------------------------------------------------------- #
# 
function Base.getproperty(v::VectorSpatial{D, T}, u::Symbol) where {D, T}
	if D ≥ 1 && u == :x
		return v.vector[1]
	elseif D ≥ 2 && u == :y
		return v.vector[2]
	elseif D ≥ 3 && u == :z
		return v.vector[3]
	end
	
	return getfield(v, u)
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	dot(v1::VectorSpatial{D, T1}, v2::VectorSpatial{D, T2}) -> Number
	dot(v1::VectorSpatial{D, T1}, v2::VectorSpatial{D, T2}, m::AbstractMetric) -> Number

Computes the dot product of two spatial vectors `v1` and `v2` using their internal vector representations, for a given metric `m`. \\
The metric here makes no difference whatsoever, as the dot product is invariant under any metric, by construction.\\
The method involving the metric is included for consistency with the Lorentzian case.\\

# Input
- `v1::VectorLorentz`: first Lorentz vector
- `v2::VectorLorentz`: second Lorentz vector
. (optional) `m::AbstractMetric`: an `AbstractMetric`-type object; defaults to Minkowski

# Output
- `Number`: the dot product of the two Lorentz vectors
"""
function dot(v1::VectorSpatial, v2::VectorSpatial) 
	return  @fastmath dot(v1.vector, v2.vector)
end

function dot(v1::VectorSpatial, v2::VectorSpatial, m::AbstractMetric)
	size(m)[1] == length(v1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return  dot(v1, v2) ##### FIX!!!!!!!!!!!
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	cross(v1::VectorSpatial, v2::VectorSpatial) -> VectorSpatial

Compute the cross product of two 3D spatial vectors `v1` and `v2`.\\
This function is only defined for 3-dimensional vectors.\\
It throw a `DimensionMismatch` error if the vectors are not 3D.\\

# Input
- `v1::VectorSpatial`:  first 3D spatial vector
- `v2::VectorSpatial`:  second 3D spatial vector

# Output
- A new `VectorSpatial` object representing the cross product of `v1` and `v2`.

# Notes
The cross product is only defined for 3-dimensional vectors. Ensure that both input vectors have a length of 3 before calling this function.
"""
function cross(v1::VectorSpatial, v2::VectorSpatial)
	if length(v1) ≠ 3 || length(v2) ≠ 3
		throw(DimensionMismatch("Cross product is only defined for 3D vectors."))
	end
	return VectorSpatial(cross(v1.vector, v2.vector))
end

# ----------------------------------------------------------------------------------------------- #
