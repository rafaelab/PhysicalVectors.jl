# ----------------------------------------------------------------------------------------------- #
#
export 
	MetricEuclid


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricEuclid

A structure representing an Euclidean metric in `D`-dimensional space. This metric is parameterised by:
- `D`: the dimensionality of the space \\
- `T`: the numeric type of the elements (e.g., `Float64`) \\

This type is a subtype of `AbstractMetric{N, T}` and is used to represent and work with Euclidean metrics in a statically-typed manner. \\

# Fields
- `metric::V`: a static matrix that defines the Euclidean metric \\

# Available constructors
- `MetricEuclid(m::AbstractMatrix{D, D, T})` \\
- `MetricEuclid(d::Integer, ::Type{T})` \\
- `MetricEuclid(d::Integer)` \\
"""
struct MetricEuclid{D, T} <: AbstractMetric{D, T}
	metric::SMatrix{D, D, T}
end

@metricMatrixConstructors MetricEuclid

MetricEuclid(d::Integer, ::Type{T}) where {T <: AbstractFloat} = begin
	return MetricEuclid(Diagonal(ones(T, d)))
end

MetricEuclid(d::Integer) = MetricEuclid(d, Float64)


# ----------------------------------------------------------------------------------------------- #
