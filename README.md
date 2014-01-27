# gemignore

[![Gem Version](https://badge.fury.io/rb/gemignore.png)](http://badge.fury.io/rb/gemignore)

Gemignore allows you to easily add .gitignore snippets to the .gitignore file in your current working directory. The snippets are taken from [the GitHub gitignore repository](https://github.com/github/gitignore), so if there is anything missing, feel free to fork that repository and create a pull request :)

# Installation

    $ gem install gemignore

# Usage

To search for a .gitignore snippet, simply type

    $ gemignore search linux    # or
	$ gemignore s linux

To list all available snippets run

    $ gemignore list    # or
	$ gemignore l

And finally, to add a snippet to the .gitignore file in the **current working directory**:

    $ gemignore add Global/OSX    # or
    $ gemignore add osx    # or
	$ gemignore a osx

To display usage information you can use

    $ gemignore help


# Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright (c) 2014 Lucas Jenß

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

