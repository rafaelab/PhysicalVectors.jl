# ----------------------------------------------------------------------------------------------- #
# 
export 
	VectorLorentz,
	getSpatialPart,
	getTemporalPart

# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	VectorLorentz{D, T, V <: StaticVector{D, T}}

A structure representing a Lorentzian vector in a physical vector space.\\ 
It is parameterised by:\\
- `D`: dimensionality of the vector \\
- `T`: element type of the vector \\
- `V`: sub-type of `StaticVector{D, T}` representing the underlying static vector \\

# Fields
- `vector::V`: the underlying static vector storing the data.

# Available constructors
- `VectorLorentz(v::StaticVector{D, T})` \\
- `VectorLorentz(v::AbstractVector{T})` \\
- `VectorLorentz(vs::Vararg{<: Number})` \\
"""
struct VectorLorentz{D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
	vector::V
end

@physicalVectorConstructors VectorLorentz


# ----------------------------------------------------------------------------------------------- #
# 
function Base.getproperty(v::VectorLorentz{D, T}, u::Symbol) where {D, T}
	if u == :t
		return v.vector[end]
	end

	if D ≤ 4
		if u == :x
			return v.vector[1]
		elseif u == :y && D ≥ 2
			return v.vector[2]
		elseif u == :z && D ≥ 3
			return v.vector[3]
		end
	end
	
	return getfield(v, u)
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	getSpatialPart(v::VectorLorentz) -> VectorSpatial

Extracts the spatial part of a `VectorLorentz` object. \\
The spatial part is obtained by taking all elements of the internal vector except the last one. \\

# Input
- `v::VectorLorentz`: a Lorentz vector from which the spatial part is to be extracted. \\
- `m::AbstractMetric`: an `AbstractMetric`-type object; defaults to Minkowski \\

# Output
- `VectorSpatial`: an Euclidean vector containing the spatial components of the input Lorentz vector.
"""
@inline getSpatialPart(v::VectorLorentz{D, T}) where {D, T} = VectorSpatial(v.vector[1 : end - 1])

######### METRIC NOT IMPLEMENTED CORRECTLY! 
@inline getSpatialPart(v::VectorLorentz{D, T}, ::AbstractMetric{D, U}) where {D, T, U} = getSpatialPart(v)


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	getTemporalPart(v::VectorLorentz) -> Vector{T}

Extracts the temporal part of a `VectorLorentz` object. \\
The temporal part is assumed to be the last element of the vector representation.

# Input
- `v::VectorLorentz`: Lorentz vector from which the temporal part is to be extracted. \\

# Output
- A one-element vector containing the temporal part of the input `VectorLorentz`. \\
"""
@inline getTemporalPart(v::VectorLorentz) = v.vector[end]

@inline function getTemporalPart(v::VectorLorentz, m::AbstractMetric)
	# NOT IMPLEMENTED CORRECTLY! IGNORES METRIC
	return getTemporalPart(v)
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	dot(v1::VectorLorentz, v2::VectorLorentz, m::AbstractMetric) -> Number
	dot(v1::VectorLorentz{D, T1, V}, v2::VectorLorentz{D, T2, V}, ::MetricEuclid{D, U}) -> T
	dot(v1::VectorLorentz{D, T1, V}, v2::VectorLorentz{D, T2, V}, ::MetricMinkowski{D, U, S}) -> T

Computes the dot product of two Lorentz vectors `v1` and `v2` using their internal vector representations, for a given metric `m`. \\
**Note:** This implementation currently ignores the metric `m` and defaults to the basic dot product for Minkowski.

# Note
- The metric has *necessarily* to be provided, otherwise the function will be the actual dot product of the two vectors. \\

# Input
- `v1::VectorLorentz`: first Lorentz vector \\
- `v2::VectorLorentz`: second Lorentz vector \\
- `m::AbstractMetric`: an `AbstractMetric`-type object; defaults to Minkowski \\

# Output
- `Number`: the dot product of the two Lorentz vectors. \\
"""
function dot(v1::VectorLorentz, v2::VectorLorentz, ::MetricMinkowski{D, U, MostlyMinus}) where {D, U}
	return  @fastmath getTemporalPart(v1) * getTemporalPart(v2) - dot(getSpatialPart(v1), getSpatialPart(v2))
end

function dot(v1::VectorLorentz, v2::VectorLorentz, ::MetricMinkowski{D, U, MostlyPlus}) where {D, U}
	return  @fastmath dot(getSpatialPart(v1), getSpatialPart(v2)) - getTemporalPart(v1) * getTemporalPart(v2)
end

function dot(v1::VectorLorentz, v2::VectorLorentz) 
	return @fastmath dot(v1, v2, MetricMinkowski(d, eltype(v1), MostlyPlus))
end

function dot(v1::VectorLorentz, v2::VectorLorentz, ::MetricEuclid) 
	return  @fastmath dot(v1, v2)
end



# ----------------------------------------------------------------------------------------------- #
