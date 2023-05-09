pushfirst!(LOAD_PATH, joinpath(@__DIR__, "..")) # add Oceanostics environment to docs
using Pkg
CI = get(ENV, "CI", nothing) == "true" || get(ENV, "GITHUB_TOKEN", nothing) !== nothing
CI && Pkg.instantiate()

using Documenter
using Literate

using Oceananigans
using Oceanostics

#+++ Run examples
EXAMPLES_DIR = joinpath(@__DIR__, "examples")
OUTPUT_DIR   = joinpath(@__DIR__, "src/generated")

examples = ["two_dimensional_turbulence.jl",
           ]

for example in examples
    example_filepath = joinpath(EXAMPLES_DIR, example)
    Literate.markdown(example_filepath, OUTPUT_DIR; flavor = Literate.DocumenterFlavor())
end

example_pages = ["Quick start" => "quick_start.md",
                 "Two-dimensional turbulence" => "generated/two_dimensional_turbulence.md",
                 ]
#---


#+++ Organize pages and HTML format
pages = ["Home" => "index.md",
         "Examples" => example_pages,
         "Function library" => "library.md",
        ]


format = Documenter.HTML(collapselevel = 1,
                         prettyurls = CI, # Makes links work when building locally
                         mathengine = MathJax3(),
                         warn_outdated = true,
                         )
#---

#+++ Make and deploy docs
makedocs(sitename = "Oceanostics.jl",
         authors = "Tomas Chor and contributors",
         pages = pages,
         modules = [Oceanostics],
         doctest = true,
         strict = :doctest,
         clean = true,
         format = format,
         )

if CI
    deploydocs(repo = "github.com/tomchor/Oceanostics.jl.git",
               push_preview = true,
               )
end
#---
