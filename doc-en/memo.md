
## Not latin font


### CJK
- [Variables · The Julia Language](https://docs.julialang.org/en/v1/manual/variables/)

```julia
# cjkfont
人人生而自由，在尊严和权利上一律平等。

# Korean
안녕하세요
```

TeX patch:
```tex
% CJK font
\usepackage{xeCJK}
\setCJKmonofont{Noto Sans Mono CJK SC}
\setCJKfallbackfamilyfont{\CJKttdefault}{ % \texttt 和 \ttfamily
  {Noto Sans Mono CJK KR},
}
```

### Unicode

```julia
⊼ ⊽ ⊻ ≡ ≤ ⧐
ℯ π ௰ ℵ Θ α β
⛵ 🚀
⋮ ⠀ ⠈ ⡀ ⠁ ⠠
∤ ⅋ ≀ ⊼ ⋇ ⋉ ⋊ ⋋ ⋌ ⋒ ⟑ ⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ ⩑ ⩓ ⩕
⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⨝ ⟕ ⟖ ⟗ ∔ ⊽ ⋓ ⨈ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ ⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨹ ⨺ ⩁ ⩂ ⩅ ⩊ ⩌ ⩏ ⩐ ⩒ ⩔ ⩖ ⩗ ⩛ ⩝ ⩡ ⩢ ⩣
```

TeX patch:
```tex
\setmonofont{JuliaMono Regular}[Scale=MatchLowercase]
\newcommand\unicodeveebar{ ⊻ }
```
