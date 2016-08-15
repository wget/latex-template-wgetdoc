% !TEX encoding = UTF-8
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
% The date is mandatory next to our own class title, otherwise we get the
% following error message:
%! Missing number, treated as zero.
\ProvidesClass{wgetdoc}[2016/08/15 William Gathoye's document class]

%-------------------------------------------------------------------------------
% This document needs to be compiled with xelatex or lualatex. In this regard,
% all UTF-8 packages emulation have been removed.
% Compilation:
% $ xelatex <your tex filename.tex>
% $ biber <your tex filename without extension>
% $ xelatex <your tex filename>
% $ xelatex <your tex filename>
% $ <your pdf reader> <your tex filename.pdf>
% You can use lualatex instead of xetex

% If the compilation complains dependencies are not met, use the following
% command to install the missing deps.
% tlmgr search --global --file <name of file>
%-------------------------------------------------------------------------------

% Install extra/ttf-arphic-umin
% tlmgr install mnsymbol
% does not work with lualatex yet, because of japanese fonts.

%-------------------------------------------------------------------------------
% Always use \LoadClass and \RequirePackage instead of \input. If a package is
% loaded with \input then it can be loaded more than once. Such an extra loading
% may waste time and memory and it may produce strange results.

% The @ symbol is used to namespace the commands and prevent them from being
% used in a regular environment. As we are in our own class file, this is like
% as we had an implicit \makeatletter
% src.: http://tex.stackexchange.com/q/6240/66964
% makeatletter and makeatother are thus unneeded in class files.

% Use LaTeX commands as much as possible as their are more robust than their
% TeX counterparts.
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%SEC: Template and options
%-------------------------------------------------------------------------------

% Hack in order to parse class keys which have several values
% \documentclass[languages={english, french}]{wgetdoc}
% src.: http://tex.stackexchange.com/a/322238/66964
\let\oldin@\in@
\def\zzz#1#2#{\oldin@{#2}{#1}\zzzb}
\def\in@#1#2{\zzz{#2}#1{}\@nil}
\def\zzzb#1\@nil{}

% Needed to detect the TeX engine used. To have a generic code working for all
% engines.
\RequirePackage{iftex}

\RequirePackage{pgfopts}
\newif\if@wgetdoc@options@rectoverso
\pgfkeys{
    /wgetdoc/.cd,
    languages/.value required,
    languages/.code={
        \typeout{The languages you specified are: #1}
        \if#1\@empty
            \ClassError{wgetdoc}{You did not specify a language. "languages" is empty. Aborting}{}
        \fi

        \newcommand{\@wgetdoc@options@languages}{#1}
        \PassOptionsToPackage{\@wgetdoc@options@languages}{babel}
    },
    rectoverso/.is if=@wgetdoc@options@rectoverso
}

\ProcessPgfOptions{/wgetdoc}


% As a reminder: the only difference between article and report is that article
% has no chapter statement. 
% Do not use \documentclass{report}, because \documentclass should only ever be
% called once at the very beginning of your LaTeX document. Book does provide
% single sided and double sided page options.
\if@wgetdoc@options@rectoverso
    \LoadClass[twoside]{report}
\else
    \LoadClass{report}
\fi

% Add the ability to compare macros with string values. The package is reported
% to be weak and deprecated, while it appears to be maintained. etoolbox is
% considered far superior and supersedes ifthen.
%\RequirePackage{ifthen}
% ifmtarg could be useful to detect if strings are empty without the burden
% etoolbox requires.
%\RequirePackage{ifmtarg}
\RequirePackage{etoolbox}

%-------------------------------------------------------------------------------
%SEC: Languages and translations
%-------------------------------------------------------------------------------
% Require to have a package option loaded, otherwise complains with:
% ! Package babel Error: You haven't specified a language option.
% If we do not want to specify a language, the [base] option is the minimum required, but [base] does not load most of babel parts. We are not even able to check which languages have been loaded for example.
\@ifundefined{@wgetdoc@options@languages}{
    \ClassWarning{wgetdoc}{No main language specified. Defining English}
    \RequirePackage[english]{babel}
}{
    \RequirePackage{babel}
}

% Used to detect the language used in our custom listing environments and in our footers to disable shorthands/autospacing accordingly. Cannot rely on \iflanguage by babel.
\RequirePackage{iflang}

% Polyglossia should be used when XeTeX/LuaTeX is used, but polyglossia has no
% option to disable shortlands and spaces brought by French as French is not
% officially supported yet. This is annoying when you need to write an IPv6
% address or simply hours. Forcing the section to another language which allows
% to disable shorthands does not work either.
%\usepackage{polyglossia}
%\setdefaultlanguage{french}
%\setotherlanguage[babelshorthands=false]{dutch}
% Polyglossia has also issues with lualatex, when defining languages and coming back to another the spaces are not restored: http://tex.stackexchange.com/q/186156/66964

% Use the translations package instead of the LaTeX beamer "translator", because the latter has translations which can not be expanded.
% src.: http://tex.stackexchange.com/a/193452/66964
\RequirePackage{translations}

% Page <pageNumber> of <pageTotalNumber>
% \pagename contains the text used to represent the page which is "page" by default.
% src.: http://ctan.cs.uu.nl/macros/latex/contrib/babel-contrib/french/frenchb.dtx
% By default, English is used. If we want the translated version, if babel is used, the latter prefixes the command by the language name e.g.: \frenchpagename for French
% src.: http://tex.stackexchange.com/a/82994/66964
\DeclareTranslationFallback{pageOfPages}
{\pagename~\thepage~of~\pageref{lastPage}}
\DeclareTranslation{English}{pageOfPages}
{\pagename~\thepage~of~\pageref{lastPage}}
\DeclareTranslation{Dutch}{pageOfPages}
{\pagename~\thepage~op~\pageref{lastPage}}
\DeclareTranslation{French}{page-of-pages}
{\pagename~\thepage~de~\pageref{lastPage}}

\DeclareTranslationFallback{codeSnippet}
{Code snippet}
\DeclareTranslation{English}{codeSnippet}
{Code snippet}
\DeclareTranslation{Dutch}{codeSnippet}
{Codefragment}
\DeclareTranslation{French}{codeSnippet}
{Extrait de code}

\DeclareTranslationFallback{configFile}
{Configuration file}
\DeclareTranslation{English}{configFile}
{Configuratie bestand}
\DeclareTranslation{Dutch}{configFile}
{Codefragment}
\DeclareTranslation{French}{configFile}
{Fichier de configuration}

\ProvideTranslation{English}{fileListing}
{File}
\ProvideTranslation{Dutch}{fileListing}
{Bestand}
\ProvideTranslation{French}{fileListing}
{Fichier}

\ProvideTranslation{English}{author}
{Author}
\ProvideTranslation{Dutch}{author}
{Auteur}
\ProvideTranslation{French}{author}
{Auteur}


% Allow to have accentuated characters with XeLaTeX and LuaLaTeX. If you use
% polyglossia, you can remove fontspec since polyglossia already loads that
% package.
% Complain that \math-dollar is already defined if the [no-math] option is missing
% XeTeX
\RequirePackage[no-math]{fontspec}

% Use a font other than the default cmtt (Computer Modern Typewriter) which has
% no boldfaced variant. src.: http://tex.stackexchange.com/a/27677/66964
\setmonofont{Bitstream Vera Sans Mono}[Scale=MatchLowercase]

% Sometimes elements from technical documentation are written in Chinese
\RequirePackage{xeCJK}
% require the font AR PL UMing CN to be installed. Package extra/ttf-arphic-uming on Arch Linux
\setCJKmainfont{AR PL UMing CN}
%\setCJKmainfont{SimSun}

% Use quotes adapted to the language used, otherwise it fallbacks to American
% English quotes. This is a requirement for biblatex and in order to use the
% \enquote{text} command.
\RequirePackage{csquotes}

%-------------------------------------------------------------------------------
% SEC: Metrics
%-------------------------------------------------------------------------------
% Fix LaTeX incorrrect metrics and avoid overflow/underflow hbox warnings
% activate={true,nocompatibility} - activate protrusion and expansion
% final - enable microtype; use "draft" to disable
% tracking=true, kerning=true, spacing=true - activate these techniques
% factor=1100 - add 10% to the protrusion amount (default is 1000)
% stretch=10, shrink=10 - reduce stretchability/shrinkability (default is 20/20)
%\RequirePackage[
%activate={true,nocompatibility},
%final,
%tracking=true,
%kerning=true,
%spacing=true,
%factor=1100,
%stretch=10,
%%shrink=10]{microtype}

% Margins and page paddings
\ifXeTeX
    \RequirePackage[driver=xetex,margin=2.5cm]{geometry}
\else\ifPDFTeX
    \RequirePackage[driver=pdftex,margin=2.5cm]{geometry}
\else
    \RequirePackage[driver=dvips,margin=2.5cm]{geometry}
% Pay attention at the double closing if. This is needed as we use nested if statements.
% src.: http://tex.stackexchange.com/a/20780/66964
\fi\fi
% Recommended for double sided
%\RequirePackage[top=2.5cm, bottom=2.5cm, left=4cm, right=2cm]{geometry}
% Recommended for single sided
%\RequirePackage[top=2.2cm, bottom=2.2cm, left=2cm, right=2cm]{geometry}

% The default line spacing factor is 1. 1.3 which corresponds to \onehalfspacing with setspace.
% like the \linespread command, linespace is still applied on the whole document, except footnotes and captions. setspace is now a native package as of LaTeX 2e and allows more fine-grained control over line spacing thanks to dedicated environments. We still need to apply a rule to all our listings environment as linespacing is still applied on them.
% src.: https://en.wikibooks.org/wiki/LaTeX/Text_Formatting#Line_Spacing
%       http://tex.stackexchange.com/a/200215/66964
\RequirePackage{setspace}
\onehalfspacing

% Do not ask to adapt paragraph vertical spaces to make all page content of the
% same hight.
\raggedbottom

% Disable the default alineas and add a space between all paragraphs.
% Note 1: Do not try to change the values of \parskip and \parindent using
% \setlength{} because this will change the table of contents and footnotes
% spacing as well. Using the parskip package has already all the logic to avoid such
% alteration.
% Note 2: When creating new space between paragraphs, do not use \newline which
% generates an underful hbox badness 10000 and an horizontal empty box which
% doesn't stretch. But use \bigskip instead which adds a vertical space command
% of size \bigskipamount.
\RequirePackage{parskip}
% For better reading, this should be the optimized space between paragraphs:
%\setlength{\parskip}{0.5cm}

%-------------------------------------------------------------------------------
% SEC: Title management
%-------------------------------------------------------------------------------
\RequirePackage{titlesec}

%-------------------------------------------------------------------------------
% SUBSEC: Custom chapter style
%-------------------------------------------------------------------------------
\def\thickhrulefill{\leavevmode \leaders \hrule height 1.2ex \hfill \kern \z@}
\def\@makechapterhead#1{
    \vspace*{10\p@}%
    {\parindent \z@ \centering \reset@font
        \thickhrulefill\quad
        \scshape\bfseries\textit{\@chapapp{} \thechapter}
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

%-------------------------------------------------------------------------------
% SUBSEC: Support for subsubsubsection
%-------------------------------------------------------------------------------

% Add underlines below section titles. Don't try to get rid of titlesec.
% Otherwise we will need to use \hrule instead. While it is a LaTeX primitive,
% the syntax is completely different from \titlerule. titlesec takes care of
% the following issue: making sure the rule which creates a new paragraph will
% not move into the next page, and avoid to make it indented.
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}[{\titlerule[0.8pt]}]
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{1em}{}[{\titlerule[0.8pt]}]

% Define a fresh new sectional unit below \subsubsection, but above \paragraph
% does require to do considerably more work: a new counter has to be created
% and its representation has to be appropriately defined; the sectional units
% \paragraph and \subparagraph will also have to be redefined, as well as they
% corresponding \l@... commands (controlling how the will be typeset in the ToC
% if the tocdepth value is increased); also, the toclevel (for eventual
% bookmarks) will have to be considered.
% src.: http://tex.stackexchange.com/a/60212/66964
\titleclass{\subsubsubsection}{straight}[\subsection]
\newcounter{subsubsubsection}[subsubsection]
\renewcommand\thesubsubsubsection{\thesubsubsection.\arabic{subsubsubsection}}
% optional; useful if paragraphs are to be numbered
\renewcommand\theparagraph{\thesubsubsubsection.\arabic{paragraph}}
\titleformat{\subsubsubsection}
{\normalfont\normalsize\bfseries}{\thesubsubsubsection}{1em}{}
\titlespacing*{\subsubsubsection}
{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}

\renewcommand\paragraph{\@startsection{paragraph}{5}{\z@}%
   {3.25ex \@plus1ex \@minus.2ex}%
   {-1em}%
   {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{6}{\parindent}%
   {3.25ex \@plus1ex \@minus .2ex}%
   {-1em}%
   {\normalfont\normalsize\bfseries}}
\def\toclevel@subsubsubsection{4}
\def\toclevel@paragraph{5}
\def\toclevel@paragraph{6}
\def\l@subsubsubsection{\@dottedtocline{4}{7em}{4em}}
\def\l@paragraph{\@dottedtocline{5}{10em}{5em}}
\def\l@subparagraph{\@dottedtocline{6}{14em}{6em}}
\setcounter{secnumdepth}{4}

%-------------------------------------------------------------------------------
% SUBSEC: Dots in numbering
%-------------------------------------------------------------------------------

% Force trailing dot to appear in table of content and (sub) sections numbering
% scheme when chapters are used. If we define the dot in the 'thesection'
% condition below and we are not using sections, the chapter number will not be
% suffixed by a dot. If we replace the class to article, as chapters do not
% exist add a condition.
\ifdefined \thechapter
    \renewcommand{\thechapter}{\arabic{chapter}.}
\fi

% Remove double dot in figure caption numbering.
\renewcommand\thefigure{\thesection\arabic{figure}}

% Force it in appendixes too.
% Bug: this is putting letters from the end of alphabet
%\renewcommand{\appendix}{\gdef\thechapter{\@Alph\c@chapter.}}

% When no chapter is used, avoid to have section titles beginning with zeroes.
% This condition breaks if you use 'article' since chapter is not defined in
% that class. The trailing dots are used because dots are missing at the end of
% the numbering scheme made of exactly two number caracters in the table of
% content.
\renewcommand{\thesection}{%
    \ifnum\c@chapter<1
    \arabic{section}.%
    \else
    \thechapter\arabic{section}.%
    \fi
}

% Remove heading dot and add a trailing dot in subsection titles and table of
% content. In practise, change 2.1..2 to 2.1.2.
\renewcommand{\thesubsection}{%
    \thesection\@arabic\c@subsection.%
}
\renewcommand{\thesubsubsection}{
    \thesection\@arabic\c@subsection.%
    \@arabic\c@subsubsection.%
}
\renewcommand{\thesubsubsubsection}{%
    \thesection\@arabic\c@subsection.%
    \@arabic\c@subsubsection.%
    \@arabic\c@subsubsubsection.%
}

%-------------------------------------------------------------------------------
% SUB: Custom environments
%-------------------------------------------------------------------------------

% Package to customize enumeration. Allow to continue numbering scheme in
% enumeration.
\RequirePackage{enumitem}

% Use bullets in lists instead of large dashes. Must be inside the document
% scope, so inside the AtBeginDocument hook to work.
% The french flavour of babel is modifying all label items to long dashes (—)
% and the default ones for others languages are ugly for the 3th and 4th levels,
% let's redefine this to our needs.
\AtBeginDocument{%
    \renewcommand{\labelitemi}{\textbullet}
    \renewcommand{\labelitemii}{--}
    \renewcommand{\labelitemiii}{\filledsquare}
    \renewcommand{\labelitemiv}{\filledtriangleright}
}

\RequirePackage{tcolorbox}
    \tcbuselibrary{breakable}
    \tcbuselibrary{skins}
    \tcbuselibrary{listings}
\RequirePackage{caption}

% Use listing for raw data and code recognition, and wrap lines by default.
% The UTF-8 version does not bring anything new. Using it without fontenc does
% not produce compilation error with XeLaTeX, but does not display any
% accentuated characters if fontspec is not specified.
% Already loaded with tcolorbox
%\RequirePackage{listings}

% Let's create style to inherit from in other custom environments based on listings. Indeed, we do not want copy paste always the same customization for each environments.
\lstdefinestyle{custom}{
    % iflanguage is a feature of babel, but not recommanded as it is based on the detection of hyphen rules and several languages can share the same rules, we have to use \iflanguagename from the iflang package instead.
    % NoAutoSpacing is a feature of frenchb, a Babel language definition file for French, and prevents a space before colons to be added when the french
    % language is loaded with babel.
    % src.: http://tex.stackexchange.com/a/117767/66964
    %       http://tex.stackexchange.com/a/200215/66964
    basicstyle=\linespread{1}\normalsize\ttfamily\IfLanguageName{french}{\NoAutoSpacing}{},
    % Space separated words are not properly aligned on next lines if `columns` statement is set to
    % flexible. Default is 'fixed'.
    columns=fixed,
    breaklines=true,
    breakautoindent=false,
    breakindent=0pt,
    % Sets default tabsize to 4 spaces
    tabsize=4,
    % Normally used to define delimiters in code listings like begin and end
    % keywords, but it has a side effect allowing linebreaks. We are thus gonna
    % use that ugly trick to force lstinline statements to break the line at
    % the underscore character if there is not enough room for the string. This
    % is an ugly hack because it has a side effect: the _ character becomes
    % a suitable breakpoint for both sides. This can create either foo_\n bar
    % or foo\n _bar, but this cannot be avoided.
    %moredelim=[s]{_}{_},
    % Put in bold words surrounded by @@
    % [is] specifies the style.
    % i: standing for "invisible", ask for the delimiters @@ to invisible in the rendered version
    % s: standing for "string", ask for two delimiters, one starting the expression and the other closing the expression.
    moredelim={[is][keywordstyle]{@@}{@@}}
}

\lstset{
    style=custom
}

% Code environment. Does inherit from lstset settings thanks to style.
\newtcblisting[auto counter]{code}[2][]{%
    listing only,
    breakable,
    top=0.5pt,
    bottom=0.5pt,
    left=6mm,
    sharp corners,
    boxrule=0pt,
    bottomrule=1pt,
    toprule=1pt,
    enhanced jigsaw,
    listing options={
        style=custom,
        numbers=left,
        numberstyle=\tiny,
    },
    lefttitle=0pt,
    coltitle=black,
    colbacktitle=white,
    % Crashes on long lstlisting lines. \the\baselineskip reports 12.0pt. 1.2 * 12.0 = 14.4
    %borderline north={1pt}{1.2\baselineskip}{dashed},
    borderline north={1pt}{14.4pt}{dashed},
    title={\GetTranslation{codeSnippet} \thetcbcounter:  #2},#1
}

\RequirePackage{epigraph}
\setlength{\epigraphwidth}{0.5\paperwidth}

% Use continuous numbering for footnotes and avoid restart to 1 at each chapter.
\usepackage{chngcntr}
\counterwithout{footnote}{chapter}

% Add the ability to have tables. Compared to tabular, tabu has a new column
% specifier like X (in uppercase) which streches columns to make the table as
% wide as specified, greatly simplifying the creation of tables. tabu is
% a rewrite merging and extending features from tabularx and longtable. The
% latter still needs to be sourced first though.
\RequirePackage{longtable}
\RequirePackage{tabu}
% Add extra space for proper alignement between table rows
\tabulinesep = 3pt

% The "to \textwidth" expression is similar to the first argument passed to
% tabularx environment. However, in this case, according to the tabu manual, it
% should speed up the algorithm convergence.
\newenvironment{keyvalue}
{%
    \newcommand{\x}{\\[0.5\normalbaselineskip]}%
    \begin{longtabu} to \textwidth {X@{ : }X}%
    % Prevent the column and table widths to be discarded when there are only
    % multicolumns in the table. Since this adds a new line, the colon we have
    % manually defined is displayed too.
    %\tabuphantomline
}
{\end{longtabu}}

% Replace standard plain LaTeX rules in tables by rules with correct space
% between rows. While vertical lines in tables are not supported by this
% package, these are not breaking the layout, except they are not completely
% crossing horizontal rules.
\RequirePackage{booktabs}

% Add the ability for LaTeX to import and manage graphics directly.
\RequirePackage{graphicx}

% Add the ability to insert a figure at the exact location in the LaTeX code.
\RequirePackage{float}

% Allow to adjust via boxes and add options to the \includegraphics command.
% The export parameter exports most keys of \adjustbox to \includegraphics.
% Cannot be included below menukeys, otherwise, the compilation fails.
\RequirePackage[export]{adjustbox}
\newcommand{\icon}[1]{%
    % \fontcharht calculates the height of the font letter defined with the
    % \font command. That command is followed by the character, prefixed by
    % a quote escape sequence, whose height will be computed. Change X to any
    % other letter to change the height. \fontcharht comes from eTeX, but the
    % XeTeX engine understands it. valign is an option from adjustbox to align
    % to the bottom of the line keeping the line height in mind.
    \includegraphics[valign=b,height=\fontcharht\font`X]{#1}
}

%-------------------------------------------------------------------------------
% SUB: Headers and footers
%-------------------------------------------------------------------------------
\RequirePackage{datetime}
\newdateformat{ddFullMonthyyyy}{\THEDAY \monthname[\THEMONTH] \THEYEAR}
% Using the hh:mm:ss format does not take seconds into account. They seem to
% remain at 00.
%\settimeformat{hhmmsstime}

% Define a counter for last year at the time of the document compilation
\newcounter{lastYear}
\setcounter{lastYear}{\year}
\addtocounter{lastYear}{-1}

% Define headers and footers
\RequirePackage{fancyhdr}

% Define author command
\def\@firstname{}
\def\@lastname{}
\def\@email{}
\define@key{author}{firstname}{%
    \def\@author{%
        {#1}%
    }%
}

\define@key{author}{lastname}{%
    \def\@author{%
        {\@author #1}%
    }%
}

\define@key{author}{email}{%
    \def\@author{%
        {}%
    }%
}

% Since commands like chapter (which is used in the table of content too)
% automatically switch to the plain style, we need to redefine it. See the
% section 7. of the fancyhdr manpages.
\fancypagestyle{plain}{
    \lhead{School name \thelastYear-\the\year}
    \chead{Document name}
    \rhead{Author name \textsc{Lastname}}
    
    % As babel=ere, and as in French colon are preceded by a space, babel adds
    % a space even in hours. Use \NoAutoSpacing to avoid that.
    % Left field in footer
%    \lfoot{\NoAutoSpacing\today~\currenttime}
  %  \lfoot{27 mai 2015 13:47}
    
    
    
    % Left and odd (1,3,...) + right and even (2,4,...) pages
    \fancyfoot[LO,RE]{\today~\currenttime\NoAutoSpacing}
    
    % Center and odd (1,3,...) + center and even (2,4,...) pages
    \fancyfoot[CO,CE]{School section year and name}

    
    % You can use a \ref{lastPage} at the end of the document avoiding the need
    % of the lastpage package.
   % \ifx\footerRight\undefined
  %  \else
        \fancyfoot[RO,LE]{Page \thepage\ de \pageref{lastPage}}
%        \fancyfoot[RO,LE]{\footerRight}
   % \fi

    % Redefine height of header and footer lines.
    \renewcommand{\headrulewidth}{0.4pt}
    \renewcommand{\footrulewidth}{0.4pt}
}
\pagestyle{plain}

%-------------------------------------------------------------------------------
% SEC: Pagetitle and title
%-------------------------------------------------------------------------------

% If we use setkeys to define the keys from the argument of our environement,
% and we call the defined keys at the exact location we need them, the function
% linked to the key will be actually executed 2 times: at definition with
% setkeys and when we call them. To prevent that, a solution is to define a
% command that will contain the function of our key. By default, that command
% will thus not be executed. We just need to call that command when we need
% them.
% This is what we do here. We define commands like \@wgetdoc@title@maintitle
% that we need to call manually to execute their content.
\define@key{title}{maintitle}{%
    \def\@wgetdoc@title@maintitle{#1}%
}

\define@key{title}{subtitle}{%
    \def\@wgetdoc@title@subtitle{#1}%
}

\define@key{title}{author}{%
    \def\@wgetdoc@title@author{#1}%
}

\define@key{title}{filename}{%
   \def\@wgetdoc@title@filename{#1}%
}

\define@boolkey{title}{ownpage}[true]{}

\renewcommand{\title}[1][]{%

    % Define the first argument of the command to be parsed as keys. There isn't
    % any filtering restriction here wrt. the prefix and the family: all keys
    % are thus taken into account. When the \setkeys command has a key=value as
    % argument, the macro \prefix@family@keyName is defined, the value is
    % assigned and the function is executed.
    \setkeys{title}{#1}
    
    \@ifundefined{@wgetdoc@title@filename}{

        \@ifundefined{@wgetdoc@title@maintitle}{
            \ClassError{wgetdoc}{You did not specify a main title}{}
        }{}

        % Do not use the following check. This macro allows just checking if a
        % key is defined in a family from a list of families.
        %\key@ifundefined{title}{maintitle}{NOT DEFINED}{DEFINED}

        \@ifundefined{@wgetdoc@title@maintitle}{
            \ClassError{wgetdoc}{You did not specify a main title}{}
        }{}

        % Not needed as xkeyval checks if an equal sign is present (=). If absent 
        % it complains with
        %! Package xkeyval Error: no value specified for key `maintitle'.
        %\ifdefempty{\@wget@title@maintitle}{EMPTY}{NOT EMPTY}

        % Check if maintitle is empty as it: maintitle=,subtitle=lorem
        % or maintitle={},subtitle=lorem
        % No need to chek further as xkeyval is stripping white spaces and
        % checks performed either by \ifblank (etoolbox) or
        % \@ifmtarg (ifmtarg) are lost
        \ifx\@wgetdoc@title@maintitle\@empty
            \ClassError{wgetdoc}{The main title you specified is empty}{}
        \fi

        % Custom horizontale rule only local to this environment
        \newcommand{\@wgetdoc@title@hrule}{\rule{\linewidth}{1mm}}

        % If this boolean key is absent of the title command, this will return
        % false. If it is only present, it will return false too. To return true,
        % the boolean value needs to be explicitely set explicitely on true. Any
        % value other than 'true' or 'false' is non accepted and will make the
        % compilation crash.
        \ifKV@title@ownpage%
            \begin{titlepage}
                \begin{center}

                    \@wgetdoc@title@hrule%
                    \vspace{0.4cm}

                    % We always need to define \par in scope for a font size
                    % change, otherwise, if the title is ever longer than a
                    % line, it will wrap to the next line with huge characters
                    % on a normal baseline.
                    {\Huge\textbf{\@wgetdoc@title@maintitle}\par}%

                    \vspace{0.4cm}%
                    \@wgetdoc@title@hrule

                    \@ifundefined{@wgetdoc@title@subtitle}{}{
                        \vspace{1.5cm}
                        {\Large{\@wgetdoc@title@subtitle}\par}%
                    }

                    \@ifundefined{@wgetdoc@title@author}{}{
                        % Adds vertical space which will not be suppressed at the
                        % beginning or end of a page. Text following that statement
                        % will be at the bottom of the page.
                        \vspace*{\fill}
                        {\emph{\GetTranslation{author}: \@wgetdoc@title@author}\par}%
                    }

                \end{center}
            \end{titlepage}%
        \else
            \begin{center}
                {\huge\textbf{\@wgetdoc@title@maintitle}\par}
                \@ifundefined{@wgetdoc@title@subtitle}{}{
                    {\large{\@wgetdoc@title@subtitle}\par}%
                }
            \end{center}
            \@ifundefined{@wgetdoc@title@author}{}{
                {\emph{\GetTranslation{author}: \@wgetdoc@title@author}\par}%
            }
            \@wgetdoc@title@hrule%
        \fi

    % If a filename has been defined for te title page and the file exists,
    % the file will be used as title page and others arguments in the \title
    % command will be discarded.
    }{
        \IfFileExists{\@wgetdoc@title@filename}{%
            \includepdf[pages={1}]{\@wgetdoc@title@filename}%
            \ClassInfo{wgetdoc}{\@wgetdoc@title@filename has been used as title page. Any other argument have been discarded.}{}
        }{%
            \ClassError{wgetdoc}{You specified \@wgetdoc@title@filename as filename for the page title, but it could not be found.}{}
        }
    }
}

%-------------------------------------------------------------------------------
% SEC: Links management
%-------------------------------------------------------------------------------
% Add extra support for links.
% Even if hyperref implicitly loads the url package, it passes the default
% parameters. Here we are tweaking them to use 'hyphens' allowing long URLs to
% break at slashes (the default) but also at dashes. This command must be
% declared before BibLaTeX, otherwise, links, especially in footnotes, are not
% hyphenated properly.
\PassOptionsToPackage{hyphens}{url}

% Use BibLaTeX as the bibliography system
\RequirePackage[backend=biber,sorting=none,alldates=short]{biblatex}
\addbibresource{references.bib}

% Since hyperref job basically consists in redefining many LaTeX commands, this
% package needs to be the last loaded to avoid being over-written. If you have
% footnotes with urls having special characters like #, you must escape them
% with \. Please pay attention this command is overriding command declared by
% the url package like \DeclareUrlCommand.
\RequirePackage{hyperref}

% Define a new command for filenames using url appearance. This command must be
% defined after BibLaTeX.
\DeclareUrlCommand\filename{\urlstyle{tt}}

% Define a new command for textfields using url appearance. This command must
% be defined after BibLaTeX.
\DeclareUrlCommand\textfield{\urlstyle{tt}}

% Allow include pdf pages inside LaTeX
\RequirePackage{pdfpages}

% Used to count the number of page.
\AtEndDocument{\label{lastPage}}

%-------------------------------------------------------------------------------
% SEC: Logos and additional characters
%-------------------------------------------------------------------------------
% Use special characters like a right oriented triangle. These are present in
% the fonts from the American Mathematical Society.
\RequirePackage{amssymb}

% For redefinition of label items in unordered lists. Needs the fontspec package
% to be loaded with the no-math option.
\RequirePackage{MnSymbol}

% For Physics and Mathematics symbols (electricity for currents for example).
\RequirePackage{wasysym}

% Symbol for direct current
% src.: http://tex.stackexchange.com/a/40628/66964
\newcommand{\DC}{%
    \settowidth{\dimen0}{$=$}%
    \vbox to .85ex {\offinterlineskip
        \hbox to \dimen0{\leaders\hrule\hfill}
        \vskip.35ex
        \hbox to \dimen0{%
            \leaders\hrule\hskip.2\dimen0\hfill
            \leaders\hrule\hskip.2\dimen0\hfill
            \leaders\hrule\hskip.2\dimen0
        }
        \vfill
    }%
}

% Used to implement TeX related logos.
% doesn't work since a recent update
%\RequirePackage{dtklogos}
\RequirePackage{metalogo}

% Add support for special keystrokes and paths.
% Must be loaded after BibLaTeX to avoid trouble and after hyperref when the
% later is tweaked with "\PassOptionsToPackage{hyphens}{url}", otherwise the
% compilation fails.
% https://github.com/tweh/menukeys/issues/41
\RequirePackage{menukeys}

% Use a proper split symbol for separation between directories in menu
% statements.
\newcommand{\paramsep}{%
    \hspace{0.4em plus 0.1em }%
    \raisebox{0.08ex}{%
        \tikz{%
            \draw (-1ex,0.5ex) -- (0,0.5ex);
            \fill (0,0) -- (0.5ex,0.5ex) -- (0,1ex) -- cycle;
        }%
    }%
    \hspace{0.4em plus 0.1em}%
}

\tw@declare@style@simple*{menu}{%
    {\sffamily\small\CurrentMenuElement}%
}[\paramsep]{blacknwhite}

\renewmenumacro{\menu}[>]{menu}

%-------------------------------------------------------------------------------
% SEC: Debug
%-------------------------------------------------------------------------------
% For debug purpose. Only needed if you want to print the layout with \layout
% inside the document environment scope.
%\usepackage{layout}

% For debug purpose. Show all fonts TeX is using in your file, so we can see at
% which stage a font is being misinterpreted (ex. pdf conversion stage).
%\showoutput
