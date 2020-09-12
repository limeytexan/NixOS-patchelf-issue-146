with import <nixpkgs> { };

buildGoModule rec {
  name = "issue_146";
  src = ./.;
  vendorSha256 = "1hc3nmxnc3zc9bis1aj69nrb2ww60b9bvvgz6p7xxa1v6n35nlld";
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc kerberos ];
  CGO_LDFLAGS = "-lgssapi_krb5";

  # Create "unpatched" copy and ensure it doesn't get patchelf'd by setting
  # "dontAutoPatchelf" and then manually invoking "autoPatchelf" on just the
  # original file.
  dontAutoPatchelf = true;
  postFixup = ''
    cp $out/bin/${name}{,.unpatched}
    autoPatchelf -- $out/bin/${name}
  '';
}
