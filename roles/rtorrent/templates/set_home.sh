#!/bin/sh -x
export HOME="`eval printf ~$(whoami)`"
exec "$@"
