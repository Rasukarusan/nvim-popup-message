if exists("g:loaded_popup_message")
  finish
endif
let g:loaded_popup_message = 1

command! -nargs=1 PopupOpen call popup_message#open(<q-args>)
