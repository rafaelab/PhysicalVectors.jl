# ----------------------------------------------------------------------------------------------- #
#
@doc """
	numberOfDimensions(metric::AbstractMetric{D, T}) -> D
	numberOfDimensions(vector::AbstractPhysicalVector{D, T}) -> D

Retrieve the number of dimensions of an object.
This function is *not* exported, as it is intended for internal use within packages.
"""
function numberOfDimensions end


# ----------------------------------------------------------------------------------------------- #
