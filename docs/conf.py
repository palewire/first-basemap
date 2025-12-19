"""Configuration file for the Sphinx documentation builder."""

from typing import Any
from datetime import datetime

project = "First Basemap"
year = datetime.now().year
copyright = f"{year} palewire"

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]
source_suffix = ".md"
master_doc = "index"

html_theme = "palewire"
pygments_style = "sphinx"

html_sidebars = {
    "**": [
        'about.html',
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
