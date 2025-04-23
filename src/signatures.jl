# ----------------------------------------------------------------------------------------------- #
#
export
	MostlyMinus,
	MostlyPlus



# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricSignatureConvention

Abstract type representing a convention for metric signature in spacetime geometries. \\
This is implemented for completeness. The mostly-plus signature is obviously the better one, despite the wide adoption of the mostly-minus convetion in high-energy physics. \\

# Sub-types
- `MostlyMinus`: Represents the "mostly minus" convention, where the metric signature is typically (+, -, -, -, ...) \\
- `MostlyPlus`: Represents the "mostly plus" convention, where the metric signature is typically (-, +, +, +, ...) \\

These types can be used to specify the metric signature convention in calculations involving spacetime metrics.
"""
abstract type MetricSignatureConvention end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MostlyMinus

In this case, the corresponding Minkowski-like metric has the signature (+, -, -, -). \\
This is the convention used in high-energy physics, where the time component is positive and the spatial components are negative.
"""
struct MostlyMinus <: MetricSignatureConvention end


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MostlyPlus

In this case, the corresponding Minkowski-like metric has the signature (-, +, +, +). \\
This is the convention used in general relativity, where the time component is negative and the spatial components are positive.
"""
struct MostlyPlus <: MetricSignatureConvention end



# ----------------------------------------------------------------------------------------------- #
#
@doc """
	_getSignature(d::Integer, ::Type{MostlyPlus}, ::Type{T}) where {T <: AbstractFloat}
	_getSignature(d::Integer, ::Type{MostlyMinus}, ::Type{T}) where {T <: AbstractFloat}

Computes the signature vector for a Minkowski metric with `d` dimensions, where the metric is mostly positive/negative.
The resulting vector has `d-1` positive (negative) entries (1.0) followed by a single negative (positive) entry (-1.0).

# Input
- `d::Integer`: number of dimensions \\
- `::Type{MostlyPlus}`: type marker indicating a mostly positive metric \\
- `::Type{T}`: floating-point type of the resulting vector elements \\

# Output
A static vector (`SVector`) of type `T` representing the signature.
"""
@inline _getSignature(d::Integer, ::Type{MostlyPlus}, ::Type{T}) where {T <: AbstractFloat} = begin
	v = @SVector(ones(T, d - 1))
	return vcat(v, [-1])
end

@inline _getSignature(d::Integer, ::Type{MostlyMinus}, ::Type{T}) where {T <: AbstractFloat} = begin
	return - _getSignature(d, MostlyPlus, T)
end



# ----------------------------------------------------------------------------------------------- #