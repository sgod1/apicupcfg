#!/bin/bash

function _zomadir() {
   local zomadir="zoma"
   mkdir -p ./$zomadir
   echo $zomadir
}

function _zomadirf() {
   local filename=$1
   echo $(_zomadir)/$filename
}
