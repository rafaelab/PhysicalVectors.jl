# ----------------------------------------------------------------------------------------------- #
#
export 
	MetricEuclidean


# ----------------------------------------------------------------------------------------------- #
#
@doc """
	MetricEuclidean

A structure representing a Euclidean metric in `D`-dimensional space. This metric is parameterised by:
- `D`: the dimensionality of the space \\
- `T`: the numeric type of the elements (e.g., `Float64`) \\

This type is a subtype of `AbstractMetric{N, T}` and is used to represent and work with Euclidean metrics in a statically-typed manner. \\

# Fields
- `metric::V`: a static matrix that defines the Euclidean metric \\
"""
struct MetricEuclidean{D, T} <: AbstractMetric{D, T}
	metric::SMatrix{D, D, T}
end

MetricEuclidean(d::Integer, ::Type{T}) where {T <: AbstractFloat} = MetricEuclidean{d, T}(Diagonal(ones(T, d)))

MetricEuclidean(d::Integer) = MetricEuclidean(d, Float64)



# ----------------------------------------------------------------------------------------------- #
