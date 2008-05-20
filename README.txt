= plugit

* http://github.com/aiwilliams/plugit

== DESCRIPTION:

Having written a number of libraries, I have found that many of them depend on other libraries.
Often, those other libraries have multiple revisions and the people who use my libraries want
my libraries to work with all revisions of those other libraries. This can get hard to manage!

The goal of plugit is to make it easy to construct library environments within which you can
run tests, to show that your code works in more than just one environment. It also allows you
to keep from having copies of those libraries checked into your own repository. If they are
available for others to download, and you expect that they will, then you should have no problem
depending on them being available to you for future download, either!

This may all only prove useful to Rails plugin developers ;)

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

Plugit.describe do |mything|
  mything.environment :default, 'The one we want everyone using' do |env|
    env.library :example, '1.0', "cp -R #{File.dirname(__FILE__)}/../../../repositories/example/*"
    env.library :another, '2.0', "svn co http://something.com/svn/ALibrary"
  end
end

== REQUIREMENTS:

== INSTALL:

sudo gem install plugit --source=http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Adam Williams (aiwilliams)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.