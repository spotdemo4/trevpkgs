{ callPackage, curl }:

(callPackage ./generic.nix { }) {
  name = "httpfs";
  repo = "duckdb-httpfs";
  branch = "main";
  rev = "b444a6760db478299894cee19373dd12a50f4911";
  hash = "sha256-Nmjg3K4vUMd6a0SPH9BtiT8ze+40hcz2tEGK42a07Ng=";
  duckdbBuildInputs = [
    curl
  ];
}
