% rwth-document.cls
%
% Pascal Richter (richter@mathcces.rwth-aachen.de)
% 2014/11/22
%
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{rwth-brochure}[2014/11/22 RWTH Vorlage fuer Broschüren]

% class and all needed packages
\LoadClass[a4paper,twoside,footsepline]{scrartcl}
\RequirePackage{ifthen}[2001/05/26]
\RequirePackage{refcount}[2010/12/01]
\RequirePackage{graphicx}[1999/02/16]
\RequirePackage[absolute]{textpos}[2010/09/30]
\RequirePackage{lastpage}
\RequirePackage[ngerman]{babel}

% options
\PassOptionsToPackage{table}{xcolor}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{rwth-document}}
\ProcessOptions\relax
\RequirePackage{rwth-base}[2013/11/22]

% additional packages
%\RequirePackage[%
%colorlinks,pdfpagelabels,pdfstartview = FitH,bookmarksopen = false,bookmarksnumbered = false,linkcolor = black,plainpages = false,hypertexnames = false,citecolor = black, urlcolor = black] {hyperref}
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
\RequirePackage{etoolbox}
\RequirePackage{pdfpages}
\RequirePackage{subfigure}
\RequirePackage{wrapfig}
\RequirePackage{type1cm}
\RequirePackage{lettrine}
%\RequirePackage[automark, footsepline]{scrlayer-scrpage}
\RequirePackage[automark,footsepline]{scrpage2}
\RequirePackage{pifont}
\RequirePackage{titlesec}
\RequirePackage{multirow}
\RequirePackage[onehalfspacing]{setspace}
\RequirePackage{grffile}

% package settings
\pgfplotsset{compat=1.4}
\usetikzlibrary{calc,shapes,arrows,fadings,decorations.markings,backgrounds}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}} % linksbündig mit Breitenangabe
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}} % zentriert mit Breitenangabe
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}} % rechtsbündig mit Breitenangabe
\setcounter{secnumdepth}{3}			
\addtokomafont{section}{\normalfont\Huge\sffamily\color{black}}
\addtokomafont{subsection}{\normalfont\Large\sffamily\bfseries\color{black}}
\addtokomafont{subsubsection}{\normalfont\large\sffamily\bfseries\color{black}}
\addtokomafont{paragraph}{\normalfont\large\color{black}}


% -----------------------------------------------------------------------------------------------
% commands
\newcommand{\highlight}[1]{{\color{rwth-blue} \bfseries #1}}
\newcommand{\capital}[1]{\lettrine[lines=3]{\color{rwth-blue}#1}{}\enspace}

% paper format a4
\setlength{\paperwidth}{210mm}
\setlength{\paperheight}{297mm}
\setlength{\textwidth}{190mm}
\setlength{\textheight}{233mm}%297-32-32
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}
\setlength{\unitlength}{1mm}
\setlength{\oddsidemargin}{10mm}
\addtolength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\topmargin}{-1in}
\setlength{\hoffset}{0mm}
\setlength{\voffset}{0mm}
\setlength{\headsep}{0mm}
\setlength{\parindent}{0mm}
\setlength{\parskip}{0mm}
\setlength{\headheight}{32mm}
\setlength{\footskip}{20.8mm}

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

% page style
%\setfootsepline{0.5pt}
\clearscrheadfoot
\def\foottext{}
\lefoot{\normalfont\footnotesize{\bfseries\ifnum\thepage<10 0\fi\thepage}\enspace|\enspace\@title\foottext}
\rofoot{\normalfont\footnotesize\@title\foottext\enspace|\enspace{\bfseries\ifnum\thepage<10 0\fi\thepage}}
\pagestyle{scrheadings}


% -----------------------------------------------------------------------------------------------
% Pictures
\newlength\@picShift
\newlength\@piclineWidth
\newlength\@picGap
\newlength\@picOneWidth
\newlength\@picTwoWidth
\newlength\@picThreeWidth
\newlength\@picFourWidth

\newcommand{\picturelineOne}[3][]{%
	\ifthenelse{\equal{#1}{}}{\setlength\@picGap{8pt}}{\setlength\@picGap{#1}}%option
	\setlength\@piclineWidth{#2}
	\setlength\@picShift{-10mm+0.5\paperwidth-0.5\@piclineWidth}
	\setlength\@picOneWidth{\widthof{\includegraphics[height=1cm]{#3}}}%
	\pgfmathparse{(\@piclineWidth-0.1pt)/(\@picOneWidth)}%
	%
	\hspace*{\@picShift}%
	\includegraphics[height=\pgfmathresult cm]{#3}%
	\hspace*{-\textwidth}%
}%

\newcommand{\picturelineTwo}[4][]{%
	\ifthenelse{\equal{#1}{}}{\setlength\@picGap{8pt}}{\setlength\@picGap{#1}}%option
	\setlength\@piclineWidth{#2}
	\setlength\@picShift{-10mm+0.5\paperwidth-0.5\@piclineWidth}
	\setlength\@picOneWidth{\widthof{\includegraphics[height=1cm]{#3}}}%
	\setlength\@picTwoWidth{\widthof{\includegraphics[height=1cm]{#4}}}%
	\pgfmathparse{(\@piclineWidth-\@picGap-0.1pt)/(\@picOneWidth+\@picTwoWidth)}%
	%
	\hspace*{\@picShift}%
	\includegraphics[height=\pgfmathresult cm]{#3}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#4}%
	\hspace*{-\textwidth}%
}%

\newcommand{\picturelineThree}[5][]{%
	\ifthenelse{\equal{#1}{}}{\setlength\@picGap{8pt}}{\setlength\@picGap{#1}}%option
	\setlength\@piclineWidth{#2}
	\setlength\@picShift{-10mm+0.5\paperwidth-0.5\@piclineWidth}
	\setlength\@picOneWidth{\widthof{\includegraphics[height=1cm]{#3}}}%
	\setlength\@picTwoWidth{\widthof{\includegraphics[height=1cm]{#4}}}%
	\setlength\@picThreeWidth{\widthof{\includegraphics[height=1cm]{#5}}}%
	\pgfmathparse{(\@piclineWidth-2\@picGap-0.1pt)/(\@picOneWidth+\@picTwoWidth+\@picThreeWidth)}%
	%
	\hspace*{\@picShift}%
	\includegraphics[height=\pgfmathresult cm]{#3}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#4}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#5}%
	\hspace*{-\textwidth}%
}%

\newcommand{\picturelineFour}[6][]{%
	\ifthenelse{\equal{#1}{}}{\setlength\@picGap{8pt}}{\setlength\@picGap{#1}}%option
	\setlength\@piclineWidth{#2}
	\setlength\@picShift{-10mm+0.5\paperwidth-0.5\@piclineWidth}
	\setlength\@picOneWidth{\widthof{\includegraphics[height=1cm]{#3}}}%
	\setlength\@picTwoWidth{\widthof{\includegraphics[height=1cm]{#4}}}%
	\setlength\@picThreeWidth{\widthof{\includegraphics[height=1cm]{#5}}}%
	\setlength\@picFourWidth{\widthof{\includegraphics[height=1cm]{#6}}}%
	\pgfmathparse{(\@piclineWidth-2\@picGap-0.1pt)/(\@picOneWidth+\@picTwoWidth+\@picThreeWidth+\@picFourWidth)}%
	%
	\hspace*{\@picShift}%
	\includegraphics[height=\pgfmathresult cm]{#3}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#4}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#5}%
	\hspace*{\@picGap}%
	\includegraphics[height=\pgfmathresult cm]{#6}%
	\hspace*{-\textwidth}%
}%

% -----------------------------------------------------------------------------------------------
% Title page
\def\setDate#1{\gdef\@date{#1}}\setDate{~}
\def\setLogo#1{\gdef\@logo{#1}}\setLogo{}
\def\setClaimLogoTop#1{\def\@claimlogotop{#1}}\setClaimLogoTop{}
\def\setClaimLogoBottom#1{\def\@claimlogobottom{#1}}\setClaimLogoBottom{}
\def\backgroundgraphic#1{\def\@backgroundgraphic{#1}}\backgroundgraphic{}
\def\backgroundgraphicText#1{\def\@backgroundgraphicText{#1}}\backgroundgraphicText{}
\newlength\@backgroundgraphicheight\setlength\@backgroundgraphicheight{0pt}

\renewcommand\maketitle{%
	\thispagestyle{empty}
	
	% background graphic
	\textblockorigin{0mm}{0mm}%
	\expandafter\ifstrempty\expandafter{\@backgroundgraphic}{}{%
		\setlength\@backgroundgraphicheight{\heightof{\@backgroundgraphic}}%
		\begin{textblock}{210}[0,0](0,0)%
			\@backgroundgraphic%
		\end{textblock}%
	}%
	%
	% claim
	\IfGraphicFileExists{\@claimlogotop}{
		\textblockorigin{0mm}{0mm}%
		\begin{textblock}{48}[0,0](10,0)%
			\includegraphics[width=48mm]{\@claimlogotop}%
		\end{textblock}%
	}{}%
	%
	% backgroundgraphic Text
	\textblockorigin{0mm}{\@backgroundgraphicheight-5mm}
	\begin{textblock}{145}[1,1](205,0)%
		\flushright{\large\@backgroundgraphicText}%
	\end{textblock}%
	%
	% title
	\textblockorigin{10mm}{\@backgroundgraphicheight+5mm}
	\begin{textblock}{190}[0,0](0,0)%
		\parbox{178mm}{%
			\HUGE \color{rwth-blue} \@title\\%
			\huge \color{black} \@subtitle%
		}%
	\end{textblock}%
	%
	% logo
	\IfGraphicFileExists{\@logo}{%
		\textblockorigin{0mm}{0mm}
		\begin{textblock}{150}[1,1](210,297)%
			\flushright\includegraphics[height=32mm]{\@logo}\hspace*{5mm}
		\end{textblock}%
	}{}%
	~\clearpage
	%
	% empty page
	\thispagestyle{empty}
	~\clearpage
	\setcounter{page}{1}
	\large%
}


% -----------------------------------------------------------------------------------------------
% Section page
\titleformat{\section}{\Huge}{}{0pt}{}
\titleformat{\subsection}{\LARGE}{}{0pt}{}
\newcounter{dingNum}
\newcounter{subseclistentry}
\newcounter{experiencelistentry}\setcounter{experiencelistentry}{0}

\def\setSectionName#1{\gdef\@sectionname{#1}}\setSectionName{}
\def\clearSubsectionList{
	\setcounter{subseclistentry}{0}
	\gdef\subsectionListEntryOne{}
	\gdef\subsectionListEntryTwo{}
	\gdef\subsectionListEntryThree{}
	\gdef\subsectionListEntryFour{}
	\gdef\subsectionListEntryFive{}
	\gdef\subsectionListEntrySix{}
}\clearSubsectionList
\def\addSubsectionEntry#1{
	\stepcounter{subseclistentry}
	\ifcase\value{subseclistentry}
	\or \gdef\subsectionListEntryOne{#1}
	\or \gdef\subsectionListEntryTwo{#1}
	\or \gdef\subsectionListEntryThree{#1}
	\or \gdef\subsectionListEntryFour{#1}
	\or \gdef\subsectionListEntryFive{#1}
	\or \gdef\subsectionListEntrySix{#1}
	\fi
}
\def\getSubsectionEntry#1{
	\ifcase#1
	\or \subsectionListEntryOne
	\or \subsectionListEntryTwo
	\or \subsectionListEntryThree
	\or \subsectionListEntryFour
	\or \subsectionListEntryFive
	\or \subsectionListEntrySix
	\fi
}
\def\setSectionImages#1#2{\gdef\@sectionImageOne{#1}\gdef\@sectionImageTwo{#2}}\setSectionImages{}{}

\def\printSectionPage{
	\def\foottext{}
	\clearpage%
	\ifthenelse{\isodd{\thepage}}{}{~\clearpage}
	\clearpage%
	\def\foottext{\enspace|\enspace\@sectionname}%
	\picturelineTwo[1ex]{\paperwidth}{\@sectionImageOne}{\@sectionImageTwo}%
	\vfill
	\begin{tabular}{m{25mm}m{120mm}}
		\setcounter{dingNum}{182+\value{section}}
		{\color{rwth-orange} \Huge \scalebox{3}{\ding{\value{dingNum}}}}
		& \section{\@sectionname}
		\\ & 
		\ifthenelse{\value{subseclistentry}>0}{%
		\begin{itemize}\LARGE
			\foreach \i in {1,...,\value{subseclistentry}} {
				\item[$\bullet$\hspace*{1ex}]\getSubsectionEntry{\i}
			}
		\end{itemize}}{}
	\end{tabular}
	\vfill
	\clearpage%
}


% -----------------------------------------------------------------------------------------------
% Report
\def\setReportProblemFile#1{\gdef\@reportproblemfile{#1}}\setReportProblemFile{}
\def\setReportFile#1{\gdef\@reportfile{#1}}\setReportFile{}

\newcommand{\printReport}{%
	\addcontentsline{toc}{subsection}{\getSubsectionEntry{1}}%
	\includepdf[pagecommand={\thispagestyle{scrheadings}},pages=1-, width=\textwidth, offset=0pt 20pt, frame=true]{\@reportproblemfile}
	\clearpage%
	\addcontentsline{toc}{subsection}{\getSubsectionEntry{2}}%
	\includepdf[pagecommand={\thispagestyle{scrheadings}},pages=1-, width=\textwidth, offset=0pt 20pt, frame=true]{\@reportfile}
	\clearSubsectionList%
}


% -----------------------------------------------------------------------------------------------
% Experience Report
\def\setReportAuthor#1{\gdef\@reportauthor{#1}}\setReportAuthor{}
\def\setReportTitle#1{\gdef\@reporttitle{#1}}\setReportTitle{}
	
\newcommand{\printExperienceReport}[1]{%
	\clearpage
	\normalfont
	\stepcounter{experiencelistentry}%
	\addcontentsline{toc}{subsection}{\getSubsectionEntry{\value{experiencelistentry}}}%
	\begin{tabular}{m{10mm}m{120mm}}%
		\multirow{2}{*}{%
			\setcounter{dingNum}{171+\value{experiencelistentry}}%
			{\color{rwth-orange} \Huge \scalebox{1.5}{\ding{\value{dingNum}}}}%
		}%
		& \Large \bfseries Erfahrungsbericht \\
		& \Large \bfseries \getSubsectionEntry{\value{experiencelistentry}} \\
	\end{tabular}
	\\[3ex]
	{\Large \bfseries \color{rwth-blue} \@reporttitle}\\
	von \@reportauthor \normalsize
	\\[3ex]
	#1
	\ifthenelse{\value{experiencelistentry}=\value{subseclistentry}}{\clearSubsectionList}{}
}


% -----------------------------------------------------------------------------------------------
% Imprint
\def\setThanksText#1{\gdef\@thankstext{#1}}\setThanksText{~}
\def\setThanksLogos#1{\gdef\@thankslogos{#1}}\setThanksLogos{~}
\def\setImprintText#1{\gdef\@imprinttext{#1}}\setImprintText{
{\bfseries Impressum}\\
	\@title\enspace|\enspace RWTH Aachen\\
	\@date\\[1em]
	Herausgeber:\\
	Professor Dr. Martin Frank\\
	Schinkelstr. 2\\
	52062 Aachen\\
	Telefon: +49 241 80-98661\\
	Telefax: +49 241 80-92600\\
	frank@mathcces.rwth-aachen.de\\
	http://www.cammp.rwth-aachen.de
}

\newcommand{\drawImprint}{%
	% thanks page left
	\parbox{0.35\textwidth}{\@thankstext}
	\clearpage%
	%
	% thanks page right
	\centering\@thankslogos%
	\clearpage%
	%
	% free pages
	\pgfmathparse{int(4-mod(\thepage,4))}
	\ifthenelse{\pgfmathresult=1}{~\clearpage}{}
	\ifthenelse{\pgfmathresult=2}{~\clearpage~\clearpage}{}
	\ifthenelse{\pgfmathresult=3}{~\clearpage~\clearpage~\clearpage}{}
	%
	% impressum page (odd)
	\setSectionName{Impressum}
	~\vfill\flushright\parbox{0.8\textwidth}{\small\@imprinttext}
	\clearpage
	%
	% free page (odd)
	\def\foottext{}
	\pagestyle{empty}
	~\clearpage
	%
	% claim page (even)
	\IfGraphicFileExists{\@claimlogobottom}{
		\textblockorigin{0mm}{297mm}%
		\begin{textblock}{48}[0,1](10,0)%
			\includegraphics[width=48mm]{\@claimlogobottom}%
		\end{textblock}%
	}{}%
}


% end
\endinput