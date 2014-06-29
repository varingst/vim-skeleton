# vim-skeleton

Initialize new Vim buffers with file-type-specific templates

[![Build Status][buildimg]](https://travis-ci.org/noahfrederick/vim-skeleton)

## Usage
### The Basics

Add something like the following to `~/.vim/templates/skel.xml`:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<@BASENAME@>
	@CURSOR@
</@BASENAME@>
```

And when you create a new buffer, e.g., `books.xml`, it will be initialized
with your template:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<books>
	[cursor is here]
</books>
```

It differs from a snippet plug-in in that it is concerned with initializing
new buffers with boilerplate text without any manual intervention such as
triggering a snippet.

vim-skeleton stays out of your way: it will never load a template unless the
buffer is empty and is not associated with an existing file on disk. And if you
don't happen to want to use the template for a particular file, hitting undo
(`u`) restores your empty buffer.

### Template Precedence

Out of the box, vim-skeleton will attempt to load `<parent_dir_name>.<ext>`.
So for example, editing a new buffer with name
`app/controllers/user_controller.rb` will attempt to load `controllers.rb` and
fall back to `skel.rb` if not found. The plug-in can be extended with your own
rules for loading templates and doing your own processing of template files
(such as doing custom substitutions).  See `:help skeleton-customize` for
details.

### Provided Commands

Use the `:SkelEdit[!]` command for quick access to the currently loaded
template file (or the default template if no appropriate template file was
found).

## Installation

vim-skeleton is installed just about the same way as any other Vim plug-in.
The only extra step is creating your templates directory and adding templates
to it. By default, vim-skeleton looks in `~/.vim/templates`, but this can be
changed (see `:help skeleton-configuration`).

To get started, try:

	mkdir -p ~/.vim/templates
	echo "Hello world" > ~/.vim/templates/skel.txt
	vim hello.txt

## Development

### Testing

Tests are written for [vspec][vspec], which can be installed via
[vim-flavor][vim-flavor]:

	bundle install
	vim-flavor install

The test suite can then be run via the rake task:

	rake test

### Documentation

The documentation in `doc/` is generated from the plug-in source code via
[vimdoc][vimdoc]. Do not edit `doc/skeleton.txt` directly. Refer to the
existing inline documentation as a guide for documenting new code.

The help doc can be rebuilt by running:

	vimdoc ./

## Credits & License

[vim-skeleton][repo] is based on @tpope's [ztemplate.vim][ztemplate] and
@godlygeek's [snippets.vim][snippets] and is maintained by [Noah
Frederick][home]. It is distributed under the same terms as Vim itself (`:help
license`).

[buildimg]: https://travis-ci.org/noahfrederick/vim-skeleton.png?branch=master
[repo]: https://github.com/noahfrederick/vim-skeleton
[ztemplate]: https://github.com/tpope/tpope/blob/master/.vim/plugin/ztemplate.vim
[snippets]: https://github.com/godlygeek/vim-files/blob/master/plugin/snippets.vim
[home]: http://noahfrederick.com/
[vspec]: https://github.com/kana/vim-vspec
[vim-flavor]: https://github.com/kana/vim-flavor
[vimdoc]: https://github.com/google/vimdoc
