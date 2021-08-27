#!/usr/bin/env sh

if grep -q "if \[ -f \$HOME/.initrc \]" "$HOME/.bashrc"; then
  echo "already exists";

else
  cat >> $HOME/.bashrc <<-EOF

# custom init rc load
if [ -f \$HOME/.initrc ]; then
    . \$HOME/.initrc
fi

if [ -f \$HOME/.functionrc ]; then
    . \$HOME/.functionrc
fi

if [ -f \$HOME/.aliasrc ]; then
    . \$HOME/.aliasrc
fi

EOF

fi
