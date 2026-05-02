# Flake for packages and modules

![CI](https://github.com/wnix/packages/actions/workflows/ci.yml/badge.svg)



Custom Nix packages and NixOS modules for software we use but that is not (yet) available in nixpkgs.

Follows the nixpkgs convention: packages live under `pkgs/<name>/`, modules under `modules/<name>/`.

## Packages

- `seatsurfing-server` -- Go backend + healthcheck for ([seatsurfing project](https://seatsurfing.io/))
- `seatsurfing-ui` -- Next.js frontend (static export) for ([seatsurfing project](https://seatsurfing.io/))
- `harmonograph` -- [App::GUI::Harmonograph](https://metacpan.org/pod/App::GUI::Harmonograph): wxPerl GUI for drawing with pendula (discovered at [Chemnitzer Linux-Tage 2026](https://chemnitzer.linux-tage.de/))
- `fet` -- [FET](https://lalescu.ro/liviu/fet/): free software for automatically scheduling timetables (schools, high schools, universities); fast timetabling algorithm; [GNU AGPLv3](https://www.gnu.org/licenses/agpl-3.0.html)
- `jsonschema2shacl` -- [jsonschema2shacl](https://github.com/citiususc/jsonschema2shacl) / [PyPI](https://pypi.org/project/jsonschema2shacl/): CLI that translates JSON Schema into SHACL Turtle (`jsonschema2shacl` ↔ `python -m jsonschema2shacl`). Built from official wheels; pins transitive deps (`owlrl` 6.x, `pyshacl` 0.26.x, `jsonpath-ng` 1.6.1) per the published package metadata.

## NixOS modules

- `seatsurfing` -- `services.seatsurfing.*`

## Usage

```nix
{
  inputs.wnix.url = "github:wnix/packages";
  inputs.wnix.inputs.nixpkgs.follows = "nixpkgs";
}
```

```bash
nix build .#seatsurfing-server
nix build .#seatsurfing-ui
nix build .#harmonograph
nix build .#fet
nix build .#jsonschema2shacl
```

Run the translator without installing globally:

```bash
nix run github:wnix/packages#jsonschema2shacl -- /path/to/schema.json
```

(`github:wnix/packages` assumes this flake is published under that path; use `path:.` or your flake input name when developing locally.)

## Binary cache

```
extra-substituters = https://wnix.cachix.org
extra-trusted-public-keys = wnix.cachix.org-1:EjPQ1/a4+2MuoBrTxCy1Uh78jntG41kyLnPprUo/GrU=
```

Add to `nix.settings` in your NixOS config or `~/.config/nix/nix.conf`.

## Adding a new package

1. Create `pkgs/<name>/default.nix`
2. Register it in `flake.nix` under `packages`
3. Optionally add a NixOS module under `modules/<name>/`
4. Add the package to the CI build matrix in `.github/workflows/ci.yml`

When bumping `jsonschema2shacl`, refresh `fetchurl` hashes and wheel URLs from PyPI; keep `owlrl` below 7 and `pyshacl` below 0.27 unless upstream relaxes constraints.

## License

Individual packages retain their upstream licenses. The Nix expressions in this repository are MIT-licensed.
