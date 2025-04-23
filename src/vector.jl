
# ----------------------------------------------------------------------------------------------- #
#
@doc """
	AbstractPhysicalVector{D, T}

An abstract type representing a physical vector with a specific dimension `D` and element type `T`. \\
This type inherits from `AbstractVector{T}` and serves as a base type for defining vectors that have physical or geometric interpretations.

# Parameters
- `D`: dimension of the vector (e.g., 2 for 2D, 3 for 3D) \\
- `T`: type of the elements in the vector (e.g., `Float64`) \\

This type is intended to be extended by concrete implementations that define specific behaviours and properties of physical vectors.
For instance, `VectorLorentz` and `VectorEuclidean` are such concrete sub-types.
"""
abstract type AbstractPhysicalVector{D, T} <: AbstractVector{T} end


# ----------------------------------------------------------------------------------------------- #
#

Base.length(::AbstractPhysicalVector{D, T}) where {D, T} = D

Base.size(::AbstractPhysicalVector{D, T}) where {D, T} = (D,)

Base.eltype(::AbstractPhysicalVector{D, T}) where {D, T} = T

Base.getindex(v::AbstractPhysicalVector, i::Integer)  = v.vector[i]

Base.IndexStyle(::Type{<: AbstractPhysicalVector}) = IndexCartesian()

Base.setindex!(v::AbstractPhysicalVector{D, T}, value, i::Integer) where {D, T} = begin
	v.vector[i] = value
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	@physicalVectorConstructors(vector)

A macro that generates constructor methods for a custom `VectorXXX` sub-typing from `AbstractPhysicalVector`.\\
This macro is not exported and is intended for internal use within the package. \\
The generated constructors allow for the creation of `VectorXXX` instances from different input types, including: \\
1. Static Vectors (`SVector`):\\
. Accepts an `SVector{D, T}` where `D` is the dimension and `T` is a subtype of `Number`. \\
. Returns an instance of `vector` parameterized by `D`, `T`, and the type of the input vector. \\
2. Abstract Vectors: \\
. Accepts an `AbstractVector{T}` where `T` is a subtype of `Number`. \\
. Converts the input vector to a mutable `MVector` and returns an instance of `vector` parameterized by the length of the input vector, `T`, and the type of the converted vector. \\
3. Varargs: \\
. Accepts a variable number of arguments of type `T` (where `T` is a subtype of `Number`). \\
. Constructs an `MVector` from the arguments and returns an instance of `vector`. \\
This macro simplifies the creation of constructors for custom vector types, ensuring compatibility with various input formats.
"""
macro physicalVectorConstructors(vector)
	quote

		$(esc(vector))(v::StaticVector{D, T}) where {D, T <: Number} = begin
			return $(vector){D, T, typeof(v)}(v)
		end

		$(esc(vector))(v::AbstractVector{T}) where {T <: Number} = begin
			u = MVector{length(v), T}(v)
			return $(vector){length(v), T, typeof(u)}(u)
		end

		$(esc(vector))(vs::Vararg{T}) where {T <: Number} = begin
			return $(vector)([vs...])
		end

	end
end


# ----------------------------------------------------------------------------------------------- #
#
include("vector/euclid.jl")
include("vector/spatial.jl")
include("vector/lorentz.jl")


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	norm(v::VectorLorentz{D, T}) -> T
	norm(v::VectorLorentz{D, T}, m::AbstractMetric{D, U}) -> T

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


