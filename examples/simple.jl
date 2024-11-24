using WordSearch

println("Enter Size (10 seems good for 6 year olds; 8 for 4 year olds):")
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

println("Solution Board:")
show(board)

WordSearch.fillBoardRandomLetters(board)
println("Board with random letters:")
show(board)

WordSearch.generateLatexOutput("wordsearch.tex", board, words, title)
println("LaTeX output written to wordsearch.tex")

