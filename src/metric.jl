# ----------------------------------------------------------------------------------------------- #
#
export
	getMetricTensor

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	AbstractMetric{D, T}

An abstract type representing a metric tensor in a `D`-dimensional space with elements of type `T`.
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

Base.getindex(m::AbstractMetric, i::Integer, j::Integer) = m.tensor[i, j]

Base.IndexStyle(::Type{<: AbstractMetric}) = IndexCartesian()


# ----------------------------------------------------------------------------------------------- #
#
@inline numberOfDimensions(::AbstractMetric{D, T}) where {D, T} = D


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
@inline getMetricTensor(m::AbstractMetric{D, T}) where {D, T} = m.tensor


# ----------------------------------------------------------------------------------------------- #
#
include("metric/euclid.jl")
include("metric/minkowski.jl")


# ----------------------------------------------------------------------------------------------- #