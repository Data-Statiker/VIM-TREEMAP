" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79

" Menu {{{1
" Run
:menu Plugin.&Treemap.&Run<tab>main()  :call treemap#main(g:tmOutput,g:tmSeparator)<CR>

" Create & Print
:menu Plugin.&Treemap.&Create<tab>create()  :call treemap#create(g:tmSeparator)<CR>
:menu Plugin.&Treemap.&Draw<tab>draw()  :call treemap#draw(g:tmOutput)<CR>

" Open a SCG/HTML treemap in the browser
:menu Plugin.&Treemap.&Open<tab>SVG  :call treemap#tmOpenSVG()<CR>

" Print log variable g:tmMess
:menu Plugin.&Treemap.&Log<tab>g:tmMess  :call treemap#printAllMessages(g:tmMess,$LANG)<CR>

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

" Commands {{{1
:command! -count=1 TmRun
      \ call treemap#main(g:tmOutput,g:tmSeparator)
:command! -count=1 TmCreate
      \ call treemap#create(g:tmSeparator)
:command! -count=1 TmDraw
      \ call treemap#draw(g:tmOutput)
:command! -count=1 TmOpen
      \ call treemap#tmOpenSVG()
:command! -count=1 TmLog
      \ call treemap#printAllMessages(g:tmMess,$LANG)
:command! -count=1 TmTitle
      \ let g:tmTitle =  input("Title: ","Treemap")
:command! -count=1 TmColor
      \ let g:tmColor = [] |
      \ call add(g:tmColor,input("Choose first Color: ","blue")) |
      \ call add(g:tmColor,input("Choose second Color: ","grey")) |
      \ call add(g:tmColor,input("Choose first Color: ","red"))
:command! -count=1 TmSeparator
      \ let g:tmSeparator =  input("Separator: ","\\t")
:command! -count=1 TmOutput
      \ let g:tmOutput =  input("Output Type: ","VIM")
:command! -count=1 TmWidth
      \ let g:tmUx=  input("Width: ","70")
:command! -count=1 TmHeight
      \ let g:tmUy=  input("Hight: ","25")

" Mappings {{{1
:map <Leader>tr  :TmRun<Esc>
:map <Leader>tc  :TmCreate<Esc>
:map <Leader>td  :TmDraw<Esc>
:map <Leader>to  :TmOpen<Esc>
:map <Leader>tl  :TmLog<Esc>
