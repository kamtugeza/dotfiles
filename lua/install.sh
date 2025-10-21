#!/usr/bin/env bash

if ! has_command "lua-language-server"; then
  brew install lua lua-language-server
fi

