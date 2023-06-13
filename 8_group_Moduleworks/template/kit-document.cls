% rwth-document.cls
%
% Pascal Richter (richter@mathcces.rwth-aachen.de)
% 2014/11/22
%
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{rwth-document}[2014/11/22 RWTH Vorlage fuer Dokumente]

% class and all needed packages
\LoadClass[a4paper,twoside]{scrartcl}
\RequirePackage{ifthen}[2001/05/26]
\RequirePackage{refcount}[2010/12/01]
\RequirePackage{graphicx}[1999/02/16]
\RequirePackage[absolute]{textpos}[2010/09/30]
\RequirePackage{lastpage}

% options
\PassOptionsToPackage{table}{xcolor}
\newif\ifpagenum\pagenumtrue
\newif\iflandscape\landscapefalse
\DeclareOption{english}{\AtEndOfClass{\main@language{english}}}
\DeclareOption{ngerman}{\AtEndOfClass{\main@language{ngerman}}}
\DeclareOption{pagenumoff}{\pagenumfalse}
\DeclareOption{landscape}{\landscapetrue}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{rwth-base}}
\ProcessOptions\relax
\RequirePackage{rwth-base}[2013/11/22]
\RequirePackage[english,ngerman]{babel}


% additional packages
\RequirePackage[%
colorlinks,pdfpagelabels,pdfstartview = FitH,bookmarksopen = false,bookmarksnumbered = false,linkcolor = black,plainpages = false,hypertexnames = false,citecolor = black, urlcolor = black] {hyperref}
\RequirePackage{caption}
\RequirePackage{wrapfig}
\RequirePackage{multirow}
\RequirePackage{longtable}
\RequirePackage{tabularx}
\RequirePackage{fix-cm}
\RequirePackage{pgf}
\RequirePackage{tikz}
\RequirePackage{pgfplotstable}
\RequirePackage{calc}

% package settings
\pgfplotsset{compat=1.4}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}} % linksb�ndig mit Breitenangabe
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}} % zentriert mit Breitenangabe
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}} % rechtsb�ndig mit Breitenangabe
\setcounter{secnumdepth}{3}			
\addtokomafont{section}{\normalfont\Large\bfseries\sffamily\color{rwth-blue}}
\addtokomafont{subsection}{\normalfont\large\sffamily\bfseries\color{rwth-blue}}
\addtokomafont{subsubsection}{\normalfont\normalsize\sffamily\bfseries\color{rwth-blue}}
\addtokomafont{paragraph}{\normalfont\large\bfseries\color{rwth-blue}}

% commands
\newcommand{\highlight}[1]{{\color{rwth-blue} \bfseries #1}}

% paper format a4
\iflandscape
	\setlength{\paperwidth}{297mm}
	\setlength{\paperheight}{210mm}
	\setlength{\textwidth}{258mm} %182.5mm
	\setlength{\textheight}{170mm}
\else
	\setlength{\paperwidth}{210mm}
	\setlength{\paperheight}{297mm}
	\setlength{\textwidth}{170mm} %182.5mm
	\setlength{\textheight}{258mm}
\fi
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}
\textblockorigin{0mm}{0mm}
\setlength{\unitlength}{1mm}
\setlength{\oddsidemargin}{20mm}
\addtolength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\topmargin}{-1in}
\setlength{\hoffset}{0mm}
\setlength{\voffset}{0mm}
\setlength{\headsep}{10mm}
\setlength{\parindent}{0mm}
\setlength{\parskip}{0mm}
\setlength{\headheight}{16mm}
\setlength{\footskip}{5mm}

% graphic file exists
\newif\if@GraphicFileExistsTest\@GraphicFileExistsTestfalse
\def\IfGraphicFileExists#1#2#3{%
	\IfFileExists{#1}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.pdf}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.PDF}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.png}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.PNG}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.jpg}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.JPG}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.jpeg}{\@GraphicFileExistsTesttrue}{%
	\IfFileExists{#1.JPEG}{\@GraphicFileExistsTesttrue}{%
		\@GraphicFileExistsTestfalse}}}}}}}}}%
	\if@GraphicFileExistsTest#2\else#3\fi
}

% header and logo
\def\setLogo#1{\gdef\@logo{#1}}\setLogo{}
\def\setPartnerLogo#1{\gdef\@partnerlogo{#1}}\setPartnerLogo{}
\def\setHeader#1{\gdef\@header{#1}}\setHeader{}
\def\setFooter#1{\def\@footer{#1}}

\newlength\logowidth
\def\showHeaderAndLogo{%
	\begin{textblock}{60}[0,0](20,12)
		\noindent%
		{\@header}%
	\end{textblock}
	%
	\IfGraphicFileExists{\@logo}{
		\settowidth\logowidth{\includegraphics[height=16mm]{\@logo}}%
		\iflandscape\def\logoxpos{291}\else\def\logoxpos{205}\fi
		\begin{textblock}{150}[1,1](\logoxpos,32)%
			\flushright\IfGraphicFileExists{\@partnerlogo}{\raisebox{4mm}{\includegraphics[height=24mm]{\@partnerlogo}\hspace*{5mm}}}{}\includegraphics[height=20mm]{\@logo}%
		\end{textblock}
		\vspace*{10mm}
	}{}
}

% page style
\def\@footer{\ifpagenum\hfill\footnotesize\thepage/\pageref{LastPage}\fi}
\def\ps@rwthpage{%
	\def\@oddhead{}
	\def\@evenhead{}
	\def\@oddfoot{\@footer}
	\def\@evenfoot{\@oddfoot}
}
\pagestyle{rwthpage}

% begin document
\AtBeginDocument{%
	\showHeaderAndLogo
}

% end
\endinput

