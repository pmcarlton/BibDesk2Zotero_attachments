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

- Quit Zotero standalone
- Backup the old BibTex.js file from, then copy this one into, your Zotero translators
directory (something like `$HOME/Library/Application Support/Zotero/Profiles/XXXXXX.default/zotero/translators`)
- Then launch **Zotero standalone** and perform an import of NEW.bib 
    
# What the programs do:

## bdsk-zotero-attachments.pl

- Scans your BibDesk bibliography for every instance of
    "Bdsk-File-N", which indicate local attachments.
- Decodes the Base64-encoded pathname of the files
- Writes out a new BibTeX file with the correct pathnames, listing
    each under a new field "Local-Zo-Url-N"
    
## BibTex.js

- A very slightly altered translator, which upon import of BibTeX
    records also scans for the presence of "Local-Zo-Url-N" fields, and
    adds a Zotero attachment for every such field for each entry.
    
- Can create via `ed` from existing BibTex.js (as of translator ID 9cb70025-a888-4a29-a210-93ec52da40d4, 2013-02-03) thusly:
    
        1786a
        } else if (field.match(/Local-Zo-Url/i)) {
            item.attachments.push({path:value}); 
        .

# Requirements and limitations
- Tested on OS X 10.8.2, Zotero standalone 3.0.11.1, BibDesk 1.5.10
- Requires system utilities "dirname", "grep", "tail", "base64" and "plutil" (standard on
Mac OS X).
- Requires that the directory /tmp exists and is user-writable (can be
    customized).
- Correct functioning of the program depends on the current way
    that BibDesk (as of version 1.5.10) encodes local attachments, and
    on the way that the Mac OS X "plutil" prints out the XML. Any
    changes in these factors will produce unexpected behavior.
- Does not recursively import entire directories as attachments, but
prints a warning to STDOUT that the directory was ignored.
- As stated at the top, the BibDesk bibliography file must be in the same directory as the attachment root directory.
(i.e., if you have a "Papers" directory containing PDFs, movies, etc., the BibDesk file must be located in that
"Papers" directory.)
