export 
	VectorSpatial,
	norm2,
	norm²


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	VectorSpatial{D, T, V <: StaticVector{D, T}}

A structure representing a spatial vector in a physical vector space.
It is parameterised by:
- `D`: dimensionality of the vector
- `T`: element type of the vector
- `V`: sub-type of `StaticVector{D, T}` representing the underlying static vector

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
function Base.:(+)(v1::VectorSpatial, v2::VectorSpatial)
	length(v1) == length(v2) || throw(DimensionMismatch("Vector dimensions do not match."))
	return VectorSpatial(v1.vector + v2.vector)
end
Base.:(+)(v::VectorSpatial) = VectorSpatial(+v.vector)
Base.:(+)(v::VectorSpatial{D, T}, a::Number) where {D, T} = VectorSpatial(v.vector .+ a)
Base.:(+)(a::Number, v::VectorSpatial) = Base.:(+)(v, a)

function Base.:(-)(v1::VectorSpatial, v2::VectorSpatial)
	length(v1) == length(v2) || throw(DimensionMismatch("Vector dimensions do not match."))
	return VectorSpatial(v1.vector - v2.vector)
end
Base.:(-)(v::VectorSpatial) = VectorSpatial(-v.vector)
Base.:(-)(v::VectorSpatial{D, T}, a::Number) where {D, T} = VectorSpatial(v.vector .- a)
Base.:(-)(a::Number, v::VectorSpatial) = VectorSpatial(a .- v.vector)

Base.:(*)(v::VectorSpatial{D, T}, a::Number) where {D, T} = VectorSpatial(v.vector * a)
Base.:(*)(a::Number, v::VectorSpatial) = Base.:(*)(v, a)

Base.:(/)(v::VectorSpatial{D, T}, a::Number) where {D, T} = VectorSpatial(v.vector / a)
Base.:(/)(a::Number, v::VectorSpatial) = VectorSpatial(transpose(a / v.vector))



# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	dot(v1::VectorSpatial{D, T1}, v2::VectorSpatial{D, T2}) -> Number
	dot(v1::VectorSpatial{D, T1}, v2::VectorSpatial{D, T2}, m::AbstractMetric) -> Number

Compute the Euclidean dot product when no metric is supplied.
With a metric `m`, compute `dot(v1.vector, getMetricTensor(m) * v2.vector)`.
For complex components, the first vector is conjugated, following `LinearAlgebra.dot`.

# Input
- `v1` [`VectorSpatial`]: first Spatial vector
- `v2` [`VectorSpatial`]: second Spatial vector
- `m` [`AbstractMetric`]: optional metric tensor; without it, use the Euclidean dot product

# Output
- `Number`: the dot product of the two spatial vectors
"""
function dot(v1::VectorSpatial, v2::VectorSpatial) 
	return  @fastmath dot(v1.vector, v2.vector)
end

function dot(v1::VectorSpatial, v2::VectorSpatial, m::AbstractMetric)
	length(v1) == length(v2) == size(m, 1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return dot(v1.vector, getMetricTensor(m) * v2.vector)
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	cross(v1::VectorSpatial, v2::VectorSpatial) -> VectorSpatial

Compute the cross product of two 3D spatial vectors `v1` and `v2`.
This function is only defined for 3-dimensional vectors.
It throws a `DimensionMismatch` error if the vectors are not 3D.

# Input
- `v1` [`VectorSpatial`]: first 3D spatial vector
- `v2` [`VectorSpatial`]: second 3D spatial vector

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
