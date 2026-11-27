{
  callPackage,
  libpq,
}:

(callPackage ./generic.nix { }) {
  name = "postgres_scanner";
  repo = "duckdb-postgres";
  rev = "8b9d0bbe8de4c57fb90d9e2530f9ce39f8c4baf3";
  hash = "sha256-a5Tej/FckRXjDF66CDee9XNixFARm9ZvFht1+xy8Xzs=";
  fetchSubmodules = true;
  duckdbBuildInputs = [ libpq ];
}
