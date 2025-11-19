# ----------------------------------------------------------------------------------------------- #
#
export
	getMetricTensor,
	getMetricSignatureSign,
	isMostlyMinus,
	isMostlyPlus,
	isMetricLorentzian,
	isMetricRiemannian


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	AbstractMetric{D, T, S} <: AbstractMatrix{T}

An abstract type representing a metric tensor in a `D`-dimensional space with elements of type `T`.
This type is a subtype of `AbstractMatrix{T}`, indicating that it behaves like a matrix and can  be used to define geometric properties such as distances and angles in a given space.

# Parameters
- `D`: dimensionality of the space \\
- `T`: element type of the metric tensor  \\
- `S`: metric signature convention (e.g., MostlyPlus, MostlyMinus)

This type is intended to be extended by concrete implementations of specific metrics.
"""
abstract type AbstractMetric{D, T, S} <: AbstractMatrix{T} end


# ----------------------------------------------------------------------------------------------- #
#
Base.length(::AbstractMetric{D, T, S}) where {D, T, S} = D

Base.size(::AbstractMetric{D, T, S}) where {D, T, S} = (D, D)

Base.eltype(::AbstractMetric{D, T, S}) where {D, T, S} = T

Base.getindex(m::AbstractMetric, i::Integer, j::Integer) = m.tensor[i, j]

Base.IndexStyle(::Type{<: AbstractMetric}) = IndexCartesian()


# ----------------------------------------------------------------------------------------------- #
#
@inline numberOfDimensions(::AbstractMetric{D, T, S}) where {D, T, S} = D


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getMetric(m::AbstractMetric{D, T, S}) -> T

Retrieve the metric tensor from an `AbstractMetric` object.

# Input
- `m::AbstractMetric{D, T, S}`: an instance of a subtype of `AbstractMetric`, where `D` is the dimensionality, `T` is the type of the metric tensor, and `S` is the metric signature convention.

# Output
- `T`: the metric tensor associated with the given `AbstractMetric` object.
"""
@inline getMetricTensor(m::AbstractMetric{D, T, S}) where {D, T, S} = m.tensor


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	isMostlyPlus(m::MetricMinkowski) -> Bool
	isMostlyMinus(m::MetricMinkowski) -> Bool

Determines the signature convention of the Minkowski metric. 

# Input
- `m::MetricMinkowski{D, T, MostlyPlus}`:  Minkowski metric object with "mostly plus" convention
- `m::MetricMinkowski{D, T, MostlyMinus}`:  Minkowski metric object with "mostly minus" convention

# Output
- `true` if the metric is "mostly plus"
- `false` if the metric is "mostly minus"
"""
@inline isMostlyPlus(::AbstractMetric{D, T, MetricSignatureRiemannian}) where {D, T} = true
@inline isMostlyPlus(::AbstractMetric{D, T, MetricSignatureLorentzian{MostlyPlus}}) where {D, T} = true
@inline isMostlyPlus(::AbstractMetric{D, T, MetricSignatureLorentzian{MostlyMinus}}) where {D, T} = false

@inline isMostlyMinus(::AbstractMetric{D, T, MetricSignatureRiemannian}) where {D, T} = false
@inline isMostlyMinus(::AbstractMetric{D, T, MetricSignatureLorentzian{MostlyPlus}}) where {D, T} = false
@inline isMostlyMinus(::AbstractMetric{D, T, MetricSignatureLorentzian{MostlyMinus}}) where {D, T} = true


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getMetricSignatureSign(::AbstractMetric)
	getMetricSignatureSign(::Type{AbstractMetric})

Retrieves the signature sign of the metric.

# Output
- `+1` for "mostly plus" convention
- `-1` for "mostly minus" convention
"""
getMetricSignatureSign(::Type{AbstractMetric{D, T, MetricSignatureRiemannian}}) where {D, T} = T(1)
getMetricSignatureSign(::Type{AbstractMetric{D, T, MetricSignatureLorentzian{MostlyPlus}}}) where {D, T} = T(1)
getMetricSignatureSign(::Type{AbstractMetric{D, T, MetricSignatureLorentzian{MostlyMinus}}}) where {D, T} = T(-1)


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	isMetricRiemannian(m::AbstractMetric{D, T, S}) -> Bool
	isMetricLorentzian(m::AbstractMetric{D, T, S}) -> Bool

Determines whether the given metric is Riemannian or Lorentzian based on its signature.

# Input
- `m::AbstractMetric{D, T, S}`: an instance of a subtype of `AbstractMetric`, where `D` is the dimensionality, `T` is the type of the metric tensor, and `S` is the metric signature convention.

# Output
- `true` if the metric is Riemannian
- `false` if the metric is Lorentzian
"""
isMetricRiemannian(::AbstractMetric{D, T, MetricSignatureRiemannian}) where {D, T} = true
isMetricRiemannian(::AbstractMetric{D, T, MetricSignatureLorentzian}) where {D, T} = false


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	isMetricRiemannian(m::AbstractMetric{D, T, S}) -> Bool
	isMetricLorentzian(m::AbstractMetric{D, T, S}) -> Bool

Determines whether the given metric is Riemannian or Lorentzian based on its signature.

# Input
- `m::AbstractMetric{D, T, S}`: an instance of a subtype of `AbstractMetric`, where `D` is the dimensionality, `T` is the type of the metric tensor, and `S` is the metric signature convention.

# Output
- `true` if the metric is Lorentzian
- `false` if the metric is Riemannian
"""
isMetricLorentzian(::AbstractMetric{D, T, MetricSignatureRiemannian}) where {D, T} = false
isMetricLorentzian(::AbstractMetric{D, T, MetricSignatureLorentzian}) where {D, T} = true


# ----------------------------------------------------------------------------------------------- #
#
include("metric/euclid.jl")
include("metric/minkowski.jl")


# ----------------------------------------------------------------------------------------------- #