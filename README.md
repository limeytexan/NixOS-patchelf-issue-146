# Reproducer for https://github.com/NixOS/patchelf/issues/146

This collection of files provides a reproducer for the `patchelf` issue
noted above. To reproduce the bug invoke `nix-build` from within this
repository and invoke `result/bin/issue_146` followed by
`result/bin/issue_146.unpatched`:

```
$ nix-build
these derivations will be built:
  /nix/store/s0ap6gww54ry8lx8sx8mcc71flhdw5d6-issue_146.drv
building '/nix/store/s0ap6gww54ry8lx8sx8mcc71flhdw5d6-issue_146.drv'...
unpacking sources
unpacking source archive /nix/store/af9dbhwxlxjqby6f2i2kb2hrndzy9wgv-NixOS-patchelf-issue-146
source root is NixOS-patchelf-issue-146
patching sources
configuring
building
Building subPackage .
runtime/cgo
net
golang.org/x/sys/unix
github.com/sirupsen/logrus
crypto/x509
crypto/tls
net/textproto
vendor/golang.org/x/net/http/httpguts
vendor/golang.org/x/net/http/httpproxy
net/http/httptrace
net/http
issue_146
installing
post-installation fixup
shrinking RPATHs of ELF executables and libraries in /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146
shrinking /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146/bin/issue_146
strip is /nix/store/h4v5qdxlmnh7xfpl7pwzrs8js7220bz2-binutils-2.31.1/bin/strip
stripping (with command strip and flags -S) in /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146/bin
patching script interpreter paths in /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146
checking for references to /build/ in /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146...
automatically fixing dependencies for ELF files
searching for dependencies of /nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146/bin/issue_146
  libgssapi_krb5.so.2 -> found: /nix/store/r0v2kz5a9f888lqkslh9zhz67rh2hifq-libkrb5-1.18/lib/libgssapi_krb5.so.2
setting RPATH to: /nix/store/r0v2kz5a9f888lqkslh9zhz67rh2hifq-libkrb5-1.18/lib
/nix/store/rg77fl092bdwi893lrq3ybh9z5vh9l8b-issue_146

$ result/bin/issue_146
Segmentation fault (core dumped)

$ result/bin/issue_146.unpatched
result/bin/issue_146.unpatched: error while loading shared libraries: libgssapi_krb5.so.2: cannot open shared object file: No such file or directory

$ LD_LIBRARY_PATH=/nix/store/r0v2kz5a9f888lqkslh9zhz67rh2hifq-libkrb5-1.18/lib result/bin/issue_146.unpatched && echo works
works

$
```

Disclaimer: I am not a Go programmer; this reproducer was created by taking
a problem experienced in production and cutting it down through a process of
trial and error to the bare minimum Go code required to reproduce the issue.
