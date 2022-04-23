## https://github.com/JuliaLang/julia/blob/master/doc/src/manual/unicode-input.md
#
# Generate a table containing all LaTeX and Emoji tab completions available in the REPL.
#
import REPL, Markdown
using DelimitedFiles
const NBSP = '\u00A0'

function tab_completions(symbols...)
    completions = Dict{String, Vector{String}}()
    for each in symbols, (k, v) in each
        completions[v] = push!(get!(completions, v, String[]), k)
    end
    return completions
end

function unicode_data()
    # http://www.unicode.org/Public/13.0.0/ucd/UnicodeData.txt
    file = normpath(".", "UnicodeData.txt")
    names = Dict{UInt32, String}()
    open(file) do unidata
        for line in readlines(unidata)
            id, name, desc = split(line, ";")[[1, 2, 11]]
            codepoint = parse(UInt32, "0x$id")
            names[codepoint] = titlecase(lowercase(
                name == "" ? desc : desc == "" ? name : "$name / $desc"))
        end
    end
    return names
end

# Surround combining characters with no-break spaces (i.e '\u00A0'). Follows the same format
# for how unicode is displayed on the unicode.org website:
# https://util.unicode.org/UnicodeJsps/character.jsp?a=0300
function fix_combining_chars(char)
    cat = Base.Unicode.category_code(char)
    return cat == 6 || cat == 8 ? "$NBSP$char$NBSP" : "$char"
end


function table_entries(completions, unicode_dict)
    entries = [[
        "Code point(s)", "Character(s)",
        "Tab completion sequence(s)", "Unicode name(s)"
    ]]
    for (chars, inputs) in sort!(collect(completions), by = first)
        code_points, unicode_names, characters = String[], String[], String[]
        for char in chars
            push!(code_points, "U+$(uppercase(string(UInt32(char), base = 16, pad = 5)))")
            push!(unicode_names, get(unicode_dict, UInt32(char), "(No Unicode name)"))
            push!(characters, isempty(characters) ? fix_combining_chars(char) : "$char")
        end
        push!(entries, [
            join(code_points, " + "), join(characters),
            join(inputs, ", "), join(unicode_names, " + ")
        ])
    end
    return entries
end

table_entries(
    tab_completions(
        REPL.REPLCompletions.latex_symbols,
        REPL.REPLCompletions.emoji_symbols
    ),
    unicode_data()
)
## ==== unicode-input gen END




## ============================================================================

# copy from `LaTeXWriter.jl` documenter.jl
const _latexescape_chars = Dict{Char, AbstractString}(
    '~' => "{\\textasciitilde}",
    '^' => "{\\textasciicircum}",
    '\\' => "{\\textbackslash}",
    '\'' => "{\\textquotesingle}",
    '"' => "{\\textquotedbl}",
)
for ch in "&%\$#_{}"
    _latexescape_chars[ch] = "\\$ch"
end

latexesc(io, ch::AbstractChar) = print(io, get(_latexescape_chars, ch, ch))

function latexesc(io, s::AbstractString)
    for ch in s
        latexesc(io, ch)
    end
end

latexesc(s) = sprint(latexesc, s)


const use_Math_Font_One = [
    "U+000AA", "U+000BA", "U+000C5", "U+000C6", "U+000D0", 
    "U+000D8", "U+000DE", "U+000DF", "U+000E5", "U+000E6", 
    "U+000F8", "U+000FE", 
    
    "U+00110", "U+00111", "U+00127", "U+00141", "U+00142", 
    "U+0014A", "U+0014B", "U+00152", "U+00153", "U+00195", 
    "U+0019E", "U+001C2", 
    
    "U+00250", "U+00252", "U+00254", "U+00256", "U+00259", 
    "U+00263", "U+00264", "U+00265", "U+0026C", "U+0026D", 
    "U+0026F", "U+00270", "U+00271", "U+00272", "U+00273", 
    "U+00277", "U+00278", "U+00279", "U+0027A", "U+0027B", 
    "U+0027C", "U+0027D", "U+0027E", "U+00282", "U+00283", 
    "U+00287", "U+00288", "U+0028A", "U+0028B", "U+0028C", 
    "U+0028D", "U+0028E", "U+00290", "U+00292", "U+00294", 
    "U+00295", "U+00296", "U+0029E", "U+002A4", "U+002A7", 
    "U+002BC", "U+002C8", "U+002CC", "U+002D0", "U+002D1", 
    
    "U+00300", "U+00301", "U+00302", "U+00303", "U+00304", 
    "U+00305", "U+00306", "U+00307", "U+00308", "U+00309", 
    "U+0030A", "U+0030B", "U+0030C", "U+00310", "U+00312", 
    "U+00315", "U+0031A", "U+00321", "U+00322", "U+00327", 
    "U+00328", "U+0032A", "U+00330", "U+00332", "U+00336", 
    "U+00338", "U+0034D", "U+003D0", "U+003D8", "U+003D9", 
    "U+003DA", "U+003DB", "U+003DC", "U+003DD", "U+003DE", 
    "U+003DF", "U+003E0", "U+003E1", 
    
    "U+020D0", "U+020D1", "U+020D2", "U+020D6", "U+020D7", 
    "U+020DB", "U+020DC", "U+020DD", "U+020DE", "U+020DF", 
    "U+020E1", "U+020E4", "U+020E7", "U+020E8", "U+020E9", 
    "U+020EC", "U+020ED", "U+020EE", "U+020EF", "U+020F0", 
    
    "U+02126"
]

# FreeSerif
const use_Math_Font_Two = [
    "U+01D45", "U+01D49", "U+01D4B", "U+01DA5", "U+01DB2", 
    "U+0205D", "U+02094", 
    "U+0215F", 
    "U+02422", 
    "U+02519", 
    "U+02643", "U+02644", "U+02645", "U+02646", "U+02647",
]


#= Show invisible spaces

%% Show invisible spaces
% \newbox\SpaceBox
% \newdimen\SpaceDim
% \newcommand\ShowSpaceWidth[1][\,]{%
%   \sbox\SpaceBox{#1}%
%   \SpaceDim=\wd\SpaceBox%
%   \makebox[\SpaceDim]{%
%     \kern.06em
%     \vrule height.3ex
%     \hrulefill
%     \vrule height.3ex
%     % \kern.06em
%   }%
% }
%%
=#
const invisible_spaces = [
    # "U+02002", "U+02003", "U+02005", "U+02009", "U+0200A"
]


"""Gen full emoji list.

ref:
    - [emoji_sequences.txt](https://unicode.org/Public/emoji/13.0/emoji-sequences.txt)
"""
function gen_full_emoji_list()
    full_emoji_list = Vector{Char}()
    sizehint!(full_emoji_list, 1122) # one code point emoji @ v13.0 

    #= Read Unicode Emoji Data 

    Emoji Data Format
        code_point(s) ; type_field  ; description           # comments
        231A..231B    ; Basic_Emoji ; watch                 # E0.6   [2] (⌚..⌛)
        23F0          ; Basic_Emoji ; alarm clock           # E0.6   [1] (⏰)
        2611 FE0F     ; Basic_Emoji ; check box with check  # E0.6   [1] (☑️)
    =#
    emoji_data = readdlm(
        # download("https://unicode.org/Public/emoji/13.0/emoji-sequences.txt"),
        "emoji-sequences.txt", 
        ';', String, '\n', 
        comments=true, comment_char='#'
    )
    # remove spaces
    emoji_code_point_str = map(strip, emoji_data[:, 1])


    #= filter out ONE code point uchar
        We don't need multi code point emoji like "2611 FE0F".
    =#
    ustr = "[0-9A-F]{4,5}" # code point sequence
    one_cp   = Regex("^($ustr){1}\$") # one code point
    cp_range = Regex("^($ustr)\\.\\.($ustr)\$") # code point range
    is_one_cp(s)    = !isnothing(match(one_cp, s))
    is_cp_range(s)  = !isnothing(match(cp_range, s))
    is_emoji(s::AbstractString) = is_one_cp(s) || is_cp_range(s) 

    one_cp_emoji = filter(is_emoji, emoji_code_point_str)


    #= gen full emoji list =#
    str_to_uchar(s::AbstractString) = parse(Int, s, base=16) |> Char
    for s in one_cp_emoji
        if is_one_cp(s)
            push!(full_emoji_list, str_to_uchar(s))
        elseif is_cp_range(s)
            us, ue = split(s, "..")
            us = str_to_uchar(us)
            ue = str_to_uchar(ue)
            append!(full_emoji_list, collect(us:ue))
        end
    end
    
    full_emoji_list
end


Full_OneCP_Emoji_List = gen_full_emoji_list()
function table_item(arr::Vector{String})
    code_point, uchar, name, desc = arr

    latex_input = "$(uchar)"
    if ':' in name || uchar[1] in Full_OneCP_Emoji_List
        latex_input = "{\\EmojiFont $(uchar)}"
    elseif code_point in use_Math_Font_One
        latex_input = "{\\MathSymFontOne $(uchar)}"
    elseif code_point in use_Math_Font_Two
        latex_input = "{\\MathSymFontTwo $(uchar)}"
    elseif code_point in invisible_spaces
        latex_input = "\\ShowSpaceWidth[\$ $(uchar) \$]"
    else
        latex_input = "\$ $(uchar) \$"
    end

    join([
        code_point,
        latex_input,
        latexesc(name),
        latexesc(desc),
    ], " & ") * " \\\\ \\hline"
end

all_symbols = table_entries(
    tab_completions(
        REPL.REPLCompletions.emoji_symbols, 
        REPL.REPLCompletions.latex_symbols
    ),
    unicode_data()
)

# open("unicode-input-table.tex", "w") do f
#     for a in all_symbols[2:end]
#         println(f, table_item(a))
#     end
# end

function table_item(arr::Vector{String})
    code_point, uchar, name, desc = arr

    latex_input = "$(uchar)"
    if ':' in name || uchar[1] in Full_OneCP_Emoji_List
        latex_input = "{\\EmojiFont $(uchar)}"
    else
        return ""
    end

    join([
        code_point,
        latex_input,
        latexesc(name),
        latexesc(desc),
    ], " & ") * " \\\\ \\hline"
end

open("emoji-test.tex", "w") do f
    for a in all_symbols[2:end]
        println(f, table_item(a))
    end
end
