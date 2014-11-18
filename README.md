## VIM-TREEMAP

VIM-TREEMAP is a vim script to create a treemap from a tab seperated input file. the output could be a text file or a html file with imbedded SVG.

### How to use
* open the input file in vim
* load the script in commandLine with ':so PFAD/treemap.vim' (example - :so C:\treemap\treemap.vim)
* run the method treemap#main() in commandLine with ":call treemap#main('VIM')" or "treemap#main('SVG')"

Use 'VIM': the treemap is created in a new tab with the signs '-', '|' and '+'
Use 'SVG': the treemap is discripted in a new tab in SVG. The SVG is imbedded in a HTML file.

### Example
#### Input file:
folder	file	size
treemap	treemap.vim	12
treemap	readme.txt	6
xml	xmlcleaner.vim	16
xml	readme.md	7

#### Output 'VIM':
+----------------------------------------------------------+  
|+-----------------------++-------------------------------+|  
||+-------------++------+||+--------------------++-------+||  
|||treemap.vim  ||readme|tx|xmlcleaner.vim      ||readme.|d|  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
|||             ||      ||||                    ||       |||  
||+-------------++------+||+--------------------++-------+||  
|+-----------------------++-------------------------------+|  
+----------------------------------------------------------+  

#### Output 'SVG':
\<?xml version="1.0" encoding="ISO-8859-1"?\>
\<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de"\>
\<head\>
\<title\>Treemap\</title\>
\</head\>
\<body\>
\<h1\>Treemap\</h1\>
\<svg width="1024" height="768" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"\>
\<title\>Treemap\</title\>
\<desc\>generierte Treemap\</desc\>
\<rect x="2" y="2" width="449" height="766" fill="blue" stroke="black" /\>
\<text x="12" y="22" fill="black"\>treemap\</text\>
\<rect x="451" y="2" width="573" height="766" fill="grey" stroke="black" /\>
\<text x="461" y="22" fill="black"\>xml\</text\>
\<rect x="3" y="3" width="447" height="509" fill="blue" stroke="black" /\>
\<text x="13" y="23" fill="black"\>treemap.vim\</text\>
\<rect x="3" y="512" width="447" height="255" fill="blue" stroke="black" /\>
\<text x="13" y="532" fill="black"\>readme.txt\</text\>
\<rect x="452" y="3" width="571" height="531" fill="grey" stroke="black" /\>
\<text x="462" y="23" fill="black"\>xmlcleaner.vim\</text\>
\<rect x="452" y="534" width="571" height="233" fill="grey" stroke="black" /\>
\<text x="462" y="554" fill="black"\>readme.md\</text\>
\</svg\>
\</body\>
\</html\>

### Colouring
Only in case of 'SVG' the rectangles get a color:
* If there is only on column with values, the first column fixes the color of all child rectangles
* If there is a second column with values, the second value fixes the color of the rectangle (Heat Map)

More details to the second case:
* the value in the second value column is \< 20% of the avarage of the second value column, the color of the rectangle is blue
* the value in the second value column is \>= 20% or \<= 20% of the avarage of the second value column, the color of the rectangle is grey
* the value in the second value column is \> 20% of the avarage of the second value column, the color of the rectangle is red

You can change the colors in the global array 'g:color':
:let g:color = ['blue','grey','red']

You can change the percentage of the borders in the global variable 'g:val2Interval:
:let g:val2Interval = 20.00

