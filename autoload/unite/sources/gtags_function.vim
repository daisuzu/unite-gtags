call unite#util#set_default('g:unite_source_global_command', 'global')
call unite#util#set_default('g:unite_source_global_default_opts', '--result=ctags-x')
call unite#util#set_default('g:unite_source_global_function_opt', '-s')

let s:source_gtags = {
      \ 'name': 'gtags/function',
      \ 'hooks' : {},
      \ }

function! s:source_gtags.hooks.on_init(args, context)
  let a:context.source__input = a:args[0]
endfunc

function! s:source_gtags.gather_candidates(args, context)
  let cmdline = printf('%s %s %s %s',
    \   g:unite_source_global_command,
    \   g:unite_source_global_default_opts,
    \   g:unite_source_global_function_opt,
    \   string(a:context.source__input),
    \)
  
  let res = unite#util#system(cmdline)
  let candidates = map(split(res, '\r\n\|\r\|\n'), 
              \ 'matchlist(substitute(v:val, a:context.source__input . "\\s\\+", "", ""),
              \ "\\(\\d\\+\\)\\s\\+\\(.*\\.\\S\\+\\) \\(.*\\)$")')

  return map(candidates,
    \ '{
    \   "word": v:val[0],
    \   "kind": "jump_list",
    \   "action__path": v:val[2],
    \   "action__line": v:val[1],
    \   "action__text": v:val[3],
    \ }')
endfunction

function! unite#sources#gtags_function#define()
  return s:source_gtags
endfunction

