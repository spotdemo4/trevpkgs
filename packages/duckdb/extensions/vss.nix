{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "vss";
  repo = "duckdb-vss";
  branch = "v1.5-variegata";
  rev = "6264ee9162c3a08f85914783e8625d27fbce257b";
  hash = "sha256-2wQWhopMCS6q+aoGO5lf42VeTvw+a3s0WROJsqV4v/k=";
  loadOptions = [ "DONT_LINK" ];
  duckdbPostPatch = ''
    substituteInPlace \
      extension_external/vss/src/hnsw/hnsw_index.cpp \
      extension_external/vss/src/include/hnsw/hnsw_index.hpp \
      --replace-fail "CommitDrop" "ResetStorage"
  '';
}
