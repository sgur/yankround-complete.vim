" YankRound complete
scriptencoding utf-8

" Internal {{{1

function! s:yankround_complete() abort "{{{
  let col = match(getline('.')[: -1], '\S\+$') + 1
  call complete(col > 0 ? col : col('$'), s:get_candidates())
  call s:enable_completedone_handler()
  return ""
endfunction "}}}

function! s:yankround_inscomplete(findstart, base) abort "{{{
  if a:findstart
    let col = match(getline('.')[: -1], '\k\+$') + 1
    return (col > 0 ? col : col('$'))-1
  endif
  call s:enable_completedone_handler()
  return filter(s:get_candidates(), 'v:val.word =~? a:base')
endfunction "}}}

function! s:get_candidates() abort "{{{
  return map(copy(get(g:, '_yankround_cache', [])), 's:completion_item(v:val[0], v:val[2:])')
endfunction "}}}

function! s:completion_item(type_char, word) "{{{{
  let chars = strchars(a:word)
  let width = &columns / 2
  return { "word" : a:word
        \ , "abbr" : split(chars > width ? a:word[: width - 3] . "..." : a:word, "\n")[0]
        \ , "menu" : a:type_char is# "v" ? printf("%2d chars", chars) : printf("%2d lines", len(split(a:word, "\n")))
        \ , 'icase' : 1
        \ }
endfunction "}}}

" Event handler {{{2

function! s:on_completedone_yankround() "{{{
  call s:disable_completedone_handler()
  " Assume (Vim >= 7.4.774)
  if exists('v:completed_item') && empty(v:completed_item)
    return
  endif
  undojoin | execute 's/\%x00/\r/ge'
endfunction "}}}

function! s:enable_completedone_handler() abort "{{{
  autocmd yankround_complete CompleteDone *  call s:on_completedone_yankround()
endfunction "}}}

function! s:disable_completedone_handler() abort "{{{
  autocmd! yankround_complete CompleteDone
endfunction "}}}


" Interface {{{1

function! yankround_complete#complete(...) abort
  call s:disable_completedone_handler()
  return !a:0
        \ ? s:yankround_complete()
        \ : s:yankround_inscomplete(a:1, a:2)
endfunction


" Initialization {{{1

augroup yankround_complete "{{{
  autocmd!
augroup END "}}}


" 1}}}
