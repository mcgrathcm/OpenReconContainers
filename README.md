# OpenReconContainers

MRI reconstruction containers built with Neurocontainers and packaged for OpenRecon.

[Releases](https://github.com/mcgrathcm/OpenReconContainers/releases) provide
the scanner ZIP and the Docker pull command for local use.

## Build

Requires Docker with Linux amd64 support, Git, uv and 7z.

```bash
bash package.sh bios214-radial
```

Outputs: scanner ZIP and PDF in `dist/bios214-radial/`.
Container sources: `containers/<name>/`.

## Publish

Run **Actions → Build OpenRecon release → Run workflow** and select a container.
The workflow publishes the ZIP/PDF to Releases and the same image to GHCR.
