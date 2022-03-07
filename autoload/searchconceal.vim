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

function! s:GroupConcealSyntax(group, pattern, cchar)
  let p = a:pattern
  if !&magic
    let p = '\M'. p
  end
  exe 'syntax match '. a:group .' /'. p .'/ conceal cchar='. a:cchar .' containedin=ALL'
endfunction

function! searchconceal#add(...)
  if a:0 == 1
    let pattern = a:1
  else
    let pattern = @/
  endif

  let searchtextchars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  if exists('b:searchtextmatches')
    let synmatches = b:searchtextmatches
  else
    let synmatches = 0
  endif

  call s:GroupConcealSyntax('searchtext'. synmatches, pattern, searchtextchars[synmatches])
  let b:searchtextmatches = synmatches + 1
endfunction
