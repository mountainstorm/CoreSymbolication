CoreSymbolication
-----------------

Here are the reverse engineered headers for Apples CoreSymbolication private
framework.

I've created these so that I can build dtrace from source; I'm using dtrace-90
(from Apples open source site).  If you want to do the same you'll just need
to add the path to the header files into the dtrace projects "Header search
path"

Turns out though that this is a great symbol api.  If you've ever needed to
get symbols from files/processes/kernel this makes it so much easier.  You can
see all the symbols, get the ranges for them and even extract the instruction
bytes.  Yes, you never need worry again about parsing mach-o symbol tables.

Its not complete at the moment, I've just done the methods needed to compile
dtrace; but most of the other methods should be pretty easy to guess the
prototypes for as they're all pretty uniform.

Enjoy!

Rich


License
------- 

Created by R J Cooper on 05/06/2012. This file: Copyright (c)
2012 Mountainstorm API: Copyright (c) 2008 Apple Inc. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
