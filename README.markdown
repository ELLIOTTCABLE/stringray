StringRay
=========

**StringRay** exposes a powerful method to split a `String` into an `Array` of
words, and further allows you to include `Enumerable`, thus exposing many of the most useful `Array` methods on your `String`s.

Links
-----

* [source (GitHub)](http://github.com/elliottcable/stringray "GitHub source repository")
* [wiki (Google Code)](http://code.google.com/p/stringray/w/list "Google Code wiki")
* [issues (Google Code)](http://code.google.com/p/stringray/issues "Google Code issues")
* [Gitorious mirror](http://gitorious.org/projects/stringray "Gitorious source repository")
* [RubyForge mirror](http://rubyforge.org/projects/stringray/ "RubyForge project")
* [repo.or.cz mirror](http://repo.or.cz/w/stringray.git "repo.or.cz source repository")


Usage
-----
    
    class String; include StringRay; end
    
    "Oi! I'm a string, do something fun with me!".enumerate do |word|
      p word
    end
    
    class String; make_enumerable!; end
    "Who, what, when, where, why? The questions these are.".map do |word|
      word << word[0].chr
    end
    
Getting
-------

The authoritative source for this project is available at
<http://github.com/elliottcable/stringray>. You can clone your own copy with
the following command:

    git clone git://github.com/elliottcable/stringray.git

If you want to make changes to the codebase, you need to fork your own GitHub
repository for said changes. Send a pullrequest to [elliottcable](http://github.com/elliottcable "elliottcable on GitHub")
when you've got something ready for the master branch that you think should be
merged.

Requirements
------------

To use StringRay, you need... nothing!

Contributing
------------

To develop and contribute to StringRay, you need...

* `gem install rake`
* `gem install rspec`
* `gem install rcov`
* `gem install echoe`