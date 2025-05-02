using Documenter

push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using PhysicalVectors



DocMeta.setdocmeta!(PhysicalVectors, :DocTestSetup, :(using PhysicalVectors))

# copy README.md to docs/src/index.md
fileIn = joinpath(@__DIR__, "..", "README.md")
fileOut = joinpath(@__DIR__, "..", "docs", "src/index.md")
`cp $(fileIn) $(fileOut)` |> run


makedocs(;
	sitename = "PhysicalVectors.jl",
    authors = "Rafael Alves Batista",
	format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
	modules = [PhysicalVectors],
	pages = [
		"Home" => "index.md",
		"API" => "api.md"
		],
	workdir = joinpath(@__DIR__, ".."),
	doctest = true,
	)

deploydocs(repo = "github.com/rafaelab/PhysicalVectors.jl.git", versions = nothing)