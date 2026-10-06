{ lib, permittedInsecurePackages }:
{
  allowInsecurePredicate = pkg:
    builtins.elem (lib.getName pkg) permittedInsecurePackages;
}
