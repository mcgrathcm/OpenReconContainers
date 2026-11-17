# OpenReconContainers

Shared build scripts and container-specific reconstruction sources.
Requires Docker with Linux amd64 support, Git, uv, 7z and internet access.

```bash
bash build.sh bios214-radial
bash package.sh bios214-radial
```

`build.sh` fetches Neurocontainers at commit
`5fc5675e94f6148ec5e9c8f766a57dba330ef51d` and builds the application image.
`package.sh` also creates the scanner ZIP and PDF under `dist/bios214-radial/`.
All container-specific inputs are in `containers/bios214-radial/`; its scanner
identifier remains `bios214radial` and its current version is 0.1.2.

## GitHub builds

Select **Actions → Build OpenRecon release → Run workflow**, choosing the
container. The workflow builds and publishes ZIP/PDF Release assets in this
repository, separate from Git downloads. Each run gets its own release tag.
It uses GitHub's provided token; no additional secret is required.

The reference `.seq` is required at runtime to derive k-space coordinates.
Solution-bearing test fixtures and checksum sidecars are not included.
The original recipe uses live apt repositories and some unpinned Python
dependencies, so fresh build hashes can differ.

The Julia/Koma TCP client stays in the
[BIOS 214 course repository](https://github.com/cncastillo/bios-214/pull/16).
