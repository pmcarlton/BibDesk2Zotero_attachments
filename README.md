# Summary:

BibDesk2Zotero (with attachments) is a pair of files that should allow you to convert a BibDesk
bibliography (in BibTeX format) containing local file attachments in the form of
(Bdsk-File) to a new BibTeX file that Zotero can import *along with 
all of its attachments*, using the (included)
BibTex.js translator file. All attachments (excepting entire directories) in each entry present in the original BibDesk file should come along seamlessly into Zotero.

**Important**: To convert successfully, the BibDesk bibliography file must be in the same directory as the attachment root directory.
(i.e., if you have a "Papers" directory containing PDFs, movies, etc., the BibDesk file must be located in that
"Papers" directory. You can move or copy it there if it's not already, of course.)

# Rationale:

BibDesk stores attachments as Base64-encoded pathnames. Currently these
are ignored when importing a BibTeX file into Zotero. To enable import
into Zotero, these entries must be decoded to actual filenames and given
a new field that the appropriate translator can recognize.

# Use: 
   
- run the command `perl bdsk-to-zotero-attachments.pl /PATH/TO/OLD.bib /PATH/TO/NEW.bib` to create the new, attachment-import-enabled BibTeX file.    
- install [Zotero Better BibTex](https://github.com/retorquere/zotero-better-bibtex) (as per [this issue](https://github.com/retorquere/zotero-better-bibtex/issues/667), Zotero Better BibTex supports the `Local-Zo-Url-N` "out of the box").
- Quit Zotero standalone
- Then launch **Zotero standalone** and perform an import of NEW.bib 
    
# What the `bdsk-zotero-attachments.pl` script does:

- Scans your BibDesk bibliography for every instance of
    "Bdsk-File-N", which indicate local attachments.
- Decodes the Base64-encoded pathname of the files
- Writes out a new BibTeX file with the correct pathnames, listing
    each under a new field "Local-Zo-Url-N"
    
    
# Requirements and limitations

- Last tested on MacOS 10.12.4, Zotero Standalone 4.0.29.15, BibDesk 1.6.11, and Zotero Better Bibtex 1.6.97. As of 2017-05-15, *this still works*.
- Requires system utilities "dirname", "grep", "tail", "base64" and "plutil" (standard on
Mac OS X).
- Requires that the directory /tmp exists and is user-writable (can be
    customized).
- Correct functioning of the program depends on the current way
    that BibDesk (as of version 1.5.10) encodes local attachments, and
    on the way that the Mac OS X "plutil" prints out the XML. Any
    changes in these factors will produce unexpected behavior.
- Does not recursively import entire directories as attachments, but prints a warning to STDOUT that the directory was ignored.
- As stated at the top, the BibDesk bibliography file must be in the same directory as the attachment root directory. (i.e., if you have a "Papers" directory containing PDFs, movies, etc., the BibDesk file must be located in that "Papers" directory.)
