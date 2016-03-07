" yankround_complete
" Version: 0.0.1
" Author: sgur
" License: MIT License

if exists('g:loaded_yankround_complete')
  finish
endif
let g:loaded_yankround_complete = 1

let s:save_cpo = &cpo
set cpo&vim


inoremap <Plug>(yankround-complete) <C-r>=yankround#complete#complete()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
