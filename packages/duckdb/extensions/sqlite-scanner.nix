{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "sqlite_scanner";
  repo = "duckdb-sqlite";
  rev = "ce0987fda4f6393231c6783ee32f72ab873a6d3e";
  hash = "sha256-dmOo8sQq9HiwUIc+rLMQqUzWdloacXKmT9GpFvqe0+U=";
  fetchSubmodules = true;
}
