" rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007 by Christian J. Robinson <infynity@onewest.net>
" Updated August 2011 by Dan Rogers <dan@danro.net>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :rename[!] {newname}

command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
cabbrev rename <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Rename" : "rename"<CR>

function! Rename(name, bang)
	let l:curfile = expand("%:p")
  let l:curpath = expand("%:h") . "/"
	let v:errmsg = ""
	silent! exe "saveas" . a:bang . " " . l:curpath . a:name
	if v:errmsg =~# '^$\|^E329'
		if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
			silent exe "bwipe! " . l:curfile
			if delete(l:curfile)
				echoerr "Could not delete " . l:curfile
			endif
		endif
	else
		echoerr v:errmsg
	endif
endfunction
