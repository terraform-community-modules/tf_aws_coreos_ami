.PHONY: all

all: clean variables.tf.json

variables.tf.json:
	ruby getvariables.rb > variables.tf.json

clean:
	rm -f variables.tf.json

