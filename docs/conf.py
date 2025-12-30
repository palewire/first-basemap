"""Configuration file for the Sphinx documentation builder."""

from datetime import datetime

project = "First Basemap"
year = datetime.now().year
copyright = f"{year} palewire"

templates_path = ["_templates"]
html_static_path = ["_static"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]
source_suffix = ".md"
master_doc = "index"

html_theme = "palewire"
pygments_style = "sphinx"

html_css_files = [
    (
        "https://unpkg.com/maplibre-gl@5.15.0/dist/maplibre-gl.css",
        {"crossorigin": "anonymous"},
    ),
]

html_js_files = [
    (
        "https://unpkg.com/maplibre-gl@5.15.0/dist/maplibre-gl.js",
        {"crossorigin": "anonymous"},
    ),
    ("https://unpkg.com/pmtiles@3/dist/pmtiles.js", {"crossorigin": "anonymous"}),
]

html_sidebars = {
    "**": [
        "about.html",
        "navigation.html",
    ]
}
html_theme_options = {
    "canonical_url": "https://palewi.re/docs/first-basemap/",
}

extensions = [
    "myst_parser",
]

myst_enable_extensions = [
    "attrs_block",
    "colon_fence",
]
