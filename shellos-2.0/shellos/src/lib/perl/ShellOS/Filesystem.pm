package ShellOS::Filesystem;

use strict;
use warnings;
use utf8;
use base 'Exporter';

use Cwd;

##
## include
##

use File::Basename;

##
## export
##

our @EXPORT = qw(

    dir_create
    symlink_create
    symlink_create_rel

);

##
## public static methods
##

# dir_create($dir, $user, $group, $permissions)
sub dir_create {

    my ($dir, $user, $group, $permissions) = @_;

    unless(-d File::Basename::dirname($dir)) {
        dir_create(File::Basename::dirname($dir), $user, $group, $permissions);
    }

    `mkdir $dir; chown $user:$group $dir; chmod $permissions $dir`;
}

# symlink_create($link, $dest)
sub symlink_create {

    my ($link, $dest) = @_;

    if((-f $dest || -d $dest) && (! -e $link)) {
        `ln -s $dest $link`;
    }
}

# symlink_create_rel($dir, $link, $dest)
sub symlink_create_rel {

    my ($dir, $link, $dest) = @_;

    my $current_dir = getcwd;
    chdir $dir;
    if((-f $dest || -d $dest) && (! -e $link)) {
        symlink($dest, $link);
    }
    chdir $current_dir;
}

1;

