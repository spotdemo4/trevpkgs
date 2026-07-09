{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "sqlsmith";
  repo = "duckdb-sqlsmith";
  branch = "main";
  rev = "2144df06ad9069a651adb6590349dcd638633ee1";
  hash = "sha256-ea+d6evPF3ynZZOwO931jw7VT8R5+tWpG/Aj6+r9VYQ=";
  loadOptions = [ "DONT_LINK" ];
  duckdbPostPatch = ''
    substituteInPlace extension_external/sqlsmith/src/include/statement_generator.hpp \
      --replace-fail "class SetStatement;" "class SetStatement;
    class MultiStatement;"

    substituteInPlace extension_external/sqlsmith/src/statement_generator.cpp \
      --replace-fail "setop->left = GenerateQueryNode();" "setop->children.push_back(GenerateQueryNode());" \
      --replace-fail "setop->right = GenerateQueryNode();" "setop->children.push_back(GenerateQueryNode());" \
      --replace-fail "column_count = view.types.size();" "view.BindView(context);
        column_count = view.GetColumnInfo()->types.size();"
  '';
}
