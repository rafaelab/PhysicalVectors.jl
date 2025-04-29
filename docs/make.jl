using Documenter

using PhysicalVectors

DocMeta.setdocmeta!(Longinus, :DocTestSetup, :(using PhysicalVectors))


makedocs(
	sitename = "PhysicalVectors.jl",
	format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
	modules = [PhysicalVectors],
	workdir = joinpath(@__DIR__, ".."),
	pages = [
		"Home" => "index.md",
	]
)

deploydocs(repo = "github.com/rafaelab/PhysicalVectors.jl.git", versions = nothing)