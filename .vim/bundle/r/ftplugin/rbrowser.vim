"  This program is free software; you can redistribute it and/or modify
"  it under the terms of the GNU General Public License as published by
"  the Free Software Foundation; either version 2 of the License, or
"  (at your option) any later version.
"
"  This program is distributed in the hope that it will be useful,
"  but WITHOUT ANY WARRANTY; without even the implied warranty of
"  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"  GNU General Public License for more details.
"
"  A copy of the GNU General Public License is available at
"  http://www.r-project.org/Licenses/

"==========================================================================
" ftplugin for RBrowser files (created by the Vim-R-plugin)
"
" Author: Jakson Alves de Aquino <jalvesaq@gmail.com>
"          
" Last Change: Wed Nov 30, 2011  05:17PM
"==========================================================================

" Only do this when not yet done for this buffer
if exists("b:did_ftplugin")
    finish
endif


" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Source scripts common to R, Rnoweb, Rhelp and rdoc files:
runtime r-plugin/common_global.vim

" Some buffer variables common to R, Rnoweb, Rhelp and rdoc file need be
" defined after the global ones:
runtime r-plugin/common_buffer.vim

setlocal noswapfile
set buftype=nofile
setlocal nowrap

if !exists("g:rplugin_hasmenu")
    let g:rplugin_hasmenu = 0
endif

" Popup menu
if !exists("g:rplugin_hasbrowsermenu")
    let g:rplugin_hasbrowsermenu = 0
endif

" Current cursor position in the object browser and in the library browser
let g:rplugin_curbline = 1
let g:rplugin_curbcol = 0
let g:rplugin_curlline = 1
let g:rplugin_curlcol = 0

" Current view of the object browser: .GlobalEnv X loaded libraries
let g:rplugin_curview = "GlobalEnv"

" The list of objects in R's workspace is a dictionary. Each key in the
" dictionary is a dictionary with at least the key 'class'. If the class is
" "list", it will have the key 'items' (which lists the elements of the list).
let b:workspace = {}

" Dictionary storing flags indicating whether the elements of an R's list
" must be shown in the object browser. By default, "data.frame" objects are
" included in the dictionary with the flag 1, but other list objects are
" inserted in the dictionary with the flag 0.
if !exists("g:rplugin_opendict")
    let g:rplugin_opendict = {}
endif

" Dictionary storing the order of the elements in a list. This is necessary
" because Vim's dictionary stores the items in an "arbitrary" order.
let b:list_order = {}

let b:liblist = []

function! RBrowserMakeLibDict()
    let b:libdict = {}
    let nobjs = len(g:rplugin_liblist)
    let i = 0
    while i < nobjs
        let obj = split(g:rplugin_liblist[i], ';')
        let curlib = obj[3]
        let haslib = 0
        for lib in b:liblist
            if lib == obj[3]
                let haslib = 1
                break
            endif
        endfor
        if haslib
            let b:libdict[obj[3]] = {'class': "library", 'items': {}}
            while curlib == obj[3]
                if obj[2] == "list" || obj[2] == "data.frame"
                    let b:libdict[obj[3]]['items'][obj[0]] = {'class': obj[2], 'items': {}}
                    let curdf = obj[0]
                    let lastdf = obj[0]
                    let lo_element = "-" . curlib . "-" . curdf
                    let b:list_order[lo_element] = []
                    let g:rplugin_opendict[curdf] = 0
                    let i += 1
                    if i == nobjs
                        break
                    endif
                    let obj = split(g:rplugin_liblist[i], ';')
                    while stridx(obj[0], "$") > 0
                        let [lastdf, lastcol] = split(obj[0], '\$')
                        let b:libdict[curlib]['items'][curdf]['items'][lastcol] = {'class': obj[2]}
                        call add(b:list_order[lo_element], lastcol)

                        let i += 1
                        if i == nobjs
                            break
                        endif
                        let obj = split(g:rplugin_liblist[i], ';')
                    endwhile
                else
                    let b:libdict[obj[3]]['items'][obj[0]] = {'class': obj[2]}
                    let i += 1
                    if i == nobjs
                        break
                    endif
                endif
                let obj = split(g:rplugin_liblist[i], ';')
            endwhile
        else
            while curlib == obj[3]
                let i += 1
                if i == nobjs
                    break
                endif
                let obj = split(g:rplugin_liblist[i], ';')
            endwhile
        endif
    endwhile
endfunction

function! RBrowserMakeLine(key, prefix, curlist)
    exe "let curkey = g:rplugin_curdict['" . a:key . "']"
    let cls = curkey['class']
    if has("conceal")
        if cls == "list" || cls == "data.frame"
            let line = a:prefix . '[#' . a:key . '	'
        elseif cls == "numeric"
            let line = a:prefix . '{#' . a:key . '	'
        elseif cls == "character"
            let line = a:prefix . '"#' . a:key . '	'
        elseif cls == "factor"
            let line = a:prefix . "'#" . a:key . '	'
        elseif cls == "function"
            let line = a:prefix . '(#' . a:key . '	'
        elseif cls == "logical"
            let line = a:prefix . '%#' . a:key . '	'
        elseif cls == "library"
            let line = a:prefix . '##' . a:key . '	'
        elseif cls == "flow-control"
            let line = a:prefix . '!#' . a:key . '	'
        else
            let line = a:prefix . '=#' . a:key . '	'
        endif
    else
        if cls == "list" || cls == "data.frame"
            let line = a:prefix . '[' . a:key . '	'
        elseif cls == "numeric"
            let line = a:prefix . '{' . a:key . '	'
        elseif cls == "character"
            let line = a:prefix . '"' . a:key . '	'
        elseif cls == "factor"
            let line = a:prefix . "'" . a:key . '	'
        elseif cls == "function"
            let line = a:prefix . '(' . a:key . '	'
        elseif cls == "logical"
            let line = a:prefix . '%' . a:key . '	'
        elseif cls == "library"
            let line = a:prefix . '#' . a:key . '	'
        elseif cls == "flow-control"
            let line = a:prefix . '!' . a:key . '	'
        else
            let line = a:prefix . '=' . a:key . '	'
        endif
    endif

    if has("conceal") && g:rplugin_curobjlevel == 0
        let line = " " . line
    endif

    " If the object's label exists, then append it to the end of the line
    let thekeys = keys(curkey)
    for subkey in thekeys
        if subkey == "label"
            let line = line . curkey['label']
        endif
    endfor
    let lnr = line("$") + 1
    call setline(lnr, line)

    " If the object is a data.frame, show its columns
    if cls == "data.frame" || cls == "list" || cls == "library"
        let whattodo = "addkey"
        for i in keys(g:rplugin_opendict)
            if i == a:key
                if g:rplugin_opendict[a:key] == 0
                    return
                else
                    let whattodo = "show elements"
                    break
                endif
            endif
        endfor
        if whattodo == "addkey"
            if cls == "data.frame" || cls == "list"
                echoerr "rbrowser.vim: unregistered data.frame or list!"
            else
                let g:rplugin_opendict[a:key] = 0
            endif
        endif
        if g:rplugin_opendict[a:key] == 0
            return
        endif

        if &encoding == "utf-8"
            let strL = " └─"
            let strT = " ├─"
            let strI = " │ "
        else
            let strL = " `-"
            let strT = " |-"
            let strI = " | "
        endif

        if has("conceal")
            let strL = strL . " "
            let strT = strT . " "
            let strI = strI . " "
            let g:rplugin_curobjlevel += 1
        endif

        if a:prefix =~ strL
            let newprefix = substitute(a:prefix, strL, "   ", "")
        else
            let newprefix = substitute(a:prefix, strT, strI, "") 
        endif
        let newprefix = newprefix . strT
        let olddict = g:rplugin_curdict
        let g:rplugin_curdict = curkey['items']
        let curlist = a:curlist . "-" . a:key
        if cls == "library"
            let thesubkeys = sort(keys(g:rplugin_curdict))
        else
            let thesubkeys = b:list_order[curlist]
        endif
        let nkeys = len(thesubkeys)
        let i = 0
        for key in thesubkeys
            let i += 1
            if i < nkeys
                call RBrowserMakeLine(key, newprefix, curlist)
            else
                let newprefix = substitute(newprefix, strT, strL, "")
                call RBrowserMakeLine(key, newprefix, curlist)
            endif
        endfor
        let g:rplugin_curdict = olddict
    endif
endfunction

function! RBrowserAddItemToList(key, curlist)
    exe "let curkey = g:rplugin_curdict['" . a:key . "']"
    let cls = curkey['class']

    " If the object is a data.frame, show its columns
    if cls == "data.frame" || cls == "list"
        let whattodo = "addkey"
        for i in keys(g:rplugin_opendict)
            if i == a:key
                let whattodo = "nothing"
                break
            endif
        endfor
        if whattodo == "addkey"
            if cls == "data.frame"
                let g:rplugin_opendict[a:key] = g:vimrplugin_open_df
            else
                if cls == "list"
                    let g:rplugin_opendict[a:key] = g:vimrplugin_open_list
                else
                    let g:rplugin_opendict[a:key] = 0
                endif
            endif
        endif

        let olddict = g:rplugin_curdict
        let g:rplugin_curdict = curkey['items']
        let curlist = a:curlist . "-" . a:key
        let thesubkeys = b:list_order[curlist]
        let nkeys = len(thesubkeys)
        let i = 0
        for key in thesubkeys
            let i += 1
            if i < nkeys
                call RBrowserAddItemToList(key, curlist)
            else
                call RBrowserAddItemToList(key, curlist)
            endif
        endfor
        let g:rplugin_curdict = olddict
    endif
endfunction

function! RBrowserFillCloseList()
    let thekeys = sort(keys(b:workspace))
    for key in thekeys
        let s:curlist = ""
        let g:rplugin_curobjlevel = 0
        let g:rplugin_curdict = b:workspace
        call RBrowserAddItemToList(key, "")
    endfor
endfunction

function! RBrowserShowGE(fromother)
    let g:rplugin_curview = "GlobalEnv"
    if a:fromother == 0
        let g:rplugin_curbline = line(".")
        let g:rplugin_curbcol = col(".")
    endif

    setlocal modifiable
    sil normal! ggdG
    call setline(1, ".GlobalEnv | Libraries")
    call setline(2, "")
    let thekeys = sort(keys(b:workspace))
    for key in thekeys
        let s:curlist = ""
        let g:rplugin_curobjlevel = 0
        let g:rplugin_curdict = b:workspace
        call RBrowserMakeLine(key, "  ", "")
    endfor
    call cursor(g:rplugin_curbline, g:rplugin_curbcol)
    setlocal nomodifiable
endfunction

function! RBrowserShowLibs(fromother)
    let g:rplugin_curview = "libraries"
    if a:fromother == 0
        let g:rplugin_curlline = line(".")
        let g:rplugin_curlcol = col(".")
    endif

    if !exists("b:libdict")
        call RBrowserMakeLibDict()
    endif

    setlocal modifiable
    sil normal! ggdG
    call setline(1, "Libraries | .GlobalEnv")
    call setline(2, "")

    " Fill the object browser
    let thekeys = sort(keys(b:libdict))
    for key in thekeys
        let s:curlist = ""
        let g:rplugin_curobjlevel = 0
        let g:rplugin_curdict = b:libdict
        call RBrowserMakeLine(key, "  ", "")
    endfor

    " Warn about libraries not present when :RUpdateObjList was run
    let hasmissing = 0
    let misslibs = []
    for lib in b:liblist
        if search('#' . lib, "wn") == 0
            let hasmissing += 1
            call add(misslibs, lib)
        endif
    endfor
    if hasmissing
        call setline(line("$") + 1, "")
        call setline(line("$") + 1, "Warning:")
        call setline(line("$") + 1, "The following")
        if hasmissing == 1
            call setline(line("$") + 1, "library is loaded")
            call setline(line("$") + 1, "but is not in the")
        else
            call setline(line("$") + 1, "libraries are loaded")
            call setline(line("$") + 1, "but are not in the")
        endif
        call setline(line("$") + 1, "omniList:")
        call setline(line("$") + 1, "")
        for lib in misslibs
            call setline(line("$") + 1, "   " . lib)
        endfor
        call setline(line("$") + 1, "")
        call setline(line("$") + 1, "Please read the Vim-R-plugin")
        call setline(line("$") + 1, "documentation:")
        call setline(line("$") + 1, "")
        call setline(line("$") + 1, "  :h :RUpdateObjList")
        call setline(line("$") + 1, "")
        call setline(line("$") + 1, "to know how to show all loaded")
        call setline(line("$") + 1, "libraries in the Object Browser.")
    endif

    call cursor(g:rplugin_curlline, g:rplugin_curlcol)
    setlocal nomodifiable
endfunction

function! RBrowserFill(fromother)
    if g:rplugin_curview == "libraries"
        call RBrowserShowLibs(a:fromother)
    else
        call RBrowserShowGE(a:fromother)
    endif
endfunction

function! RBrowserDoubleClick()
    " Toggle view: Objects in the workspace X List of libraries
    if line(".") == 1
        if g:rplugin_curview == "libraries"
            call RBrowserShowGE(1)
        else
            call RBrowserShowLibs(1)
        endif
        return
    endif

    " Toggle state of list or data.frame: open X closed
    let key = RBrowserGetName(0)
    for i in keys(g:rplugin_opendict)
        if i == key
            let g:rplugin_opendict[key] = !g:rplugin_opendict[key]
            call RBrowserFill(0)
            break
        endif
    endfor
endfunction

function! RBrowserOpenCloseLists(status)
    if !exists("b:myservername")
        if !buflisted("Object_Browser")
            call RWarningMsg('There is no "Object_Browser" buffer.')
            return
        endif

        let switchedbuf = 0
        if g:rplugin_curbuf != "Object_Browser"
            let savesb = &switchbuf
            set switchbuf=useopen,usetab
            sil noautocmd sb Object_Browser
            let switchedbuf = 1
        endif
    endif

    for key in keys(g:rplugin_opendict)
        let g:rplugin_opendict[key] = a:status
    endfor
    call RBrowserFill(0)

    if !exists("b:myservername")
        if switchedbuf
            exe "sil noautocmd sb " . g:rplugin_curbuf
            exe "set switchbuf=" . savesb
        endif
    endif
endfunction

function! RBrowserRightClick()
    if line(".") == 1
        return
    endif

    let key = RBrowserGetName(1)
    if key == ""
        return
    endif

    let line = getline(".")
    let isfunction = 0
    if has("conceal")
        if line =~ "(#.*\t"
            let isfunction = 1
        endif
    else
        if line =~ "(.*\t"
            let isfunction = 1
        endif
    endif

    if g:rplugin_hasbrowsermenu == 1
        aunmenu ]RBrowser
    endif
    let key = substitute(key, '\.', '\\.', "g")
    let key = substitute(key, ' ', '\\ ', "g")

    exe 'amenu ]RBrowser.summary('. key . ') :call RAction("summary")<CR>'
    exe 'amenu ]RBrowser.str('. key . ') :call RAction("str")<CR>'
    exe 'amenu ]RBrowser.names('. key . ') :call RAction("names")<CR>'
    exe 'amenu ]RBrowser.plot('. key . ') :call RAction("plot")<CR>'
    exe 'amenu ]RBrowser.print(' . key . ') :call RAction("print")<CR>'
    amenu ]RBrowser.-sep01- <nul>
    exe 'amenu ]RBrowser.example('. key . ') :call RAction("example")<CR>'
    exe 'amenu ]RBrowser.help('. key . ') :call RAction("help")<CR>'
    if isfunction
        exe 'amenu ]RBrowser.args('. key . ') :call RAction("args")<CR>'
    endif
    popup ]RBrowser
    let g:rplugin_hasbrowsermenu = 1
endfunction

function! RBrowserFindParent(word, curline, curpos)
    let curline = a:curline
    let curpos = a:curpos
    while curline > 1 && curpos >= a:curpos
        let curline -= 1
        let line = substitute(getline(curline), "	.*", "", "")
        if has("conceal")
            let curpos = stridx(line, '[#')
        else
            let curpos = stridx(line, '[')
        endif
        if curpos == -1
            let curpos = a:curpos
        endif
    endwhile

    if curline > 1
        if has("conceal")
            let word = substitute(line, '.*[#', "", "") . '$' . a:word
        else
            let word = substitute(line, '.*[', "", "") . '$' . a:word
        endif
        if curpos != s:spacelimit
            let word = RBrowserFindParent(word, line("."), curpos)
        endif
        return word
    else
        " Didn't find the parent: should never happen.
        let msg = "R-plugin Error: " . a:word . ":" . curline
        echoerr msg
    endif
    return ""
endfunction

function! RBrowserGetName(complete)
    let curpos = col(".")

    let line = getline(".")
    if line =~ "^$"
        return
    endif

    " Is the object a top level one (curpos == 2)?
    if has("conceal")
        let delim = ['{#', '[#', '(#', '"#', "'#", '%#', '=#']
        let word = substitute(line, '^\W*#\{-1,}\(.*\)\t.*', '\1', "")
    else
        let tabpos = stridx(getline("."), "	")
        if curpos > tabpos
            return
        endif
        let delim = ['{', '[', '(', '"', "'", '%', '=']
        let word = expand("<cword>")
    endif

    if word =~ ' ' || word =~ '^[0-9]'
        let word = '`' . word . '`'
    endif

    if a:complete == 0
        return word
    endif

    for i in delim
        let curpos = stridx(line, i)
        if curpos != -1
            break
        endif
    endfor
    if curpos == -1
        return ""
    endif

    let s:spacelimit = 2
    if has("conceal")
        let s:spacelimit += 1
    endif
    if g:rplugin_curview == "libraries"
        if &encoding == "utf-8"
            let s:spacelimit += 7
        else
            let s:spacelimit += 3
        endif
    endif

    if curpos == s:spacelimit
        " top level object
        return word
    else
        if curpos > s:spacelimit
            " Find the parent data.frame or list
            let word = RBrowserFindParent(word, line("."), curpos)
            " Unnamed objects of lists
            if word =~ '\$\[\[[0-9]*\]\]'
                let word = substitute(word, '\$\[\[\([0-9]*\)\]\]', '[[\1]]', "g")
            endif
            return word
        else
            " Wrong object name delimiter: should never happen.
            let msg = "R-plugin Error: (curpos = " . curpos . ") < (spacelimit = " . s:spacelimit . ") " . word
            echoerr msg
            return ""
        endif
    endif
endfunction

function! MakeRBrowserMenu()
    let g:rplugin_curbuf = bufname("%")
    if g:rplugin_hasmenu == 1
        return
    endif
    menutranslate clear
    call RControlMenu()
    call RBrowserMenu()
endfunction

function! LeaveRBrowser()
    if g:rplugin_curview == "libraries"
        let g:rplugin_curlline = line(".")
        let g:rplugin_curlcol = col(".")
    else
        let g:rplugin_curbline = line(".")
        let g:rplugin_curbcol = col(".")
    endif
endfunction

function! ObBrBufUnload()
    if exists("b:myservername")
        call system("tmux select-pane -t 0")
    endif
endfunction

function! SourceObjBrLines()
    exe "source " . $VIMRPLUGIN_TMPDIR . "/objbrowserInit"
endfunction

nmap <buffer><silent> <CR> :call RBrowserDoubleClick()<CR>
nmap <buffer><silent> <2-LeftMouse> :call RBrowserDoubleClick()<CR>
nmap <buffer><silent> <RightMouse> :call RBrowserRightClick()<CR>

call RControlMaps()

setlocal winfixwidth
setlocal bufhidden=wipe

if has("gui_running")
    call RControlMenu()
    call RBrowserMenu()
    let s:thisbuffname = substitute(bufname("%"), '\.', '', "g")
    let s:thisbuffname = substitute(s:thisbuffname, ' ', '', "g")
    exe "augroup " . s:thisbuffname
    au BufLeave <buffer> call LeaveRBrowser()
    exe "augroup END"
    unlet s:thisbuffname
endif

au BufUnload <buffer> call ObBrBufUnload()

let &cpo = s:cpo_save
unlet s:cpo_save

