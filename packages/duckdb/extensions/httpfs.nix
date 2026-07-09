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
  duckdbPostPatch = ''
    substituteInPlace extension_external/httpfs/src/include/s3_multi_part_upload.hpp \
      --replace-fail "return buffer.GetDataMutable();" "return buffer.Ptr();"

    substituteInPlace extension_external/httpfs/src/s3fs.cpp \
      --replace-fail "make_uniq<KeyValueSecret>(prefix_paths_p, Identifier(type), Identifier(provider), Identifier(name))" \
        "make_uniq<KeyValueSecret>(prefix_paths_p, type, provider, name)"

    substituteInPlace extension_external/httpfs/src/create_secret_functions.cpp \
      --replace-fail "result.provider = Identifier(kv_secret.GetProvider());" "result.provider = kv_secret.GetProvider();" \
      --replace-fail "result.storage_type = Identifier(secret_entry.storage_mode);" "result.storage_type = secret_entry.storage_mode;" \
      --replace-fail "result.options[Identifier(key.GetIdentifierName()).GetIdentifierName()] = value;" "result.options[key.GetIdentifierName()] = value;" \
      --replace-fail "secret_type.name = Identifier(type);" "secret_type.name = type;" \
      --replace-fail "secret_type_hf.name = Identifier(HUGGINGFACE_TYPE);" "secret_type_hf.name = HUGGINGFACE_TYPE;"

    python3 - <<'PY'
    from pathlib import Path

    replacements = {
        Path("extension_external/httpfs/src/include/httpfs.hpp"): {
            "\t// Expose the measured network throughput estimate to the (parquet) prefetch cost model.\n"
            "\tbool TryGetNetworkThroughput(NetworkThroughputEstimate &result);\n": "",
            "\tbool TryGetNetworkThroughput(FileHandle &handle, NetworkThroughputEstimate &result) override {\n"
            "\t\treturn handle.Cast<HTTPFileHandle>().TryGetNetworkThroughput(result);\n"
            "\t}\n": "",
        },
        Path("extension_external/httpfs/src/httpfs.cpp"): {
            "bool HTTPFileHandle::TryGetNetworkThroughput(NetworkThroughputEstimate &result) {\n"
            "\tlock_guard<mutex> guard(throughput_lock);\n"
            "\tif (tp_sample_count == 0 || tp_latency_seconds <= 0 || tp_bandwidth_bps <= 0) {\n"
            "\t\treturn false;\n"
            "\t}\n"
            "\tresult.latency_seconds = tp_latency_seconds;\n"
            "\tresult.bandwidth_bytes_per_s = tp_bandwidth_bps;\n"
            "\treturn true;\n"
            "}\n\n": "",
        },
    }

    for path, path_replacements in replacements.items():
        text = path.read_text()
        for old, new in path_replacements.items():
            if old not in text:
                raise SystemExit(f"pattern not found in {path}: {old!r}")
            text = text.replace(old, new)
        path.write_text(text)
    PY
  '';
}
