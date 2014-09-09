How to create a patch file?
---------------------------

diff -crB dir_old dir > ./patches/dir.patch

How to apply a patch?
---------------------

patch --dry-run -p1 -i ./patches/dir.patch
patch -p1 -i ./patches/dir.patch

How to revert a patch?
----------------------

patch -p1 -R < ./patches/dir.patch
