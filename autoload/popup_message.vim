hi messagePopup guibg=#07343b

function! s:focus_main_window()
  execute '0windo :'
endfunction

function! s:close_popup_message()
  if exists('g:win_id')
    call nvim_win_close(g:win_id, v:true)
    unlet g:win_id
    augroup popup_message
      autocmd!
    augroup END
  endif
endfunction
function! popup_message#open(message)
  let message = a:message
  if message == ''
    return
  endif

  let pos = win_screenpos('.')
  let opened_at = [pos[0] + winline() - 1, pos[1] + wincol() - 2]
  let message_len = strlen(message)
  let width = get(g:, 'popup_message_width', 70)
  let height =  message_len / width + 1

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
      \ 'width': message_len > width ? width : message_len,
      \ 'height': height,
      \ 'anchor': vert . 'W',
      \ 'style': 'minimal',
      \}

  let buf = nvim_create_buf(v:false, v:true)
  let g:win_id = nvim_open_win(buf, v:true, config)
  setlocal winhighlight=Normal:messagePopup
  call setline(1, message)
  setlocal nomodified nomodifiable

  call s:focus_main_window()

  augroup popup_message
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter <buffer> call s:close_popup_message()
  augroup END
endfunction
