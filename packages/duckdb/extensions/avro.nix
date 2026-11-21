{
  callPackage,
  jansson,
  snappy,
  xz,
  zlib,
}:

(callPackage ./generic.nix { }) {
  name = "avro";
  repo = "duckdb-avro";
  rev = "4176191c961fe5c0763976b8b869e30ba0e93054";
  hash = "sha256-cPiXl3x8vcC2bkZgPiYX4iePUEi25nZuZet2A0yJ8RI=";
  # avro-c is built from the third_party/avro-c submodule
  fetchSubmodules = true;
  duckdbBuildInputs = [
    jansson
    snappy
    xz
    zlib
  ];
  duckdbPostPatch = ''
    # avro-c's cmake runs version.sh, which expects /bin/bash
    patchShebangs extension_external/avro/third_party/avro-c/lang/c/version.sh

    # avro-c predates C23, which newer compilers default to
    substituteInPlace extension_external/avro/CMakeLists.txt \
      --replace-fail "# Add avro-c from submodule" "set(CMAKE_C_STANDARD 17)
    set(CMAKE_C_FLAGS \"\''${CMAKE_C_FLAGS} -Wno-incompatible-pointer-types\")
    # Add avro-c from submodule"
  '';
}
