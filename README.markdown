StringRay
=========
**StringRay** exposes a powerful method to split a `String` into an `Array` of
words, and further allows you to include `Enumerable`, thus exposing many of the most useful `Array` methods on your `String`s.

Links
-----
- [Source code (GitHub)](
    http://github.com/elliottcable/stringray "GitHub source repository")
- [Issues and suggestions (GitHub)](
    http://github.com/elliottcable/stringray/issues "GitHub issues")

Usage
-----
Basic usage is really simple. Just take a normal `String` (the `StringRay`
magic has already been included for you) and enumerate over it, just as you
are used to doing with `Array`s. By default, this enumerates over the "words"
in the string.

    "Oi! I'm a string, do something fun with me!".enumerate do |word|
      p word
    end
    
    "Who, what, when, where, why? The questions these are.".map do |word|
      word << word[0]
    end

You can gain a *lot* more fine-grained control over how the string is treated
by passing arguments to the enumerator methods, or by explicitly creating a
`StringRay` enumerator and modifying it.

    TODO: More examples and usage summaries!

Getting
-------
The authoritative source for this project is available at
<http://github.com/elliottcable/stringray>. You can clone your own copy with
the following command:

    git clone git://github.com/elliottcable/stringray.git

If you want to make changes to the codebase, you need to fork your own GitHub
repository for said changes. Send a pullrequest to [elliottcable][] when
you've got something ready for the master branch that you think should be
merged.

  [elliottcable]: http://github.com/elliottcable
    "elliottcable's profile on GitHub"

Requirements
------------
To use StringRay, you need... nothing!

Contributing
------------
To develop and contribute to StringRay, you need...

- `gem install rake`
- `gem install echoe`
- `gem install rspec`
- `gem install relevance-rcov`
- `gem install yard`

Mirrors
-------
If GitHub is unavailable, or you prefer to fork one one of the following
sources, they are also available:

- [Gitorious mirror](http://gitorious.org/projects/stringray
    "Gitorious source repository")
- [RubyForge mirror](http://rubyforge.org/projects/stringray/
    "RubyForge project")
- [repo.or.cz mirror](http://repo.or.cz/w/stringray.git
    "repo.or.cz source repository")
