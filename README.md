# wgetdoc - A simple multilanguage class dedicated to technical documentation

## Installation

Install a full texlive installation with the following packages:

* texlive-most
* texlive-lang

This class file is also compatible [with a minimal LaTeX installation](https://en.wikibooks.org/wiki/LaTeX/Installation#Custom_installation_with_TeX_Live), but this is a bit tedious.

There is currently a bug in the xeCJK module, but hopefully, [there is a fix](https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1536714.html).

Open the file `xeCJK-listings.sty` located at the following location:

* On Arch Linux:  ̀/usr/share/texmf-dist/tex/xelatex/xecjk/xeCJK-listings.sty`
* On Debian: `/usr/share/texlive/texmf-dist/tex/xelatex/xecjk/xeCJK-listings.sty`

and add the statement `\bool_new:N \l__xeCJK_listings_letter_bool` in order to obtain the following result:

```
    \lst@Append #2
  }
\bool_new:N \l__xeCJK_listings_letter_bool
\cs_new_protected_nopar:Npn \__xeCJK_listings_process_letter:nN
  {
    \lst@whitespacefalse
    \bool_if:NTF \l__xeCJK_listings_letter_bool
```

## Usage

This document needs to be compiled with xelatex or lualatex. In this regard, all UTF-8 packages emulation have been removed.

    $ xelatex <your tex filename.tex>
    $ biber <your tex filename without extension>
    $ xelatex <your tex filename>
    $ xelatex <your tex filename>
    $ <your pdf reader> <your tex filename.pdf>

You can use lualatex instead of xetex

If the compilation complains dependencies are not met, use the following commands to find the concerned package name from the filename specified and install it to satisfy the dependency:

    # umask 0022
    # tlmgr search --global --file <name of file>
    # tlmgr install <package name>

You should know [these commands](https://en.wikibooks.org/wiki/LaTeX/Installation#Installing_LaTeX) if you installed a LaTeX distribution in a minimal way.
