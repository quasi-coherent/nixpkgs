cargo-clean-all () {
    for proj in $(find $1 -name Cargo.toml | xargs readlink -f | xargs dirname); do
        pushd $proj;
        cargo clean;
        popd;
    done
}
