% rwth-letter.cls
%
% Pascal Richter (richter@mathcces.rwth-aachen.de)
% 2014/11/22
% Modification of the RWTH Corporate Design version (Jens Dodenhoff)
%
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{rwth-letter}[2013/11/22 RWTH Briefvorlage]

% class and all needed packages
\LoadClass[a4paper,twoside]{scrartcl}
\RequirePackage{afterpage}[1995/10/27]
\RequirePackage{ifthen}[2001/05/26]
\RequirePackage{refcount}[2010/12/01]
\RequirePackage{graphicx}[1999/02/16]
\RequirePackage[absolute]{textpos}[2010/09/30]
\RequirePackage{lastpage}

% options
\newif\ifgerman\germantrue
\newif\ifenglish\englishfalse
\newif\iffoldmarks\foldmarksfalse
\newif\ifattached\attachedfalse
\DeclareOption{german}{\englishfalse\germantrue}
\DeclareOption{english}{\englishtrue\germanfalse}
\DeclareOption{foldmarks}{\foldmarkstrue}
\DeclareOption{list}{\attachedtrue}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{rwth-base}}
\ProcessOptions\relax
\RequirePackage{rwth-base}[2013/11/22]

% parameter
\newread\myread
\newcounter{linecnt}
\newcounter{konten}\setcounter{konten}{0}
\newcounter{attCount}\setcounter{attCount}{0}

% paper format a4
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}
\textblockorigin{0mm}{0mm}
\setlength{\unitlength}{1mm}
\setlength{\oddsidemargin}{20mm}
\addtolength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\textwidth}{172.5mm}
\setlength{\paperwidth}{210mm}
\setlength{\paperheight}{297mm}
\setlength{\topmargin}{-1in}
\setlength{\hoffset}{0mm}
\setlength{\voffset}{0mm}
\setlength{\headsep}{0mm}
\setlength{\parindent}{0mm}
\setlength{\parskip}{0mm}

% pagestyle
\def\pagelabel{\footnotesize\thepage/\pageref{LastPage}}
\def\ps@rwthpage{%
\setlength{\textheight}{248mm}%
\setlength{\headheight}{96mm}% dies plus topmargin sind 96mm vom oberen seitenrand, obere Rand der Betreffzeile
\setlength{\footskip}{5mm}% dies sollte auf 13mm abstand vom unteren seitenrand bedeuten
\def\@oddfoot{\hfill\pagelabel}
\def\@evenfoot{\@oddfoot}}

% footer
\def\footer{%
	\setcounter{linecnt}{0}
	% tax
\iftrue
	\begin{textblock}{44}[0,1](20,284)%
		\noindent
		\raggedright\footnotesize\getUStIdText\newline\getUStId\newline\hfill%
		\newline\getSteuerText\newline\getSteuerNummer\newline%
	\end{textblock}%
	\begingroup%
	\makeatletter%
	\setcounter{linecnt}{21}%
	\openin\myread=\jobname.acc
	\@whilesw\unless\ifeof\myread\fi{%
		\addtocounter{linecnt}{45}%
		\read\myread to \command%
		\ifnum\value{linecnt}<175
			\begin{textblock}{44}[0,1](\thelinecnt,284)%
				\command%
			\end{textblock}%
		\fi%
	}%
	\closein\myread%
	\if@filesw
		\expandafter\newwrite\csname tf@acc\endcsname%
		\immediate\openout \csname tf@acc\endcsname \jobname.acc\relax%
	\fi%
	\@nobreakfalse
	\endgroup%
\fi
}

% constant text
\def\RWTHPAGE{rwth-aachen.de}
\def\getPhonePrefix{+49~241~80}
\def\getBank{Sparkasse~Aachen}
\def\getBIN{390~500~00}
\def\getIBAN{DE34~3905~0000~0000~0145~22}
\def\getSWIFT{AACSDE33XXX}
\def\getUStId{DE~121~689~807}
\def\getSteuerNummer{201/5930/5005}

% language-dependent text
\ifgerman
	\RequirePackage[ngerman]{babel}
	\def\getUStIdText{USt-Identifikationsnummer}%
	\def\getSteuerText{Steuernummer}%
	\def\getKontoText{Konto}%
	\def\getBLZText{BLZ}%
	\def\getBuildText{Geb\"{a}ude}%
	\def\getRoomText{Raum~Nr.}%
	\def\getFloorText{Geschoss}%
	\def\getPhoneText{Telefon:}%
	\def\getMobileText{Mobil:\hspace{1.5ex}}%
	\def\getFaxText{Fax:\hspace{3ex}}%
	\def\getSignatureText{Mein Zeichen:}%
	\def\getInvoiceNumberText{Rechnungsnummer:}%
	\def\getAnlagenText{Anlagen}%
	\def\getmfgText{Mit freundlichen Gr\"{u}\ss en}%
	\def\getSubjectText{Kein Betreff}%
	\def\getSalutation{Sehr geehrte Damen und Herren,}
\fi
\ifenglish
	\RequirePackage[english]{babel}
	\def\getUStIdText{VAT Identification Number}%
	\def\getSteuerText{Tax Number}%
	\def\getKontoText{Account}%
	\def\getBLZText{BIN}%
	\def\getBuildText{Building}%
	\def\getRoomText{Room}%
	\def\getFloorText{Floor}%
	\def\getPhoneText{Phone:\hspace{0.5ex}}%
	\def\getMobileText{Cell:\hspace{2.8ex}}%
	\def\getFaxText{Fax:\hspace{3ex}}%
	\def\getSignatureText{Signature:}%
	\def\getInvoiceNumberText{Invoice number:}%
	\def\getAnlagenText{Attachment}%
	\def\getmfgText{Kind regards}%
	\def\getSubjectText{No subject}%
	\def\getSalutation{Dear Sir or Madam:}
\fi
\def\getSWIFTText{SWIFT-BIC}%
\def\getIBANText{IBAN}%

% adress
\def\layoutAdress#1#2#3#4#5#6#7#8#9{\noindent#1\newline%
	\noindent#2\newline%
\noindent#3\newline%
\noindent#4~#5\ifthenelse{\equal{#6}{\empty}}{}{,~\getBuildText~#6}\newline%
\noindent#7~#8\newline%
\noindent{#9}%\MakeUppercase{#9}
}

% sidepanel
\def\sidepanel{%
	\begin{textblock}{60}[1,0](202.5,36)%
		\raggedright\small\noindent%
		\textbf\getDeanFullName\newline%
		\getInstituteName
		\\[1ex]%
		\ifthenelse{\equal{\getSenderName}{~}}{}{\textbf\getSenderFullName\newline%
		\getPositionName\\[1ex]}%
		\getSenderStreet~\getSenderHNo\ifthenelse{\equal{\getSenderBuildNo}{\empty}}{}{,~		\getBuildText~\getSenderBuildNo}\newline%
		\getSenderPostcode~\getSenderCity\newline%
		\MakeUppercase{\getSenderCountry}%
		\\[1ex]%
		\getPhoneText\quad\getPhone\newline%
		\getFaxText\quad\getFax%
		\ifthenelse{\equal{\getMobile}{\empty}}{}{\newline\getMobileText\quad\getMobile}%
		\\[1ex]%
		\getEMail\newline%
		\getWebsite%
		\\[1ex]%
		\ifthenelse{\equal{\getInvoiceNumber}{\empty}}{}{\getInvoiceNumberText~\getInvoiceNumber\\[1ex]}%
		\textbf{\getDate}%
	\end{textblock}
}

% konto
	\def\kontoblock#1#2#3#4#5#6{%
	\raggedright\hfill\newline\hfill\newline\footnotesize#1\hfill\newline#2\hfill\newline%
	\getKontoText~#3\newline\getBLZText~#4\newline\getSWIFTText:~#5\newline%
	\getIBANText:~#6%
}

% anlagen
\def\getAnlagen{%
	\ifnum\value{attCount}>0%
		\getAnlagenText~\theattCount\ifattached\begingroup\makeatletter
		\begin{itemize}\def\labelitemi{\empty}
			\setcounter{linecnt}{0}
			\openin\myread=\jobname.att
			\@whilesw\unless\ifeof\myread\fi{%
				\stepcounter{linecnt}
				\read\myread to \command%
				\item \command
			}%
			\closein\myread%
		\ifnum\value{linecnt}=0\item \hfill\fi%
		\end{itemize}
		\vspace{-\baselineskip}%
	\fi
	\if@filesw
		\expandafter\newwrite\csname tf@att\endcsname%
		\immediate\openout \csname tf@att\endcsname \jobname.att\relax%
	\fi%
	\@nobreakfalse
\endgroup\fi}
\def\attach#1{\stepcounter{attCount}\addtocontents{att}{\protect #1}}

% functions
\def\setLogo#1{\def\getLogo{#1}}\setLogo{logo/logo.png}
\def\setInstituteName#1{\def\getInstituteName{#1}}\setInstituteName{}
\def\setPositionName#1{\def\getPositionName{#1}}\setPositionName{}
\def\setSender#1#2#3#4#5#6#7#8{
	\def\getWWW{www\ifthenelse{\equal{#1}{\empty}}{}{.\MakeLowercase{#1}}.\RWTHPAGE}
	\def\getSenderKurz{#1}
	\def\getSenderStreet{#2}
	\def\getSenderHNo{#3}
	\def\getSenderBuildNo{#4}
	\def\getSenderCity{#6}
	\def\getSenderPostcode{#5}
	\def\getSenderCountry{\MakeUppercase{#7}}
	\def\getSenderKennziffer{#8}
	}\setSender{}{}{}{}{}{}{}{}
\def\setDeanName#1#2#3{
	\def\getDeanName{#2~#3}%
	\def\getDeanFullName{\ifthenelse{\equal{#1}{\empty}}{}{#1~}\ifthenelse{\equal{#2}{\empty}}{}{#2~}#3}%
		}\setDeanName{}{}{}
\def\setSenderName#1#2#3{
		\def\getSenderName{#2~#3}%
		\def\getSenderFullName{\ifthenelse{\equal{#1}{\empty}}{}{#1~}\ifthenelse{\equal{#2}{\empty}}{}{#2~}#3}%
		}\setSenderName{}{}{}
\def\setFloorNo#1{\def\getFloorNo{#1}}\setFloorNo{\empty}
\def\setRoomNo#1{\def\getRoomNo{#1}}\setRoomNo{\empty}
\def\setPhoneTail#1#2{}\renewcommand{\setPhoneTail}[2][\getPhonePrefix]{\def\getPhone{#1-#2}}\setPhoneTail{1}
\def\setFaxTail#1#2{}\renewcommand{\setFaxTail}[2][\getPhonePrefix]{\def\getFax{#1-#2}}\setFaxTail{92312}
\def\setMobile#1{\def\getMobile{#1}}\setMobile{\empty}
\def\setEMail#1#2{}\renewcommand{\setEMail}[2][\getSenderKurz]{\def\getEMail{#2}}
\def\setWebsite#1{\def\getWebsite{#1}}\setWebsite{}
\def\leadingzero#1{\expandafter\ifnum#1<10 0#1\else #1\fi}
\def\setDate#1#2#3{\def\getDate{{\leadingzero{\number#3}.\leadingzero{\number#2}.\number#1}}}\setDate{\year}{\month}{\day}
\def\setInvoiceNumber#1{\def\getInvoiceNumber{#1}}\setInvoiceNumber{\empty}
\def\setKonto#1#2#3#4#5#6{\addtocontents{acc}{\protect\kontoblock{#1}{#2}{#3}{#4}{#5}{#6}}}
\def\setAdress#1#2#3#4#5#6#7#8#9{
	\def\getHonorific{#1}
	\def\getFirm{#2}
	\def\getContact{#3}
	\def\getStreet{#4}
	\def\getHNo{#5}
	\def\getBuildNo{#6}
	\def\getPostcode{#7}
	\def\getCity{#8}
	\def\getCountry{#9}
	}\setAdress{}{}{}{}{}{}{}{}{}	
\def\setSubject#1{\def\getSubject{\begin{flushleft}\noindent\textbf{#1}\newline\hfill\newline\hfill\end{flushleft}}}\setSubject{\getSubjectText}
\def\mfg#1{%
	\raggedright\noindent\newline\getmfgText\hfill\newline\hfill\\[2em]%
	\ifthenelse{\equal{#1}{\empty}}{\ifthenelse{\equal{\getSenderName}{~}}{\getDeanName}{\getSenderName}}{#1}%
	\vfill\noindent\getAnlagen%
}
\def\anrede#1{%
	{\flushleft{\ifthenelse{\equal{#1}{\empty}}{\getSalutation}{#1}\\  \hfill \newline}}
}
\def\attach#1{\stepcounter{attCount}\addtocontents{att}{\protect #1}}

% layout
\pagestyle{rwthpage}
\AtBeginDocument{%
	% logo
	\begin{textblock}{1}[0,0](137.3,4)%
		\noindent\blue[25]{\vrule width 1pt height 80mm }
	\end{textblock}
	\begin{textblock}{150}[1,1](207.5,36)%
		\noindent\flushright\noindent%
		\includegraphics[height=32mm]{\getLogo}% logos kommen mit 32mm hoehe
	\end{textblock}
	% sidepanel
	\sidepanel
	% footer
%	\footer
	% windowpanel
	\begin{textblock}{85}[0,0](20,45)\raggedright\noindent{\scriptsize\blue{{\bfseries\getSenderKurz}~~\textbar~~\getSenderStreet~~\getSenderHNo~~\textbar~~\getSenderPostcode~~\getSenderCity~~\textbar~~\getSenderCountry} \hfill  \getSenderKennziffer}\newline\hfill\newline%
		\layoutAdress{\getHonorific}{\getFirm}{\getContact}{\getStreet}{\getHNo}{\getBuildNo}{\getPostcode}{\getCity}{\getCountry}	
	\end{textblock}
	% foldmarks
	\iffoldmarks
		\begin{textblock}{10}[0,0](0,105)\noindent\blue[50]{\rule{7mm}{1pt}\hfill}\end{textblock}%
		\begin{textblock}{10}[0,0](0,148.5)\noindent\blue[50]{\rule{7mm}{1pt}\hfill}\end{textblock}%
		\begin{textblock}{10}[0,0](0,210)\noindent\blue[50]{\rule{7mm}{1pt}\hfill}\end{textblock}%
	\fi
	% page label
	\begin{textblock}{7}[1,1](202.5,289)%
		\flushright\pagelabel%
	\end{textblock}%
	\enlargethispage{-88mm}
	% subject
	\getSubject%
	\ifthenelse{\equal{\getpagerefnumber{LastPage}}{1}}{\empty}{%
		\afterpage{\global\setlength{\headheight}{36mm}}%
	}%
}%