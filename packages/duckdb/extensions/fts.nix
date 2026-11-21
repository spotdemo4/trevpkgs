{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "fts";
  repo = "duckdb-fts";
  rev = "623ee80e0bd5a771347f7dd320915cc3ef2fb965";
  hash = "sha256-6uQnLho05QmIC2CKTwqx4fvKTP6wJ3mibpz63QSP968=";
  loadOptions = [
    "SOURCE_DIR \${PROJECT_SOURCE_DIR}/extension_external/fts"
    "INCLUDE_DIR \${PROJECT_SOURCE_DIR}/extension_external/fts/extension/fts/include"
  ];
}
