" Run
:menu Plugin.&Treemap.&Run<tab>main()  :call treemap#main(g:output,g:separator)<CR>

" Color
:menu Plugin.&Treemap.&Color.BLUE/GREY/RED  :let g:color = ['blue','grey','red']<CR>
:menu Plugin.&Treemap.&Color.GREEN/YELLOW/BLUE  :let g:color = ['green','yellow','blue']<CR>

" Output
:menu Plugin.&Treemap.&Output\ Type.VIM\ <Textfile>  :let g:output = 'VIM'<CR>
:menu Plugin.&Treemap.&Output\ Type.SVG\ <SVG/HTML>  :let g:output = 'SVG'<CR>

" Separator
:menu Plugin.&Treemap.&Separator.Semicolon<tab>;  :let g:separator = ';'<CR>
:menu Plugin.&Treemap.&Separator.Tabulator<tab>\\t  :let g:separator = '\t'<CR>
:menu Plugin.&Treemap.&Separator.Comma<tab>,  :let g:separator = ','<CR>
:menu Plugin.&Treemap.&Separator.Slash<tab>/  :let g:separator = '/'<CR>
:menu Plugin.&Treemap.&Separator.Backslash<tab>\\  :let g:separator = '\'<CR>
