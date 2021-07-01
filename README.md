# Build

    $ make

# Serve

Use a local webserver to serve index.html and elm.js like:

    $ python -m http.server

# Running

Use the --backend debug argument to brun in my clvm and clvm_tools branches like this:

    $ brun --backend debug '(sha256 (sha256 (q . "yodude") (q . "hithere")) (sha256 (q . 99) (sha256 (q . "chia"))))'

A file called sha256.trace will be appended (so we don't have to do anything fancy)

Use ```./python/collect-hashes.py``` to make input for the elm code:

    $ ./python/collect-hashes.py sha256.trace sha256.json

Then use the page's file selector to load it.
