{
  aws-sdk-cpp,
  callPackage,
  croaring,
  curl,
  zlib,
}:

(callPackage ./generic.nix { }) {
  name = "iceberg";
  repo = "duckdb-iceberg";
  rev = "f979b5b28a044c49c38a26636ac01bc1f7047fa5";
  hash = "sha256-gwYRha9c3ToO/cTxLdcxGK4wR2vYjVr6aYIs2Z83zOA=";
  dependencies = [
    "avro"
    "httpfs"
  ];
  duckdbBuildInputs = [
    aws-sdk-cpp
    croaring
    curl
    zlib
  ];
}
