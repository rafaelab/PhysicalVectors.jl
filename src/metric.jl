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

Base.IndexStyle(::Type{<: AbstractMetric}) = IndexCartesian()

Base.getindex(m::AbstractMetric{D, T}, i::Integer, j::Integer) where {D, T} = m.metric[i, j]

# Base.setindex!(m::AbstractMetric{D, T}, value, i::Int, j::Int) where {D, T} = (getMetric(m)[i, j] = value)


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
include("metric/euclidean.jl")
# include("metric/pseudoEuclidean.jl")
include("metric/minkowski.jl")


# ----------------------------------------------------------------------------------------------- #