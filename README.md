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
repository and the final scanner image to GitHub Container Registry (GHCR).
It loads the tar from the scanner ZIP and tags that same image for GHCR.
Each run gets its own release tag and image tag:
`ghcr.io/<owner>/<container>:<version>-build-<run number>`.
The release notes include the exact Docker pull command.
It uses GitHub's provided token with `packages: write`; no additional secret
or personal access token is required.

After the first publish, open your GitHub profile's **Packages**, select
**bios214-radial → Package settings → Change visibility → Public**. GHCR
packages initially default to private, even when the repository is public.
This is a one-time step so students can pull without signing in.

For local use, replace `N` with the build number from the release:

```bash
docker pull --platform linux/amd64 ghcr.io/mcgrathcm/bios214-radial:0.1.2-build-N
```

Pass that image name to the course client's existing `image` keyword:

```julia
image = recon_docker(raw;
    image="ghcr.io/mcgrathcm/bios214-radial:0.1.2-build-N")
```

The scanner continues to use the ZIP installer.

The reference `.seq` is required at runtime to derive k-space coordinates.
Solution-bearing test fixtures and checksum sidecars are not included.
The original recipe uses live apt repositories and some unpinned Python
dependencies, so fresh build hashes can differ.

The Julia/Koma TCP client stays in the
[BIOS 214 course repository](https://github.com/cncastillo/bios-214/pull/16).
