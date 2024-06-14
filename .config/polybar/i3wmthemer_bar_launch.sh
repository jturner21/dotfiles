#!/bin/env sh

pkill polybar

sleep 1;

polybar bottom1 &
polybar top &
