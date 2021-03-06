#!/bin/bash -xe

main() {
    TARGET="$0"
    TARGET="${TARGET#./}"
    TARGET="${TARGET%.*}"
    TARGET="${TARGET#*.}"
    echo "TARGET=$TARGET"
    export TARGET

    echo "Start ovs process"
    /usr/share/openvswitch/scripts/ovs-ctl --system-id=random start

    cd ..
    mkdir -p go/src/kubevirt.io
    mkdir -p go/pkg
    export GOPATH=$(pwd)/go
    ln -s $(pwd)/ovs-cni go/src/kubevirt.io/
    cd go/src/kubevirt.io/ovs-cni

    echo "Run tests"
    make build test

    echo "Run functional tests"
    exec automation/test.sh
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
