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
            default = 12
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
    
    words=sort(words, by=length, rev=true) # place longest words first... 
    # makes the greedy placement more likely to succeed (i.e. achieves higher density). 
    # I don't know whether this biases the boards produced? 
    
    # Try to place each word
    println("Placing words...")
    incomplete=false
    placedwords=[]

    for word in words
        if length(word) > args["size"]
            println("⚠️  WARNING! Word '$word' is longer than board size $(args["size"]) - skipping")
            incomplete=true
            continue
        end

        placed = WordSearch.placeWord(board, word, 
                                    allow_reverse=args["reverse"], 
                                    allow_diagonal=args["diagonal"])
        if !placed
            println("⚠️  WARNING! Failed to place word: $word")
            incomplete=true
        else
            append!(placedwords,[word])
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
    println(join(placedwords, ", "))
    
    if incomplete
        println("WARNING! Did not place all words.")
    end

    # Generate LaTeX output only if output file is specified
    if !isnothing(args["output"])
        WordSearch.generateLatexOutput(args["output"], board, placedwords, args["title"])
        println("\nLaTeX output written to $(args["output"])")
    end
end

main()
