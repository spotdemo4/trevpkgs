{
  aws-sdk-cpp,
  callPackage,
  curl,
  zlib,
}:

(callPackage ./generic.nix { }) {
  name = "aws";
  repo = "duckdb-aws";
  rev = "1b96925856ded7c9cbde7403fdb3d467d0cdf779";
  hash = "sha256-SQs9ywEBTKAX3sy2R0y3h6SAP9TjARGiAyUzMCHLFiA=";
  duckdbBuildInputs = [
    aws-sdk-cpp
    curl
    zlib
  ];
}
