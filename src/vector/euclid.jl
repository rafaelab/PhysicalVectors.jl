# ----------------------------------------------------------------------------------------------- #
# 
export 
	VectorEuclid

# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	VectorEuclid{D, T, V <: StaticVector{D, T}}

A structure representing a Euclidean vector in a physical vector space.\\ 
It is parameterised by:\\
- `D`: dimensionality of the vector \\
- `T`: element type of the vector \\
- `V`: sub-type of `StaticVector{D, T}` representing the underlying static vector \\

# Fields
- `vector::V`: the underlying static vector storing the data.

# Available constructors
- `VectorEuclid(v::StaticVector{D, T})` \\
- `VectorEuclid(v::AbstractVector{T})` \\
- `VectorEuclid(vs::Vararg{<: Number})` \\
"""
struct VectorEuclid{D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
	vector::V
end



@physicalVectorConstructors VectorEuclid

# ----------------------------------------------------------------------------------------------- #
# 
function Base.getproperty(v::VectorEuclid{D, T}, u::Symbol) where {D, T}
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
	dot(v1::VectorEuclid{D, T1}, v2::VectorEuclid{D, T2}) -> Number
	dot(v1::VectorEuclid{D, T1}, v2::VectorEuclid{D, T2}, m::AbstractMetric) -> Number

Computes the dot product of two Euclidean vectors `v1` and `v2` using their internal vector representations, for a given metric `m`. \\
The metric here makes no difference whatsoever, as the dot product is invariant under any metric, by construction.\\
The method involving the metric is included for consistency with the Lorentzian case.\\

# Input
- `v1::VectorLorentz`: first Lorentz vector \\
- `v2::VectorLorentz`: second Lorentz vector \\
- `m::AbstractMetric`: an `AbstractMetric`-type object; defaults to Minkowski \\

# Output
- `Number`: the dot product of the two Lorentz vectors. \\
"""
function dot(v1::VectorEuclid, v2::VectorEuclid) 
	return  @fastmath dot(v1.vector, v2.vector)
end

function dot(v1::VectorEuclid, v2::VectorEuclid, m::AbstractMetric)
	size(m)[1] == length(v1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return dot(v1, v2)
end



# ----------------------------------------------------------------------------------------------- #
