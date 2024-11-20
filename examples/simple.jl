using WordSearch

board=WordSearch.createEmptyBoard(13)

println("Enter words:")
words=readline() |> split 
show(words)

for word in words
    WordSearch.placeWord(board,word)
end

WordSearch.fillBoardRandomLetters(board)

println("Board generated:")
show(board)

# Generate LaTeX output to file
open("wordsearch.tex", "w") do f
    # Document setup
    write(f, "\\documentclass[a4paper]{article}\n")
    write(f, "\\usepackage[margin=2cm]{geometry}\n")
    write(f, "\\usepackage{tikz}\n\n")
    write(f, "\\begin{document}\n\n")
    write(f, "\\centering\n\n")

    # Start TikZ picture
    write(f, "\\begin{tikzpicture}\n")

    # Draw grid with boxes
    write(f, "\\draw[step=1cm,gray,very thin] (0,0) grid ($(length(board)),$(length(board)));\n")

    # Add background boxes
    for i in 1:length(board)
        for j in 1:length(board)
            write(f, "\\draw[fill=white] ($(j-1),$(length(board)-i)) rectangle ($(j),$(length(board)-i+1));\n")
        end
    end

    # Print letters in grid with improved formatting
    for i in 1:length(board)
        for j in 1:length(board)
            write(f, "\\node[font=\\Huge\\sffamily, text depth=0pt, text height=1.5ex] at ($(j-0.5),$(length(board)-i+0.4)) {$(board[i][j])};\n")
        end
    end

    write(f, "\\end{tikzpicture}\n\n")

    # Print word list preserving case
    write(f, "\\begin{itemize}\n")
    for word in words
        write(f, "\\item $(word)\n")
    end
    write(f, "\\end{itemize}\n\n")

    write(f, "\\end{document}\n")
end

println("LaTeX output written to wordsearch.tex")





