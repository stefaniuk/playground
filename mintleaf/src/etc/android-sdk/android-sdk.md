## android-sdk

#### Description

This module automatically installs the Android SDK tool and provides facility to
download all the SDK packages without having to use SDK Manager user interface.

#### Supported Platforms

 * Mac OS X
 * Cygwin

#### Available arguments

To download all the SDK packages while installing or updating this module use:

    --android-sdk-update-packages

To only update already installed SDK packages but not the module itself use:

    --android-sdk-update-packages-only

#### Caveats

At the moment, all the SDK packages are downloaded. This may take up to a few
hours before installation process completes.
