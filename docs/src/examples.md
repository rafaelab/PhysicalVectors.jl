## Examples

Vectors can be defined in any dimension desired.
```julia
x = VectorSpatial(1., 0.) ## 2D vector
```

In the case of "four" vectors (which can be in any dimension), the last entry correspond to the temporal part.
It has to be defined in a consistent way with respect to the spatial part, with the `c`s.
```julia
X = FourPosition(1e10, 0, 0, c)
x = getSpatialPart(X)
ct = getTemporalPart(X)
```
Note that `c` is explicitly defined as a constant, referring to the speed of light in S.I. units.

A few operations based on four-vectors and the metric are implemented by default, including inner product.
```julia
V = VectorLorentz(3., 0., 0., 1.)
g = MetricMinkowski(4)
v = dot(V, v, g)
```

All vectors accept basic arithmetic operations.
```julia
x1 = VectorSpatial(1., 2., 0.)
x2 = VectorSpatial(0., 0., 1.)
x = x1 + x2 # VectorSpatial(1., 2., 1.)
y = 2. * x1 # VectorSpatial(2., 4., 0.)
```


Although this has not yet been explicitly tested, `Unitful` quantities should also be accepted as input, although there are currently no checks preventing inconsistencies such as:
```julia
X = FourPosition(u"kg", 0, 0, c)
```

