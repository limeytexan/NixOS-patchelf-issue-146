with import <nixpkgs> { };

buildGoModule rec {
  name = "issue_146";
  src = ./.;
  vendorSha256 = "1hc3nmxnc3zc9bis1aj69nrb2ww60b9bvvgz6p7xxa1v6n35nlld";
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ glibc kerberos ];
  CGO_LDFLAGS = "-lgssapi_krb5";

  # Keep original binary and create wrapped and patchelf'd versions for
  # comparison. Use "dontAutoPatchelf" to prevent autoPatchelf from patching
  # the original.
  dontAutoPatchelf = true;
  postFixup = ''
    # Create wrapped version to demonstrate the unpatched binary works.
    makeWrapper $out/bin/${name} $out/bin/${name}.wrapped \
      --set LD_LIBRARY_PATH "${lib.concatStringsSep ":" (map (p: "${p}/lib") buildInputs)}"
    # Create patchelf'd version which segfaults.
    cp $out/bin/${name}{,.patchelf}
    autoPatchelf -- $out/bin/${name}.patchelf
  '';
}
