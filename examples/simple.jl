using WordSearch

println("Enter Size (13):")
size = parse(Int, readline())

board=WordSearch.createEmptyBoard(size)

println("Enter Title:")
title=readline()

println("Enter words:")
words=readline() |> split 
show(words)

for word in words
    placed=WordSearch.placeWord(board,word,allow_reverse=false,allow_diagonal=false)
    if !placed
        println("WARNING! Failed to place word: $word")
    end
end

WordSearch.fillBoardRandomLetters(board)

println("Board generated:")
show(board)

# Generate LaTeX output to file
open("wordsearch.tex", "w") do f
    # Document setup
    write(f, "\\documentclass[a4paper]{article}\n")
    write(f, "\\usepackage[margin=2cm]{geometry}\n")
    write(f, "\\usepackage{tikz}\n")
    write(f, "\\usepackage{multicol}\n")
    write(f, "\\usepackage[scaled]{helvet}\n") # Use Helvetica font; for sans-serif with open 'g'
    write(f, "\\renewcommand{\\familydefault}{\\sfdefault}\n")
    write(f, "\\begin{document}\n\n")
    write(f, "\\centering\n\n")
    # Print title
    write(f, "\\begin{huge}\n")
    write(f, title * "\n")
    write(f, "\\end{huge}\n\n")
    write(f, "\\vspace{1cm}\n\n")

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

    # Print word list in columns
    write(f, "\\vspace{1cm}\n")  # Add some vertical space
    write(f, "\\begin{multicols}{3}\\raggedcolumns\n")  # 3 columns, adjust number as needed
    write(f, "\\begin{itemize}\\setlength{\\itemsep}{0.2cm}\n")
    write(f, "\\Hugo\\sffamily \n")
    for word in sort(words)  # Sort words alphabetically
        write(f, "\\item {$(word)}\n")
    end
    write(f, "\\end{itemize}\n")
    write(f, "\\end{multicols}\n\n")

    write(f, "\\end{document}\n")
end

println("LaTeX output written to wordsearch.tex")





