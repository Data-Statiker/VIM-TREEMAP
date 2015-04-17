" Run
:menu Plugin.&Treemap.&Run<tab>main()  :call treemap#main(g:output,g:separator)<CR>

" Print log variable g:mess
:menu Plugin.&Treemap.&Log<tab>g:mess  :call treemap#printAllMessages(g:mess,$lang)<CR>

" Color
:menu Plugin.&Treemap.&Color.BLUE/GREY/RED  :let g:color = ['blue','grey','red']<CR>
:menu Plugin.&Treemap.&Color.BLUE/YELLOW/RED  :let g:color = ['blue','yellow','red']<CR>
:menu Plugin.&Treemap.&Color.GREEN/BLUE/YELLOW  :let g:color = ['green','blue','yellow']<CR>
:menu Plugin.&Treemap.&Color.GREEN/YELLOW/BLUE  :let g:color = ['green','yellow','blue']<CR>
:menu Plugin.&Treemap.&Color.GREEN/YELLOW/RED  :let g:color = ['green','yellow','red']<CR>
:menu Plugin.&Treemap.&Color.YELLOW/GREEN/RED  :let g:color = ['yellow','green','red']<CR>
:menu Plugin.&Treemap.&Color.YELLOW/GREY/BLUE  :let g:color = ['yellow','grey','blue']<CR>

" Output
:menu Plugin.&Treemap.&Output\ Type.VIM\ <Textfile>  :let g:output = 'VIM'<CR>
:menu Plugin.&Treemap.&Output\ Type.SVG\ <SVG/HTML>  :let g:output = 'SVG'<CR>

" Separator
:menu Plugin.&Treemap.&Separator.Semicolon<tab>;  :let g:separator = ';'<CR>
:menu Plugin.&Treemap.&Separator.Tabulator<tab>\\t  :let g:separator = '\t'<CR>
:menu Plugin.&Treemap.&Separator.Comma<tab>,  :let g:separator = ','<CR>
:menu Plugin.&Treemap.&Separator.Vertical\ Bar<tab>\|  :let g:separator = '\|'<CR>
:menu Plugin.&Treemap.&Separator.Slash<tab>/  :let g:separator = '/'<CR>
:menu Plugin.&Treemap.&Separator.Backslash<tab>\\  :let g:separator = '\'<CR>

" Size
:menu Plugin.&Treemap.&Size.Width<tab>g:ux  :let g:ux = inputdialog("Width:",1024,1024)<CR>
:menu Plugin.&Treemap.&Size.Height<tab>g:uy  :let g:uy = inputdialog("Height:",768,768)<CR>
