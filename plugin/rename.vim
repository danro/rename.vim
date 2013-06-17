" rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007 by Christian J. Robinson <infynity@onewest.net>
" Updated August 2011 by Dan Rogers <dan@danro.net>
" Updated June 2013 by Alexandre Fonseca <alexandrejorgefonseca@gmail.com>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :rename[!] {newname}

command! -nargs=* -complete=customlist,SiblingFiles -bang Rename :call Rename("<args>", "<bang>")
cabbrev rename <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Rename" : "rename"<CR>

function! SiblingFiles(A, L, P)
	return map(split(globpath(expand("%:h") . "/", a:A . "*"), "\n"), 'fnamemodify(v:val, ":t")')
endfunction

function! Rename(name, bang)
	let l:curfile = expand("%:p")
	let l:curpath = expand("%:h") . "/"
	let v:errmsg = ""
	silent! exe "saveas" . a:bang . " " . fnameescape(l:curpath . a:name)
	if v:errmsg =~# '^$\|^E329'
		let l:oldfile = l:curfile
		let l:curfile = expand("%:p")
		if l:curfile !=# l:oldfile && filewritable(l:curfile)
			silent exe "bwipe! " . fnameescape(l:oldfile)
			if delete(l:oldfile)
				echoerr "Could not delete " . l:oldfile
			endif
		endif
	else
		echoerr v:errmsg
	endif
endfunction
