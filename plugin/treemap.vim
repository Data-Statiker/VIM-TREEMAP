"  vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
"  treemap.vim: (plugin) Creates a treemap in a new tab
"  Last Change: Tue May 12 10:45 PM 2015 MET
"  Author:      Data-Statiker
"  Maintainer:  Data-Statiker
"  Version:     1.0, for Vim 7.4+

"  New: {{{1
"  Version 1.0:
"  * New command TmOpen (Mapping <leader>to)
"    This command opens a generated SVG/HTML treemap in a web browser
"  * Bugfix: Replace $lang with $LANG for compatibility with older VIM
"    versions
"  * New command TmClear to delete all generated files from TmOpen in
"    the $HOME/treemaps/ directory
"
"  Version 0.9.2.1:
"  *  Bugfix TmCreate with other separators than "\t" (tab)
"
"  Version 0.9.2:
"  *	New Commands TmCreate and TmDraw
"     To seperate the calculating and drawing of treemap
"  *  Create folders in plugin files for a clear view
"
"  Version 0.9.1:
"  *	Add corresponding VIM COMMANDS for each menu entry
"  *	Add Mappings for VIM Commands:
"  *	Set the default width and height in case of Output Type 'VIM'
"     to 70*25
"
"  Version 0.9:
"  *	Title for the treemap
"  *	Initialize g:tmMess / no error occurs by starting "print log"
"  *	Namespace for treemap global variables: g:tm*
"  	  To avoid incompatibility to other plugins
"  *	Small changes in the help file
"
"  Version 0.8:
"  *	Introduce the global variables g:tmUx and g:tmUy to set the size from the
"	    treemap. So the size of the treemap could be changed throug the variables:
"	    g:tmUx = width
"	    g:tmUy = height
"  *	Adapt the menu to set the height and width of the treemap
"  *	Adapt the menu for printing the log variable g:tmMess
"  *	Update VIM help file
"  *	For some parameters in the function treemap#initialize()
"  	  Only set the variables when they do not exist
"  *	New function treemap#checkChildParentRelation(matrix,val2Active)
"  	  Check if every unit has only one parent
"
"  Version 0.7:
"  *	In version 0.7 the output paramater is created for the function
"  	  treemap#main(). The paramater output could have the values "VIM" or
"  	  "SVG".
"  	   VIM: Rectangles are created in a new tab with the signs "-", "|" and "+" 
"  	   SVG: Rectangles are descripted in a SVG structure imbedded in a html
"  	        file 
"  *	New function treemap#initialize for initializing global variables
"  *	New parameter separator for the method treemap#main(). So the input
"  	  file could be separated by ";" or "\t" (tab) or any other signs. The values
"  	  of these parameter are for example:
"  	    ;	for semicolon separated files
"  	   \t	for tabulator separated files
"  	  Examples: :call treemap#main('VIM',';')
"  		  :call treemap#main('SVG','\t')
"  *	Insert 'throw "oops"' in treemap#interruptRun() so the program stops
"	    in case of error	
"  *	Create the menu "Plugin - Treemap" tor run the script and set the
"	    variables g:tmSeparator, g:tmOutput, g:tmColor
"
"  Version 0.6:
"  *	Delete not used functions "treemap#reorgHierachy" and "treemap#reorgHierachy2" with
"  	  all sub functions
"  *	Rename function "treemap#reorgHierachy3" to "treemap#reorgHierachy"
"  *	Add a second value column. This value is represented in the treemap through
"  	  colors (Heat Map). Only SVG-Output. If ther is no val 2 column, the layer 1
"  	  entries define the color of their childs
"  
"  Version 0.5:
"  *	In version 0.5 the recursive function "treemap#reorgHierachy2" is substitute
"  	  through the iterative function "treemap#reorgHierachy3"
"  *	SVG-Output with fill color

" Variable Definition {{{1
" fill colors for Rectangles
:let g:tmColor = ['blue','grey','red']

" initialize g:tmSeparator
:let g:tmSeparator = "\\t"

" initialize g:tmOutput
:let g:tmOutput = 'VIM'

" list for warnings and errors
:let g:tmMess = []
:let g:tmErr = 0

" initialize global variables
:function! treemap#initialize()
	" frame data / will be defined in the main() function
	":let g:tmX = 230
	":let g:tmY = 65
	":let g:tmX = 1024
	":let g:tmY = 768
	":let g:tmPt = g:tmX * g:tmY

	" val2 average and interval values / is val2 active or not
	:let g:tmVal2Active = "false"
	:let g:tmVal2Average = 0.00
	:if !exists("g:tmVal2Interval")
		:let g:tmVal2Interval = 20.00
	:endif

	" fill colors for Rectangles color index
	:let g:tmCIndex = 0

	" number of layers
	:let g:tmLNr = 0
  :let g:tmLayNrs = []

	" actual tabpage
	" :let g:tmTabMain = tabpagenr()

	" verbose - all messenges are displayed if g:tmVerbose = 1
	:if !exists("g:tmVerbose")
		:let g:tmVerbose = 0
	:endif

	" Hierachy flat
	:let g:tmTrHier = []

	" Title for the treemap
	:if !exists("g:tmTitle")
		:let g:tmTitle = "Treemap"
	:endif

  " Clipboard variables
	:if !exists("g:tmClipboard")
		:let g:tmClipboard = []
	:endif
	:if !exists("g:tmClipSize")
    :let g:tmClipSize = {}
  :endif

	" list for warnings and errors
	:let g:tmMess = []
	:let g:tmErr = 0

	" Definition of errors, informations and warnings
	" Errors
	:let g:tmE0001 = {"T":"E","O":"A","DE":"|E|E0001|Anzahl Ebenen nicht korrekt"}
	:let g:tmE0001["EN"] = "|E|E0001|Number of layers are incorrect"
	:let g:tmE0002 = {"T":"E","O":"A","DE":"|E|E0002|Das Programm musste aufgrund eines Fehlers abgebrochen werden"}
	:let g:tmE0002["EN"] = "|E|E0002|The program was interupted cause of errors"
	:let g:tmE0003 = {"T":"E","O":"A","DE":"|E|E0003|Der letzte Eintrag ist kein numerischer Wert"}
	:let g:tmE0003["EN"] = "|E|E0003|The last entry is no numeric value"
	:let g:tmE0004 = {"T":"E","O":"A","DE":"|E|E0004|Der Rahmen ist zu klein"}
	:let g:tmE0004["EN"] = "|E|E0004|Frame is too small"
	:let g:tmE0005 = {"T":"E","O":"A","DE":"|E|E0005|Jede Einheit darf nur einer übergeordneten Einheit zugeordnet sein"}
	:let g:tmE0005["EN"] = "|E|E0005|Every unit must have only one parent"
 	:let g:tmE0006 = {"T":"E","O":"A","DE":"|E|E0006|Für diese Funktion (TmCreate) muss ein Bereich markiert sein"}
 	:let g:tmE0006["EN"] = "|E|E0006|This function need a marked area"
  :let g:tmE0007 = {"T":"E","O":"A","DE":"|E|E0007|Es sind keine Daten im Zwischenspeicher zum zeichnen vorhanden"}
 	:let g:tmE0007["EN"] = "|E|E0007|There are no data to draw in the clipboard"
	" Warnings
	:let g:tmW0001 = {"T":"W","O":"A","DE":"|W|W0001|Das Rechteck wird nicht gezeichnet, da Fläche zu gering"}
	:let g:tmW0001["EN"] = "|W|W0001|The rectangle is not drawn because the area is too small"
	" Informations
	:let g:tmI0001 = {"T":"I","O":"A","DE":"|I|I0001|Die Inputparameter sind korrekt"}
	:let g:tmI0001["EN"] = "|I|I0001|Input paramter are correct"
	:let g:tmI0002 = {"T":"I","O":"A","DE":"|I|I0002|Die Parameter wurden erfolgreich eingelesen"}
	:let g:tmI0002["EN"] = "|I|I0002|Parameter read successfull"
	:let g:tmI0003 = {"T":"I","O":"A","DE":"|I|I0003|Hierachie wurde aufgebaut und Summen ermittelt"}
	:let g:tmI0003["EN"] = "|I|I0003|Hierachy set up completed / calculating of sums completed"
	:let g:tmI0004 = {"T":"I","O":"A","DE":"|I|I0004|Proportionen wurden ermittelt und Hierachie angereichert"}
	:let g:tmI0004["EN"] = "|I|I0004|Proportion are calculated and hierachy are enriched"
	:let g:tmI0005 = {"T":"I","O":"A","DE":"|I|I0005|Rechteck wurde gezeichnet"}
	:let g:tmI0005["EN"] = "|I|I0005|Rectangle is drawn"
	:let g:tmI0006 = {"T":"I","O":"A","DE":"|I|I0006|Der Rahmen wurde gezeichnet"}
	:let g:tmI0006["EN"] = "|I|I0006|Frame is drawn"
	:let g:tmI0007 = {"T":"I","O":"A","DE":"|I|I0007|Jede Einheit bezieht sich auf eine übergerordnete Einheit"}
	:let g:tmI0007["EN"] = "|I|I0007|Every unit has only one parent"
:endf

" Object Rectangle {{{1
" returns an object of type rectangle
:function! treemap#rectangle (posx,posy,lenx,leny)
	:let rec = {}
	:let rec = {'x':a:posx,'y':a:posy,'lx':a:lenx,'ly':a:leny}
	" Daten aus Objekt rec holen
	" :let positionx = get(rec,'x')
	:return rec
:endf

" Read & Check Input Data {{{1
" data are read out of the window and return the values as a double list
" (matrix)
:function! treemap#readScreen(separator,area)
	
	:let notes = []
	:let err = 0
  
  :if a:area == 'block'  "input data are from a visual block
    :execute 'normal gv"ay'
    :let buffer = split(@a,"\n")
    " insert first line (headline)
    :let tmTemp = split(buffer[0],a:separator)
    :let tmHeadline = ""
    :let tmI = 0
    :for item in tmTemp
      :let tmI += 1
      :let tmHeadline = tmHeadline."Head"
      :if tmI < len(tmTemp)
        :if g:tmSeparator == "\\t"
          :let tmHeadline = tmHeadline."\t"   
        :else
          :let tmHeadline = tmHeadline.a:separator
        :endif
      :endif
    :endfor
    :call insert(buffer,tmHeadline,0)
  :else  " a:area == file
    :let buffer = getline(1,line("$"))
  :endif
  
  :let screen = []
	:let i = 0
	:for i in range(0,len(buffer)-1)
		
		:call add(screen,split(buffer[i],a:separator))

	:endfor
	:unlet i
	:unlet buffer
	
	:call treemap#checkInput(screen)

	:if (err == 0)
		:call add(notes,[g:tmI0002,""])
		
		:if g:tmVal2Active == "true"
			:call treemap#calculateVal2Average(screen)
		:endif
	:endif

	:call treemap#printMessage(notes)

	:if (err == 1)
		:call treemap#interruptRun(err)
	:endif
	
	:call treemap#fillMessage(notes)
		
	:unlet notes
	:unlet err
	
	:return screen

:endf

" calculate the average value of all val2 values and set global variable g:tmVal2Average
:function! treemap#calculateVal2Average(screen)

	:let sum = 0.00
	
	:let i = 0
	:for item in a:screen
		:if i == 0
			:let i += 1
		:else
			:let sum += item[len(item)-1]
		:endif
	:endfor
		
	:let g:tmVal2Average = sum / (len(a:screen)-1)
	
	:unlet sum

:endf

" checks about the read data of the screen
:function! treemap#checkInput(screen)
	:let notes = []
	:let err = 0
	:let layerNr = len(a:screen[0])
	:let err = 0

	:let i = 0
	:for i in range(0,len(a:screen)-1)
		
		:let li = i+1

		" are numbers of elements in every row correct?
		:try
			:if len(a:screen[i]) != layerNr
				:call add(notes,[g:tmE0001,"Zeile: ".li])
				:let err = 1
			:endif
		:catch /^Vim\%((\a\+)\)\=:E/
			:call add(notes,[g:tmE0001,"Zeile: ".li])
			:let err = 1
		:endtry

		" is in all rows the last column a value
		:try
			:if !(a:screen[i][layerNr-1] =~ str2nr(a:screen[i][layerNr-1]))
				:if i > 0
					:call add(notes,[g:tmE0003,"Zeile: ".li])
					:let err = 1
				:endif
			:endif
		:catch /^Vim\%((\a\+)\)\=:E/
			:let err = 1
		:endtry
		
		" is in all rows the column before the last column a value
		:if a:screen[1][layerNr-2] =~ str2nr(a:screen[i][layerNr-2])
			
			:let g:tmVal2Active = "true"

			:try
				:if !(a:screen[i][layerNr-2] =~ str2nr(a:screen[i][layerNr-2]))
					:if i > 0
						:call add(notes,[g:tmE0003,"Zeile: ".li])
						:let err = 1
					:endif
				:endif
			:catch /^Vim\%((\a\+)\)\=:E/
				:let err = 1
			:endtry
		:endif

		:unlet li
	:endfor
	:unlet i

	:call treemap#checkChildParentRelation(a:screen,g:tmVal2Active)
	
	:if (err == 0)
		:call add(notes,[g:tmI0001,""])
	:endif

	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)
	:call treemap#interruptRun(err)

	:unlet layerNr
	:unlet err
	
	:return notes
	
:endf

:function! treemap#checkChildParentRelation(matrix,val2Active)
	
	:let notes = []
	:let err = 0

	:if a:val2Active == "false"
		:let layerNr = len(a:matrix[0])-1
	:else
		:let layerNr = len(a:matrix[0])-2
	:endif

	:if layerNr > 1

		:let i = 1
		:for i in range(1,layerNr-1)
	
			:let column = layerNr-i	

			:let a = 0 
			:for item in a:matrix
			
				:if a == 0
					:let a = 1
					:continue
				:endif

				:let checkUnit = item[column]
				:let checkParent = item[column-1]
			
				:let b = 0
				:for unit in a:matrix
					:if b == 0
						:let b = 1
						:continue
					:endif
				
					:if unit[column] == checkUnit
						:if unit[column-1] != checkParent
							:let err = 1
							:call add(notes,[g:tmE0005,checkUnit." - ".checkParent])
						:endif
					:endif

				:endfor
				:unlet b


			
			:endfor
			:unlet a

			:let i += 1
		:endfor
		:unlet i

	:endif
	
	:if err == 0
		:call add(notes,[g:tmI0007,""])
	:endif

	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)
	:call treemap#interruptRun(err)
:endf

" units list: entries are dictioniaries: layer, description, value, sum
:function! treemap#createHierachy(screen)
	
	:let notes = []
	:let err = 0

	:let hierachy = []
	:let layerNr = len(a:screen[0])
	:if g:tmVal2Active == "true"
		:let diff = 3
	:else
		:let diff = 2
	:endif

	:let i = 0
	:for i in range(0,layerNr-diff)
		
		:let layerElements = treemap#groupBy(a:screen,i)
		:let a = 0	
		:for a in range(0,len(layerElements)-1)
			:let entry = {}
	
			:let entry = {"layer":i,"desc":layerElements[a][0],"parent":layerElements[a][1]}
			
			" add value column 2 to last layer entries
			:if g:tmVal2Active == "true"
				:if entry.layer == layerNr-3
					:let entry["val2"] = treemap#getVal2(a:screen,entry.desc)
				:endif
			:endif
						
			:let sum = treemap#calculateSum(layerElements[a][0],a:screen,i)
			:let entry["sum"] = sum
			:unlet sum

			:call add(hierachy,entry)
			
			:unlet entry
		:endfor
		:unlet a
		:unlet layerElements
	:endfor
	:unlet i

	:if (err == 0)
		:call add(notes,[g:tmI0003,""])
	:endif

	:if (err == 1)
		:call treemap#interruptRun(err)
	:endif
	
	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)

	:unlet notes
	:unlet err
	:unlet layerNr
	:unlet diff

	:let hierachy = treemap#enrichProportion(hierachy)

	:let g:tmTrHier = hierachy
	
	:return hierachy

:endf

:function! treemap#getVal2(screen,lastLayerDesc)
	
	:let val2 = 0.00
	:let layerNr = len(a:screen[1])-3
	
	:if !exists("a:screen[1][layerNr+2")
		
		:for item in a:screen
			
			:if item[layerNr] == a:lastLayerDesc
				:let val2 = item[layerNr+2] + 0.00
			:endif

		:endfor
	:endif
	:unlet layerNr
	
	:return val2	

:endf

:function! treemap#reorgHierachy(hierachy)

	:let layerNr = treemap#getLayerNr(a:hierachy)
	:let collector = []

	:let i = 0
	:for i in range(0,layerNr-1)

		:let parents = treemap#getAllParentsPerLayer(a:hierachy,i)
		
		:let container = {}
		:for p in parents
			:let container[p] = []
		:endfor

		:for item in a:hierachy
			
			:if item.layer == i
				
				:for unit in parents
					
					:if item.parent == unit || (item.parent == "" && unit == 'FRAME')

						:call add(container[unit],item)

					:endif
				:endfor


			:endif

		:endfor
		
		:call add(collector,container)

		:unlet container

	:endfor
	:unlet i
	
	:let i = layerNr-1
	:while i > 0
		
		:for key in keys(collector[i])
			
			:for item in collector[i][key]
				:if i == item.layer
					:if !exists("item.childs")
						:let item["childs"] = []
					:endif		
					:for key2 in keys(collector[i-1])
					
						:for pa in collector[i-1][key2]
							:if !exists("pa.childs")
								:let pa["childs"] = []
							:endif
							:if item.parent == pa.desc

								:call add(pa["childs"],item)
							:endif

						:endfor

					:endfor
				:endif
			:endfor
		
		:endfor

		:let i -= 1
	:endwhile
	:unlet i	
	
	:let collector2 = collector[0].FRAME

	:for item in collector2
		:if !exists("item.childs")
			:let item["childs"] = []
		:endif	
	:endfor

	:return collector2
	
:endf

" Functions Utilities {{{1
:function! treemap#getAllParentsPerLayer(hierachy,layerNr)

	:let parents = []

	:for item in a:hierachy
		:if item.layer == a:layerNr
			:let exists_ = ""
			:for p in parents
				:if p == item.parent
					:let exists_ = 'X'
					:break
				:endif
			:endfor
			:if exists_ != "X"
				:call add(parents,item.parent)
			:endif
		:endif
	:endfor
	
	:if parents[0] == ""
		:let parents[0] = "FRAME"
	:endif

	:return parents
:endf

:function! treemap#getDescEntry(p,hierachy)

	:for item in a:hierachy
		:if item.desc == a:p
			:let entry = item
		:endif	
	:endfor

	:return entry
:endf

:function! treemap#getParents(hierachy,layerNr)
	
	:let temp = []
	:let parents = []

	:for item in a:hierachy
		:if item.layer == a:layerNr
			:call add(temp,item)
		:endif
	:endfor
	
	:let parentTemp = ''
	:let exist = ''
	:for unit in temp
		:let parentTemp = unit.desc
		:for p in parents
			:if p == parentTemp
				:let exist = 'X'
			:endif				
		:endfor

		:if exist != 'X'
			:call add(parents,parentTemp)
		:endif
		:let exist = ''
	:endfor

	:return parents
:endf



" break run when an error occur
:function! treemap#interruptRun(err)
	:let notes = []

	:if a:err == 1
		:call add(notes,[g:tmE0002,""])
		:call treemap#fillMessage(notes)
		:call treemap#printMessage(notes)
		:let g:tmErr = 1
		:sleep 5
		:throw "oops"
		":exit
	:endif

	:unlet notes
:endf

" print protocol messages
:function! treemap#printMessage(notes)

	:let language = $LANG
	
	:let i = 0
	:for i in range(0,len(a:notes)-1)
		:if language == "DE" || language == "de" || strpart(language,0,2) == "DE" || strpart(language,0,2) == "de"
			:if a:notes[i][0].T == "E"
				echohl = ErrorMsg | echom a:notes[i][0].DE ." / ". a:notes[i][1] | echohl = None
			:elseif g:tmVerbose == 1
				echom a:notes[i][0].DE ." ". a:notes[i][1]
			:endif
		:else
			:if a:notes[i][0].T == "E"
				echohl = ErrorMsg | echom a:notes[i][0].EN ." / ". a:notes[i][1] | echohl = None
			:elseif g:tmVerbose == 1
				echom a:notes[i][0].EN ." ". a:notes[i][1]
			:endif
		:endif
	:endfor
	:unlet i
	:unlet language

:endf

" delete double entries in a column of a list (matrix)
:function! treemap#groupBy(buffer,column)
	
	:let output = []
	:let outputAll = []
	
	:let i = 1
	:for i in range(1,len(a:buffer)-1)
		
		:let exists = " "
			
		:let a = 0
		:for a in range(0,len(output)-1)
			:if (a:buffer[i][a:column] == output[a])
				:let exists = "X"
				:break
			:endif
		:endfor
		:unlet a
		
		:let parentID = 0
		:if a:column > 0
			let parentID = a:column-1
		:endif

		
		:if exists != "X"
			:if a:column > 0
				:call add(output,a:buffer[i][a:column])
				:call add(outputAll,[a:buffer[i][a:column],a:buffer[i][parentID]])
			:else
				:call add(output,a:buffer[i][a:column])
				:call add(outputAll,[a:buffer[i][a:column],''])
			:endif
		:endif

		:unlet exists
		
	:endfor
	:unlet i
	:unlet output
	
	:return outputAll
:endf

" calculate sum the element of a layer X
:function! treemap#calculateSum(element,matrix,column)

	:if g:tmVal2Active == 'true'
		:let diff = 2
	:else
		:let diff = 1 
	:endif

	:let sum = 0.00000
	:let layerNr = len(a:matrix[0])
	:let z = 0
	:for z in range(0,len(a:matrix)-1)
		:if a:matrix[z][a:column] == a:element
			let sum += a:matrix[z][layerNr-diff]
		:endif
	:endfor
	:unlet z
	:unlet diff

	:return sum
:endf

" enrich hierarchy data with the proportion
:function! treemap#enrichProportion(hierachy)
	
	:let notes = []
	:let err = 0

	"calculate sum
	":for key in keys(a:hierachy)
	"	:
	":endfor
	
	:let sum = 0.0
	:let item = {}
	:for item in a:hierachy
		:if item.layer == 0
			:let sum += item.sum	
		:endif
	:endfor
	:unlet item

	" calculate proportion and enrich data
	:let i = 0
	:for i in range (0,len(a:hierachy)-1)

		:let prop = a:hierachy[i].sum * 100 / sum
		:let a:hierachy[i]["prop"] = prop
		:let pt = g:tmPt * prop / 100
		:let a:hierachy[i]["pt"] = pt

		:unlet prop
		:unlet pt
	:endfor
	:unlet i

	:if (err == 0)
		:call add(notes,[g:tmI0004,""])
	:endif

	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)
	:call treemap#interruptRun(err)

	:unlet err
	:unlet notes

	return a:hierachy
:endf

:function! treemap#fillMessage(notes)
	
	:if !empty(a:notes)
		:for note in a:notes
			:call add(g:tmMess,note)
		:endfor
	:endif

:endf

" determine the number of layers
:function! treemap#getLayerNr(hierachy)

	:if g:tmLNr == 0	

		:let max = 0

		:for item in a:hierachy
			:if item.layer > max
				:let max = item.layer
			:endif
		:endfor

		:let g:tmLNr = max+1
	
	:endif
	
	:return g:tmLNr

:endf

" determine the layer number of a special entry
:function! treemap#getLayerNrDesc(desc,hierachy)

	:let layer = -1

	:for item in a:hierachy
		:if item.desc == a:desc
			:let layer = item.layer
			:break
		:endif
	:endfor

	:call add(g:tmLayNrs,a:desc.': '.layer)
	:return layer
:endf

" Print all messages from g:tmMess
:function! treemap#printAllMessages(messages,lang)

  :let tmLang = toupper(strpart(a:lang,0,2))

	:if tmLang == 'DE' || tmLang == 'EN'
		:tabnew
		:let i = 0
		:for item in a:messages
			:let i += 1
			:call setline(i,item[0][tmLang].' / '.item[1])
		:endfor
		:unlet i
	:else
    :tabnew
    :let i = 0
		:for item in a:messages
			:let i += 1
			:call setline(i,item[0]['EN'].' / '.item[1])
		:endfor
		:unlet i
	:endif

:endf

" Check if this VIM is insatlled on Windows or a LINUX System
:function! treemap#tmIsWin()
  :return has("win32") || has("win64") || has("win95") || has("win16")
:endf

" Print Treemap {{{1
" Draw Frame
:function! treemap#drawFrame(column,line)
	
	:let notes = []
	:let err = 0	

	:if (g:tmX > 1) && (g:tmY > 1)

		:call setpos(".",[0,a:line,1,0])

		:let a = 0
		:for a in range (0,g:tmY+1)
			:execute "normal i\<ENTER>\<ESC>"
			:execute "normal k"	
			:let i = 0
			:for i in range (0,g:tmX+1+a:column)
				:execute "normal i \<ESC>" 
			:endfor
			:unlet i
		
		:endfor
		:unlet a
	
		:let frame = treemap#rectangle(a:column,a:line,g:tmX,g:tmY)
		:let frame.title = 'FRAME'
	
		:call treemap#drawRectangle(frame)
	:else
		:call add(notes,[g:tmE0004,""])
		:let err = 1
	:endif
	
	:if (err == 0)
		:call add(notes,[g:tmI0006,""])
	:endif

	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)
	:call treemap#interruptRun(err)

	:unlet err
	:unlet notes
	
:endf

" Draw a rectangle
:function! treemap#drawRectangle(rec)

	:let notes = []
	:let err = 0

	:if (a:rec.lx > 1) && (a:rec.ly > 1)
	
		" set corner points
		:call setpos(".",[0,a:rec.y,a:rec.x,0])
		:execute "normal r+\<Esc>"
		:call setpos(".",[0,a:rec.y,a:rec.x+a:rec.lx-1,0])
		:execute "normal r+\<Esc>"
		:call setpos(".",[0,a:rec.y+a:rec.ly-1,a:rec.x,0])
		:execute "normal r+\<Esc>"
		:call setpos(".",[0,a:rec.y+a:rec.ly-1,a:rec.x+a:rec.lx-1,0])
		:execute "normal r+\<Esc>"

		" set description
		:let i = 1
		:for i in range(1,strlen(a:rec.title)) 
			:call setpos(".",[0,a:rec.y+1,a:rec.x+i,0])
			:execute "normal r".strpart(a:rec.title,i-1,1)."\<Esc>"
		:endfor
		:unlet i

		" paint horizontal 1
		:let i = 1
		:for i in range(1,a:rec.lx-2)
			:call setpos(".",[0,a:rec.y,a:rec.x+i,0])
			:execute "normal r-\<Esc>"
		:endfor
		:unlet i
		:redraw
		":call input("Type [ENTER] to go further")

		" paint vertical 1
		:let i = 1
		:for i in range(1,a:rec.ly-2)
			:call setpos(".",[0,a:rec.y+i,a:rec.x,0])
			:execute "normal r|\<Esc>"
		:endfor
		:unlet i
		:redraw
		":call input("Type [ENTER] to go further")

		" paint horizontal 2
		:let i = 1
		:for i in range(1,a:rec.lx-2)
			:call setpos(".",[0,a:rec.y+a:rec.ly-1,a:rec.x+i,0])
			:execute "normal r-\<Esc>"
		:endfor
		:unlet i
		:redraw
		":call input("Type [ENTER] to go further")

		" paint vertical 2
		:let i = 1
		:for i in range(1,a:rec.ly-2)
			:call setpos(".",[0,a:rec.y+i,a:rec.x+a:rec.lx-1,0])
			:execute "normal r|\<Esc>"
		:endfor
		:unlet i
		:redraw
		":call input("Type [ENTER] to go further")

		:redraw

	:else
		:call add(notes,[g:tmW0001,a:rec.title])
	:endif
	
	:if (err == 0)
		:call add(notes,[g:tmI0005,a:rec.title])
	:endif

	:call treemap#fillMessage(notes)
	:call treemap#printMessage(notes)
	:call treemap#interruptRun(err)

	:unlet err
	:unlet notes

:endf

" SVG Output
:function! treemap#drawRectanglesSVG(rectangles)

	" HTML part 1	
	:call setline(1,'<?xml version="1.0" encoding="ISO-8859-1"?>')
	:call setline(2,'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de">')
	:call setline(3,'<head>')
	:call setline(4,'<title>'.g:tmTitle.'</title>')
	:call setline(5,'</head>')
	:call setline(6,'<body>')
	:call setline(7,'<h1>'.g:tmTitle.'</h1>')

	" SVG
	":call setline(8,'<?xml version="1.0" encoding="ISO-8859-1" standalone="no" ?>')
	":call setline(9,'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">')
	:call setline(8,'<svg width="'.g:tmX.'" height="'.g:tmY.'" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">')
	:call setline(9,'<title>'.g:tmTitle.'</title>')
	:call setline(10,'<desc>powered by TREEMAP VIM PLUGIN</desc>')
	
	:let i = 11
	:for item in a:rectangles
		:if (item.lx > 1) && (item.ly > 1)
			:call setline(i,'<rect x="'.item.x.'" y="'.item.y.'" width="'.item.lx.'" height="'.item.ly.'" fill="'.item.fill.'" stroke="black" />')
			:let i+= 1
			:let p1 = item.x+10
			:let p2 = item.y+20
			:call setline(i,'<text x="'.p1.'" y="'.p2.'" fill="black">'.item.title.'</text>')
			:unlet p1
			:unlet p2
			:let i+= 1
		:endif

	:endfor

	:call setline(i,'</svg>')

	" HTML part 2
	:call setline(i+1,'</body>')
	:call setline(i+2,'</html>')

	:unlet i
	
:endf

" Save and open SVG treemap in a web browser
:function! treemap#tmOpenSVG()
  
  :let tmIsWin = treemap#tmIsWin()

  :if tmIsWin == 1
    :let tmDirSep = '\'
  :else
    :let tmDirSep = '/'
  :endif

  :if @% == ""
  
    :let tmDirName = $HOME.tmDirSep.'treemaps'

    :if isdirectory($HOME.tmDirSep.'treemaps') == 0
      :let tmCreateDir = input('Create folder '.$HOME.tmDirSep.'treemaps [y/n]:')
      :if tmCreateDir == "y" || tmCreateDir == "Y"
        :call mkdir(tmDirName,"p")
        :let tmFileNr = 1
      :endif
    :else
       :let tmFiles = split(globpath(tmDirName,'*.htm'),'\n')
       :let i = 0
       :if !empty(tmFiles)
         :for i in range(0,len(tmFiles)-1)
           :let tmPos1 = match(tmFiles[i],"treemap_") + 7
           :let tmPos2 = match(tmFiles[i],".htm") - tmPos1 - 1
           :let tmTempFileNr = strpart(tmFiles[i],tmPos1+1,tmPos2) + 1
           :if !exists('tmFileNr')
             :let tmFileNr = tmTempFileNr
           :else
             :if tmTempFileNr > tmFileNr
               :let tmFileNr = tmTempFileNr
             :endif
           :endif
           :let i += 1
         :endfor
       :else
         :let tmFileNr = 1
       :endif
"      :let tmDeleteFile = $HOME.tmDirSep.'treemaps'.tmDirSep.'treemap.htm'
"      :let tmDeleteFile = substitute(tmDeleteFile,':\\',':/','g')
"      :let tmDeleteFile = substitute(tmDeleteFile,'\','/','g')
"      :let tmIsDeleted = delete(tmDeleteFile)
    :endif
      :if isdirectory($HOME.tmDirSep.'treemaps') == 1
        :let tmFileName = $HOME.tmDirSep.'treemaps'.tmDirSep.'treemap_'.tmFileNr.'.htm'
        :execute "w! ".tmFileName
      :endif
  :else
    :let tmFileName = expand(@%)
  :endif
  :if isdirectory($HOME.tmDirSep.'treemaps') == 1 " && executable(tmFileName)
      :let tmTempOpenFile = substitute(tmFileName,':\\',':/','g')
      :let tmOpenFile = substitute(tmTempOpenFile,'\\','/','g')
      :if treemap#tmIsWin()
        :execute 'silent ! start "Title" /b "file:///'.tmOpenFile.'"'
      :else
        :call system('xdg-open ' . shellescape(tmOpenFile, 1).' &')
      :endif
  :endif
:endf

" Delelete all treemap files in the HOME-Treemaps directory
:function! treemap#tmClearTreemapDir()
  
  :let tmIsWin = treemap#tmIsWin()

  :if tmIsWin == 1
    :let tmDirSep = '\'
  :else
    :let tmDirSep = '/'
  :endif
  
  :let tmDirName = $HOME.tmDirSep.'treemaps'
  :let tmDirName = substitute(tmDirName,'\\\\','\\','g')
  :if isdirectory(tmDirName) == 1
    :let tmFiles = split(globpath(tmDirName,'*.htm'),'\n')
    :if !empty(tmFiles)
      :let i = 0
      :for item in tmFiles
        :call delete(tmFiles[i])
        :let i+= 1
      :endfor
    :endif
    :let tmFiles = split(globpath(tmDirName,'*.htm~'),'\n')
    :if !empty(tmFiles)
      :let i = 0
      :for item in tmFiles
        :call delete(tmFiles[i])
        :let i+= 1
      :endfor
    :endif
  :endif
:endf

" Main Function {{{1
" main function to run the treemap algorithm
:function! treemap#main(output,separator)
	
	:call treemap#initialize()
	
	:let g:tmCIndex = 0

	" Output = VIM / set frame variables
	:if a:output == 'VIM'
		:if exists("g:tmUx") && exists("g:tmUy")
			:let g:tmX = g:tmUx
			:let g:tmY = g:tmUy
		:else
			:let g:tmX = 70
			:let g:tmY = 25
		:endif
		:let g:tmPt = g:tmX * g:tmY
	:endif

	" Output = SVG / set frame variables
	:if a:output == 'SVG'
		:if exists("g:tmUx") && exists("g:tmUy")
			:let g:tmX = g:tmUx
			:let g:tmY = g:tmUy
		:else
			:let g:tmX = 1024
			:let g:tmY = 768
		:endif
		:let g:tmPt = g:tmX * g:tmY
	:endif
	
	:let screen = treemap#readScreen(a:separator,"file")
	:let hier = treemap#createHierachy(screen)
	:let nestedHier = treemap#reorgHierachy(hier)
	:let recs = treemap#sliceAndDice(nestedHier)
	:tabnew

	" Output = VIM / print rectangles (text)
	:if a:output == 'VIM'
		
		:call treemap#drawFrame(1,1)
		:for item in recs
			:call treemap#drawRectangle(item)
		:endfor

		:execute "normal" "gg"
		:execute "normal" "O"
		:call setline(1,g:tmTitle)
		
	:endif

	" Output = SVG / print rectangles SVG
	:if a:output == 'SVG'
		:call treemap#drawRectanglesSVG(recs)
	:endif

:endf

" Only create the rectangles of a treemap, but don't print it
:function! treemap#create(separator)
	
  "set width and height
  :if g:tmOutput == 'VIM'
		:if exists("g:tmUx") && exists("g:tmUy")
			:let g:tmX = g:tmUx
			:let g:tmY = g:tmUy
		:else
			:let g:tmX = 70
			:let g:tmY = 25
		:endif
		:let g:tmPt = g:tmX * g:tmY
	:endif

	" Output = SVG / set frame variables
	:if g:tmOutput == 'SVG'
		:if exists("g:tmUx") && exists("g:tmUy")
			:let g:tmX = g:tmUx
			:let g:tmY = g:tmUy
		:else
			:let g:tmX = 1024
			:let g:tmY = 768
		:endif
		:let g:tmPt = g:tmX * g:tmY
	:endif

  :call treemap#initialize()

  :let notes = []
  :let err = 0

  " check if a visual-block is active
  :if char2nr(visualmode()) != 22 && visualmode() != 'v'
    :call add(notes,[g:tmE0006,""])
    :let err = 1
    :call treemap#fillMessage(notes)
	  :call treemap#printMessage(notes)
  	:call treemap#interruptRun(err)
  :endif

  :let screen = treemap#readScreen(a:separator,"block")
	:let hier = treemap#createHierachy(screen)
	:let nestedHier = treemap#reorgHierachy(hier)
	:let recs = treemap#sliceAndDice(nestedHier)
	
  " Save the calculated rectangles to the clipboard
  :let g:tmClipboard = recs
  :let g:tmClipSize = {'x':g:tmX,'y':g:tmY}

:endf

" draw the treemap at the position of your cursor
:function! treemap#draw(output)

  :let notes = []
  :let err = 0

  :call treemap#initialize()

  :if empty(g:tmClipboard) || empty(g:tmClipSize)
    :call add(notes,[g:tmE0007,""])
    :let err = 1
    :call treemap#fillMessage(notes)
	  :call treemap#printMessage(notes)
  	:call treemap#interruptRun(err)
  :endif

  :let s:tmRecs = []

  " read width and height from g:tmClipSize
  :let g:tmX = g:tmClipSize.x
  :let g:tmY = g:tmClipSize.y
  :let s:tmRecs = deepcopy(g:tmClipboard)

  " Output = VIM / print rectangles (text)
	:if a:output == 'VIM'
	
    :let s:tmPos = getpos(".")
    :let s:lnum = s:tmPos[1]
    :let s:col = s:tmPos[2]

		:call treemap#drawFrame(s:col,s:lnum)
		:for item in s:tmRecs
      :let item.x = item.x + s:col-1
      :let item.y = item.y + s:lnum-1
			:call treemap#drawRectangle(item)
		:endfor

	:endif

	" Output = SVG / print rectangles SVG
	:if a:output == 'SVG'
    :tabnew
		:call treemap#drawRectanglesSVG(g:tmClipboard)
	:endif

:endf

" Calculate the Rectangles {{{1
" Treemap algorithm Slice and Dice
:function! treemap#sliceAndDice(hierachy)
	
	:let rectangles = []
	:let root = treemap#rectangle(1,1,g:tmX,g:tmY)
	:let root.title = 'FRAME'
	:let root.fill = ''
	:let root.layer = -1

	:let recs = treemap#getRectangles(root,a:hierachy)

	:for t in recs
		:call add(rectangles,t)
	:endfor
	
	:return rectangles
	
:endf

:function! treemap#getRectangles(root,hierachy)
	
	:let rectangles = []
	
	:let recs = treemap#getSubRectangles(a:root,a:hierachy)
	
	:for t in recs
		:call add(rectangles,t)
	:endfor

	:for item in a:hierachy
		:let unit = []
		:let unit = treemap#getChilds(item.desc,a:hierachy)
		
		:if !empty(unit)
			
			:let recRoot = treemap#getRootRectangle(item.desc,rectangles)
			":echo 'Root Rectangle// Laenge: '.recRoot.lx.'  Hoehe: '.recRoot.ly
			:let r = treemap#getRectangles(recRoot,unit)
	
			:for re in r
				:call add(rectangles,re)
			:endfor
		:endif

	:endfor

	:return rectangles
:endf

:function! treemap#getRootRectangle(desc,rectangles)
	
	:let recRoot = {}
	:let hit = ''

	:for re in a:rectangles
		:if hit == 'X'
			:break
		:endif
		
		:if re.title == a:desc
			:let recRoot = re
			:let hit = 'X'
		:endif
	:endfor

	:return recRoot

:endf

:function! treemap#getChilds(unit,hierachy)

	:let collector = []

	:for item in a:hierachy
		:for it in item.childs
	"	:echo a:unit
			:if it.parent == a:unit
				:call add(collector,it)
	"			:echo 'Child: '.it.desc
			:endif
		:endfor
	":echo '***************'
	:endfor
	":echo '***********************************************'

	:return collector
	
:endf

" Get Hierachy Entry or FRAME
:function! treemap#getHierachyEntry(unit,hierachy)

	:let collector = {}
	:let sum = 0

	:for item in a:hierachy
		:if a:unit == 'FRAME'
			
			:let collector['desc'] = 'FRAME'

			:for it in a:hierachy
				:if it.layer == 0
					:let sum += it.sum
				:endif
			:endfor
			:let collector['sum'] = sum 
			:break
		:endif
		:if item.desc == a:unit
			:let collector = item
			:break
		:endif

	:endfor

	:return collector
	
:endf

" determine the sub rectangles / Slice and Dice
:function! treemap#getSubRectangles(root,childs)

	:let resultList = []
	:let rect = {}
	:let width = 0
	:let actual = 0
	:let layer = treemap#getLayerNrDesc(a:childs[0].desc,a:childs)
	
	:let rootHier = treemap#getHierachyEntry(a:root.title,g:tmTrHier)

	:if a:root.ly > a:root.lx
		
		:let width = a:root.lx-2
		
		:for child in a:childs
			
			" determine Color
			:let rFill = ''
			:let val2 = 0
			:if g:tmVal2Active == 'true'
				:if child.layer == treemap#getLayerNr(g:tmTrHier)-1
					:let val2 = child.val2
				:endif
			:endif
			:let rFill = treemap#getColor(val2,a:root.layer,child.layer)
			
			:let rect = {}
			:let rect.x = a:root.x+1
			:let rect.y = a:root.y+actual+1
			:let rect.lx = width
			:let rect.ly = float2nr(round((a:root.ly-2.00)*((child.sum*100.00)/rootHier.sum)/100.00))
			:let actual = actual + rect.ly
			:let rect.title = child.desc
			:if rFill == ''
				:if g:tmVal2Active == 'true'
					:let rect.fill = 'white'
				:else
					:let rect.fill = a:root.fill
				:endif
			:else
				:let rect.fill = rFill
			:endif
			:let rect.layer = child.layer
			:call add (resultList, rect)
		:endfor
		:let actual = 0
		
	:else

		:let hight = a:root.ly-2

		:for child in a:childs

			" determine Color
			:let rFill = ''
			:let val2 = 0
			:if g:tmVal2Active == 'true'
				:if child.layer == treemap#getLayerNr(g:tmTrHier)-1
					:let val2 = child.val2
				:endif
			:endif
			:let rFill = treemap#getColor(val2,a:root.layer,child.layer)
			
			:let rect = {}
			:let rect.y = a:root.y+1
			:let rect.x = a:root.x+actual+1
			:let rect.ly = hight
			:let rect.lx = float2nr(round((a:root.lx-2.00)*((child.sum*100.00)/rootHier.sum)/100.00))
			:let actual = actual + rect.lx
			:let rect.title = child.desc
			:if rFill == ''
				:if g:tmVal2Active == 'true'
					:let rect.fill = 'white'
				:else
					:let rect.fill = a:root.fill
				:endif
			:else
				:let rect.fill = rFill
			:endif
			:let rect.layer = child.layer
			:call add (resultList, rect)
		:endfor
		:let actual = 0

	:endif

	:unlet actual
	:unlet rFill
	:unlet width
	:unlet layer
	:unlet rootHier
	:unlet rect

	:return resultList
:endf

" Colorization
:function! treemap#getColor(val2,rootLayer,childLayer)

	:let fillColor = ''
	
	" heat map
	:if g:tmVal2Active == 'true' && a:childLayer == treemap#getLayerNr(g:tmTrHier)-1
		:let fillColor = g:tmColor[1]
		:if a:val2 < g:tmVal2Average - (g:tmVal2Average * g:tmVal2Interval / 100)
			:let fillColor = g:tmColor[0]
		:elseif a:val2 > g:tmVal2Average + (g:tmVal2Average * g:tmVal2Interval / 100)
			:let fillColor = g:tmColor[2]
		:else
			:let fillColor = g:tmColor[1]
		:endif
	" one color for one layer 1 entry
	:elseif g:tmVal2Active == 'false'
		:if a:rootLayer == -1
			:let fillColor = g:tmColor[g:tmCIndex]
			:if g:tmCIndex < len(g:tmColor)-1
				:let g:tmCIndex += 1
			:else
				:let g:tmCIndex = 0
			:endif
		:endif
	:else
		:let fillColor = ''
	:endif


	:return fillColor

:endf
