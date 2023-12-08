#!/bin/bash

set -e

rm -f /studying_mate/tmp/pids/server.pid

exec "$@"
