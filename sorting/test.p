set terminal pdf
set output "test.pdf"

set style line 1 lc rgb "black" lw 1 pt 1
set title ""

set xlabel "n"
set ylabel "time in us"

plot "test.dat" u 1:2 with lines title "list", \
    "" u 1:3 with lines title "tree"
