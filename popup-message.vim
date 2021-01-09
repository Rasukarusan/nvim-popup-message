hi messagePopup guibg=#07343b

function! s:get_command_result(cmd) abort
  let [verbose, verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => str
    execute 'silent!' a:cmd
  redir END
  let [&verbose, &verbosefile] = [verbose, verbosefile]
  return str
endfunction

" =============================================
" :messagesの最後の行を取得する
" =============================================
function! s:get_last_message() abort
  let lines = filter(split(s:get_command_result('messages'), "\n"), 'v:val !=# ""')
  if len(lines) <= 0
      return ''
  end
  return lines[len(lines) - 1 :][0]
endfunction

function! s:focus_to_main_window()
  execute '0windo :'
endfunction

function! s:close_popup_message()
  if exists('g:win_id')
    call nvim_win_close(g:win_id, v:true)
    unlet g:win_id
    augroup my_function
      autocmd!
    augroup END
  endif
endfunction

function! s:show_last_message(message)
  let message = a:message
  if message == ''
    return
  endif

  let pos = win_screenpos('.')
  let opened_at = [pos[0] + winline() - 1, pos[1] + wincol() - 2]
  let message_len = strlen(message)
  let MAX_WIDTH = 70
  let height =  message_len / MAX_WIDTH + 1

  let row = opened_at[0]
  let col = opened_at[1]

  if row + height + 2 <= winheight(0)
    let vert = 'N'
  else
    let vert = 'S'
    let row -= 1
  endif

  let config = { 
      \'relative': 'editor',
      \ 'row': row,
      \ 'col': col,
      \ 'width': message_len > MAX_WIDTH ? MAX_WIDTH : message_len,
      \ 'height': height,
      \ 'anchor': vert . 'W',
      \ 'style': 'minimal',
      \}

  let buf = nvim_create_buf(v:false, v:true)
  let g:win_id = nvim_open_win(buf, v:true, config)
  setlocal winhighlight=Normal:messagePopup
  call setline(1, message)
  setlocal nomodified nomodifiable

  " focus to main window
  execute '0windo :'

  augroup my_function
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter <buffer> call s:close_popup_message()
  augroup END
endfunction

call s:show_last_message(s:get_last_message())
