% !TXS template
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2014/10/22 Wget's default template document class]

% This document needs to be compiled with xelatex or lualatex. In this regard, all UTF-8 packages emulation have been removed.
% Compilation:
% $ xelatex <your tex filename.tex>
% $ biber <your tex filename without extension>
% $ xelatex <your tex filename>
% $ xelatex <your tex filename>
% $ <your pdf reader> <your tex filename.pdf>
% You can use lualatex instead of xetex

% As a reminder: the only difference between article and report is that article has no chapter statement.
% Do not use \documentclass{report}, because \documentclass should only ever be called once at the very beginning of your LaTeX document. Book does provide single sided and double sided page options.
%\define@boolkey{template}{doubleside}{%
%    \ifKV@template@doubleside %we continue
%
%    \else %we stop here
%        \LoadClass{book}
%    \fi
%}
%\DeclareOption{doublesided}{%
%    \PassOptionsToClass{twoside}{report}%
%}
%
%\RequirePackage{xkeyval}
%\define@key{doublesided}{true}{twoside}
%
%
%\define@key{doublesided}{false}{}
%
%\newcommand\doublesided[1][true]{%
%    \PassOptionsToClass{\setkeys{doublesided}{\noexpand{#1}}}{report}%
%}
%\newif\if#1
%\ifdoublesided
%    \PassOptionsToClass{twoside}{report}%
%\fi



%\ProcessOptions

\LoadClass[twoside]{report}


% Default French is frenchb, francais is Parisian French.
%\RequirePackage[frenchb]{babel}
\RequirePackage[french]{babel}

% Allow to have accentuated characters with XeLaTeX and LuaLaTeX. If you use polyglossia, you can remove fontspec since polyglossia already loads that package.
\RequirePackage{fontspec}

% Use special characters like a right oriented triangle. These are present in the fonts from the American Mathematical Society.
\RequirePackage{amssymb}

% Polyglossia should be used when XeTeX/LuaTeX is used, but polyglossia has no option to disable shortlands and spaces brought by French. This is annoying when you need to write an IPv6 address or simply hours. Forcing the section to another language which allows to disable shorthands does not work either. Do not use polyglossia until a fix is released.
%\usepackage{polyglossia}
%\setdefaultlanguage{french}
%\setotherlanguage[babelshorthands=false]{dutch}

% margin=2cm can be replaced with top=2cm, bottom=2cm, left=2cm, right=2cm. This is useful if you want to redifine each margin separately.
\RequirePackage[margin=2cm]{geometry}

% The default line spacing factor is 1. 1.3 which corresponds to one and a half line spacing, specify it a bit less.
\linespread{1.2}

% Do not ask to adapt paragraph vertical spaces to make all page content of the same hight.
\raggedbottom

% Add a dot after title numbers (chapters and sections and in table of contents).
\RequirePackage{titlesec}
%\titlelabel{\thetitle.\quad}

\makeatletter
% Force trailing dot to appear in table of content and (sub) sections numbering scheme when chapters are used. If we define the dot in the 'thesection' condition below and we are not using sections, the chapter number will not be suffixed by a dot. If we replace the class to article, as chapters do not exist add a condition.
\ifdefined \thechapter
    \renewcommand{\thechapter}{\arabic{chapter}.}
\fi

% Remove double dot in figure caption numbering.
\renewcommand\thefigure{\thesection\arabic{figure}}

% Force it in appendixes too.
\renewcommand{\appendix}{\gdef\thechapter{\@Alph\c@chapter.}}

% When no chapter are used, avoid to have section titles beginning with zeroes. This condition breaks if you use 'article' since chapter is not defined is that class.
\renewcommand{\thesection}{%
    \ifnum\c@chapter<1 \arabic{section}.%
    \else \thechapter\arabic{section}.%
    \fi
}
% Remove heading dot defined when writing a subsection and force a trailing dot dot to appear in subsection numbering scheme and table of content.
\renewcommand{\thesubsection}{\thesection\@arabic\c@subsection.}
\makeatother

% Define style for chapters
\makeatletter
\def\thickhrulefill{\leavevmode \leaders \hrule height 1.2ex \hfill \kern \z@}
\def\@makechapterhead#1{
    \vspace*{10\p@}%
    {\parindent \z@ \centering \reset@font
        \thickhrulefill\quad
        \scshape\bfseries\textit{\@chapapp{}  \thechapter}
        \quad \thickhrulefill
        \par\nobreak
        \vspace*{10\p@}%
        \interlinepenalty\@M
        \hrule
        \vspace*{10\p@}%
        \Huge \bfseries #1 \par\nobreak
        \par
        \vspace*{10\p@}%
        \hrule
        \vskip 25\p@
    }
}

% Disable the default alineas and add a space between all paragraphs. Do not try to change the values of \parskip and \parindent using \setlength{} because this will change the table of contents and footnotes spacing. Using the parskip package has already all the logic to avoid such alteration.
\RequirePackage{parskip}

% Use listing for raw data and code recognition, and wrap lines by default.
\RequirePackage{listings}
\lstset{
    basicstyle=\normalsize\ttfamily,
    frame=single,
    columns=flexible,
    breaklines=true,
    % Sets default tabsize to 4 spaces
    tabsize=4
}

% Add underlines below section titles. Don't try to get rid of titlesec. Otherwise we will need to use \hrule instead. While it is a LaTeX primitive, the syntax is completely different from \titlerule. titlesec takes care of the following issue: making sure the rule which creates a new paragraph will not move into the next page, and avoid to make it indented.
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}[{\titlerule[0.8pt]}]
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{1em}{}[{\titlerule[0.8pt]}]

\RequirePackage{epigraph}
\setlength{\epigraphwidth}{0.5\paperwidth}

\RequirePackage{datetime}
\newdateformat{ddFullMonthyyyy}{\THEDAY \monthname[\THEMONTH] \THEYEAR}
% Using the hh:mm:ss format does not take seconds into account. They seem to remain at 00.
%\settimeformat{hhmmsstime}

% Define a counter for last year at the time of the document compilation
\newcounter{lastYear}
\setcounter{lastYear}{\year}
\addtocounter{lastYear}{-1}

% Define headers and footers
\RequirePackage{fancyhdr}

% Define a style for the title page
\fancypagestyle{titlepagestyle}{
    \rfoot{Page \thepage\ de \pageref{lastPage}}
}

% Since commands like chapter (which is used in the table of content too) automatically switch to the plain style, we need to redefine it. See the section 7. of the fancyhdr manpages.
\fancypagestyle{plain}{
    \lhead{School year \thelastYear-\the\year}
    \chead{Document name}
    \rhead{Author name \textsc{Lastname}}
    
    % As babel is used in French here, and as in French colon are preceded by a space, babel adds a space even in hours. Use \NoAutoSpacing to avoid that.
    \lfoot{\NoAutoSpacing\today~\currenttime}
    \fancyfoot[LO,RE]{\today~\currenttime}
    \fancyfoot[CO,CE]{Center footer}
    
    % You can use a \ref{lastPage} at the end of the document avoiding the need of the lastpage package.
    \fancyfoot[RO,LE]{Page \thepage\ de \pageref{lastPage}}

    % Redefine height of header and footer lines.
    \renewcommand{\headrulewidth}{0.4pt}
    \renewcommand{\footrulewidth}{0.4pt}
}
\pagestyle{plain}

% Use BibLaTeX as the bibliography system
\RequirePackage[backend=biber,sorting=none,alldates=short]{biblatex}
\addbibresource{references.bib}

% Use quotes adapted to the language used, otherwise it fallbacks to American English quotes. This is a requirement for biblatex and in order to use the \enquote{text} command.
\RequirePackage{csquotes}

% Add the ability to have tables. Compared to tabular, tabu has a new column specifier like X (in uppercase) which streches columns to make the table as wide as specified, greatly simplifying the creation of tables. tabu is a rewrite merging and extending features from tabularx and longtable. The latter still needs to be sourced first though.
\RequirePackage{longtable}
\RequirePackage{tabu}
% Add extra space for proper alignement between table rows
\tabulinesep = 3pt

% The "to \textwidth" expression is similar to the first argument passed to tabularx environment. However, in this case, according to the tabu manual, it should speed up the algorithm convergence.
\newenvironment{keyvalue}
{%
    \newcommand{\x}{\\[0.5\normalbaselineskip]}%
    \begin{longtabu} to \textwidth {X@{ : }X}%
    % Prevent the column and table widths to be discarded when there are only multicolumns in the table. Since this adds a new line, the colon we have manually defined is displayed too.
    \tabuphantomline
}
{\end{longtabu}}

% Replace standard plain LaTeX rules in tables by rules with correct space between rows. While vertical lines in tables are not supported by this package, these are not breaking the layout, except they are not completely crossing horizontal rules.
\RequirePackage{booktabs}

% Add the ability for LaTeX to import and manage graphics directly.
\RequirePackage{graphicx}

% Add the ability to insert a figure at the exact location in the LaTeX code.
\RequirePackage{float}

% Allow to adjust via boxes and add options to the \includegraphics command. The export parameter exports most keys of \adjustbox to \includegraphics. Cannot be included below menukeys, otherwise, the compilation fails.
\RequirePackage[export]{adjustbox}
\newcommand\icon[1]{%
    % \fontcharht calculates the height of the font letter defined with the \font command. That command is followed by the character, prefixed by a quote escape sequence, whose height will be computed. Change X to any other letter to change the height. \fontcharht comes from eTeX, but the XeTeX engine understands it. valign is an option from adjustbox to align to the bottom of the line keeping the line height in mind.
    \includegraphics[valign=b,height=\fontcharht\font`X]{#1}
}

% Add support for special keystrokes and paths.
\RequirePackage{menukeys}

% Allow to have optional named arguments with a key=value style and removes the limit of 9 args.
% Key values like author=\textit{Me} used as options passed to classes are not allowed by the LaTeX default kernel. The expression \textit{Me} will not be processed. To allow such a syntax, xkeyval includes xkvltxp. Loading this package before loading the class or package which uses xkeyval for option processing will allow class and package options to contain expandable macros.
\RequirePackage{xkeyval}

\AtBeginDocument{%
    % Use bullets in lists instead of large dashes. Must be inside the document scope to work.
    \renewcommand{\labelitemi}{\textbullet}

    % Redefine the title commmand

    % makeatletter and makeatother are unneeded in class files.
    %\makeatletter

    % Restrict the commands to the internals of this class file.
    \def\@maintitle{}
    \def\@subtitle{}
    \def\@author{}

    \define@key{title}{maintitle}{%
        \def\@maintitle{%
            \hrule%
            \vspace{0.4cm}
            % We always need to define \par in scope for a font size change, otherwise, if the title is ever longer than a line, it will wrap to the next line with huge characters on a normal baseline.
            {\Huge\textbf{#1}\par}%
            \vspace{0.4cm}%
            \hrule
        }%
    }
    \define@key{title}{subtitle}{%
        \def\@subtitle{%
            \vspace{1.5cm}
            {\Large{#1}\par}%
        }%
    }
    \define@key{title}{author}{%
        \def\@author{%
            {\emph{Author: #1}\par}%
        }%
    }

    % The outer bracket is the renewcommand syntax, the inner one is a group definition avoiding \@author to leak out and be the default in later uses.
    \renewcommand{\title}[2][]{{%
        \setkeys{title}{#1}
        \begin{titlepage}
            \begin{center}
                \renewcommand{\hrule}{\rule{\linewidth}{1mm}}
                \@maintitle
                \@subtitle
                \vfill%
                \@author
            \end{center}
        \end{titlepage}%
    }}

}

% Used to count the number of page.
\AtEndDocument{\label{lastPage}}

% Add extra support for links. Since its job basically consists in redefining many LaTeX commands, this package needs to be the last loaded to avoid being over-written. If you have footnotes with urls having special characters like #, you must escape them with \.
\RequirePackage{hyperref}

% For debug purpose. Only needed if you want to print the layout with \layout inside the document environment scope.
%\usepackage{layout}

% For debug purpose. Show all packages (+version) used in your document.
%\listfiles
