#!/bin/bash

# welcome screen
cat <<EOF > /etc/motd.tail
    __               __  __ __
   / /_  ____  _____/ /_/ // / ____ ____   _________  ____ ___
  / __ \\/ __ \\/ ___/ __/ // /_/ __ \`/ _ \\ / ___/ __ \\/ __ \`__ \\
 / / / / /_/ (__  ) /_/__  __/ /_/ /  __// /__/ /_/ / / / / / /
/_/ /_/\\____/____/\\__/  /_/  \\__, /\\___(_)___/\\____/_/ /_/ /_/
                            /____/

EOF

exit 0
