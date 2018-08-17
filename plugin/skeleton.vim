" Skeleton:    Initialize new Vim buffers with file-type-specific templates
" Maintainer:  Noah Frederick (http://noahfrederick.com)

if (exists('g:loaded_skeleton') && g:loaded_skeleton) || &cp
  finish
endif
let g:loaded_skeleton = 1

""
" @section Introduction, intro
" @stylized Skeleton
" @plugin(stylized) initializes new Vim buffers with filename and
" file-type-specific templates.
"
" Add something like the following to ~/.vim/templates/skel.xml:
" >
"   <?xml version="1.0" encoding="UTF-8" ?>
"   <@BASENAME@>
"       @CURSOR@
"   </@BASENAME@>
" <
" And when you create a new buffer, e.g., books.xml, it will be initialized
" with your template:
" >
"   <?xml version="1.0" encoding="UTF-8" ?>
"   <books>
"       [cursor is here]
"   </books>
" <
"
" Add something like the following to ~/.vim/templates/jsconfig.json
" >
"   {
"     "compilerOptions": {
"       "checkJs": true
"     }
"   }
" <
" And when you create a new buffer jsconfig.json, it will be initialized with
" your template.
"
" It differs from a snippet plug-in in that it is concerned with initializing
" new buffers with boilerplate text without any manual intervention such as
" triggering a snippet.
"
" @plugin(stylized) stays out of your way: it will never load a template
" unless the buffer is empty and is not associated with an existing file on
" disk. And if you don't happen to want to use the template for a particular
" file, issuing |undo| (u) will restore your empty buffer.
"
" This plug-in is only available if 'compatible' is not set.

""
" @section About, about
" @plugin(stylized) is distributed under the same terms as Vim itself (see
" |license|)
"
" You can find the latest version of this plug-in on GitHub:
" https://github.com/noahfrederick/vim-@plugin(name)
"
" Please report issues on GitHub as well:
" https://github.com/noahfrederick/vim-@plugin(name)/issues

if !exists('g:skeleton_template_dir')
  ""
  " The directory that contains skeleton template files. Example:
  " >
  "   let g:skeleton_template_dir = "~/.vim/templates"
  " <
  " Default: "~/.vim/templates"
  let g:skeleton_template_dir = '~/.vim/templates'
endif

if !exists("g:skeleton_replacements")
  ""
  " Dictionary of custom global replacement functions. Each function should be
  " named after the corresponding template placeholder, and should return the
  " value with which the placeholder will be substituted. For example:
  " >
  "   function! g:skeleton_replacements.TITLE()
  "     return "The Title"
  "   endfunction
  " <
  " Registering the above function would replace the @TITLE@ placeholder with
  " the return value, "The Title".
  "
  " Default: {}
  "
  " To create one or more replacements for a particular file-type, add your
  " function instead to a g:skeleton_replacements_{filetype} dictionary. For
  " example, to create a TITLE placeholder for Ruby files:
  " >
  "   let g:skeleton_replacements_ruby = {}
  "
  "   function! g:skeleton_replacements_ruby.TITLE()
  "     return "The Title"
  "   endfunction
  " <
  " This will override g:skeleton_replacements.TITLE() (if defined) for Ruby
  " files.
  let g:skeleton_replacements = {}
endif

if !exists("g:skeleton_find_template")
  ""
  " Dictionary of custom template-finding functions. Each function should be
  " named after the filetype to which the function applies, and should return
  " the path to the template file relative to your template directory.
  " Functions are passed one parameter containing the buffer's filename. For
  " example:
  " >
  "   function! g:skeleton_find_template.ruby(path)
  "     if stridx(a:path, '/controllers/') != -1
  "       return 'controller.rb'
  "     endif
  "     return ''
  "   endfunction
  " <
  " Returning an empty string falls back to @plugin(stylized)'s default
  " methods of locating the template. In the above example, a custom
  " controller.rb template is used if and only if the passed path contains a
  " "/controllers/" segment.
  "
  " Default: {}
  let g:skeleton_find_template = {}
endif

function! skeleton#ClearBufferMaybe(filename, force)
  " Abort if buffer is non-empty or file already exists
  if ! (line('$') == 1 && getline('$') == '') || filereadable(a:filename)
    if a:force == 1
      " Clear buffer instead
      1,$ delete _
    else
      return -1
    endif
  endif

  return 1
endfunction

function! s:load_maybe(filename, filetype)
  if skeleton#ClearBufferMaybe(a:filename, 0) == -1
    return -1
  endif

  let ext = skeleton#GetExtensionOrBasename(a:filename)

  if ext == -1
    let ext = skeleton#FiletypeToExtension(a:filetype)
  endif

  return skeleton#Load(ext, a:filename, '')
endfunction

augroup Skeleton
  autocmd!
  autocmd BufNewFile * call s:load_maybe(expand('<amatch>'), '')
  autocmd FileType   * call s:load_maybe(expand('<afile>'), expand('<amatch>'))
augroup END

""
" Edits a template file. If the optional [template] argument is omitted, edits
" the template inserted into the current buffer.
command! -bang -bar -nargs=? -complete=customlist,skeleton#CompleteTemplateNames
  \ SkelEdit execute skeleton#EditTemplate(<q-args>, 'edit<bang>')

""
" Inserts the specified [template] into the current buffer if it is empty. If
" [!] is supplied after the command, the buffer's contents will be replaced by
" the template. If the template name is omitted, the normal rules for
" determining the template to use are applied.
command! -bang -bar -nargs=? -complete=customlist,skeleton#CompleteTemplateNames
  \ SkelInsert call skeleton#InsertTemplate(<q-args>, ('<bang>' == '!'))
