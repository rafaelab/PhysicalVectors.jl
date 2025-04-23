# ----------------------------------------------------------------------------------------------- #
#
export 
	MetricMinkowski

# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricMinkowski

A structure representing the Minkowski metric in an N-dimensional space.
This metric is parameterised by:
- `D`: the dimensionality of the space \\
- `T`: the numeric type of the elements (e.g., `Float64`, `Int64`) \\

This type is a subtype of `AbstractMetric{D, T}` and is used to represent and work with Euclidean metrics in a statically-typed manner. \
The last element of the metric is the time-dependent one.

# Fields
- `metric::V`: a static matrix that defines the Minkowski metric \\

# Available constructors
- `MetricMinkowski(d::Integer, ::Type{T}, ::Type{S})` \\
- `MetricMinkowski(d::Integer, ::Type{S}, ::Type{T})` \\
- `MetricMinkowski(d::Integer, ::Type{T})` \\
- `MetricMinkowski(d::Integer, ::Type{S})` \\
- `MetricMinkowski(d::Integer)`
"""
struct MetricMinkowski{D, T, S} <: AbstractMetric{D, T}
	metric::SMatrix{D, D, T}
end

@metricMatrixConstructors MetricMinkowski

MetricMinkowski(d::Integer, ::Type{T}, ::Type{S}) where {T <: AbstractFloat, S <: MetricSignatureConvention} = begin
	return MetricMinkowski(Diagonal(_getSignature(d, S, T)))
end

MetricMinkowski(d::Integer, ::Type{S}, ::Type{T}) where {T <: AbstractFloat, S <: MetricSignatureConvention} = begin
	return MetricMinkowski(d, T, S)
end

MetricMinkowski(d::Integer, ::Type{T}) where {T <: AbstractFloat} = begin
	return MetricMinkowski(d, T, MostlyPlus)
end

MetricMinkowski(d::Integer, ::Type{S}) where {S <: MetricSignatureConvention} = begin
	return MetricMinkowski(d, Float64, S)
end

MetricMinkowski(d::Integer) = MetricMinkowski(d, Float64, MostlyPlus)



# ----------------------------------------------------------------------------------------------- #
#