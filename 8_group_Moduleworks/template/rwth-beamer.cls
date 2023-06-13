% rwth-beamer.cls
%
% Pascal Richter (richter@mathcces.rwth-aachen.de)
% 2014/11/22
%
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{rwth-beamer}[2014/11/22 RWTH Vorlage fuer Beamer Vortraege]

% class and all needed packages
\PassOptionsToClass{xcolor=table}{beamer}
\LoadClass{beamer}
\RequirePackage{ifthen}[2001/05/26]
\RequirePackage{graphicx}[1999/02/16]

% options
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{rwth-base}}
\ProcessOptions\relax
\RequirePackage{rwth-base}[2013/11/22]

% additional packages
\RequirePackage{ae}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage[utf8]{inputenc}
\RequirePackage{xcolor}
\RequirePackage{tabularx}
\RequirePackage[T1]{fontenc}
\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage{pgfplots}
\RequirePackage{tikz}
\RequirePackage[framemethod=tikz]{mdframed}
\RequirePackage{fix-cm}

% package settings
\pgfplotsset{compat=1.4}
\usetikzlibrary{calc,shapes,arrows,fadings,decorations.markings,backgrounds}

% -----------------------------------------------------------------------------------------------
% switch off navigation symbols
\beamertemplatenavigationsymbolsempty

% switch on half transparent preview
%\setbeamercovered{transparent}

% -----------------------------------------------------------------------------------------------
% Set color theme
\usecolortheme{orchid}
\definecolor{darkgreen}{HTML}{6CB540}
%
\definecolor{maincolor}{named}{rwth-blue}
\definecolor{subcolor}{named}{rwth-lblue}
\definecolor{textcolor}{named}{black}
%
\setbeamercolor{structure}{fg=maincolor}
\setbeamercolor{normal text}{fg=textcolor}
\setbeamercolor{section in head/foot}{bg=orange,fg=white}
\setbeamercolor{block title}{bg=maincolor,fg=white}
\setbeamercolor{block title example}{bg=rwth-teal,fg=white}
%\setbeamercolor{block title alert}{bg=rwth-orange,fg=white}


% -----------------------------------------------------------------------------------------------
% Set inner theme
\useinnertheme{rounded}
\setbeamertemplate{items}[circle]
\setbeamertemplate{sections/subsections in toc}[circle]  % default, square, ball, circle

% -----------------------------------------------------------------------------------------------
% Title logo
\def\@backgroundgraphic{}
\gdef\backgroundgraphic#1{\gdef\@backgroundgraphic{#1}}

% -----------------------------------------------------------------------------------------------
% Set footline (left)
\define@key{footlineleft}{height}{\gdef\@footlineleftheight{#1}}
\define@key{footlineleft}{bgcolor}{\gdef\@footlineleftbgcolor{#1}}
\define@key{footlineleft}{fgcolor}{\gdef\@footlineleftfgcolor{#1}}
\newlength\footerleftwidth

\newcommand\footlineleft[2][]{ % #1 keys   #2 content
	\setkeys{footlineleft}{#1}
	\setbeamercolor{left foot}{bg=\@footlineleftbgcolor, fg=\@footlineleftfgcolor}
	\gdef\@footlineleftcontent{#2}
}
\footlineleft[height=1em, bgcolor=white, fgcolor=textcolor]{\inserttitlegraphic}

% -----------------------------------------------------------------------------------------------
% Set footline (right)
\define@key{footlineright}{width}{\gdef\@footlinerightwidth{#1}}
\define@key{footlineright}{height}{\gdef\@footlinerightheight{#1}}
\define@key{footlineright}{bgcolor}{\gdef\@footlinerightbgcolor{#1}}
\define@key{footlineright}{fgcolor}{\gdef\@footlinerightfgcolor{#1}}
\newlength\footerrightwidth

\newcommand\footline[2][]{ % #1 keys   #2 content
	\setkeys{footlineright}{#1}
	\setbeamercolor{right foot}{bg=\@footlinerightbgcolor, fg=\@footlinerightfgcolor}
	\gdef\@footlinerightcontent{#2}
}
\footline[height=1em, bgcolor=maincolor, fgcolor=white]{\insertshortauthor\enspace|\enspace\insertshorttitle}

% -----------------------------------------------------------------------------------------------
% Set footline
\setbeamertemplate{footline}{%
	\hbox{%
	\begin{beamercolorbox}[wd=\footerleftwidth,ht=\@footlineleftheight,dp=1ex,center]{left foot}%
			\@footlineleftcontent%
	\end{beamercolorbox}%
	\begin{beamercolorbox}[wd=\footerrightwidth,ht=\@footlinerightheight,dp=1ex,left, leftskip=3ex, rightskip=2ex]{right foot}%
		\@footlinerightcontent\hspace{0pt plus 1 filll} |\parbox{4.5em}{\centering\insertframenumber/\inserttotalframenumber}%
	\end{beamercolorbox}%
	}%
}

% -----------------------------------------------------------------------------------------------
% Title page
\setbeamercolor{title foot}{bg=white,fg=black}

\newlength\@titlegraphicwidth
\newlength\@titlegraphicheight
\renewcommand\maketitle{%
	\expandafter\ifstrempty\expandafter{\@backgroundgraphic}{
		\begin{frame}
			\titlepage
		\end{frame}
	}{%
	\usebackgroundtemplate{\@backgroundgraphic}
	\begin{frame}[plain]%
		\vspace{0.6625\paperheight}%0.0175
		%
		\normalsize
		\setlength\@titlegraphicwidth{\widthof{\inserttitlegraphic}}
		\setlength\@titlegraphicheight{\maxof{\heightof{\inserttitlegraphic}}{\heightof{\vbox{\insertdate}}}}
		%
		\begin{beamercolorbox}[wd=\paperwidth,ht=0.32\paperheight,dp=1ex,leftskip=2ex, rightskip=2ex]{title foot}%
			\parbox[b][0.32\paperheight-\@titlegraphicheight-1ex][t]{\paperwidth-2ex-2ex}{%
				{\usebeamerfont{title}{\color{maincolor}\bfseries\inserttitle}}
				\vfill \normalsize\insertauthor\small \\ \insertinstitute
			}\\%
			\parbox[b][\@titlegraphicheight][t]{\paperwidth-2ex-2ex-\@titlegraphicwidth}{%
				\vfill \small \insertdate~
			}%
			\parbox[b][\@titlegraphicheight][t]{\@titlegraphicwidth}{%
				\normalsize \vfill \inserttitlegraphic
			}%
		\end{beamercolorbox}%
	\end{frame}
	\usebackgroundtemplate{}
	}
}

\newlength\footerimageheight\setlength\footerimageheight{30mm}
\def\imageframe#1#2#3{%
	\normalsize
	\setlength\@titlegraphicwidth{\widthof{\inserttitlegraphic}}
	\setlength\@titlegraphicheight{\maxof{\heightof{\inserttitlegraphic}}{\heightof{\vbox{\insertdate}}}}
	%
	\begin{frame}[plain]%
		\begin{beamercolorbox}[wd=\paperwidth,ht=\paperheight,dp=1ex,leftskip=2ex, rightskip=2ex]{title foot}%
			% title
			\parbox[b][\@titlegraphicheight+1ex][t]{\paperwidth-2ex-2ex-4ex-\@titlegraphicwidth}{\normalsize\color{maincolor}\Large\bfseries~\\#1}%
			\parbox[b][\@titlegraphicheight+1ex][t]{4ex}{~}%
			\parbox[b][\@titlegraphicheight+1ex][t]{\@titlegraphicwidth}{\normalsize\vfill\inserttitlegraphic}%
			\\%
			% text
			\parbox[t][\paperheight-\@titlegraphicheight-1ex-3ex-\footerimageheight][t]{\paperwidth-2ex-2ex}{\vfill#2\vfill}%~\\[-1em]#2}%
			\\%
			% images
			\hspace*{-2ex}\parbox[b][\footerimageheight][t]{\paperwidth}{\vfill#3}%
		\end{beamercolorbox}%
	\end{frame}
}


% -----------------------------------------------------------------------------------------------
% Begin document
\AtBeginDocument{
	% titlegraphic
	\settowidth\footerleftwidth{\tiny\inserttitlegraphic\hspace*{0.025\paperwidth}}%
	\setlength{\footerrightwidth}{\paperwidth-\footerleftwidth}%
}


% -----------------------------------------------------------------------------------------------
% END
\endinput
