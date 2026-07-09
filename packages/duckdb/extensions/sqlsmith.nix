{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "sqlsmith";
  repo = "duckdb-sqlsmith";
  branch = "main";
  rev = "2144df06ad9069a651adb6590349dcd638633ee1";
  hash = "sha256-ea+d6evPF3ynZZOwO931jw7VT8R5+tWpG/Aj6+r9VYQ=";
  loadOptions = [ "DONT_LINK" ];
}
