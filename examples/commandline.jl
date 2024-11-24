using WordSearch
using ArgParse

function parse_commandline()
    s = ArgParseSettings(
        description = "WordSearch.jl command line interface."
    )

    @add_arg_table! s begin
        "--size", "-s"
            help = "Size of the puzzle grid"
            arg_type = Int
            default = 14
        "--title", "-t"
            help = "Title of the puzzle"
            default = "WordSearch.jl"
        "--words", "-w"
            help = "Words to include (comma-separated)"
            default = "towel,babel,pangalactic,Vogon,bistromathics,hyperspace,zaphod,improbability,hoopy,froody"
        "--reverse", "-r"
            help = "Allow reverse words"
            action = :store_true
        "--diagonal", "-d"
            help = "Allow diagonal words"
            action = :store_true
        "--output", "-o"
            help = "Output LaTeX filename (optional)"
            default = nothing
    end

    return parse_args(s)
end

function display_settings(args)
    println("\n=== Word Search Settings ===")
    println("Grid Size: $(args["size"]) × $(args["size"])")
    println("Title: \"$(args["title"])\"")
    println("Words: $(join(split(args["words"], ',') .|> strip, ", "))")
    println("Allow Reverse Words: $(args["reverse"] ? "Yes" : "No")")
    println("Allow Diagonal Words: $(args["diagonal"] ? "Yes" : "No")")
    println("LaTeX Output: $(args["output"])")
    println("=========================\n")
end

function main()
    args = parse_commandline()
    
    # Display settings
    display_settings(args)
    
    # Create board
    board = WordSearch.createEmptyBoard(args["size"])
    
    # Parse words from comma-separated string
    words = split(args["words"], ',') .|> strip .|> lowercase
    
    # Try to place each word
    println("Placing words...")
    for word in words
        placed = WordSearch.placeWord(board, word, 
                                    allow_reverse=args["reverse"], 
                                    allow_diagonal=args["diagonal"])
        if !placed
            println("⚠️  WARNING! Failed to place word: $word")
        else
            println("✓ Successfully placed: $word")
        end
    end
    println("Solution Board:")
    show(board)

    # Fill remaining spaces with random letters
    WordSearch.fillBoardRandomLetters(board)
    
    # Show the result
    println("\nBoard with random letters:")
    show(board)

    println("\nWords to find:")
    println(join(words, ", "))
    
    # Generate LaTeX output only if output file is specified
    if !isnothing(args["output"])
        WordSearch.generateLatexOutput(args["output"], board, words, args["title"])
        println("\nLaTeX output written to $(args["output"])")
    end
end

main()
