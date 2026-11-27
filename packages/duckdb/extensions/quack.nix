{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "quack";
  repo = "duckdb-quack";
  rev = "3bc63c01f80a13d57ca02a721dd13908c1d934c1";
  hash = "sha256-DnmliMjsx2pgan7RVKT35Y2Ohj4mISDqKxFOYF/TWkY=";
  dependencies = [ "httpfs" ];
}
