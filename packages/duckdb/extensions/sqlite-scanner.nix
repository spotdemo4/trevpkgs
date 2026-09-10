{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "sqlite_scanner";
  repo = "duckdb-sqlite";
  branch = "v1.5-variegata";
  rev = "5274128259f73166c1f37f01190a4601f84c5525";
  hash = "sha256-ZRFwFIp2v2auDpb820twKXE1x/UKXiZN2EH3Q3C7U20=";
}
