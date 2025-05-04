using Documenter
using Pkg

push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using PhysicalVectors



Pkg.develop(PackageSpec(name = "Cosmonstants", url = "https://github.com/rafaelab/Cosmonstants.jl"))


DocMeta.setdocmeta!(PhysicalVectors, :DocTestSetup, :(using PhysicalVectors))


makedocs(;
	sitename = "PhysicalVectors.jl",
    authors = "Rafael Alves Batista",
	format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
	modules = [PhysicalVectors],
	pages = [
		"Home" => "index.md",
		"API" => "api.md",
		"Examples" => "examples.md"
		],
	workdir = joinpath(@__DIR__, ".."),
	doctest = true,
	)

deploydocs(;
	repo = "github.com/rafaelab/PhysicalVectors.jl.git", 
	versions = nothing
	)