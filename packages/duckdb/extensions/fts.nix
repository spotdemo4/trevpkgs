{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "fts";
  repo = "duckdb-fts";
  branch = "main";
  rev = "dc45d7bac19d45c8446b56073841d5eaeae3ffe6";
  hash = "sha256-U1TePRcD1MBK5PvbBK9ZwtODyAVYwwgLaN7HErL+bMQ=";
  loadOptions = [ "DONT_LINK" ];
  duckdbPostPatch = ''
    substituteInPlace extension_external/fts/src/fts_indexing.cpp \
      --replace-fail '#include "duckdb/common/sql_identifier.hpp"' '#include "duckdb/parser/keyword_helper.hpp"' \
      --replace-fail "SQLIdentifier::ToString" "KeywordHelper::WriteOptionallyQuoted" \
      --replace-fail "SQLString::ToString" "KeywordHelper::WriteQuoted" \
      --replace-fail ".GetIdentifierName()" "" \
      --replace-fail "sw_qname.Catalog()" "sw_qname.catalog" \
      --replace-fail "sw_qname.Schema()" "sw_qname.schema" \
      --replace-fail "sw_qname.Name()" "sw_qname.name" \
      --replace-fail "qname.SchemaMutable()" "qname.schema" \
      --replace-fail "qname.Catalog()" "qname.catalog" \
      --replace-fail "qname.Schema()" "qname.schema" \
      --replace-fail "qname.Name()" "qname.name" \
      --replace-fail "Identifier(GetFTSSchemaName(qname))" "GetFTSSchemaName(qname)" \
      --replace-fail "Identifier(name)" "name" \
      --replace-fail "Identifier(column_name)" "column_name" \
      --replace-fail "Identifier(doc_id)" "doc_id" \
      --replace-fail "Identifier(col_name)" "col_name" \
      --replace-fail "storage_manager.GetStorageVersion() >= StorageVersion::V2_0_0" "false"
  '';
}
