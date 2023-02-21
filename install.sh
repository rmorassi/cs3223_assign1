#!/usr/bin/env bash

# CS3223 Assignment 1 Part 1

VERSION=15.0

ASSIGN_DIR=$HOME/cs3223_assign1
DOWNLOAD_DIR=$HOME
SRC_DIR=${DOWNLOAD_DIR}/postgresql-${VERSION}
INSTALL_DIR=$HOME/pgsql
DATA_DIR=$HOME/pgdata
FILE=postgresql-${VERSION}.tar.gz

mkdir -p ${DOWNLOAD_DIR}
mkdir -p ${INSTALL_DIR}
mkdir -p ${DATA_DIR}

# Download PostgreSQL source files
cd ${DOWNLOAD_DIR}
wget https://ftp.postgresql.org/pub/source/v${VERSION}/$FILE
tar xvfz ${FILE}


# Install PostgreSQL
cd ${SRC_DIR}
export CFLAGS="-O2"
./configure --prefix=${INSTALL_DIR} --enable-debug  --enable-cassert
make clean
make world
make install
# make install-docs


# Install test_bufmgr extension
if [ ! -d ${ASSIGN_DIR} ]; then
	echo "Error: Assignment directory ${ASSIGN_DIR} missing!"
	exit 1
fi
if [ ! -d ${SRC_DIR}/contrib/test_bufmgr ]; then
	cp -r ${ASSIGN_DIR}/test_bufmgr ${SRC_DIR}/contrib
	cd ${SRC_DIR}/contrib/test_bufmgr
	make && make install 
fi
chmod u+x ${ASSIGN_DIR}/*.sh

# Create a database cluster
${INSTALL_DIR}/bin/initdb -D ${DATA_DIR}


# Update ~/.bash_profile
PROFILE=~/.bash_profile
touch ${PROFILE}
echo >> ${PROFILE}
echo "export PATH=${INSTALL_DIR}/bin:\$PATH" >> ${PROFILE}
echo "export MANPATH=${INSTALL_DIR}/share/man:\$MANPATH" >> ${PROFILE}
echo "export PGDATA=${DATA_DIR}" >> ${PROFILE}
echo "export PGUSER=$(whoami)" >> ${PROFILE}
echo >> ${PROFILE}


