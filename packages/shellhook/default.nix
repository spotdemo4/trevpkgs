{
  getForgejoFlake,
  system,
}:
(getForgejoFlake {
  url = "https://trev.zip/llc/shellHook";
  rev = "03dbbc96446ce8e61d36c467c9801cd083857eb1"; # v0.2.0
  hash = "sha256-KxVx+WhqY47uL4bU6Zlwh9qBHO+DasV7hVxVh8cnSKc=";
}).packages."${system}".default
