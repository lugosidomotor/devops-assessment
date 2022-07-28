#!/bin/bash

if [[ -z "${USERNAME}" ]]; then
  echo "Hello Word!"
else
  echo "Hello $USERNAME!"
fi

exit 0
