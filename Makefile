all: elm.js

clean:
	rm -f elm.js

elm.js: $(wildcard src/*.elm src/*/*.elm)
	elm make --output elm.js src/Main.elm
