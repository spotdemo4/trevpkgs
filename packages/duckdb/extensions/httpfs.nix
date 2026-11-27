{
  lib,
  stdenv,
  callPackage,
  curl,
  pkg-config,
}:

(callPackage ./generic.nix { }) {
  name = "httpfs";
  repo = "duckdb-httpfs";
  rev = "f71cfdb4bff85b9e15b1f3b842d9aa395aff0167";
  hash = "sha256-rTG5cQlvwvyfPWnLTvuUmUH0sEfjbQiyInHCKtM0Q9U=";
  duckdbBuildInputs = [
    curl
  ];
  pkgConfigModules = [ "libcurl" ];
  # FindCURL only reports libcurl itself, but libcurl.a also needs its private dependencies
  duckdbNativeBuildInputs = lib.optionals stdenv.hostPlatform.isStatic [
    pkg-config
  ];
  duckdbPostPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace extension_external/httpfs/CMakeLists.txt \
      --replace-fail 'find_package(CURL REQUIRED)' 'find_package(CURL REQUIRED)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(LIBCURL REQUIRED libcurl)
    set(CURL_LIBRARIES ''${LIBCURL_STATIC_LDFLAGS})'
  '';
}
