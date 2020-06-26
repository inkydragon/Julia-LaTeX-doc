# Julia LaTeX doc

> I'am using Windows 10 + Ubuntu 20 on WSL2, it's a mix of things.
> So, I can't give you a step by step instructions to reproduce.


1. use git Submodules to clone julia Main repo
    - [Git - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
2. use `Documenter.jl#master` or `0.25.0+`
    We need [add new platform to compile only to latex by cserteGT3 · Pull Request #1339 · JuliaDocs/Documenter.jl](https://github.com/JuliaDocs/Documenter.jl/pull/1339).

    ```diff
    diff -u Manifest.toml Manifest2.toml
    --- Manifest.toml       2020-06-26 10:21:07.510110200 +0800
    +++ Manifest2.toml      2020-06-26 10:20:58.069287100 +0800
    @@ -19,9 +19,11 @@

    [[Documenter]]
    deps = ["Base64", "Dates", "DocStringExtensions", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
    -git-tree-sha1 = "395fa1554c69735802bba37d9e7d9586fd44326c"
    +git-tree-sha1 = "d7d97a742a3b849c4b6312e96bba276e9dcdaf9b"
    +repo-rev = "master"
    +repo-url = "https://github.com/JuliaDocs/Documenter.jl"
    uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
    -version = "0.24.11"
    +version = "0.24.7+0.25-DEV"

    [[DocumenterLaTeX]]
    deps = ["Documenter", "Test"]
    ```

3. output only `.tex` files

    ```diff
    diff -u make.jl make2.jl
    --- make.jl     2020-06-26 10:18:32.719498400 +0800
    +++ make2.jl    2020-06-26 10:18:51.622296600 +0800
    @@ -176,6 +176,10 @@
    end
    # A few standard libraries need more than just the module itself in the DocTestSetup.
    # This overwrites the existing ones from above though, hence the warn=false.
    +using SparseArrays
    +using SuiteSparse
    +using UUIDs
    +
    DocMeta.setdocmeta!(SparseArrays, :DocTestSetup, :(using SparseArrays, LinearAlgebra), recursive=true, warn=false)
    DocMeta.setdocmeta!(SuiteSparse, :DocTestSetup, :(using SparseArrays, LinearAlgebra, SuiteSparse), recursive=true, warn=false)
    DocMeta.setdocmeta!(UUIDs, :DocTestSetup, :(using UUIDs, Random), recursive=true, warn=false)
    @@ -204,13 +208,13 @@
    makedocs(
        build     = joinpath(buildroot, "doc", "_build", (render_pdf ? "pdf" : "html"), "en"),
        modules   = [Base, Core, [Base.root_module(Base, stdlib.stdlib) for stdlib in STDLIB_DOCS]...],
    -    clean     = true,
    +    clean     = false,
        doctest   = ("doctest=fix" in ARGS) ? (:fix) : ("doctest=only" in ARGS) ? (:only) : ("doctest=true" in ARGS) ? true : false,
        linkcheck = "linkcheck=true" in ARGS,
        linkcheck_ignore = ["https://bugs.kde.org/show_bug.cgi?id=136779"], # fails to load from nanosoldier?
    -    strict    = true,
    +    strict    = false,
        checkdocs = :none,
    -    format    = format,
    +    format    = LaTeX(platform = "none"),
        sitename  = "The Julia Language",
        authors   = "The Julia Project",
        pages     = PAGES,
    @@ -230,11 +234,11 @@

    const devurl = "v$(VERSION.major).$(VERSION.minor)-dev"

    -deploydocs(
    -    repo = "github.com/JuliaLang/docs.julialang.org.git",
    -    deploy_config = BuildBotConfig(),
    -    target = joinpath(buildroot, "doc", "_build", "html", "en"),
    -    dirname = "en",
    -    devurl = devurl,
    -    versions = ["v#.#", devurl => devurl]
    -)
    +# deploydocs(
    +#     repo = "github.com/JuliaLang/docs.julialang.org.git",
    +#     deploy_config = BuildBotConfig(),
    +#     target = joinpath(buildroot, "doc", "_build", "html", "en"),
    +#     dirname = "en",
    +#     devurl = devurl,
    +#     versions = ["v#.#", devurl => devurl]
    +# )
    ```

4. copy `.tex` files
    ```sh
    $ pwd
    ~/GitHub/Julia-LaTeX-doc
    $ rm -rd doc-en/
    $ cp -R ./julia/doc/_build/pdf/en/ ./doc-en
    $ cd doc-en/
    $ pwd
    ~/GitHub/Julia-LaTeX-doc/doc-en
    $ rm -rd assets/ base/ devdocs/ manual/ stdlib/
    $ ll -h
    total 3.3M
    drwxrwxrwx 1 woclass woclass  512 Jun 26 10:39 ./
    drwxrwxrwx 1 woclass woclass  512 Jun 26 10:39 ../
    -rwxrwxrwx 1 woclass woclass 3.3M Jun 26 10:39 TheJuliaLanguage.tex*
    -rwxrwxrwx 1 woclass woclass    0 Jun 26 10:39 custom.sty*
    -rwxrwxrwx 1 woclass woclass 1.8K Jun 26 10:39 documenter.sty*
    ```
