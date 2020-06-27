import REPL
const NBSP = '\u00A0'

function tab_completions(symbols...)
    completions = Dict{String, Vector{String}}()
    for each in symbols, (k, v) in each
        completions[v] = push!(get!(completions, v, String[]), k)
    end
    return completions
end

function unicode_data()
    # file = normpath(Sys.BINDIR, "..", "UnicodeData.txt")
    # http://www.unicode.org/Public/9.0.0/ucd/UnicodeData.txt
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
# http://unicode.org/cldr/utility/character.jsp?a=0300
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
    # return Markdown.Table(entries, [:l, :l, :l, :l])
    entries
end


emoji = table_entries(
    tab_completions(
        # REPL.REPLCompletions.latex_symbols,
        REPL.REPLCompletions.emoji_symbols
    ),
    unicode_data()
)

# U+1F6B9 & 🚹 & {\textbackslash}:mens: & Mens Symbol \\ \hline
function emoji_item(arr::Vector{String})
    code_points, emoji, name, desc = arr
    emoji_name_esc = replace(name[2:end], r"_" => "\\_")

    "  $(code_points) & \\EmojiFont{$(emoji)} & {\\textbackslash}$(emoji_name_esc) & $(desc) \\\\ \\hline"
end

open("unicode-table-item.tex", "w") do f
    for a in emoji[2:end]
      println(f, emoji_item(a))
    end
end
