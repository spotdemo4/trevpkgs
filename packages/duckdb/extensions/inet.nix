{
  callPackage,
  lib,
}:

(callPackage ./generic.nix { }) {
  name = "inet";
  repo = "duckdb-inet";
  branch = "main";
  rev = "f6a2a14f061d2dfccdb4283800b55fef3fcbb128";
  hash = "sha256-0gobkFDXa1u4BFXJqltCSj8acGc/t16RbzFBnxMTtC4=";
  fetchSubmodules = true;
  loadOptions = [ "DONT_LINK" ];
}
