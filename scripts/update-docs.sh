#!/bin/bash

# Documentation Auto-Update Script
# This script updates documentation timestamps and metadata

set -e

DOCS_DIR="/home/runner/work/kybers/kybers/docs"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

echo "🔄 Starting documentation update..."

# Function to update timestamp in README files
update_timestamp() {
    local file="$1"
    if [ -f "$file" ]; then
        # Update the last updated line
        sed -i "s/\*Last updated:.*/\*Last updated: $TIMESTAMP (Auto-generated on merge to main)\*/" "$file"
        echo "✅ Updated: $file"
    fi
}

# Update all README files in docs subdirectories
for readme in "$DOCS_DIR"/*/README.md; do
    if [ -f "$readme" ]; then
        update_timestamp "$readme"
    fi
done

# Generate documentation index
cat > "$DOCS_DIR/INDEX.md" <<EOF
# Kybers DEX Documentation Index

*Last updated: $TIMESTAMP*

## Documentation Sections

### 📢 [Sponsors](./sponsors/README.md)
Information about our sponsors and sponsorship opportunities.

### 📱 [Marketing](./marketing/README.md)
Marketing materials, brand guidelines, and promotional assets.

### 💰 [Financial](./financial/README.md)
Financial details, tokenomics, and revenue models.

### 👥 [Founders](./founders/README.md)
Information about the founding team and core contributors.

## Quick Links

- [Main Website](../app/index.html)
- [API Documentation](../app/api/README.md)
- [GitHub Repository](https://github.com/SMSDAO/kybers)

## Automated Updates

This documentation is automatically updated on every merge to the main branch.
The last update was performed on: $TIMESTAMP

EOF

echo "✅ Generated documentation index"

# Generate a changelog entry
CHANGELOG_FILE="$DOCS_DIR/CHANGELOG.md"
if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "# Documentation Changelog" > "$CHANGELOG_FILE"
    echo "" >> "$CHANGELOG_FILE"
fi

echo "## Update - $TIMESTAMP" >> "$CHANGELOG_FILE"
echo "- Documentation auto-updated by master.sh script" >> "$CHANGELOG_FILE"
echo "- Timestamp refreshed across all sections" >> "$CHANGELOG_FILE"
echo "" >> "$CHANGELOG_FILE"

echo "✅ Updated changelog"
echo "🎉 Documentation update complete!"
