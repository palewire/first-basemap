UV := uv run
PYTHON := python -W ignore -m

serve:
	@rm -rf docs/_build
	@cd docs && $(UV) make livehtml

.PHONY: serve
