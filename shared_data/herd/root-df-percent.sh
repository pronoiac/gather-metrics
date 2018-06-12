#!/bin/bash

percent=$(df / |\
  egrep -o "[0-9]+%" |\
  egrep -o "[0-9]+")

echo "root_df_used_percent=$percent"