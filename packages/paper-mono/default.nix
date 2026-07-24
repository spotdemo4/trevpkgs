{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  nix-update-script,
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
  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

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
