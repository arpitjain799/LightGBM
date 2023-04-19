#!/bin/sh

DIST_DIR=${1}

echo "checking Python package distributions in '${DIST_DIR}'"

pip install \
    -qq \
    check-wheel-contents \
    pydistcheck \
    twine || exit -1

echo "twine check..."
twine check --strict ${DIST_DIR}/* || exit -1

if { test "${TASK}" = "bdist" || test "${METHOD}" = "wheel"; }; then
    echo "check-wheel-contents..."
    check-wheel-contents ${DIST_DIR}/*.whl || exit -1
fi

echo "pydistcheck..."
pydistcheck \
    --inspect \
    --max-allowed-size-compressed '5M' \
    --max-allowed-size-uncompressed '15M' \
    --max-allowed-files 800 \
    ${DIST_DIR}/* || exit -1

echo "done checking Python package distributions"
