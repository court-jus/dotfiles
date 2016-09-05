#! /bin/sh

find /home/gl/src/clarisys/MCA3/ -name "*.py" | xargs ctags -f ~/src/clarisys/MCA3/tags
find /home/gl/local/lib/python2.6/site-packages/django/ -name "*.py" | xargs ctags -a -f ~/src/clarisys/MCA3/tags
