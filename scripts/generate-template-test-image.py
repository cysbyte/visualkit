#!/usr/bin/env python3
"""Generate an uploadable reference photo for the volumetric laser poster template."""

from __future__ import annotations

import argparse
import base64
import json
import os
from pathlib import Path
import urllib.error
import urllib.request


DEFAULT_ENV_FILE = Path.home() / "Desktop/Project/tokenduoduo/gateway/.env"
DEFAULT_OUTPUT = Path("output/imagegen/volumetric-laser-upload-reference.png")
DEFAULT_PROMPT = (
    "Photorealistic straightforward reference photograph, square crop: one anonymous "
    "fictional adult stage performer with short dark hair in a simple matte-black outfit, "
    "standing three-quarter view on a bare dark theater stage, holding a palm-sized "
    "transparent solid acrylic prism delicately in their right hand at chest height. "
    "Ordinary soft white studio work lights reveal the person and the crystal clearly; "
    "crisp face, body silhouette, fingers and transparent object, realistic perspective "
    "and material. Neutral documentary lighting, subtle gray-black plain background, "
    "single subject centered with generous empty space around them. The prism must remain "
    "visible and colorless. This is intentionally an unprocessed input reference "
    "photograph for later transformation into a volumetric-laser poster: absolutely no "
    "lasers, colored light beams, smoke, typography, graphic overlays, poster design, "
    "logos, or watermark."
)


def load_env_file(path: Path) -> None:
    if not path.is_file():
        return
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        if key and key not in os.environ:
            os.environ[key] = value.strip().strip('"').strip("'")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--env-file", type=Path, default=DEFAULT_ENV_FILE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--prompt", default=DEFAULT_PROMPT, help="Override the reference photo prompt.")
    parser.add_argument("--model", default="gpt-image-2")
    parser.add_argument("--size", default="1024x1024")
    parser.add_argument("--quality", choices=("low", "medium", "high", "auto"), default="medium")
    parser.add_argument("--force", action="store_true", help="Overwrite an existing image.")
    parser.add_argument("--dry-run", action="store_true", help="Show the request without generating an image.")
    args = parser.parse_args()

    if args.output.suffix.lower() != ".png":
        parser.error("--output must end in .png")
    if args.output.exists() and not args.force and not args.dry_run:
        parser.error(f"{args.output} already exists; choose another --output or pass --force")

    payload = {
        "model": args.model,
        "prompt": args.prompt,
        "size": args.size,
        "quality": args.quality,
        "output_format": "png",
    }
    if args.dry_run:
        print(json.dumps({"output": str(args.output), **payload}, indent=2))
        return 0

    load_env_file(args.env_file.expanduser())
    api_key = (
        os.environ.get("GATEWAY_IMAGE_UPSTREAM_API_KEY")
        or os.environ.get("OPENAI_API_KEY")
    )
    if not api_key:
        parser.error("Set OPENAI_API_KEY or GATEWAY_IMAGE_UPSTREAM_API_KEY (or pass --env-file)")
    base_url = (
        os.environ.get("GATEWAY_IMAGE_UPSTREAM_BASE_URL")
        or os.environ.get("OPENAI_BASE_URL")
        or "https://api.openai.com"
    ).rstrip("/")
    if base_url.endswith("/images/generations"):
        url = base_url
    elif base_url.endswith("/v1"):
        url = f"{base_url}/images/generations"
    else:
        url = f"{base_url}/v1/images/generations"

    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            result = json.load(response)
        image = result["data"][0]
        if image.get("b64_json"):
            image_bytes = base64.b64decode(image["b64_json"])
        elif image.get("url"):
            with urllib.request.urlopen(image["url"], timeout=300) as response:
                image_bytes = response.read()
        else:
            raise ValueError("Image API returned no image")
    except urllib.error.HTTPError as error:
        parser.exit(1, f"Image generation failed: HTTP {error.code}\n")
    except (urllib.error.URLError, KeyError, IndexError, ValueError) as error:
        parser.exit(1, f"Image generation failed: {error}\n")

    if len(image_bytes) > 8 * 1024 * 1024:
        parser.exit(1, "Generated image exceeds the 8 MB upload limit\n")
    if args.output.exists() and not args.force:
        parser.error(f"{args.output} already exists; choose another --output or pass --force")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(image_bytes)
    print(f"Saved {args.output} ({len(image_bytes)} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
