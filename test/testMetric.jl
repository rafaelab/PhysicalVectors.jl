@testset "MetricEuclid Tests" begin

	@testset "constructor with SMatrix" begin
		m = MetricEuclid(SMatrix{3, 3, Float64}(Diagonal([1, 1, 1.])))
		@test m.tensor == SMatrix{3, 3, Float64}(I)
		@test size(m) == (3, 3)
		@test eltype(m) == Float64
	end

	@testset "constructor with AbstractMatrix" begin
		m = MetricEuclid([1. 0. 0.; 0. 1. 0.; 0. 0. 1.])
		@test m.tensor == SMatrix{3, 3, Float64}(I)
		@test size(m) == (3, 3)
		@test eltype(m) == Float64
	end

	@testset "constructor with dimension and type" begin
		m = MetricEuclid(3, Float32)
		@test m.tensor == Diagonal(ones(Float32, 3))
		@test size(m) == (3, 3)
		@test eltype(m) == Float32
	end

	@testset "constructor with dimension and default type" begin
		m = MetricEuclid(3)
		@test m.tensor == Diagonal(ones(3))
		@test size(m) == (3, 3)
		@test eltype(m) == Float64
	end
	
	@testset "accessing metric properties" begin
		m = MetricEuclid(3)
		@test size(m) == (3, 3)
		@test length(m) == 9
		@test eltype(m) == Float64
		@test m[1, 1] == 1.
		@test m[2, 2] == 1.
		@test m[1, 2] == 0.
	end

	@testset "getMetricTensor Function" begin
		m = MetricEuclid(3)
		matrix = getMetricTensor(m)
		@test matrix == Diagonal(ones(3))
		@test size(matrix) == (3, 3)
		@test eltype(matrix) == Float64
	end

end



@testset "MetricMinkowski Tests" begin

	@testset "constructor with StaticMatrix" begin
		m = MetricMinkowski(SMatrix{4, 4, Float64}(Diagonal([-1., -1., -1., 1.])))
		@test m.tensor == SMatrix{4, 4, Float64}(Diagonal([-1., -1., -1., 1.]))
		@test size(m) == (4, 4)
		@test eltype(m) == Float64
	end

	@testset "constructor with AbstractMatrix" begin
		m = MetricMinkowski([-1.0 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0; 0.0 0.0 -1.0 0.0; 0.0 0.0 0.0 1.0])
		@test m.tensor == SMatrix{4, 4, Float64}(Diagonal([-1.0, -1.0, -1.0, 1.0]))
		@test size(m) == (4, 4)
		@test eltype(m) == Float64
	end

	@testset "constructor with dimension and type" begin
		m = MetricMinkowski(4, Float32, MostlyPlus)
		@test m.tensor == Diagonal([1.0f0, 1.0f0, 1.0f0, -1.0f0])
		@test size(m) == (4, 4)
		@test eltype(m) == Float32
	end

	@testset "constructor with dimension (default type and signature)" begin
		m = MetricMinkowski(4)
		@test m.tensor == Diagonal([1., 1., 1., -1.])
		@test size(m) == (4, 4)
		@test eltype(m) == Float64
	end

	@testset "signature conventions" begin
		m1 = MetricMinkowski(4, Float64, MostlyPlus)
		m2 = MetricMinkowski(4, Float64, MostlyMinus)
		@test isMostlyPlus(m1) == true
		@test isMostlyMinus(m1) == false
		@test isMostlyPlus(m2) == false
		@test isMostlyMinus(m2) == true
		@test m1.tensor == Diagonal([1., 1., 1., -1.])
		@test m2.tensor == Diagonal([-1., -1., -1., 1.])
	end

	@testset "invalid constructor (non-square matrix)" begin
		@test_throws DimensionMismatch MetricMinkowski([1.0 0.0; 0.0 -1.0; 0.0 0.0])
	end

	@testset "property access" begin
		m = MetricMinkowski(4, Float64, MostlyMinus)
		@test size(m) == (4, 4)
		@test length(m) == 16
		@test eltype(m) == Float64
		@test m[1, 1] == -1.
		@test m[2, 2] == -1.
		@test m[1, 2] == 0.
		@test m[4, 4] == 1.
	end

	@testset "getMetricTensor Function" begin
		m = MetricMinkowski(4, MostlyPlus)
		tensor = getMetricTensor(m)
		@test tensor == Diagonal([1., 1., 1., -1.])
		@test size(tensor) == (4, 4)
		@test eltype(tensor) == Float64
	end

	@testset "explicit metric contractions and dimensions" begin
		for vectorType ∈ (VectorSpatial, VectorLorentz, FourPosition, FourVelocity, FourMomentum, FourCurrentDensity)
			v = vectorType(1., 2.)
			@test dot(v, v, MetricEuclid(2)) == 5.
			@test dot(v, v, MetricEuclid([2. 0.; 0. 3.])) == 14.
			@test dot(v, v, MetricEuclid([2. 1.; 1. 3.])) == 18.
			@test dot(v, v, MetricMinkowski([2. 0.; 0. -3.])) == -10.
			@test dot(v, v, MetricMinkowski([2. 1.; 1. -3.])) == -6.
			@test_throws DimensionMismatch dot(v, v, MetricMinkowski(4))
			@test_throws DimensionMismatch dot(v, vectorType(1.), MetricEuclid(2))
			@test_throws DimensionMismatch dot(vectorType(1.), v, MetricEuclid(2))
		end
	end

	@testset "interface and signatures" begin
		for d ∈ (1, 2, 4), convention ∈ (MostlyPlus, MostlyMinus)
			m = MetricMinkowski(d, Float32, convention)
			@test length(m) == d * d
			@test collect(vec(m)) == collect(vec(m.tensor))
			@test numberOfDimensions(m) == d
			@test isMetricLorentzian(m)
			@test ! isMetricRiemannian(m)
			@test isMostlyPlus(m) == (convention == MostlyPlus)
			@test getMetricSignatureSign(m) == (convention == MostlyPlus ? 1 : -1)
			@test getMetricSignatureSign(typeof(m)) == getMetricSignatureSign(m)
			@test isMostlyPlus(MetricMinkowski(m.tensor)) == isMostlyPlus(m)
			@test isMostlyPlus(MetricMinkowski(Matrix(m.tensor))) == isMostlyPlus(m)
		end

		m = MetricEuclid(3)
		@test length(m) == 9
		@test collect(vec(m)) == collect(vec(m.tensor))
		@test isMetricRiemannian(m)
		@test ! isMetricLorentzian(m)
		@test getMetricSignatureSign(m) == getMetricSignatureSign(typeof(m)) == 1
		for convention ∈ (MostlyPlus, MostlyMinus)
			v = VectorLorentz(2.)
			@test dot(v, v, MetricMinkowski(1, convention)) == (convention == MostlyPlus ? -4. : 4.)
		end
	end

end