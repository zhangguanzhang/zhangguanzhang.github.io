#!/bin/bash
find . -type f ! -size 0 -exec perl -le 'for(@ARGV){open(A,"<",$_)or
  next;seek A,0,4;$p=tell A;seek A,0,2;print if$p!=tell A;close A}' {} +