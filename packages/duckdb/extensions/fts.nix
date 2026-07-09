{ callPackage }:

(callPackage ./generic.nix { }) {
  name = "fts";
  repo = "duckdb-fts";
  branch = "main";
  rev = "69c44bed3ceae0b9dcf2c7888314f37fb3ea8ca3";
  hash = "sha256-s/AEiR7g7vK0sF3dGYzniS3KylxJPk9ar3YeUoHHZlE=";
  loadOptions = [ "DONT_LINK" ];
  duckdbPostPatch = ''
    substituteInPlace extension_external/fts/src/fts_indexing.cpp \
      --replace-fail '#include "duckdb/common/sql_identifier.hpp"' '#include "duckdb/parser/keyword_helper.hpp"' \
      --replace-fail "SQLIdentifier::ToString" "KeywordHelper::WriteOptionallyQuoted" \
      --replace-fail "SQLString::ToString" "KeywordHelper::WriteQuoted" \
      --replace-fail ".GetIdentifierName()" "" \
      --replace-fail $'    return QualifiedName(\n        qname.Catalog(),\n        ClientData::Get(context).catalog_search_path->GetDefaultSchema(\n            qname.Catalog()),\n        qname.Name());' $'    qname.schema =\n        ClientData::Get(context).catalog_search_path->GetDefaultSchema(\n            qname.catalog);' \
      --replace-fail "qname.Catalog()" "qname.catalog" \
      --replace-fail "qname.Schema()" "qname.schema" \
      --replace-fail "qname.Name()" "qname.name" \
      --replace-fail $'  return Catalog::GetEntry<TableCatalogEntry>(\n             context, qname, OnEntryNotFound::RETURN_NULL) != nullptr;' $'  return Catalog::GetEntry<TableCatalogEntry>(\n             context, qname.catalog, qname.schema, qname.name,\n             OnEntryNotFound::RETURN_NULL) != nullptr;' \
      --replace-fail "Catalog::GetEntry<TableCatalogEntry>(context, qname)" "Catalog::GetEntry<TableCatalogEntry>(context, qname.catalog, qname.schema, qname.name)" \
      --replace-fail "Catalog::GetEntry<TableCatalogEntry>(context, sw_qname)" "Catalog::GetEntry<TableCatalogEntry>(context, sw_qname.catalog, sw_qname.schema, sw_qname.name)" \
      --replace-fail "Identifier(GetFTSSchemaName(qname))" "GetFTSSchemaName(qname)" \
      --replace-fail "Identifier(name)" "name" \
      --replace-fail "Identifier(column_name)" "column_name" \
      --replace-fail "Identifier(doc_id)" "doc_id" \
      --replace-fail "Identifier(col_name)" "col_name" \
      --replace-fail "storage_manager.GetStorageVersion() >= StorageVersion::V2_0_0" "false"
  '';
}
