{ callPackage, curl }:

(callPackage ./generic.nix { }) {
  name = "httpfs";
  repo = "duckdb-httpfs";
  branch = "main";
  rev = "b85f6b1d3f127e5bb1ee4dc043d1f23da17517dd";
  hash = "sha256-A/oFX3NDWQpQ2b9bYiHOURlhL2Y4A369B3b2sqKIo2o=";
  duckdbBuildInputs = [
    curl
  ];
}
