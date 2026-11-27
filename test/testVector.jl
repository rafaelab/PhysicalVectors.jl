@testset "VectorSpatial Tests" begin

	@testset "constructor with StaticVector" begin
		v = VectorSpatial(SVector(1., 2., 3.0))
		@test v.vector == SVector(1., 2., 3.0)
		@test length(v) == 3
		@test eltype(v) == Float64
	end

	@testset "constructor with StaticVector for Float32" begin
		v = VectorSpatial(SVector{3, Float32}(ones(Float32, 3)))
		@test v.vector == ones(3)
		@test length(v) == 3
		@test eltype(v) == Float32
	end

	@testset "constructor with AbstractVector" begin
		v = VectorSpatial([1., 2., 3.0])
		@test v.vector == MVector(1., 2., 3.0)
		@test length(v) == 3
		@test eltype(v) == Float64
	end

	@testset "constructor with Varargs" begin
		v = VectorSpatial(1., 2., 3.0)
		@test v.vector == MVector(1., 2., 3.0)
		@test length(v) == 3
		@test eltype(v) == Float64
	end

	@testset "property access" begin
		v = VectorSpatial(SVector(1.0, 3.0))
		@test v.x == 1.0
		@test v.y == 3.0
	end

	@testset "dot product" begin
		v1 = VectorSpatial(SVector(1., 2., 3.0))
		v2 = VectorSpatial(SVector(4.0, 5.0, 6.0))
		@test dot(v1, v2) == 1.0 * 4.0 + 2.0 * 5.0 + 3.0 * 6.0
	end

	@testset "dot product with metric" begin
		v1 = VectorSpatial(SVector(1., 2., 3.0))
		v2 = VectorSpatial(SVector(4.0, 5.0, 6.0))
		metric = MetricEuclid(3) 
		@test dot(v1, v2, metric) == dot(v1, v2)
	end


	@testset "test higher dimensions" begin
		v1 = VectorSpatial(SVector(1., 2., 3.0, 4.0, 5.0, 6.0, 7.0))
		v2 = VectorSpatial(SVector(7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0))
		@test length(v1) == 7
		@test dot(v1, v2) == sum(i * (8 - i) for i = 1 : 7) 
	end

	@testset "test lower dimensions" begin
		v1 = VectorSpatial(SVector(1., 2.))
		v2 = VectorSpatial(SVector(3.0, 4.0))
		@test length(v1) == 2
		@test v1.x == 1.0
		@test v1.y == 2.0
		@test dot(v1, v2) == 1.0 * 3.0 + 2.0 * 4.0
	end

end


@testset "VectorLorentz Tests" begin

	@testset "constructor with StaticVector" begin
		v = VectorLorentz(SVector(1., 2., 3.0, 4.0))
		@test v.vector == SVector(1., 2., 3.0, 4.0)
		@test length(v) == 4
		@test eltype(v) == Float64
	end

	@testset "constructor with AbstractVector" begin
		v = VectorLorentz([1., 2., 3., 4.])
		@test v.vector == MVector(1., 2., 3., 4.)
		@test length(v) == 4
		@test eltype(v) == Float64
	end

	@testset "constructor with Varargs" begin
		v = VectorLorentz(1., 2., 3.0, 4.)
		@test v.vector == MVector(1., 2., 3., 4.)
		@test length(v) == 4
		@test eltype(v) == Float64
	end

	@testset "property access" begin
		v = VectorLorentz(SVector(1., 2., 3.0, 4.0))
		@test v.x == 1.0
		@test v.y == 2.0
		@test v.z == 3.0
		@test v.t == 4.0
	end

	@testset "spatial part extraction" begin
		v = VectorLorentz(SVector(1., 2., 3., 4.))
		spatial = getSpatialPart(v)
		@test spatial isa VectorSpatial
		@test spatial.vector == SVector(1., 2., 3.)
		@test length(spatial) == 3
		@test eltype(spatial) == Float64
	end

	@testset "temporal part extraction" begin
		v = VectorLorentz(SVector(1., 2., 3., 4.))
		temporal = getTemporalPart(v)
		@test temporal == 4.
	end

	@testset "dot product" begin
		v1 = VectorLorentz(SVector{4, Float64}(1., 2., 3., 4.))
		v2 = VectorLorentz(SVector{4, Float64}(4., 3., 2., 2.))
		@test dot(v1, v2, MetricMinkowski(4)) == 1. * 4. + 2. * 3. + 3. * 2. - 4. * 2.
	end

	@testset "dot product with metric" begin
		v1 = VectorLorentz(SVector{4, Float64}(1., 2., 3., 4.))
		v2 = VectorLorentz(SVector{4, Float64}(4., 3., 2., 1.))
		metric1 = MetricMinkowski(4, Float64, MostlyMinus)
		metric2 = MetricMinkowski(4, Float64, MostlyPlus)
		@test dot(v1, v2, metric1) == 4.0 * 1.0 - (1.0 * 4.0 + 2.0 * 3.0 + 3.0 * 2.0)
		@test dot(v1, v2, metric2) == (1.0 * 4.0 + 2.0 * 3.0 + 3.0 * 2.0) - 4.0 * 1.0
	end

	@testset "property access for 1+1D" begin
		v = VectorLorentz(SVector(1., 2.))
		@test v.x == 1.
		@test v.t == 2.
	end

	@testset "spatial part extraction for 1+1D" begin
		v = VectorLorentz(SVector(1., 2.))
		spatial = getSpatialPart(v)
		@test spatial.vector == SVector(1.) 
		@test length(spatial) == 1
		@test eltype(spatial) == Float64
	end

	@testset "temporal part extraction for 1+1D" begin
		v = VectorLorentz(SVector(1., 2.))
		temporal = getTemporalPart(v)
		@test temporal == 2.
	end

	@testset "dot product for 1+1D" begin
		v1 = VectorLorentz(SVector(1., 2.))
		v2 = VectorLorentz(SVector(3., 4.))
		mA = MetricMinkowski(2, Float64, MostlyPlus)
		mB = MetricMinkowski(2, Float64, MostlyMinus)
		@test dot(v1, v2, mA) == 1. * 3. - 2. * 4.
		@test dot(v1, v2, mB) == -1. * 3. + 2. * 4.
	end

	@testset "dot product with metric for 1+1D" begin
		v1 = VectorLorentz(SVector(1., 2.))
		v2 = VectorLorentz(SVector(3., 4.))
		metric = MetricMinkowski(2, Float64, MostlyPlus)
		@test dot(v1, v2, metric) == 1. * 3. -  2. * 4.
	end

	@testset "coordinate extraction" begin
		v = VectorLorentz(1., 2.)
		@test getSpatialPart(v, MetricMinkowski(2)) == VectorSpatial(1.)
		@test_throws DimensionMismatch getSpatialPart(v, MetricMinkowski(4))
		@test getTemporalPart(v, MetricMinkowski(2)) == 2.
		@test_throws DimensionMismatch getTemporalPart(v, MetricMinkowski(4))
		mixedMetric = MetricMinkowski(2, Float32)
		@test getSpatialPart(v, mixedMetric) == VectorSpatial(1.)
		@test getTemporalPart(v, mixedMetric) == 2.
		unitVector = VectorLorentz([1., 2.] .* u"m")
		@test getSpatialPart(unitVector, mixedMetric) == VectorSpatial(1u"m")
		@test getTemporalPart(unitVector, mixedMetric) == 2u"m"
		@test_throws DimensionMismatch getSpatialPart(unitVector, MetricMinkowski(4))
		@test_throws DimensionMismatch getTemporalPart(unitVector, MetricMinkowski(4))
		@test v.x == 1.
		@test v.t == 2.
		@test_throws ErrorException v.y
		@test_throws ErrorException VectorLorentz(1., 2., 3.).z
		@test_throws ErrorException VectorLorentz(1.).x
		@test VectorLorentz(1., 2., 3., 4., 5.).z == 3.
	end

end


@testset "Vector Operations Tests" begin
	v1 = VectorSpatial(SVector(1., 2., 3.))
	v2 = VectorSpatial(SVector(4., 5., 6.))
	v3 = VectorLorentz(SVector(1., 2., 3., 4.))
	v4 = VectorLorentz(SVector(4., 3., 2., 1.))
	scalar = 2.

	@testset "arithmetic and promotion" begin
		for vectorType ∈ (VectorSpatial, VectorLorentz, FourPosition, FourVelocity, FourMomentum, FourCurrentDensity)
			v = vectorType(1, 2.)
			@test eltype(v) == Float64
			@test collect(v) == [1., 2.]
			for result ∈ (v + v, v - v, +v, -v, 2 * v, v * 2, v / 2)
				@test result isa vectorType
			end
			@test collect(v + v) == [2., 4.]
			@test collect(v - v) == [0., 0.]
			@test collect(-v) == [-1., -2.]
			@test collect(v / 2) == [0.5, 1.]
			@test dot(v + v, v + v) == 4 * dot(v, v)
			@test dot(-v, -v) == dot(v, v)
			@test_throws DimensionMismatch v + vectorType(1.)
			@test_throws DimensionMismatch vectorType(1.) - v
			@test_throws DimensionMismatch dot(v, vectorType(1.))
		end
	end

	@testset "vector addition" begin
		result = v1 + v2
		@test result isa VectorSpatial
		@test result.vector == SVector(5.0, 7.0, 9.0)

		result = v3 + v4
		@test result isa VectorLorentz
		@test result.vector == SVector(5., 5., 5., 5.)
	end

	@testset "vector subtraction" begin
		result = v1 - v2
		@test result isa VectorSpatial
		@test result.vector == SVector(-3., -3., -3.)
	end

	@testset "vector scalar multiplication" begin
		result1 = v1 * scalar
		result2 = scalar * v1
		@test result1 isa VectorSpatial
		@test result2 isa VectorSpatial
		@test result1.vector == SVector(2., 4., 6.)
		@test result2.vector == SVector(2., 4., 6.)
	end

	@testset "vector scalar division" begin
		result = v1 / scalar
		@test result isa VectorSpatial
		@test result.vector == SVector(0.5, 1.0, 1.5)
	end

	@testset "vector dot product" begin
		result = dot(v1, v2)
		@test result == 1.0 * 4.0 + 2.0 * 5.0 + 3.0 * 6.0
	end

	@testset "vector norm" begin
		result = norm(v1)
		@test result == sqrt(1 + 4. + 9.)
	end

	@testset "cross product" begin
		result = cross(v1, v2)
		@test result isa VectorSpatial
		@test result == SVector(-3., 6., -3.)
	end

	@testset "default products and complex conjugation" begin
		for vectorType ∈ (VectorLorentz, FourPosition, FourVelocity, FourMomentum, FourCurrentDensity)
			v = vectorType(1, 2)
			@test dot(v, v) == -3
			v = vectorType([1., 2.] .* u"m")
			@test dot(v, v) == -3 * u"m^2"
			@test dot(v, v, MetricMinkowski(2)) == -3u"m^2"
			a = vectorType(1. + 2im, 3. + 4im)
			b = vectorType(2. - 1im, 5. - 2im)
			expected = conj(a[1]) * b[1] - conj(a[2]) * b[2]
			@test dot(a, b) == expected
			@test dot(a, b, MetricMinkowski(2)) == expected
			@test dot(a, b, MetricMinkowski(2, MostlyMinus)) == -expected
		end
		@test dot(VectorLorentz(2), VectorLorentz(2)) == -4
		@test dot(VectorLorentz(2u"m"), VectorLorentz(2u"m")) == -4 * u"m^2"
	end

end


@testset "Unit Toggler Tests" begin
	
	v1a = VectorSpatial(SVector(1., 2., 3.))
	v1b = VectorSpatial(SVector{3}([1., 2., 3.] .* u"m"))
	v2a = VectorLorentz(1., 2., 3., 4.)
	v2b = VectorLorentz([1., 2., 3., 4.] .* u"m / s")

	@test Cosmonstants.Unitless.c == getUnitSystem(eltype(v1a)).c
	@test Cosmonstants.Unitfull.c == getUnitSystem(eltype(v1b)).c
	@test Cosmonstants.Unitless.c == getUnitSystem(eltype(v2a)).c
	@test Cosmonstants.Unitfull.c == getUnitSystem(eltype(v2b)).c
	@test Cosmonstants.Unitless.c isa Real
	@test Cosmonstants.Unitfull.c isa Unitful.AbstractQuantity
	@test Cosmonstants.Unitless.c isa Real
	@test Cosmonstants.Unitfull.c isa Unitful.AbstractQuantity

end
