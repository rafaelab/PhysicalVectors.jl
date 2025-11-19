# ----------------------------------------------------------------------------------------------- #
#
export
	MetricSignatureRiemannian,
	MetricSignatureLorentzian,
	MostlyMinus,
	MostlyPlus


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	AbstractMetricSignature

An abstract type representing the signature of a metric tensor in spacetime geometries.
This type serves as a base for specific implementations of metric signatures, such as Lorentzian and Riemannian signatures.
"""
abstract type AbstractMetricSignature end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricSignatureRiemannian <: AbstractMetricSignature

A struct representing a Riemannian metric signature, where all dimensions are treated equally and positively.
"""
struct MetricSignatureRiemannian <: AbstractMetricSignature
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	LorentzMetricSignatureConvention

Abstract type representing a convention for metric signature in spacetime geometries.
This is implemented for completeness. The mostly-plus signature is obviously the better one, despite the wide adoption of the mostly-minus convetion in high-energy physics.

# Sub-types
- `MostlyMinus`: Represents the "mostly minus" convention, where the metric signature is typically (+, -, -, -, ...)
- `MostlyPlus`: Represents the "mostly plus" convention, where the metric signature is typically (-, +, +, +, ...)

These types can be used to specify the metric signature convention in calculations involving spacetime metrics.
"""
abstract type LorentzianMetricSignatureConvention 
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MostlyMinus

In this case, the corresponding Minkowski-like metric has the signature (+, -, -, -).
This is the convention used in high-energy physics, where the time component is positive and the spatial components are negative.
"""
struct MostlyMinus <: LorentzianMetricSignatureConvention 
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MostlyPlus

In this case, the corresponding Minkowski-like metric has the signature (-, +, +, +).
This is the convention used in general relativity, where the time component is negative and the spatial components are positive.
"""
struct MostlyPlus <: LorentzianMetricSignatureConvention 
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricSignatureLorentzian{S} <: AbstractMetricSignature

A struct representing a Lorentzian metric signature, where one dimension is treated differently (typically time) compared to the others (typically space).
"""
struct MetricSignatureLorentzian{S <: LorentzianMetricSignatureConvention} <: AbstractMetricSignature
end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	getLorentzianSignatureConvention(::Type{MetricSignatureLorentzian{S}}) where {S <: LorentzianMetricSignatureConvention} -> S

Retrieve the signature convention type from a `MetricSignatureLorentzian` type.
"""
@inline getLorentzianSignatureConvention(::Type{MetricSignatureLorentzian{S}}) where {S} = S


# ----------------------------------------------------------------------------------------------- #