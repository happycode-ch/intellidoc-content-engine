#!/bin/bash
# Setup clean content directory structure for IntelliDoc Content Engine

echo "=== Setting up content directory structure ==="

# Create main content type directories
echo "Creating main content directories..."
mkdir -p content/{blog,tutorials,news,whitepapers,series}

# Create sources directories
echo "Creating sources directories..."
mkdir -p content/sources/{internal,external}

# Create social media subdirectories
echo "Creating social media directories..."
mkdir -p content/social/{twitter,linkedin,instagram}

# Create Swiss localization directories
echo "Creating Swiss language directories..."
mkdir -p content/swiss/{de,fr,it}

# Create archive directory
echo "Creating archive directory..."
mkdir -p content/.archive

# Add .gitkeep files to maintain structure in git
echo "Adding .gitkeep files..."
touch content/.gitkeep
touch content/{blog,tutorials,news,whitepapers,series}/.gitkeep
touch content/sources/.gitkeep
touch content/sources/{internal,external}/.gitkeep
touch content/social/.gitkeep
touch content/social/{twitter,linkedin,instagram}/.gitkeep
touch content/swiss/.gitkeep
touch content/swiss/{de,fr,it}/.gitkeep
touch content/.archive/.gitkeep

echo ""
echo "✅ Content directory structure created successfully!"
echo ""
echo "Directory structure:"
echo "content/"
echo "├── blog/              # Blog posts"
echo "├── tutorials/         # Step-by-step guides"
echo "├── news/              # News articles"
echo "├── whitepapers/       # Long-form documents"
echo "├── series/            # Multi-part content"
echo "├── sources/           # Reference materials"
echo "│   ├── internal/     # Internal documentation"
echo "│   └── external/     # External references"
echo "├── social/            # Social media posts"
echo "│   ├── twitter/"
echo "│   ├── linkedin/"
echo "│   └── instagram/"
echo "├── swiss/             # Swiss localized content"
echo "│   ├── de/           # German"
echo "│   ├── fr/           # French"
echo "│   └── it/           # Italian"
echo "└── .archive/          # Archived content"