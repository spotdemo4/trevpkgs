{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

{
  name,
  repo,
  rev,
  hash,
  owner ? "duckdb",
  fetchSubmodules ? false,
  loadOptions ? [ ],
}:

stdenvNoCC.mkDerivation {
  pname = "duckdb-extension-${name}";
  version = builtins.substring 0 12 rev;

  src = fetchFromGitHub (
    {
      inherit
        owner
        repo
        rev
        hash
        ;
    }
    // lib.optionalAttrs fetchSubmodules {
      fetchSubmodules = true;
    }
  );

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -R ./. "$out/"
    chmod -R u+w "$out"

    runHook postInstall
  '';

  passthru.duckdbExtension = {
    inherit name loadOptions;
  };

  meta = {
    description = "DuckDB ${name} extension source";
    homepage = "https://github.com/${owner}/${repo}";
    platforms = lib.platforms.all;
  };
}
