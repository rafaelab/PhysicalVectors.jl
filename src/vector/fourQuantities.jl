# ----------------------------------------------------------------------------------------------- #
#
export 
	FourPosition,
	FourMomentum,
	FourVelocity,
	FourCurrentDensity,
	getTime,
	getPosition,
	getEnergy,
	getMomentum,
	getChargeDensity,
	getCurrentDensity


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	@generateFourQuantity(quantity)

Macro to generate a `FourQuantity` type and its associated methods.

This macro defines a new struct type for a four-dimensional physical quantity, 
along with constructors and utility methods for operations such as dot products 
and accessing temporal and spatial parts.

# Input
- `quantity`: name of the four-dimensional quantity to be generated \\

# Generated Code
- A struct definition for the `quantity` type, which is a subtype of `AbstractPhysicalVector` \\
- Constructors for the `quantity` type: \\
	-- from a `VectorLorentz` object \\
	-- from an `AbstractVector` \\
	-- from a variable number of scalar arguments \\
- Overloaded `Base.getproperty` to delegate property access to the underlying `VectorLorentz` \\
- Utility functions: \\
	-- `getTemporalPart`: the temporal part of the vector \\
	-- `getSpatialPart`:retrieves the spatial part of the vector \\
	-- `dot`: computes the dot product of two `quantity` objects, optionally using a metric \\
"""
macro generateFourQuantity(quantity)
	quote
		@doc """
			struct $(esc(quantity)){D, T, V <: StaticVector{D, T}} <: AbstractPhysicalVector{D, T}
		
		
		Constructors for the `$($(quantity))` type.
		This is a usual `FourXXX` quantity. 
		This structure allows for new methods and explicit dispatching.
		# Parameters
		- `D`: the dimensionality of the vector \\
		- `T`: the numeric type of the vector elements (e.g., `Float64`) \\
		- `V`: a subtype of `StaticVector` representing the underlying vector type \\
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

		$(esc(quantity))(vs::Vararg{T}) where {T <: Number} = begin
			return $(quantity)(VectorLorentz([vs...]))
		end

		Base.getproperty(q::$(esc(quantity)), u::Symbol) = getproperty(getfield(q, :vector), u)

		getTemporalPart(q::$(esc(quantity))) = getTemporalPart(q.vector)

		getSpatialPart(q::$(esc(quantity))) = getSpatialPart(q.vector)

		dot(q1::$(esc(quantity)), q2::$(esc(quantity))) = dot(q1.vector, q2.vector)

		dot(q1::$(esc(quantity)), q2::$(esc(quantity)), m::AbstractMetric{D, U}) where {D, U} = begin
			return dot(q1.vector, q2.vector, m)
		end

	end
end

# ----------------------------------------------------------------------------------------------- #
#
@generateFourQuantity FourPosition
@generateFourQuantity FourVelocity
@generateFourQuantity FourMomentum
@generateFourQuantity FourCurrentDensity


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getTime(p::FourPosition) -> Float64

Computes the time component of a `FourPosition` object by dividing its temporal part by the speed of light `c`.

# Input
- `x::FourPosition`: four-position object from which the time component is extracted \\

# Output
- `Float64`: the time component of the four-position \\
"""
getTime(x::FourPosition) = getTemporalPart(x) / c


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getPosition(p::FourPosition) -> VectorSpatial

Retrieve the spatial part of a `FourPosition` object.

# Input
- `x::FourPosition`: four-position object from which the time component is extracted \\

# Output
- `VectorSpatial`: the spatial part of the four-position \\
"""
getPosition(p::FourPosition) = getSpatialPart(p)

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getEnergy(v::FourMomentum) -> Float64

Compute the energy of a `FourMomentum` object `v`. 
The energy is calculated as the temporal part of the four-momentum multiplied by the speed of light `c`.

# Input
- `v::FourMomentum`: four-momentum object for which the energy is to be computed \\

# Output
- `Float64`: the energy corresponding to the given four-momentum in units of Joules \\
"""
getEnergy(v::FourMomentum) = getTemporalPart(v) * c


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getMomentum(v::FourMomentum) -> VectorSpatial

Extracts the spatial part of a `FourMomentum` object.

# Input
- `v::FourMomentum`: the four-momentum object from which the spatial part (momentum) is to be extracted \\

# Output
- The `VectorSpatial` representing the spatial momentum component of the input `FourMomentum` \\
"""
getMomentum(v::FourMomentum) = getSpatialPart(v)


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getChargeDensity(v::FourCurrent) -> Float64

Computes the charge density of a `FourCurrent` object `v`.
The charge density is calculated as the temporal part of the four-current divided by the speed of light `c`.

# Input
- `v::FourCurrent`: four-current object for which the charge density is to be computed \\

# Output
- `Float64`: the charge density corresponding to the given four-current in units of C/m³ \\
"""
getChargeDensity(v::FourCurrent) = getTemporalPart(v) / c



# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getCurrent(v::FourCurrent) -> VectorSpatial

Extracts the spatial part of a `FourCurrent` object.

# Input
- `v::FourCurrent`: the four-current object from which the spatial part (current) is to be extracted \\

# Output
- The `VectorSpatial` representing the spatial current component of the input `FourCurrent` \\
"""
getCurrentDensity(v::FourCurrent) = getSpatialPart(v)


# ----------------------------------------------------------------------------------------------- #