#!/bin/bash
# dict-lookup.sh

#  This script looks up definitions in the 1913 Webster's Dictionary.
#  This Public Domain dictionary is available for download
#+ from various sites, including
#+ Project Gutenberg (http://www.gutenberg.org/etext/247).
#
#  Convert it from DOS to UNIX format (only LF at end of line)
#+ before using it with this script.
#  Store the file in plain, uncompressed ASCII.
#  Set DEFAULT_DICTFILE variable below to filename and path.


E_BADARGS=65
MAXCONTEXTLINES=50                        # Maximum number of lines to show.
DEFAULT_DICTFILE="webster1913-dict.txt"   # Default dictionary file name/path.
                                          # Change this as necessary.
#  Note:
#  ----
#  The particular edition of the 1913 Webster's
#+ begins each entry with an uppercase letter
#+ (lowercase for the remaining characters).
#  Only the very first line of an entry begins this way,
#+ and that's why the search algorithm below works.



if [[ -z $(echo "$1" | sed -n '/^[A-Z]/p') ]]
#  Must at least specify word to look up, and
#+ it must start with an uppercase letter.
then
  echo "Usage: `basename $0` Word-to-define [dictionary-file]"
  echo
  echo "Note: Word to look up must start with capital letter,"
  echo "with the rest of the word in lowercase."
  echo "--------------------------------------------"
  echo "Examples: Abandon, Dictionary, Marking, etc."
  exit $E_BADARGS
fi


if [ -z "$2" ]                            # May specify different dictionary.
then
  dictfile=$DEFAULT_DICTFILE
else
  dictfile="$2"
fi

# ---------------------------------------------------------
Definition=$(fgrep -A $MAXCONTEXTLINES "$1 \\" "$dictfile")
#                  Definitions in form "Word \..."
#
#  And, yes, "fgrep" is fast enough to search
#+ even a very large text file.


# Now, snip out just the definition block.

echo "$Definition" |
sed -n '1,/^[A-Z]/p' |
#  Print from first line of output
#+ to the first line of the next entry.
sed '$d' | sed '$d'
#  Delete last two lines of output
#+ (blank line and first line of next entry).
# ---------------------------------------------------------

exit 0

# Exercises:
# ---------
# 1)  Modify the script to accept any type of alphabetic input
#   + (uppercase, lowercase, mixed case), and convert it
#   + to an acceptable format for processing.
#     See lines 18-20.
#
# 2)  Convert the script to a GUI application,
#   + using something like "gdialog" . . .
#     The script will then no longer take its argument(s)
#   + from the command line.