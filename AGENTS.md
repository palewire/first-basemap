# AGENTS.md

## Project Overview

**First Basemap** is an educational tutorial project that teaches users how to create fast, virtually free interactive world maps using OpenStreetMap data and the PMTiles format. The project demonstrates how to leverage GitHub Actions, AWS EC2, and Planetiler to build modern web-based basemaps without the need for expensive commercial mapping services or complex server infrastructure.

## Key Files for AI Agents

When working on this project, focus on:

- **Documentation Content**: All `.md` files in `docs/` directory
- **Sphinx Config**: `docs/conf.py` for documentation build settings
- **Project Metadata**: `pyproject.toml` for Python packaging
- **Static Assets**: `docs/_static/` for images and style files

## Common Tasks for AI Agents

1. **Updating Documentation**: Edit Markdown files in `docs/`
2. **Adding New Sections**: Create new `.md` files and update `index.md` toctree
3. **Fixing Links**: Ensure cross-references between docs pages work correctly
4. **Improving Examples**: Update YAML workflow examples or code snippets
5. **Clarifying Instructions**: Make technical steps easier to follow

## Build Commands

While the project is primarily documentation, standard Sphinx commands apply:

```bash
cd docs
make html           # Build HTML documentation
make clean          # Clean build artifacts
```

## External Resources

- Tutorial Website: https://palewi.re/docs/first-basemap/
- GitHub Repository: https://github.com/palewire/first-basemap
- Related Courses: https://palewi.re/docs/

## Notes for AI Coding Assistants

- This is primarily an **educational/documentation project**, not a software library
- The "code" examples are GitHub Actions YAML workflows, not executable Python
- Focus on clarity and accessibility when editing documentation
- The audience includes both technical and semi-technical users
- Screenshots are stored in `docs/_static/` directory
- The MyST (Markedly Structured Text) flavor of Markdown is used for Sphinx compatibility
