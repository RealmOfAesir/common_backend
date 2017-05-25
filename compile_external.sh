#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CPUS="$( grep -c ^processor /proc/cpuinfo )"
cd $DIR/external/common
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .
make -j$CPUS
cd $DIR/external/libpqxx
./configure --disable-documentation
make -j$CPUS
cd $DIR/external/librdkafka
./configure
make -j$CPUS
cd $DIR
