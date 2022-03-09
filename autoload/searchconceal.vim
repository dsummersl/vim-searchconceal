function! searchconceal#clear()
  if exists('b:searchtextmatches')
    let synmatches = b:searchtextmatches
  else
    let synmatches = 0
  endif

  for i in range(0, synmatches - 1)
    exe 'syn clear searchtext'. i
  endfor

  let b:searchtextmatches = 0
endfunction

function! s:GroupConcealSyntax(group, pattern, cchar, offsetParameters)
  let p = a:pattern
  if !&magic
    let p = '\M'. p
  end
  exe 'syntax match '. a:group .' /'. p .'/'. a:offsetParameters .' conceal cchar='. a:cchar .' containedin=ALL'
endfunction

" Conceal the current search pattern.
"
" Arguments:
"  () - The current @/ pattern is concealed (default) with character 'a', 'b',
"    'c' (increasing order for each subsequent invocation of this method)
"
"  (conceal character) - conceal character. The current @/ pattern is concealed
"    with the character provided to this function.
"
"  (conceal character, pattern) - conceal character, and pattern. The provided
"    pattern is concealed with the character provided to this function.
"
"  (conceal character, pattern, syn-pattern-offset params) - conceal character,
"    pattern, syn-pattern-offset params. The provided pattern is concealed with
"    the character provided to this function, apply rules about matching to the
"    syntax matching pattern.
function! searchconceal#add(...)
  if a:0 > 3
    echoerr 'invalid number of arguments: up 3 three parameters are allowed'
    return
  end

  let searchtextchars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  if exists('b:searchtextmatches')
    let synmatches = b:searchtextmatches
  else
    let synmatches = 0
  endif

  if a:0 > 2
    let offsetParameters = a:3
  else
    let offsetParameters = ''
  endif

  if a:0 > 1
    let pattern = a:2
  else
    let pattern = @/
  endif

  if a:0 > 0
    let textchar = a:1
  else
    let textchar = searchtextchars[synmatches]
  endif

  call s:GroupConcealSyntax('searchtext'. synmatches, pattern, textchar, offsetParameters)
  let b:searchtextmatches = synmatches + 1
endfunction
