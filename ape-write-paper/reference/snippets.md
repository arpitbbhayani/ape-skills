# Snippets

## Claim ledger (scratch file, not in the paper)

```
claim                                   value        source                                   verified
holdout exact match, system             37/48=77.1%  eval/benchmark_*_holdout.json:scores.all  yes (recomputed)
speedup vs slowest baseline             437x         5768.67 / 13.2                            yes
per-category N                          36/5/4/2/1   counted from eval/holdout.json            yes
latency 13.2 ms                         13.2         docs/07 only                              flag: not in result files
```

Wilson 95% interval: `p=k/n; d=1+z*z/n; c=(p+z*z/(2*n))/d; h=z*sqrt(p*(1-p)/n+z*z/(4*n*n))/d; (c-h, c+h)`, z=1.96.

## Pipeline figure (full width)

```latex
\begin{figure*}[t]\centering
\begin{tikzpicture}[font=\small,
  box/.style={rectangle, rounded corners=2pt, thick, align=center, minimum width=2.45cm, minimum height=1.05cm, inner sep=3pt, font=\scriptsize},
  det/.style={box, draw=determ, fill=determfill},
  nn/.style={box, draw=learned, fill=learnedfill},
  io/.style={box, draw=black!70, fill=white},
  arr/.style={-{Stealth[length=5pt]}, thick, black!75},
  darr/.style={-{Stealth[length=5pt]}, thick, dashed, determ},
  lab/.style={font=\tiny, text=black!70}]
\node[io]  (in)  at (0,0)   {\textbf{Input}};
\node[det] (s1)  at (3,0)   {\textbf{1\;Stage}\\[-1pt]detail};
\node[nn]  (s2)  at (6,0)   {\textbf{2\;Stage}\\[-1pt]detail};
\node[io]  (out) at (9,0)   {\textbf{Output}};
\draw[arr] (in) -- (s1); \draw[arr] (s1) -- (s2); \draw[arr] (s2) -- (out);
\draw[darr] (s1.north) -- ++(0,0.5) -| node[lab,pos=0.25,above]{bypass} (out.north);
% legend
\node[draw=learned, fill=learnedfill, minimum width=0.45cm, minimum height=0.28cm, rounded corners=1pt, thick] at (3,-1.5) {};
\node[anchor=west, font=\scriptsize] at (3.3,-1.5) {learned};
\node[draw=determ, fill=determfill, minimum width=0.45cm, minimum height=0.28cm, rounded corners=1pt, thick] at (5,-1.5) {};
\node[anchor=west, font=\scriptsize] at (5.3,-1.5) {deterministic};
\end{tikzpicture}
\caption{\textbf{Name.} What each stage does and what flows between them.}
\end{figure*}
```
Pitch nodes about 3 cm apart; keep arrow labels off short arrows.

## Horizontal bar chart (one column)

```latex
\begin{tikzpicture}\begin{axis}[xbar, width=\columnwidth, height=6.2cm, xmin=60, xmax=104, bar width=4.5pt,
  xtick={60,70,80,90,100}, xlabel={\small exact match (\%)},
  symbolic y coords={A,B,C}, ytick=data, y dir=reverse,
  tick label style={font=\scriptsize}, nodes near coords,
  nodes near coords style={font=\scriptsize, /pgf/number format/fixed, /pgf/number format/precision=1, /pgf/number format/zerofill},
  enlarge y limits=0.06, xmajorgrids, grid style={gray!25, line width=0.3pt}, axis lines*=left, axis x line*=bottom]
\addplot[fill=learned!70, draw=learned] coordinates {(64.6,A) (86.0,B) (99.0,C)};
\end{axis}\end{tikzpicture}
```
Sort bars by value. Extra categories at the ceiling go in the caption.

## Accuracy vs latency scatter

```latex
\begin{axis}[xmode=log, xlabel={median latency (ms, log)}, ylabel={exact match (\%)}, grid=both, legend pos=south east]
\addplot[only marks, mark=*, color=learned] coordinates {(13.2,77.1)};
\addplot[only marks, mark=square*, color=determ] coordinates {(2267,89.6) (4280,97.9)};
\end{axis}
```

## Booktabs table (wide, no fills)

```latex
\begin{table*}[t]\centering\small
\begin{tabular}{@{}llccr@{}}
\toprule
\textbf{System} & \textbf{Mode} & \textbf{All} & \textbf{p50 (ms)} & \textbf{Slower} \\
 & & \scriptsize (n=48) & & \\
\midrule
\textbf{Ours} & routing & 77.1 & \textbf{13.2} & 1$\times$ \\
\midrule
Baseline & single-shot & 89.6 & 2{,}267 & 172$\times$ \\
\bottomrule
\end{tabular}
\caption{What, units, data files, caveats.}
\end{table*}
```

## Throughput vs Tail Latency (Systems / Database)

```latex
\begin{tikzpicture}\begin{axis}[
  width=\columnwidth, height=5.8cm,
  xlabel={Throughput (k ops/sec)}, ylabel={p99 Latency (\textmu s, log)},
  ymode=log, grid=both, grid style={gray!20, line width=0.3pt},
  legend pos=north west, legend style={font=\scriptsize}]
\addplot[thick, mark=*, color=learned] coordinates {(120,45) (280,68) (450,110) (610,320)};
\addlegendentry{Ours}
\addplot[thick, dashed, mark=square*, color=determ] coordinates {(80,95) (160,180) (240,890)};
\addlegendentry{Baseline}
\end{axis}\end{tikzpicture}
```

## Multi-Core Scalability (Throughput vs Threads)

```latex
\begin{tikzpicture}\begin{axis}[
  width=\columnwidth, height=5.8cm,
  xlabel={Worker Threads}, ylabel={Throughput (M ops/sec)},
  xmin=1, xmax=64, xtick={1,8,16,32,48,64},
  grid=major, grid style={gray!20, line width=0.3pt},
  legend pos=north west, legend style={font=\scriptsize}]
\addplot[thick, mark=*, color=learned] coordinates {(1,0.42) (8,3.2) (16,6.1) (32,11.8) (64,21.5)};
\addlegendentry{Ours}
\addplot[thick, dashed, mark=square*, color=determ] coordinates {(1,0.38) (8,2.1) (16,3.4) (32,4.8) (64,5.1)};
\addlegendentry{Baseline (locking)}
\end{axis}\end{tikzpicture}
```

## Algorithm / Pseudocode Block

```latex
\begin{algorithm}[t]
\caption{Core Execution Operator / Protocol}\label{alg:core}
\begin{algorithmic}[1]
\Require Query plan node $Q$, memory budget $B$, thread pool $T$
\Ensure Materialized iterator $I$
\State Initialize lock-free hash table $H$ with capacity $B / \text{sizeof}(\text{slot})$
\For{each tuple $t \in Q.\text{scan}()$ in parallel via $T$}
  \State $k \gets \text{hash}(t.\text{join\_key})$
  \If{$H.\text{probe}(k) \neq \textsc{Null}$}
    \State $H.\text{update}(k, t.\text{val})$ \Comment{Atomic fetch-and-add}
  \Else
    \State $H.\text{insert}(k, t.\text{val})$
  \EndIf
\EndFor
\State \Return $H.\text{create\_iterator}()$
\end{algorithmic}
\end{algorithm}
```

## Hardware & Environment Specification Template

```latex
All experiments are conducted on a 2-socket server equipped with two Intel Xeon 
Platinum 8375C CPUs (32 cores / 64 threads each at 2.80\,GHz, 48\,KB L1d, 
1.25\,MB L2, and 54\,MB shared L3 cache per socket), 256\,GB DDR4-3200 RAM 
(NUMA balanced, pinned with \texttt{numactl}), and a 3.84\,TB PCIe 4.0 NVMe SSD 
(sequential read 7\,GB/s, 900k random read IOPS). The OS is Ubuntu 22.04 LTS 
(Linux kernel 5.15.0-89-generic). Binaries are compiled using Clang 16 with 
\texttt{-O3 -march=native}. OS page caches are dropped before every cold-cache 
run via \texttt{drop\_caches}; warm-cache runs precede measurement by 3 warmup iterations.
```

## ACM SIGMOD / PACMMOD Skeleton (`acmart`)

```latex
\documentclass[sigconf,review,anonymous]{acmart}
% Note: Do NOT load geometry, hyperref, or titlesec with acmart; it manages them natively.
\usepackage{booktabs}
\usepackage{pgfplots}
\usepackage{algorithm}
\usepackage{algpseudocode}
\usepackage{listings}
\pgfplotsset{compat=1.17}

\begin{document}
\title{Paper Title}

\begin{abstract}
Abstract text goes here. Must specify problem, insight, N, and key trade-off.
\end{abstract}

% ACM CCS concepts and keywords (required for camera-ready / regular submissions)
\begin{CCSXML}
<ccs2012>
 <concept>
  <concept_id>10002951.10002952.10003190</concept_id>
  <concept_desc>Information systems~Database query processing</concept_desc>
  <concept_significance>500</concept_significance>
 </concept>
</ccs2012>
\end{CCSXML}
\ccsdesc[500]{Information systems~Database query processing}
\keywords{Query processing, vectorization, indexing, benchmarks}

\maketitle

% Content sections go here...

\bibliographystyle{ACM-Reference-Format}
\bibliography{references}
\end{document}
```

## Worked-example pattern

Input text in an italic quote, field/question line, a small table of intermediate decisions with real system output, the final arithmetic or derivation in one display, the verbatim trace/log in a `\ttfamily` quote, then one sentence on why the tricky part (link, distractor, edge case) is handled.
