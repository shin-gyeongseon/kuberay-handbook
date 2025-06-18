.PHONY: help serve build clean deploy

# Default target
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  serve     Start the live-reloading docs server"
	@echo "  build     Build the documentation site"
	@echo "  clean     Clean the build directory"
	@echo "  deploy    Deploy to GitHub Pages"
	@echo "  help      Show this help message"

# Start the live-reloading docs server
serve:
	@echo "Starting MkDocs development server..."
	@mkdocs serve

# Build the documentation site
build:
	@echo "Building documentation..."
	@mkdocs build --clean
	@echo "Build complete. The HTML pages are in site/."

# Clean the build directory
clean:
	@echo "Cleaning build directory..."
	@rm -rf site/

# Deploy to GitHub Pages
deploy:
	@echo "Deploying to GitHub Pages..."
	@mkdocs gh-deploy --force

# Install dependencies
install:
	@echo "Installing dependencies..."
	pip install -r requirements.txt

# Check for broken links
check-links:
	@echo "Checking for broken links..."
	mkdocs build --strict

# Create a new markdown file
# Usage: make new name="my-new-page"
new:
	@if [ -z "$(name)" ]; then \
		echo "Error: Please specify a name with make new name=filename" >&2; \
		exit 1; \
	fi
	@if [ -f "docs/$(name).md" ]; then \
		echo "Error: docs/$(name).md already exists" >&2; \
		exit 1; \
	fi
	@echo "Creating docs/$(name).md..."
	@echo "# $(shell echo $(name) | sed 's/.*/\u&/' | sed 's/-/ /g')" > docs/$(name).md
	@echo "" >> docs/$(name).md
	@echo "Content goes here..." >> docs/$(name).md
	@echo "File created at docs/$(name).md"