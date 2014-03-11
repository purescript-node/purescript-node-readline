all: lib test

lib:
	mkdir -p js/System/
	psc src/System/ReadLine.purs.hs \
	  -o js/System/ReadLine.js \
	  -e js/System/ReadLine.e.purs.hs \
	  --module System.ReadLine --tco --magic-do

test:
	psc src/System/ReadLine.purs.hs examples/Examples.purs.hs \
	  -o js/Examples.js \
	  --main --module Main --tco --magic-do
