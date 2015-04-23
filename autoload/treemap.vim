" Run
:menu Plugin.&Treemap.&Run<tab>main()  :call treemap#main(g:tmOutput,g:tmSeparator)<CR>

" Print log variable g:tmMess
:menu Plugin.&Treemap.&Log<tab>g:tmMess  :call treemap#printAllMessages(g:tmMess,$lang)<CR>

" Title
:menu Plugin.&Treemap.&Title<tab>g:tmTitle  :let g:tmTitle = inputdialog("Title:","Treemap","Treemap")<CR>

" Color
:menu Plugin.&Treemap.&Color.BLUE/GREY/RED  :let g:tmColor = ['blue','grey','red']<CR>
:menu Plugin.&Treemap.&Color.BLUE/YELLOW/RED  :let g:tmColor = ['blue','yellow','red']<CR>
:menu Plugin.&Treemap.&Color.GREEN/BLUE/YELLOW  :let g:tmColor = ['green','blue','yellow']<CR>
:menu Plugin.&Treemap.&Color.GREEN/YELLOW/BLUE  :let g:tmColor = ['green','yellow','blue']<CR>
:menu Plugin.&Treemap.&Color.GREEN/YELLOW/RED  :let g:tmColor = ['green','yellow','red']<CR>
:menu Plugin.&Treemap.&Color.YELLOW/GREEN/RED  :let g:tmColor = ['yellow','green','red']<CR>
:menu Plugin.&Treemap.&Color.YELLOW/GREY/BLUE  :let g:tmColor = ['yellow','grey','blue']<CR>

" Output
:menu Plugin.&Treemap.&Output\ Type.VIM\ <Textfile>  :let g:tmOutput = 'VIM'<CR>
:menu Plugin.&Treemap.&Output\ Type.SVG\ <SVG/HTML>  :let g:tmOutput = 'SVG'<CR>

" Separator
:menu Plugin.&Treemap.&Separator.Semicolon<tab>;  :let g:tmSeparator = ';'<CR>
:menu Plugin.&Treemap.&Separator.Tabulator<tab>\\t  :let g:tmSeparator = '\t'<CR>
:menu Plugin.&Treemap.&Separator.Comma<tab>,  :let g:tmSeparator = ','<CR>
:menu Plugin.&Treemap.&Separator.Vertical\ Bar<tab>\|  :let g:tmSeparator = '\|'<CR>
:menu Plugin.&Treemap.&Separator.Slash<tab>/  :let g:tmSeparator = '/'<CR>
:menu Plugin.&Treemap.&Separator.Backslash<tab>\\  :let g:tmSeparator = '\'<CR>

" Size
:menu Plugin.&Treemap.&Size.Width<tab>g:tmUx  :let g:tmUx = inputdialog("Width:",1024,1024)<CR>
:menu Plugin.&Treemap.&Size.Height<tab>g:tmUy  :let g:tmUy = inputdialog("Height:",768,768)<CR>
