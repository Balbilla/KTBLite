#!/bin/bash

export ANT_OPTS='-Xmx16g -Dinfo.aduna.platform.appdata.basedir=./webapps/openrdf-sesame/app_dir/ -Dorg.eclipse.jetty.LEVEL=WARN -Dorg.eclipse.jetty.serverHttpConfiguration.requestHeaderSize=32768 -Dorg.eclipse.jetty.server.HttpConfiguration.responseHeaderSize=32768'

sw/ant/bin/ant -S -f local.build.xml $*
