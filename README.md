# Userfrosting Docker

This builds a production-style Docker container for Userfrosting.

It automatically creates secure database passwords (they will be stored
in a folder called 'siteconfig', which is created automatically), and
exposes the web port on port 8086.

Typing 'make' will completely rebuild the container (if needed), and
prepare it for being pushed out to a private repository.

## Useful Commands

* make shell

    Opens a shell into the running container
    
* make stop
    
    Stops the running container
    
* make stopall

    Stops the running container *and* the databases. **Note:** This destroys any persistant
    data stored, and the database will need to be reconfigured. This will probably confuse
    the makefile, so you will probably want to run `make shell` and then `php bakery bake` to
    reconfigure the databases.




# Licence

This is licenced under the permissive MIT Licence.

    Copyright 2019 Rob Thomas <xrobau@gmail.com>
    
    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation 
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included 
    in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.


