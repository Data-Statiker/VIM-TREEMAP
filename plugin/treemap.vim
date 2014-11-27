"  treemap.vim: (plugin) Creates a treemap in a new tab
"  Last Change: Thu Nov 21 6:31 PM 2014 MET
"  Author:	Data-Statiker
"  Maintainer:  Data-Statiker
"  Version:     0.7, for Vim 7.4+

"  New:
"  Version 0.7:
"  *	In version 0.7 the output paramater is created for the function
"  	treemap#main(). The paramater output could have the values "VIM" or
"  	"SVG".
"  	VIM: Rectangles are created in a new tab with the signs "-", "|" and "+" 
"  	SVG: Rectangles are descripted in a SVG structure imbedded in a html
"  	file 
"  *	New function treemap#initialize for initializing global variables
"  *	New parameter separator for the method treemap#main(). So the input
"  	file could be separated by ";" or "\t" (tab) or any other signs. The values
"  	of these parameter are for example:
"  	;	for semicolon separated files
"  	\t	for tabulator separated files
"  	Examples: :call treemap#main('VIM',';')
"  		  :call treemap#main('SVG','\t')
"  *	Insert 'throw "oops"' in treemap#interruptRun() so the program stops
"	in case of error	
"  *	Create the menu "Plugin - Treemap" tor run the script and set the
"	variables g:separator, g:output, g:color
"
"  Version 0.6:
"  *	Delete not used methods "treemap#reorgHierachy" and "treemap#reorgHierachy2" with
"  	all sub methods
"  *	Rename method "treemap#reorgHierachy3" to "treemap#reorgHierachy"
"  *	Add a second value column. This value is represented in the treemap through
"  	colors (Heat Map). Only SVG-Output. If ther is no val 2 column, the layer 1
"  	entries define the color of their childs
"  
"  Version 0.5:
"  *	In version 0.5 the rekursive method "treemap#reorgHierachy2" is substitute
"  	through the iterative method "treemap#reorgHierachy3"
"  *	SVG-Output with fill color

" TODO
" Check:	In every column it is only allowed that one description apears one time
" Output:	In case of SVG and value 2 columns: More Colors

" Useful commands
" tabpagenr()
" &tabpagemax

" fill colors for Rectangles
:let g:color = ['blue','grey','red']

" initialize g:separator
:let g:separator = "\\t"

" initialize g:output
:let g:output = 'VIM'

" initialize global variables
:function! treemap#initialize()
	" frame data
	":let g:x = 230
	":let g:y = 65
	:let g:x = 1024
	:let g:y = 768
	:let g:pt = g:x * g:y

	" val2 average and interval values / is val2 active or not
	:let g:val2active = "false"
	:let g:val2Average = 0.00
	:let g:val2Interval = 20.00

	" fill colors for Rectangles color index
	:let g:cIndex = 0

	" number of layers
	:let g:lNr = 0

	" actual tabpage
	:let g:tabMain = tabpagenr()

	" list for warnings and errors
	:let g:mess = []
	:let g:err = 0

	" verbose - all messenges are displayed
	:let g:verb = 0

	" Hierachy flach
	:let g:trHier = []

	" Definition of errors, informations and warnings
	" Errors
	:let g:E0001 = {"T":"E","O":"A","DE":"|E|E0001|Anzahl Ebenen nicht korrekt"}
	:let g:E0001["EN"] = "|E|E0001|Number of layers are incorrect"
	:let g:E0002 = {"T":"E","O":"A","DE":"|E|E0002|Das Programm musste aufgrund eines Fehlers abgebrochen werden"}
	:let g:E0002["EN"] = "|E|E0002|The program was interupted cause of errors"
	:let g:E0003 = {"T":"E","O":"A","DE":"|E|E0003|Der letzte Eintrag ist kein numerischer Wert"}
	:let g:E0003["EN"] = "|E|E0003|The last entry is no numeric value"
	:let g:E0004 = {"T":"E","O":"A","DE":"|E|E0004|Der Rahmen ist zu klein"}
	:let g:E0004["EN"] = "|E|E0004|Frame is too small"
	" Warnings
	:let g:W0001 = {"T":"W","O":"A","DE":"|W|W0001|Das Rechteck wird nicht gezeichnet, da Fläche zu gering"}
	:let g:W0001["EN"] = "|W|W0001|The rectangle is not drawn because the area is too low"
	" Informations
	:let g:I0001 = {"T":"I","O":"A","DE":"|I|I0001|Die Inputparameter sind korrekt"}
	:let g:I0001["EN"] = "|I|I0001|Input paramter are correct"
	:let g:I0002 = {"T":"I","O":"A","DE":"|I|I0002|Die Parameter wurden erfolgreich eingelesen"}
	:let g:I0002["EN"] = "|I|I0002|Parameter read successfull"
	:let g:I0003 = {"T":"I","O":"A","DE":"|I|I0003|Hierachie wurde aufgebaut und Summen ermittelt"}
	:let g:I0003["EN"] = "|I|I0003|Hierachy set up completed / calculating of sums completed"
	:let g:I0004 = {"T":"I","O":"A","DE":"|I|I0004|Proportionen wurden ermittelt und Hierachie angereichert"}
	:let g:I0004["EN"] = "|I|I0004|Proportion are calculated and hierachy are enriched"
	:let g:I0005 = {"T":"I","O":"A","DE":"|I|I0005|Rechteck wurde gezeichnet"}
	:let g:I0005["EN"] = "|I|I0005|Rectangle is drawn"
	:let g:I0006 = {"T":"I","O":"A","DE":"|I|I0006|Der Rahmen wurde gezeichnet"}
	:let g:I0006["EN"] = "|I|I0006|Frame is drawn"
:endf

" go to a special tab(page)
:function! treemap#gotoTab(nr)
	:tabfirst
	:let i = 0
	:for i in range (0,a:nr-2)
		:tabnext
		" :echo i
	:endfor
	:unlet i
:endf

" returns an object of type rectangle
:function! treemap#rectangle (posx,posy,lenx,leny)
	:let rec = {}
	:let rec = {'x':a:posx,'y':a:posy,'lx':a:lenx,'ly':a:leny}
	" Daten aus Objekt rec holen
	" :let positionx = get(rec,'x')
	:return rec
:endf

" units list: entries are dictioniaries: layer, description, value, sum
:function! treemap#createHierachy(screen)
	
	:let notes = []
	:let err = 0

	:let hierachy = []
	:let layerNr = len(a:screen[0])
	:if g:val2active == "true"
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
			:if g:val2active == "true"
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
		:call add(notes,[g:I0003,""])
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

	:let g:trHier = hierachy
	
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

" data are read out of the window and return the values as a double list
" (matrix)
:function! treemap#readScreen(separator)
	
	:let notes = []
	:let err = 0

	:let buffer = getline(1,line("$"))
	:let screen = []
	:let i = 0
	:for i in range(0,len(buffer)-1)
		
		:call add(screen,split(buffer[i],a:separator))

	:endfor
	:unlet i
	:unlet buffer
	
	:call treemap#checkInput(screen)

	:if (err == 0)
		:call add(notes,[g:I0002,""])
		
		:if g:val2active == "true"
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

" calculate the average value of all val2 values and set global variable g:val2Average
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
		
	:let g:val2Average = sum / (len(a:screen)-1)
	
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
				:call add(notes,[g:E0001,"Zeile: ".li])
				:let err = 1
			:endif
		:catch /^Vim\%((\a\+)\)\=:E/
			:call add(notes,[g:E0001,"Zeile: ".li])
			:let err = 1
		:endtry

		" is in all rows the last column a value
		:try
			:if !(a:screen[i][layerNr-1] =~ str2nr(a:screen[i][layerNr-1]))
				:if i > 0
					:call add(notes,[g:E0003,"Zeile: ".li])
					:let err = 1
				:endif
			:endif
		:catch /^Vim\%((\a\+)\)\=:E/
			:let err = 1
		:endtry
		
		" is in all rows the column befor the last column a value
		:if a:screen[1][layerNr-2] =~ str2nr(a:screen[i][layerNr-2])
			
			:let g:val2active = "true"

			:try
				:if !(a:screen[i][layerNr-2] =~ str2nr(a:screen[i][layerNr-2]))
					:if i > 0
						:call add(notes,[g:E0003,"Zeile: ".li])
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
	
	:if (err == 0)
		:call add(notes,[g:I0001,""])
	:endif

	:call treemap#fillMessage(notes)

	:call treemap#printMessage(notes)
	
	:call treemap#interruptRun(err)

	:unlet layerNr
	:unlet err
	
	:return notes
	
:endf

" break run when an error occur
:function! treemap#interruptRun(err)
	:let notes = []

	:if a:err == 1
		:call add(notes,[g:E0002,""])
		:call treemap#fillMessage(notes)
		:call treemap#printMessage(notes)
		:let g:err = 1
		:sleep 10
		:throw "oops"
		":exit
	:endif

	:unlet notes
:endf

" print protocol messages
:function! treemap#printMessage(notes)

	:let language = $lang
	
	:let i = 0
	:for i in range(0,len(a:notes)-1)
		:if language == "DE"
			:if a:notes[i][0].T == "E"
				echohl = ErrorMsg | echom a:notes[i][0].DE ." / ". a:notes[i][1] | echohl = None
			:elseif g:verb == 1
				echom a:notes[i][0].DE ." ". a:notes[i][1]
			:endif
		:else
			:if a:notes[i][0].T == "E"
				echohl = ErrorMsg | echom a:notes[i][0].EN ." / ". a:notes[i][1] | echohl = None
			:elseif g:verb == 1
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

"calculate sum the element of a layer X
:function! treemap#calculateSum(element,matrix,column)

	:if g:val2active == 'true'
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
		:let pt = g:pt * prop / 100
		:let a:hierachy[i]["pt"] = pt

		:unlet prop
		:unlet pt
	:endfor
	:unlet i

	:if (err == 0)
		:call add(notes,[g:I0004,""])
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
			:call add(g:mess,note)
		:endfor
	:endif

:endf

" draw frame
:function! treemap#drawFrame()
	
	:let notes = []
	:let err = 0	

	:if (g:x > 1) && (g:y > 1)

		:call setpos(".",[0,1,1,0])

		:let a = 0
		:for a in range (0,g:y+1)
			:execute "normal i\<ENTER>\<ESC>"
			:execute "normal k"	
			:let i = 0
			:for i in range (0,g:x+1)
				:execute "normal i \<ESC>" 
			:endfor
			:unlet i
		
		:endfor
		:unlet a
	
		:let frame = treemap#rectangle(1,1,g:x,g:y)
		:let frame.title = 'FRAME'
	
		:call treemap#drawRectangle(frame)
	:else
		:call add(notes,[g:E0004,""])
		:let err = 1
	:endif
	
	:if (err == 0)
		:call add(notes,[g:I0006,""])
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
		:call add(notes,[g:W0001,a:rec.title])
	:endif
	
	:if (err == 0)
		:call add(notes,[g:I0005,a:rec.title])
	:endif

	:call treemap#fillMessage(notes)

	:call treemap#printMessage(notes)
	
	:call treemap#interruptRun(err)

	:unlet err
	:unlet notes

:endf

" main function to run the treemap algorithm
:function! treemap#main(output,separator)
	
	:call treemap#initialize()
	
	:let g:cIndex = 0

	" Output = VIM / set frame variables
	:if a:output == 'VIM'
		:let g:x = 230
		:let g:y = 65
		:let g:pt = g:x * g:y
	:endif

	" Output = SVG / set frame variables
	:if a:output == 'SVG'
		:let g:x = 1024
		:let g:y = 768
		:let g:pt = g:x * g:y
	:endif
	
	:let screen = treemap#readScreen(a:separator)
	:let hier = treemap#createHierachy(screen)
	:let nestedHier = treemap#reorgHierachy(hier)
	:let recs = treemap#sliceAndDice(nestedHier)
	:tabnew

	" Output = VIM / print rectangles (text)
	:if a:output == 'VIM'
		:let g:x = 230
		:let g:y = 65
		:let g:pt = g:x * g:y
		
		:call treemap#drawFrame()
		:for item in recs
			:call treemap#drawRectangle(item)
		:endfor
	:endif

	" Output = SVG / print rectangles SVG
	:if a:output == 'SVG'
		:let g:x = 1024
		:let g:y = 768
		:let g:pt = g:x * g:y
		
		:call treemap#drawRectanglesSVG(recs)
	:endif

:endf

" Treemap algorithm Slice and Dice
:function! treemap#sliceAndDice(hierachy)
	
	:let rectangles = []
	:let root = treemap#rectangle(1,1,g:x,g:y)
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
	
	:let rootHier = treemap#getHierachyEntry(a:root.title,g:trHier)

	:if a:root.ly > a:root.lx
		
		:let width = a:root.lx-2
		
		:for child in a:childs
			
			" determine Color
			:let rFill = ''
			:let val2 = 0
			:if g:val2active == 'true'
				:if child.layer == treemap#getLayerNr(g:trHier)-1
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
				:if g:val2active == 'true'
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
			:if g:val2active == 'true'
				:if child.layer == treemap#getLayerNr(g:trHier)-1
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
				:if g:val2active == 'true'
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

:function! treemap#getColor(val2,rootLayer,childLayer)

	:let fillColor = ''
	
	" heat map
	:if g:val2active == 'true' && a:childLayer == treemap#getLayerNr(g:trHier)-1
		:let fillColor = g:color[1]
		:if a:val2 < g:val2Average - (g:val2Average * g:val2Interval / 100)
			:let fillColor = g:color[0]
		:elseif a:val2 > g:val2Average + (g:val2Average * g:val2Interval / 100)
			:let fillColor = g:color[2]
		:else
			:let fillColor = g:color[1]
		:endif
	" one color for one layer 1 entry
	:elseif g:val2active == 'false'
		:if a:rootLayer == -1
			:let fillColor = g:color[g:cIndex]
			:if g:cIndex < len(g:color)-1
				:let g:cIndex += 1
			:else
				:let g:cIndex = 0
			:endif
		:endif
	:else
		:let fillColor = ''
	:endif


	:return fillColor

:endf

" determine the number of layers
:function! treemap#getLayerNr(hierachy)

	:if g:lNr == 0	

		:let max = 0

		:for item in a:hierachy
			:if item.layer > max
				:let max = item.layer
			:endif
		:endfor

		:let g:lNr = max+1
	
	:endif
	
	:return g:lNr

:endf

:let g:layNrs = []
" determine the layer number of a special entry
:function! treemap#getLayerNrDesc(desc,hierachy)

	:let layer = -1

	:for item in a:hierachy
		:if item.desc == a:desc
			:let layer = item.layer
			:break
		:endif
	:endfor

	:call add(g:layNrs,a:desc.': '.layer)
	:return layer
:endf

" Print all messages from g:mess
function! treemap#printAllMessages(messages,lang)
	
	:if a:lang == 'DE' || a:lang == 'EN'
		:tabnew
		:let i = 0
		:for item in a:messages
			:let i+= 1
			:call setline(i,item[0][a:lang].' / '.item[1])
		:endfor
		:unlet i
	:else
		:echo 'Die Sprache '.a:lang.' ist nicht gepflegt!'
	:endif

:endf

" SVG Output
:function! treemap#drawRectanglesSVG(rectangles)

	" HTML part 1	
	:call setline(1,'<?xml version="1.0" encoding="ISO-8859-1"?>')
	:call setline(2,'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de">')
	:call setline(3,'<head>')
	:call setline(4,'<title>Treemap</title>')
	:call setline(5,'</head>')
	:call setline(6,'<body>')
	:call setline(7,'<h1>Treemap</h1>')

	" SVG
	":call setline(8,'<?xml version="1.0" encoding="ISO-8859-1" standalone="no" ?>')
	":call setline(9,'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">')
	:call setline(8,'<svg width="'.g:x.'" height="'.g:y.'" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">')
	:call setline(9,'<title>Treemap</title>')
	:call setline(10,'<desc>generierte Treemap</desc>')
	
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
