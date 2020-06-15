\ProvidesClass{sprawozdanie-agh} 
\ProcessOptions\LoadClass[a4paper,12pt,oneside]{article} 

% Pakiety
\RequirePackage[polish]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage[a4paper]{geometry}
\RequirePackage[usenames]{color}
\RequirePackage{fancyhdr}
\RequirePackage{url}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\usepackage{amsmath}
\usepackage{ifthen}
\usepackage{hyperref}
\geometry{verbose,tmargin=2.3cm,bmargin=2.3cm,lmargin=2.3cm,rmargin=2.3cm}
\frenchspacing % włączenie odpowiednich spacji po kropkach
\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}

% Przepisanie parametrów
\def\przedmiot#1	{\gdef\@przedmiot{#1}}
\def\tytul#1		{\gdef\@tytul{#1}}
\def\podtytul#1		{\gdef\@podtytul{#1}}
\def\kierunek#1		{\gdef\@kierunek{#1}}
\def\autor#1		{\gdef\@autor{#1}}
\def\email#1		{\gdef\@email{#1}}
\def\data#1			{\gdef\@data{#1}}

% Domyślny kierunek
\ifx \@kierunek \undefined
	\def \@kierunek {In\.zynieria Akustyczna}
\fi

% Strona tytułowa
\newcommand{\stronatytulowa}{
	\begin{titlepage}
		\begin{center}
			%\vspace*{3cm}
		
			% Góra strony
			\textsc{\LARGE \bfseries Akademia G{\'o}rniczo-Hutnicza}\\[0.2cm]
			\textsc{\large Wydzia\l \space In\.zynierii Mechanicznej i Robotyki}\\
			\textsc{\large Kierunek: \@kierunek}\\[1.5cm]
			\begin{figure}[h!]
				\begin{center}
					\leavevmode
					\includegraphics[scale=0.8, trim = 0mm 0mm 0mm 0mm, clip]{logo-agh.jpg}
				\end{center}
			\end{figure}
			\vspace{2cm}
			\textsc{\Large \@przedmiot}

			% Tytuł
			\HRule \\[0.4cm]{
				\huge \bfseries \@tytul\\[0.3cm]
				\large \@podtytul
			}\\[0.4cm]
			\HRule \\[1.5cm]
			
			% Autor
			\begin{minipage}{0.7\textwidth}
				\begin{center}
					\large
					%\emph{Autor:}\\
					\@autor
					\ifx \@email \undefined
					\else
						\space(\emph{\@email})
					\fi
				\end{center}
			\end{minipage}

			% Dół strony
			\vfill
			{\large \@data}
		\end{center}
	\end{titlepage}
	
	% Licznik strony
	\setcounter{page}{2}
}