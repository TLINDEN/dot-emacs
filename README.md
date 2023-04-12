# My Personal Emacs Configuration

This is my personal emacs configuration.  It is more than 20 years old
and may contain obskure or outright nonsense code and customization.

I use this live whereever I use emacs. You may try it at your own risk
or take a look as you wish.

Please be advised,  that I'll not answer any issues  or other requests
for this repo.

You can read the [HTML export of my OLD .emacs file here](https://rawgit.com/TLINDEN/dot-emacs/master/emacs.html).

# How it works

Check this repo out into `~/.emacs.d/`.

The starting point is `init.el`,  it configures some global things and
initializes  the  package  manager.   It  then  loads  every  file  in
`~/.emacs.d/init/*.el`, which are symlinks to  the real load files.

In order  to be able to  force a particular load  order, every symlink
contains a number in its name.

To disable some module, just remove the symlink.

# License

GPLv3
