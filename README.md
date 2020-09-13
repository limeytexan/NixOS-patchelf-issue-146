# Reproducer for https://github.com/NixOS/patchelf/issues/146

This collection of files provides a reproducer for the `patchelf` issue
noted above. To reproduce the bug invoke `nix-build` from within this
repository and invoke each of the files found in `result/bin`.

```
$ nix-build
these derivations will be built:
  /nix/store/9k532l30k68f2szb02f9dxyq1hnn43vj-issue_146.drv
building '/nix/store/9k532l30k68f2szb02f9dxyq1hnn43vj-issue_146.drv'...
unpacking sources
unpacking source archive /nix/store/z6hy06xnn2a5pciyzr7aqmpzas8hwdxz-NixOS-patchelf-issue-146
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
shrinking RPATHs of ELF executables and libraries in /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146
shrinking /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146/bin/issue_146
strip is /nix/store/h4v5qdxlmnh7xfpl7pwzrs8js7220bz2-binutils-2.31.1/bin/strip
stripping (with command strip and flags -S) in /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146/bin
patching script interpreter paths in /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146
checking for references to /build/ in /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146...
automatically fixing dependencies for ELF files
searching for dependencies of /nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146/bin/issue_146.patchelf
  libgssapi_krb5.so.2 -> found: /nix/store/r0v2kz5a9f888lqkslh9zhz67rh2hifq-libkrb5-1.18/lib/libgssapi_krb5.so.2
setting RPATH to: /nix/store/r0v2kz5a9f888lqkslh9zhz67rh2hifq-libkrb5-1.18/lib
/nix/store/4fhk4mynwlddiviwxv423kd7m2fn2xm3-issue_146

$ for i in result/bin/*; do echo -n $i "... " && $i && echo WORKS; done
result/bin/issue_146 ... result/bin/issue_146: error while loading shared libraries: libgssapi_krb5.so.2: cannot open shared object file: No such file or directory
result/bin/issue_146.patchelf ... Segmentation fault (core dumped)
result/bin/issue_146.wrapped ... WORKS

$
```

Disclaimer: I am not a Go programmer; this reproducer was created by taking
a problem experienced in production and cutting it down through a process of
trial and error to the bare minimum Go code required to reproduce the issue.
