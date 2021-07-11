.PHONY: build run

build:
	dune build

run: build
	./_build/default/src/game.exe
