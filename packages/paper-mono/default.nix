{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fontforge,
  installFonts,
  nerd-font-patcher,
  nix-update-script,
  python3Packages,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "paper-mono";
  version = "0.300-unstable-2026-07-02";
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "paper-design";
    repo = "paper-mono";
    rev = "b14a9274d854ac17b6225aa3456e9119a28926dc";
    hash = "sha256-fPfGrUBD6tNSEbJZaGDhPJwj/GCX7V6sGNVzb8osMok=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    fontforge
    installFonts
    nerd-font-patcher
    python3Packages.brotli
    python3Packages.fonttools
  ];

  # Keep the zero feature while making its alternate outline the default.
  buildPhase = ''
    runHook preBuild

    python - \
      fonts/otf/*.otf \
      fonts/ttf/*.ttf \
      fonts/variable/*.ttf \
      fonts/webfonts/*.woff2 <<'PY'
    from copy import deepcopy
    from pathlib import Path
    import os
    import sys

    from fontTools.ttLib import TTFont

    for path_string in sys.argv[1:]:
        path = Path(path_string)
        font = TTFont(path)

        if "glyf" in font:
            font["glyf"]["zero"] = deepcopy(font["glyf"]["zero.zero"])
            if "gvar" in font:
                font["gvar"].variations["zero"] = deepcopy(
                    font["gvar"].variations["zero.zero"]
                )
        elif "CFF " in font:
            char_strings = font["CFF "].cff.topDictIndex[0].CharStrings
            source = char_strings["zero.zero"]
            target = char_strings["zero"]
            source.decompile()
            target.decompile()
            target.program = deepcopy(source.program)
        else:
            raise RuntimeError(f"unsupported font outlines: {path}")

        font["hmtx"].metrics["zero"] = font["hmtx"].metrics["zero.zero"]

        temporary = path.with_name(f".{path.name}.tmp")
        font.save(temporary)
        font.close()
        os.replace(temporary, path)
    PY

    mkdir patched
    for font in fonts/ttf/*.ttf; do
      nerd-font-patcher --complete --mono --quiet --outputdir patched "$font"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=coding-ligatures" ];
  };

  meta = {
    description = "Beautiful monospace font for design and code by Paper";
    homepage = "https://github.com/paper-design/paper-mono";
    changelog = "https://github.com/paper-design/paper-mono/commits/coding-ligatures";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.all;
  };
})
