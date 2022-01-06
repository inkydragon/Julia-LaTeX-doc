# Julia LaTeX doc

The tex file in the `doc-en` folder is derived from the intermediate files of the julia repo master branch documentation build.
You can use these `.tex` files to test changes to the document style.

Following 2 PDFs, they should look similar:
+ V1.8 PDF doc build from [JuliaLang/julia#master][julia-2d472c633d]: [JuliaLang-julia#master-v1.8dev+2d472c633d](https://drive.google.com/file/d/1iiubflsSiPYY_AUtpHQWk-3c_XkJ3-Op/view?usp=sharing) in WSL2;
    Build with `tectonic`;
+ V1.8 PDF doc build from [`doc-en/julia-doc-en.tex`][26d1781]: [julia-doc-en+26d1781](https://drive.google.com/file/d/1kEhOXBqIvhdrFn2ex26ghhesDtnUQPMX/view?usp=sharing)
    Build with [`tectonic`](doc-en/tectonic.sh) in WSL2;
<!-- + V1.8 PDF doc build from [`doc-en/julia-doc-en.tex`][26d1781]: [julia-doc-en+26d1781]()
    Build with [`latexmk`](doc-en/pdf.cmd) on Win10; -->


[julia-2d472c633d]: https://github.com/JuliaLang/julia/commit/2d472c633d66e7697dda5aff75d2367b823048b8
[26d1781]: https://github.com/inkydragon/Julia-LaTeX-doc/commit/26d1781c695c7bc4dac4a6fdde9208b87ea49a46



## Gen PDF files

> All those TeX files are **self-contained**.
> If you don't need the latest version of the document, you can ignore submodules.

### Dependency
+ This repo: `git clone https://github.com/inkydragon/Julia-LaTeX-doc.git`
+ LaTeX env, just choose one:
    + [Tectonic](https://tectonic-typesetting.github.io/book/latest/getting-started/install.html)
    + TeXLive 2020 (older version is ok)
+ python3 + `pip install Pygments`.
    for code highlight
+ fonts:
    + `DejaVu Sans`
    + `DejaVu Sans Mono`

### Build

> You can comment some `\input` in `julia-doc-*.tex` to speed up build process, when you only care about style.

**english**
+ `cd Julia-LaTeX-doc/doc-en/`
+ build
    + Tectonic: `./tectonic.sh`
    + TeXLive:  (not test) `latexmk -f -interaction=nonstopmode -view=none -xelatex -shell-escape julia-doc-en.tex`

**chinese**
+ `cd Julia-LaTeX-doc/doc-zh/`
+ build
    + Tectonic: (not test) `tectonic -X compile --keep-logs -Z shell-escape julia-doc-en.tex`
    + TeXLive:  `latexmk -f -interaction=nonstopmode -view=none -xelatex -shell-escape --extra-mem-top=20000000 --pool-size=10000000  julia-doc-zh-cn.tex`


## Change Notes

> I made a mistake.
> I should have split the file first and then changed it. Now they're all in one commit.
> So It's necessary to make some explanations.

**about those dir**
+ `doc-en/`: for `TheJuliaLanguage` document in English.
    + `issues/`: *standalone* test for specific issue.
    + `part/`: The `\part{}` of english document, used by `TheJuliaLanguage.tex`
    + `titlepage/`: Front page, used by `TheJuliaLanguage.tex`
    + `TheJuliaLanguage.tex`: main TeX file.
    + `documenter.sty`: main style file.

**`TheJuliaLanguage.tex`**

1. I've splited these parts into separate files (`*.tex` in `doc-en/part/`) **without change them**.
    Then there is a lot of `\input` in `TheJuliaLanguage.tex`.
    They simply copy the file contents to main `tex` file.
2. remove `\usepackage{./custom.sty}`, it's empty.
3. add `\input{titlepage/title.tex}` to use title page.
4. add `\cleardoublepage` before TOC.

**`documenter.sty`**
1. use `\documentclass{book}`: We need `{book}` class, because we need `\part{}`.
2. use `{geometry}` to set page margin.
3. use `{background}` to make title page like https://julialang.org/.
4. use `{tocloft}` to make TOC looks better.


## How to generate TeX files?

> I'm using Windows 10 + Ubuntu 20 on WSL2, it's a mix of things.
> So, I can't give you a step by step instructions to reproduce.
/
1. use git Submodules to clone julia Main repo
    - [Git - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
2. apply diff
    **Chinese doc**
    ```sh
    $ pwd
    ~/Julia-LaTeX-doc
    $ cd JuliaZH.jl/
    $ pwd
    ~/Julia-LaTeX-doc/JuliaZH.jl
    $ git apply ../patch/cn0001-gen-tex-file.patch
    ```

3. build & copy
    **Chinese doc**
    ```sh
    $ pwd
    ~/Julia-LaTeX-doc/JuliaZH.jl
    $ cd doc/
    $ pwd
    ~/Julia-LaTeX-doc/JuliaZH.jl/doc
    $ julia --project=@. make.jl pdf
    $ ls build/
    Julia中文文档.tex  assets  base  custom.sty  devdocs  documenter.sty  manual  stdlib
    $ cp build/Julia中文文档.tex ../../doc-zh/Julia-doc-zh-cn-new.tex
    ```

4. copy `.tex` files
    ```sh
    $ pwd
    ~/GitHub/Julia-LaTeX-doc
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
