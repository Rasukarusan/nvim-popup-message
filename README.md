vim-popup-message
====

This vim plugin can can displaying a message in the floating window.

## Demo

This demo shows displaying the last message in the floating window.
![demo.gif](https://user-images.githubusercontent.com/17779386/104086763-f0e7d380-529d-11eb-95f7-663f2f8c8ae7.gif)

## Requirement

- NeoVim >= 0.4

## Install
```vim
Plug 'Rasukarusan/vim-popup-message'
```

## Usage

```vim
nnoremap MM :call popup_message#open('Any messages!')<CR>
" or
:PopupOpen Any messages!
```
