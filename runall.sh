#!/bin/sh

for f in ./*.out ; do
	echo "$f"
	"$f" 2.200002 2.200001 5
done
