#!/bin/sh

if [[ -z "${USERNAME}" ]]; then
  echo "Hello World!"
else
  echo "Hello $USERNAME!"
fi

exit 0
