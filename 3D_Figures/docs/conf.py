# Configuration file for Sphinx documentation builder

project = 'Numerical Methods'
copyright = '2026, Course Materials'
author = 'Course Materials'
release = '1.0'

extensions = [
    'sphinx.ext.mathjax',
    'myst_parser',
    'sphinx_rtd_theme',
]

# Source file suffix
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

# Theme
html_theme = 'sphinx_rtd_theme'
html_theme_options = {
    'logo_only': False,
    'display_version': True,
    'version_selector': True,
    'prev_next_buttons_location': 'bottom',
    'style_external_links': False,
    'style_nav_header_background': '#2c3e50',
    'style_primary_color': '#3498db',
    'style_secondary_color': '#2980b9',
    'collapse_navigation': False,
    'sticky_navigation': True,
    'navigation_depth': 5,
    'includehidden': True,
    'titles_only': False,
    'breadcrumbs': True,
    'canonical_url': 'https://sewaksunar.github.io/Numerical-Method/',
    'analytics_id': '',
    'body_max_width': '1000px',
    'right_sidebar_width': '300px',
}

# HTML theme assets
html_logo = None
html_favicon = None

# Math rendering with MathJax
mathjax_path = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'

# MyST parser settings for better markdown support
myst_enable_extensions = [
    "dollarmath",
    "colon_fence",
    "substitution",
    "deflist",
    "fieldlist",
]

# HTML output
import os
html_static_path = ['_static'] if os.path.exists('_static') else []
html_show_sourcelink = False
html_show_sphinx = True
html_show_copyright = True
html_use_smartypants = True

# Custom CSS
def setup(app):
    app.add_css_file('custom.css')

# Exclude patterns
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store', '.nojekyll']

# Master document
master_doc = 'index'
suppress_warnings = ['myst.header_anchor']

# Additional Sphinx settings
language = 'en'
pygments_style = 'sphinx'
todo_include_todos = False
