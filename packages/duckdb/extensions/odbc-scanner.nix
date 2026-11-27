{
  callPackage,
  unixodbc,
}:

(callPackage ./generic.nix { }) rec {
  name = "odbc_scanner";
  repo = "odbc-scanner";
  rev = "ef4382fbfcb238e3012373384ae4e1953f3736a3";
  hash = "sha256-7sja9Sqfm0bmYixmQQ5AaGF/bSOZVePuo1ybZKTRCjc=";
  # C API extension with its own target instead of build_loadable_extension
  loadableTarget = "odbc_scanner";
  linkable = false;
  duckdbBuildInputs = [ unixodbc ];
  duckdbPostPatch = ''
    python3 - <<'PY'
    from pathlib import Path

    path = Path("extension_external/odbc_scanner/CMakeLists.txt")
    text = path.read_text()
    old = (
        "    find_package(Git)\n"
        "    if(Git_FOUND)\n"
        "        execute_process(\n"
        "            COMMAND $" + "{GIT_EXECUTABLE} rev-parse --short=10 HEAD\n"
        "            WORKING_DIRECTORY $" + "{CMAKE_CURRENT_SOURCE_DIR}\n"
        "            OUTPUT_VARIABLE $" + "{EXTENSION_NAME}_GIT_COMMIT_HASH\n"
        "            OUTPUT_STRIP_TRAILING_WHITESPACE)\n"
        "    else()\n"
        "        message(FATAL_ERROR \"Unable to get Git version for extension: $" + "{EXTENSION_NAME}\")\n"
        "    endif()\n"
    )
    new = "    set(odbc_scanner_GIT_COMMIT_HASH ${builtins.substring 0 10 rev})\n"
    if old not in text:
        raise SystemExit(f"pattern not found in {path}")
    path.write_text(text.replace(old, new))
    PY
  '';
}
