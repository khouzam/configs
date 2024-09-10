#! /bin/bash
CLONE_DIR=$(mktemp -d)
git clone https://github.com/romkatv/powerlevel10k-media.git ${CLONE_DIR}/fonts
cd ${CLONE_DIR}

if test "$(uname)" = "Darwin"; then
    # MacOS
    FONTS_DIR="${HOME}/Library/Fonts"
else
    # Linux
    FONTS_DIR="${HOME}/.local/share/fonts"
    mkdir -p ${FONTS_DIR}
fi

cp fonts/*.ttf ${FONTS_DIR}

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "${FONTS_DIR}"
fi

rm -rf fonts
