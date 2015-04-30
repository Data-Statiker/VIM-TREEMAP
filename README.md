## VIM-TREEMAP

VIM-TREEMAP is a vim script to create a treemap from a character seperated input file. The output could be a text file or a html file with imbedded SVG.
(SLICE and DICE)

For further details read the vim help file:
../doc/treemap.txt

Version 0.9.2

### Getting Started

With the treemap extension plugin for vim you can create treemaps with the
output in a textfile or an imbedded SVG HTML file.

First install the plugin: |treemap-install|

To start the treemap creation:
- load the inputfile
- set the separator (;|,|\t|...) in the menu Plugin-Treemap-Separator
  or with the VIM Command :TmSeparator (<leader>tr)
- set the output type 'VIM' or 'SVG' in the menu Plugin-Treemap-Output Type
  or with the VIM Command :TmOutput
- Run the treemap script in the menu Plugin-Treemap-Run    
  or with the VIM Command :TmRun
  OR
  call the main function: call treemap#main(output,separator)
  for example: - call treemap#main('VIM','\t')
               - call treemap#main(g:tmOutput,g:tmSeparator)

    Note:                                                     
    Set tho option wrap to 'nowrap'                           
      :set nowrap!                                            
    Otherwise the treemap is displayed wrong. You can set this
    option also after drawing the treemap!                    

   Note:                                                        
   The decimal separator for the input file is in every language
   the point "."                                                
        examples:   23.1                                       
                  1020.23                                       
  

Use commands TmCreate and TmDraw instead of TmRun.


### Whats New

Version 0.9.2:
- New Commands TmCreate and TmDraw
  To seperate the calculating and drawing of treemap
- Create folders in plugin files for a clear view

Version 0.9.1:
- Add corresponding VIM COMMANDS for each menu entry
- Add Mappings for VIM Commands:
- Set the default width and height in case of Output Type 'VIM'
  to 70x25


### Overview

With the treemap extension plugin for vim you can create treemaps with the
output in a textfile or an imbedded SVG HTML file.

To create a treemap you need an input file. This file has to be character
seperated (CSV) and needs a headline.

Example for an input file:
folder;file;size
treemap;treemap.vim;12
treemap;readme.txt;6
xml;xmlcleaner.vim;16
xml;readme.md;7

To create a treemap do the following:
-  Open this input file in VIM
   vim inputfile.txt

-  Select the correct separator
   Menu:    Plugin->Treemap->Separator
   Command: TmSeparator
   In the example case use the separator "Semicolon ;"

-  Select your favourite output type
   Menu:    Plugin->Treemap->Output Type
   Command: TmOutput
   see |treemap-configure-output| and |treemap-menu| or |TmOutput|
   The standard Output is "VIM <Textfile>"

-a Start the treemap generation
   Menu:    Plugin->Treemap->Run main()
   Command: TmRun
   Mapping: <leader>tr (in most cases <leader> = "\")
   This call needs a headline!
   Then a new tab opens. In case of the output type SVG you get
   the SVG/HTML Code in the new tab and in the other case (VIM)
   the treemap is drawn in the new tab with the signs "|","+" 
   and "-".

-b Instead of using 4a you can also use the commands
   |TmCreate| and |TmDraw|.
   Menu:     Plugin->Treemap->Create create()
             Plugin->Treemap->Draw draw()
   Commands: TmCreate
             TmDraw
   Mappings: <leader>tc
             <leader>td
   TmCreate creates the rectangles and save this to the tmClipboard.
   TmDraw draw the rectangles to the current position of your cursor. 

       Note:                                                   
       To use TmCreate you have to select a marked area of the 
       input data! Don't select a headline!!                   
                                                               
       If you use the visual-mode, don't use the command       
       ":TmCreate". You overwrite your data with that.         


       Note:                                                        
       You start the visual mode with: 'v'                          
       You start the visual block mode with:                        
       <Ctrl-V> Linux                                               
       <Ctrl-Q> Windows                                             
       Then use the keys "h, j, k, l" to mark the area you want to  
       select. (Keys: h - <LEFT>, j - <DOWN>, k - <UP>, l - <RIGHT>)


Instead of use the menu you can set the paramters and start the generation
directly:
- Separator
  variable: g:tmSeparator                    // example: :let g:tmSeparator = ";"
- Output Type
  variable: g:tmOutput                       // example: :let g:tmOutput = "VIM"
- Run the generation
  function treemap#main(output,separator)    // example: :call treemap#main("VIM",";")


Other paramters:

You can change the size of the treemap with the following variables:
- g:tmUx - width                               // example: :let g:tmUx = 230
- g:tmUy - height                              // example: :let g:tmUy = 65
To do that you can use the menu "Plugin"->"Treemap"->"Size"
or the Vim Commands :TmWidth and :TmHeight

If this parameters aren't set, the default values are taken:
VIM:  70 * 25
SVG: 1024 * 768


The title of a treemap can defined in the menu or Command:
   Menu:    Plugin-Treemap-Title g:tmTitle (|treemap-menu|)
   Command: |TmTitle|

After executing this menu point youn can insert the name of your Treemap in a
input popup.

You can also set the variable g:tmTitle directly:
   :let g:tmTitle = "MyTreemapName"

In case of output type "VIM":
   The title is written in line 1 of the output tab
In case of output type "SVG":
   - The title is used in the HTML Header as title
   - The title is used as a headline for the SVG graphic

     Note:                                                        
     The decimal separator for the input file is in every language
     the point "."                                                
         examples:   23.1                                         
                   1020.23                                        


Other paramters:

You can change the size of the treemap with the following variables:
- g:tmUx - width                               // example: :let g:tmUx = 230
- g:tmUy - height                              // example: :let g:tmUy = 65
To do that you can use the menu "Plugin"->"Treemap"->"Size".

If this parameters aren't set, the default values are taken:
VIM:  230 * 65
SVG: 1024 * 768


The title of a treemap can defined in the menu:
   Plugin-Treemap-Title g:tmTitle (|treemap-menu|)

After executing this menu point youn can insert the name of your Treemap in a
input pop up.

You can also set the variable g:tmTitle directly:
   :let g:tmTitle = "MyTreemapName"

In case of output type "VIM":
   The title is written in line 1 of the output tab
In case of output type "SVG":
   - The title is used in the HTML Header as 'title'
   - The title is used as a headline for the SVG graphic

     Warning:                                                     
     The decimal separator for the input file is in every language
     the point "."                                                
         examples:   23.1                                         
                   1020.23                                        


### Installation

VIMBALL:
Download the vimball file treemap.vmb from:
http://www.vim.org/scripts/script.php?script_id=5157

Install the vimball file with VIM 
- Download the file treemap.vmb
- vim path/treemap.vmb
- :so %
- :q

Now you have the menu Plugin-Treemap

GITHUB:
GITHUB Repository:
https://github.com/Data-Statiker/VIM-TREEMAP

When you have the files from GITHUB:
Copy the folders 'autoload', 'doc' and 'plugin' to your local vimfiles:
 ~/.vim/doc
 OR (Windows)
 C:\Users\YourUsername\vimfiles\doc

HELP FILE:
To activate the helpfile in VIM type in command mode:
 :helptags ~/.vim/doc
 OR (Windows)
 :helptags C:\Users\YourUsername\vimfiles\doc

### Example
#### Input file:
folder;file;size<br>
treemap;treemap.vim;12<br>
treemap;readme.txt;6<br>
xml;xmlcleaner.vim;16<br>
xml;readme.md;7<br>

#### Output 'VIM':
+----------------------------------------------------------+&nbsp;&nbsp;&nbsp;&nbsp;<br>
|+-----------------------++-------------------------------+|&nbsp;&nbsp;&nbsp;&nbsp;<br>
||+-------------++------+||+--------------------++-------+||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||treemap.vim&nbsp;&nbsp;&nbsp;&nbsp;||readme|tx|xmlcleaner.vim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||readme.|d|&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|||&nbsp;&nbsp;&nbsp;&nbsp;<br>
||+-------------++------+||+--------------------++-------+||&nbsp;&nbsp;&nbsp;&nbsp;<br>
|+-----------------------++-------------------------------+|&nbsp;&nbsp;&nbsp;&nbsp;<br>
+----------------------------------------------------------+&nbsp;&nbsp;&nbsp;&nbsp;<br>
 

#### Output 'SVG':
\<?xml version="1.0" encoding="ISO-8859-1"?\><br>
\<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de"\><br>
\<head\><br>
\<title\>Treemap\</title\><br>
\</head\><br>
\<body\><br>
\<h1\>Treemap\</h1\><br>
\<svg width="1024" height="768" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"\><br>
\<title\>Treemap\</title\><br>
\<desc\>powered by TREEMAP VIM PLUGIN\</desc\><br>
\<rect x="2" y="2" width="449" height="766" fill="blue" stroke="black" /\><br>
\<text x="12" y="22" fill="black"\>treemap\</text\><br>
\<rect x="451" y="2" width="573" height="766" fill="grey" stroke="black" /\><br>
\<text x="461" y="22" fill="black"\>xml\</text\><br>
\<rect x="3" y="3" width="447" height="509" fill="blue" stroke="black" /\><br>
\<text x="13" y="23" fill="black"\>treemap.vim\</text\><br>
\<rect x="3" y="512" width="447" height="255" fill="blue" stroke="black" /\><br>
\<text x="13" y="532" fill="black"\>readme.txt\</text\><br>
\<rect x="452" y="3" width="571" height="531" fill="grey" stroke="black" /\><br>
\<text x="462" y="23" fill="black"\>xmlcleaner.vim\</text\><br>
\<rect x="452" y="534" width="571" height="233" fill="grey" stroke="black" /\><br>
\<text x="462" y="554" fill="black"\>readme.md\</text\><br>
\</svg\><br>
\</body\><br>
\</html\><br>
