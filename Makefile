VERSION=$(shell semver)
TODAY=$(shell date +%F)

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: production setup commit

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: preprocess

##
# Deploy to production
production:
	bundle exec cap production deploy

##
# Preprocess the template using ERB templating.
preprocess: index.html.erb
	bundle exec erb version=$(VERSION) date=$(TODAY) index.html.erb > index.html

commit: index.html
	git commit index.html -m"build $(VERSION)"

clean:
	rm -f "index.html"

##
# Set up the project for building
setup: ruby packages

ruby:
	bundle install

packages:
	apt-get install git-flow
