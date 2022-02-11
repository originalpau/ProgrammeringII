set terminal pdf
set output "prim.pdf"

set style line 1 lc rgb "black" lw 1 pt 1
set title "Benchmark for finding primes"

set xlabel "n"
set ylabel "time in microseconds"

plot "prim.dat" u 1:2 with lines title "first", \
    "" u 1:3 with lines title "second", \
    "" u 1:4 with lines title "third"
