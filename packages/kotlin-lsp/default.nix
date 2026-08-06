{
  autoPatchelfHook,
  fetchzip,
  jdk25,
  lib,
  makeWrapper,
  nix-update-script,
  stdenv,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "262.9593.0";

  src =
    let
      sources = {
        x86_64-linux = fetchzip {
          url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}.tar.gz";
          hash = "sha256-6ajvuyFga+IL9eLqNKCPphdVwRxpFQSQOy54HGreEqw=";
        };
        aarch64-linux = fetchzip {
          url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}-aarch64.tar.gz";
          hash = "sha256-769vjedw4TzXPak1U/ls69sIiyow3057VGAADBCXtsU=";
        };
      };
    in
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    jdk25
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/kotlin-lsp
    cp -r bin build.txt kotlin-lsp.sh lib license modules plugins product-info.json $out/share/kotlin-lsp
    ln -s ${jdk25}/lib/openjdk $out/share/kotlin-lsp/jbr

    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    req='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
    printf 'Content-Length: %d\r\n\r\n%s' "''${#req}" "$req" \
      | timeout 120 $out/bin/kotlin-lsp --stdio > response.txt 2>/dev/null || true

    grep -q '"jsonrpc"' response.txt || {
      echo "kotlin-lsp did not respond to an LSP initialize request" >&2
      exit 1
    }

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://github.com/Kotlin/kotlin-lsp"
      "--version-regex"
      "kotlin-lsp/v(.*)"
      "--commit"
      finalAttrs.pname
    ];
  };

  meta = {
    description = "Kotlin Language Server and plugin for Visual Studio Code";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    changelog = "https://github.com/Kotlin/kotlin-lsp/releases/tag/kotlin-lsp/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "kotlin-lsp";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
