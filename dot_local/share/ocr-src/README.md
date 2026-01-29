# ocr

To install dependencies:

```bash
bun install
```

To build a standalone binary:

```bash
bun run build
```

Note (chezmoi / new machine): the compiled binary is intentionally not tracked in git.

- If you're building from the applied destination copy (after `chezmoi apply`):

```bash
cd ~/.local/share/ocr-src
bun install
bun run build
```

This produces `~/bin/ocr` directly.

- If you're building from the chezmoi source state:

```bash
cd ~/.local/share/chezmoi/dot_local/share/ocr-src
bun install
bun run build
```

This produces `~/.local/share/chezmoi/bin/ocr`, which will be copied into `~/bin/ocr` on the next `chezmoi apply`.

To run:

```bash
ocr <image_path>
```

From the repo root:

```bash
bin/ocr <image_path>
```

Supported extensions: `.png`, `.jpg`, `.jpeg`, `.bmp`, `.tiff`.

This project was created using `bun init` in bun v1.3.7. [Bun](https://bun.com) is a fast all-in-one JavaScript runtime.
