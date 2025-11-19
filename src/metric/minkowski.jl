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
- `D`: the dimensionality of the space 
- `T`: the numeric type of the elements (e.g., `Float64`, `Int64`)

This type is a subtype of `AbstractMetric{D, T}` and is used to represent and work with Euclidean metrics in a statically-typed manner.
The last element of the metric is the time-dependent one.

# Fields
- `metric::V`: a static matrix that defines the Minkowski metric

# Available constructors
- `MetricMinkowski(d::Integer, ::Type{T}, ::Type{S})`
- `MetricMinkowski(d::Integer, ::Type{S}, ::Type{T})`
- `MetricMinkowski(d::Integer, ::Type{T})`
- `MetricMinkowski(d::Integer, ::Type{S})`
- `MetricMinkowski(d::Integer)`
- `MetricMinkowski()` (1-dimensional default)
"""
struct MetricMinkowski{D, T, S} <: AbstractMetric{D, T, MetricSignatureLorentzian{S}}
	tensor::SMatrix{D, D, T}
end

MetricMinkowski(m::SMatrix{D, D, T}) where {D, T} = begin
	S = first(m) > 0 ? MostlyPlus : MostlyMinus
	return MetricMinkowski{D, T, S}(m)
end

MetricMinkowski(m::AbstractMatrix{T}) where {T} = begin
	d = size(m, 1)
	size(m) == (d, d) || throw(DimensionMismatch("Matrix must be square"))
	S = first(m) > 0 ? MostlyPlus : MostlyMinus
	return MetricMinkowski{d, T, S}(SMatrix{d, d, T}(m))
end

MetricMinkowski(d::Integer, ::Type{T}, ::Type{S}) where {T <: AbstractFloat, S <: LorentzianMetricSignatureConvention} = begin
	s = S <: MostlyPlus ? 1 : -1
	v = SVector{d, T}(ntuple(i -> (i == d ? -s : s) * one(T), d))
	return MetricMinkowski(Diagonal(v))
end

MetricMinkowski(d::Integer, ::Type{S}, ::Type{T}) where {T <: AbstractFloat, S <: LorentzianMetricSignatureConvention} = begin
	return MetricMinkowski(d, T, S)
end

MetricMinkowski(d::Integer, ::Type{T}) where {T <: AbstractFloat} = begin
	return MetricMinkowski(d, T, MostlyPlus)
end

MetricMinkowski(d::Integer, ::Type{S}) where {S <: LorentzianMetricSignatureConvention} = begin
	return MetricMinkowski(d, Float64, S)
end

MetricMinkowski(d::Integer) = MetricMinkowski(d, Float64, MostlyPlus)

MetricMinkowski() = MetricMinkowski(1, Float64, MostlyPlus)


# ----------------------------------------------------------------------------------------------- #
#