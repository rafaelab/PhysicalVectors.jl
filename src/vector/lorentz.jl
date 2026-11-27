export 
	VectorLorentz,
	getSpatialPart,
	getTemporalPart,
	FourPosition,
	FourMomentum,
	FourVelocity,
	FourCurrentDensity,
	getTime,
	getPosition,
	getEnergy,
	getMomentum


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
- `vector::V`: the underlying static vector storing the data

# Available constructors
- `VectorLorentz(v::StaticVector{D, T})`
- `VectorLorentz(v::AbstractVector{T})`
- `VectorLorentz(vs::Vararg{<: Number})`
"""
struct VectorLorentz{D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
	vector::V
end

@physicalVectorConstructors VectorLorentz



function Base.getproperty(v::VectorLorentz{D, T, V}, u::Symbol) where {D, T, V}
	if u === :t
		return v.vector[end]
	elseif u === :x && D ≥ 2
		return v.vector[1]
	elseif u === :y && D ≥ 3
		return v.vector[2]
	elseif u === :z && D ≥ 4
		return v.vector[3]
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
- `v` [`VectorLorentz`]: a Lorentz vector from which the spatial part is to be extracted. 
- `m` [`AbstractMetric`]: an `AbstractMetric`-type object; defaults to Minkowski

# Output
- `VectorSpatial`: an Euclidean vector containing the spatial components of the input Lorentz vector.
"""
@inline getSpatialPart(v::VectorLorentz) = VectorSpatial(v.vector[1 : end - 1])
@inline function getSpatialPart(v::VectorLorentz, m::AbstractMetric)
	length(v) == size(m, 1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return getSpatialPart(v)
end


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	getTemporalPart(v::VectorLorentz) -> Vector{T}

Extracts the temporal part of a `VectorLorentz` object. \\
The temporal part is assumed to be the last element of the vector representation.

# Input
- `v` [`VectorLorentz`]: Lorentz vector from which the temporal part is to be extracted

# Output
- A one-element vector containing the temporal part of the input `VectorLorentz`
"""
@inline getTemporalPart(v::VectorLorentz) = v.vector[end]
@inline function getTemporalPart(v::VectorLorentz, m::AbstractMetric)
	length(v) == size(m, 1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return getTemporalPart(v)
end


# ----------------------------------------------------------------------------------------------- #
# 
function Base.:(+)(v1::VectorLorentz, v2::VectorLorentz)
	length(v1) == length(v2) || throw(DimensionMismatch("Vector dimensions do not match."))
	return VectorLorentz(v1.vector + v2.vector)
end
Base.:(+)(v::VectorLorentz) = VectorLorentz(+v.vector)
Base.:(+)(v::VectorLorentz{D, T}, a::Number) where {D, T} = VectorLorentz(v.vector .+ a)
Base.:(+)(a::Number, v::VectorLorentz) = Base.:(+)(v, a)

function Base.:(-)(v1::VectorLorentz, v2::VectorLorentz)
	length(v1) == length(v2) || throw(DimensionMismatch("Vector dimensions do not match."))
	return VectorLorentz(v1.vector - v2.vector)
end
Base.:(-)(v::VectorLorentz) = VectorLorentz(-v.vector)
Base.:(-)(v::VectorLorentz{D, T}, a::Number) where {D, T} = VectorLorentz(v.vector .- a)
Base.:(-)(a::Number, v::VectorLorentz) = VectorLorentz(a .- v.vector)

Base.:(*)(v::VectorLorentz{D, T}, a::Number) where {D, T} = VectorLorentz(v.vector * a)
Base.:(*)(a::Number, v::VectorLorentz) = Base.:(*)(v, a)

Base.:(/)(v::VectorLorentz{D, T}, a::Number) where {D, T} = VectorLorentz(v.vector / a)
Base.:(/)(a::Number, v::VectorLorentz) = VectorLorentz(transpose(a / v.vector))


# ----------------------------------------------------------------------------------------------- #
# 
@doc """
	dot(v1::VectorLorentz, v2::VectorLorentz, m::AbstractMetric) -> Number
	dot(v1::VectorLorentz{D, T1, V}, v2::VectorLorentz{D, T2, V}, ::MetricEuclid{D, U}) -> T
	dot(v1::VectorLorentz{D, T1, V}, v2::VectorLorentz{D, T2, V}, ::MetricMinkowski{D, U, S}) -> T

Computes the dot product of two Lorentz vectors `v1` and `v2` using their internal vector representations, for a given metric `m`. \\

# Input
- `v1` [`VectorLorentz`]: first Lorentz vector
- `v2` [`VectorLorentz`]: second Lorentz vector

# Output
"- `Number`: the dot product of the two Lorentz vectors."
"""
function dot(v1::VectorLorentz, v2::VectorLorentz, m::AbstractMetric)
	length(v1) == length(v2) == size(m, 1) || throw(DimensionMismatch("Metric and vector dimensions do not match."))
	return dot(v1.vector, getMetricTensor(m) * v2.vector)
end

function dot(v1::VectorLorentz, v2::VectorLorentz)
	length(v1) == length(v2) || throw(DimensionMismatch("Vector dimensions do not match."))
	return dot(getSpatialPart(v1), getSpatialPart(v2)) - conj(getTemporalPart(v1)) * getTemporalPart(v2)
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	@generateFourVector(quantity)

Macro to generate a `FourQuantity` type and its associated methods.

This macro defines a new struct type for a four-dimensional physical quantity, 
along with constructors and utility methods for operations such as dot products 
and accessing temporal and spatial parts.

# Input
- `quantity`: name of the four-dimensional quantity to be generated

# Generated Code
- A struct definition for the `quantity` type, which is a subtype of `AbstractPhysicalVector`
- Constructors for the `quantity` type:
	-- from a `VectorLorentz` object
	-- from an `AbstractVector`
	-- from a variable number of scalar arguments
- Overloaded `Base.getproperty` to delegate property access to the underlying `VectorLorentz`
- Utility functions:
	-- `getTemporalPart`: the temporal part of the vector
	-- `getSpatialPart`:retrieves the spatial part of the vector
	-- `dot`: computes the dot product of two `quantity` objects, optionally using a metric
"""
macro generateFourVector(quantity)
	return quote
		@doc """
			struct $($(quantity)){D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
		
		
		Constructors for the `$($(quantity))` type.
		This is a usual `FourXXX` quantity. 
		This structure allows for new methods and explicit dispatching.
		# Parameters
		- `D`: the dimensionality of the vector
		- `T`: the numeric type of the vector elements (e.g., `AbstractFloat`)
		- `V`: a subtype of `StaticVector` representing the underlying vector type
		"""
		struct $(esc(quantity)){D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
			vector::VectorLorentz{D, T, V}
		end

		$(esc(quantity))(v::VectorLorentz{D, T}) where {D, T <: Number} = begin
			return $(quantity){D, T, typeof(v.vector)}(v)
		end

		$(esc(quantity))(v::AbstractVector{T}) where {T <: Number} = begin
			return $(quantity)(VectorLorentz(v))
		end

		$(esc(quantity))(vs::Number...) = begin
			return $(quantity)(VectorLorentz(vs...))
		end

		Base.getproperty(q::$(esc(quantity)), u::Symbol) = u === :vector ? getfield(q, :vector) : getproperty(q.vector, u)

		$(esc(:getTemporalPart))(q::$(esc(quantity))) = getTemporalPart(q.vector)

		$(esc(:getSpatialPart))(q::$(esc(quantity))) = getSpatialPart(q.vector)

		$(esc(:dot))(q1::$(esc(quantity)), q2::$(esc(quantity))) = dot(q1.vector, q2.vector)

		$(esc(:dot))(q1::$(esc(quantity)), q2::$(esc(quantity)), m::AbstractMetric{D, U}) where {D, U} = begin
			return dot(q1.vector, q2.vector, m)
		end

		Base.:(+)(v1::$(esc(quantity)), v2::$(esc(quantity))) = $(esc(quantity))(v1.vector + v2.vector)
		Base.:(-)(v1::$(esc(quantity)), v2::$(esc(quantity))) = $(esc(quantity))(v1.vector - v2.vector)
		Base.:(+)(v::$(esc(quantity))) = $(esc(quantity))(+v.vector)
		Base.:(-)(v::$(esc(quantity))) = $(esc(quantity))(-v.vector)
		Base.:(*)(v::$(esc(quantity)), a::Number) = $(esc(quantity))(v.vector * a)
		Base.:(*)(a::Number, v::$(esc(quantity))) = $(esc(quantity))(a * v.vector)
		Base.:(/)(v::$(esc(quantity)), a::Number) = $(esc(quantity))(v.vector / a)

	end
end


## generate constructors
@generateFourVector FourPosition
@generateFourVector FourVelocity
@generateFourVector FourMomentum
@generateFourVector FourCurrentDensity


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getTime(p::FourPosition) -> AbstractFloat

Computes the time component of a `FourPosition` object by dividing its temporal part by the speed of light `c`.

# Input
- `v` [`FourPosition`]: four-position object from which the time component is extracted

# Output
- `AbstractFloat`: the time component of the four-position
"""
@inline getTime(v::FourPosition{D, T, V}) where {D, T <: Real, V} = begin
	return getTemporalPart(v.vector) / Unitless.c
end

@inline getTime(v::FourPosition{D, T, V}) where {D, T <: UnitType, V} = begin
	return getTemporalPart(v.vector) / Unitfull.c
end

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getPosition(p::FourPosition) -> VectorSpatial

Retrieve the spatial part of a `FourPosition` object.

# Input
- `v` [`FourPosition`]: four-position object from which the time component is extracted

# Output
- `VectorSpatial`: the spatial part of the four-position
"""
@inline getPosition(p::FourPosition) = getSpatialPart(p)


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getEnergy(v::FourMomentum) -> AbstractFloat

Compute the energy of a `FourMomentum` object `v`. 
The energy is calculated as the temporal part of the four-momentum multiplied by the speed of light `c`.

# Input
- `v` [`FourMomentum`]: four-momentum object for which the energy is to be computed

# Output
- `AbstractFloat`: the energy corresponding to the given four-momentum in units of Joules
"""
@inline getEnergy(v::FourMomentum{D, T, V}) where {D, T <: Real, V} = begin
	return getTemporalPart(v.vector) * Unitless.c
end

@inline getEnergy(v::FourMomentum{D, T, V}) where {D, T <: UnitType, V} = begin
	return getTemporalPart(v.vector) * Unitfull.c
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getMomentum(v::FourMomentum) -> VectorSpatial

Extracts the spatial part of a `FourMomentum` object.

# Input
- `v` [`FourMomentum`]: the four-momentum object from which the spatial part (momentum) is to be extracted

# Output
- The `VectorSpatial` representing the spatial momentum component of the input `FourMomentum`
"""
@inline getMomentum(v::FourMomentum) = getSpatialPart(v.vector)


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getChargeDensity(v::FourCurrentDensity) -> AbstractFloat

Computes the charge density of a `FourCurrentDensity` object `v`.
The charge density is calculated as the temporal part of the four-current divided by the speed of light `c`.

# Input
- `v` [`FourCurrentDensity`]: four-current object for which the charge density is to be computed 

# Output
- `AbstractFloat`: the charge density corresponding to the given four-current in units of C/m³
"""
@inline getChargeDensity(v::FourCurrentDensity{D, T, V}) where {D, T <: Real, V} = begin
	return getTemporalPart(v.vector) / Unitless.c
end

@inline getChargeDensity(v::FourCurrentDensity{D, T, V}) where {D, T <: UnitType, V} = begin
	return getTemporalPart(v.vector) / Unitfull.c
end

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getCurrent(v::FourCurrentDensity) -> VectorSpatial

Extracts the spatial part of a `FourCurrentDensity` object.

# Input
- `v` [`FourCurrentDensity`]: the four-current object from which the spatial part (current) is to be extracted

# Output
- The `VectorSpatial` representing the spatial current component of the input `FourCurrentDensity`
"""
@inline getCurrentDensity(v::FourCurrentDensity) = getSpatialPart(v)


# ----------------------------------------------------------------------------------------------- #
