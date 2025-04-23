# ----------------------------------------------------------------------------------------------- #
#
"""
	AbstractMetric{D, T}

An abstract type representing a metric tensor in a `D`-dimensional space with elements of type `T`. \\
This type is a subtype of `AbstractMatrix{T}`, indicating that it behaves like a matrix and can  be used to define geometric properties such as distances and angles in a given space.

# Parameters
- `D`: dimensionality of the space \\
- `T`: element type of the metric tensor  \\

This type is intended to be extended by concrete implementations of specific metrics.
"""
abstract type AbstractMetric{D, T} <: AbstractMatrix{T} end


# ----------------------------------------------------------------------------------------------- #
#
Base.length(::AbstractMetric{D, T}) where {D, T} = D

Base.size(::AbstractMetric{D, T}) where {D, T} = (D, D)

Base.eltype(::AbstractMetric{D, T}) where {D, T} = T

Base.getindex(m::AbstractMetric, i::Integer, j::Integer) = m.metric[i, j]

Base.IndexStyle(::Type{<: AbstractMetric}) = IndexCartesian()


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getMetric(m::AbstractMetric{D, T}) -> T

Retrieve the metric tensor from an `AbstractMetric` object.

# Input
- `m::AbstractMetric{D, T}`: an instance of a subtype of `AbstractMetric`, where `D` is the dimensionality and `T` is the type of the metric tensor.

# Output
- `T`: the metric tensor associated with the given `AbstractMetric` object.
"""
@inline getMetric(m::AbstractMetric{D, T}) where {D, T} = m.metric

# ----------------------------------------------------------------------------------------------- #
#
"""
	@metricMatrixConstructors(metric)

A macro that generates constructor methods for a given metric type. \\
The generated constructors allow for the creation of metric objects from either a static matrix (`SMatrix`) or a general abstract matrix (`AbstractMatrix`). \\
This macro is not exported and is intended for internal use within the package.

# Input
- `metric`: name of the metric type for which the constructors are being generated \\

# Generated Methods
- `MetricXXX(m::SMatrix{D, D, T}) where {D, T}`: \\
Creates a `metric` object from a static matrix (`SMatrix`) of size `D x D` and element type `T`. \\
- `metric(m::AbstractMatrix{T}) where {T}`: \\
Creates a `metric` object from a general abstract matrix. The matrix must be square, i.e., its dimensions must be `(d, d)`.\\ 
If the matrix is not square, a `DimensionMismatch` error is thrown. \\
The input matrix is converted to a static matrix (`SMatrix`) before constructing the `metric` object.
"""
macro metricMatrixConstructors(metric)
	quote
		$(esc(metric))(m::SMatrix{D, D, T}) where {D, T} = $(metric){D, T}(m)

		$(esc(metric))(m::AbstractMatrix{T}) where {T} = begin
			d = size(m, 1)
			size(m) == (d, d) || throw(DimensionMismatch("Matrix must be square"))
			return $(metric){d, T}(SMatrix{d, d, T}(m))
		end
	end
end


# ----------------------------------------------------------------------------------------------- #
#
include("metric/euclid.jl")
# include("metric/pseudoEuclidean.jl")
include("metric/minkowski.jl")


# ----------------------------------------------------------------------------------------------- #