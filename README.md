# wgetdoc

A simple LaTeX multilanguage class dedicated to technical documentation. The purpose here was to have a fully UTF-8 compatible class using a modern LaTeX installation without requiring third-party package to support UTF-8 encoded Unicode symbols.

## Installation

Follow one of the following installation methods.

### Auto installation

Install a full texlive installation with the following packages:

* texlive-most
* texlive-lang
* biber

### Manual and minimal installation

This class file is also compatible [with a minimal LaTeX installation](https://en.wikibooks.org/wiki/LaTeX/Installation#Custom_installation_with_TeX_Live), but this is a bit tedious.

Indeed, if the compilation complains dependencies are not met, you will have to use the following commands to find the concerned package name from the filename specified and install it to satisfy the dependency:

    # umask 0022
    # tlmgr search --global --file <name of file>
    # tlmgr install <package name>

You should know [these commands](https://en.wikibooks.org/wiki/LaTeX/Installation#Installing_LaTeX) if you installed a LaTeX distribution in a minimal way.

## Usage

### Create a document based on this class

Here is a minimal working example. The file `wgetdoc.cls` must reside alongside your TeX file. Symlinks are supported.

```
% Main language is last, or override with main= i.e.:
% languages={main=french,english}, rectoverso]{wgetdoc}
\documentclass[languages={french,english}, rectoverso]{wgetdoc}

% Used to generate random content. Remove in production.
\usepackage{lipsum}

\begin{document}

\header[default,line]
\title[maintitle=Some title,
       subtitle=\textsc{some sub},
       author=This is me,ownpage=true]

\tableofcontents

\chapter{Hello world, I'm a chapter}

\section{I'm a simple section}

% Used to generate random content. Remove in production.
\lipsum[4-57]

\begin{otherlanguage}{french}

    \tableofcontents
    Bonjour à tous! Ceci est un "texte".

    Bonjour à tous! Ceci est un ``texte''.

    Bonjour à tous! Ceci est un \enquote{texte}.
\end{otherlanguage}

\end{document}
```

### Compilation process

This document needs to be compiled with xelatex or lualatex. In this regard, all UTF-8 packages emulation have been removed.

    $ xelatex <your tex filename.tex>
    $ biber <your tex filename without extension>
    $ xelatex <your tex filename>
    $ xelatex <your tex filename>
    $ <your pdf reader> <your tex filename.pdf>

You can also use lualatex instead of xetex.

To make the compilation process a bit easier for you, you can also create a Makefile.

```
file=

all:
	xelatex $(file).tex
	biber $(file)
	xelatex $(file).tex
	xelatex $(file).tex

simple:
	xelatex $(file).tex

clean:
	find . -name '$(file).*' -not -name "$(file).tex" -not -name ".$(file).tex.swp" -exec rm -i {} \;

```

To launch a compilation, specify the `file` variable to your TeX file without precising its `.tex` extension:

    # 	make file=my_documentation_file

This will compile the document 3 times and compile your bibliography database if any. If you do not need this, simply use the argument `simple` which only makes one pass.

To clean the files created by the compilation process, you can safely run the same type of command. Do not worry, the rm command asks each time if you want to remove the file or not.

    # 	make clean file=my_documentation_file
