{
  callPackage,
  croaring,
}:

(callPackage ./generic.nix { }) {
  name = "ducklake";
  repo = "ducklake";
  rev = "08089b16dc8a18ce04abb6efd87e25cb4d64803a";
  hash = "sha256-T4XA2TrADtdhW3axrn5nytWEC27QeBYDXFReergDm2c=";
  duckdbBuildInputs = [ croaring ];
}
