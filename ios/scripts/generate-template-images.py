#!/usr/bin/env python3
"""Generate VisualKit template preview images through an OpenAI-compatible image upstream."""

from __future__ import annotations

import argparse
import base64
import json
import os
import shutil
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_ENV_FILE = PROJECT_ROOT.parents[1] / "tokenduoduo" / "gateway" / ".env"
DEFAULT_ASSET_DIR = PROJECT_ROOT / "VisualKit" / "Resources" / "Assets.xcassets"
DEFAULT_MODEL = "gpt-image-2"
DEFAULT_SIZE = "1024x1024"
DEFAULT_QUALITY = "high"
DEFAULT_FORMAT = "png"

GLOBAL_PROMPT = """Create a premium AI image template preview for the VisualKit iOS app.
The image is used as a tappable template card thumbnail, so it must be visually clear at small sizes.

Global requirements:
- Polished, production-quality image that demonstrates the template style clearly
- Center-safe composition, no important details at extreme edges
- No visible UI chrome from VisualKit, no watermarks, no logos, no brand names
- Avoid illegible micro-text; if text appears, keep it abstract or minimal unless requested
- Refined modern visual taste, suitable for a creative image-generation app
"""


@dataclass(frozen=True)
class TemplateImage:
    asset_name: str
    title: str
    category: str
    prompt: str


TEMPLATE_IMAGES = [
    TemplateImage(
        asset_name="template-editorial-poster",
        title="Editorial Launch Poster",
        category="Posters & Typography",
        prompt="""A premium editorial launch poster for an imaginary design conference called "SIGNAL". Bold typographic hierarchy, refined spacing, modern magazine composition, crisp print texture, coral and ink accents, subtle abstract shapes, highly legible but not crowded.""",
    ),
    TemplateImage(
        asset_name="template-studio-product",
        title="Studio Product Hero",
        category="Products & E-commerce",
        prompt="""A clean studio product hero image for a minimal matte-black wireless speaker on a stone plinth. Premium e-commerce lighting, elegant soft shadows, sharp material detail, warm neutral background, commercial clarity, square product-card composition.""",
    ),
    TemplateImage(
        asset_name="template-saas-dashboard",
        title="SaaS Dashboard Mockup",
        category="UI & Interfaces",
        prompt="""A polished modern SaaS analytics dashboard mockup on a desktop screen. Dense but organized metrics, restrained color, realistic charts and tables, left navigation, clear product detail, professional operational software design, no real company names.""",
    ),
]


def load_env_file(path: Path) -> None:
    if not path.is_file():
        return
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def normalize_images_url(base_url: str) -> str:
    cleaned = base_url.rstrip("/")
    if cleaned.endswith("/images/generations"):
        return cleaned
    if cleaned.endswith("/v1"):
        return f"{cleaned}/images/generations"
    return f"{cleaned}/v1/images/generations"


def post_json(url: str, api_key: str, payload: dict[str, Any]) -> dict[str, Any]:
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"Image request failed: HTTP {error.code}\n{body}") from error
    except urllib.error.URLError as error:
        raise RuntimeError(f"Image request failed: {error.reason}") from error


def save_image(result: dict[str, Any], output_path: Path) -> None:
    data = result.get("data")
    if not isinstance(data, list) or not data:
        raise RuntimeError(f"No image data returned: {json.dumps(result, ensure_ascii=False)[:1000]}")

    first = data[0]
    if not isinstance(first, dict):
        raise RuntimeError(f"Unexpected image response item: {first!r}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    encoded_image = first.get("b64_json")
    if isinstance(encoded_image, str) and encoded_image:
        output_path.write_bytes(base64.b64decode(encoded_image))
        return

    image_url = first.get("url")
    if isinstance(image_url, str) and image_url:
        with urllib.request.urlopen(image_url, timeout=300) as response:
            output_path.write_bytes(response.read())
        return

    raise RuntimeError(f"Image response has neither b64_json nor url: {json.dumps(first, ensure_ascii=False)[:1000]}")


def write_image_set(asset_dir: Path, asset_name: str, image_bytes_path: Path) -> Path:
    image_set = asset_dir / f"{asset_name}.imageset"
    image_set.mkdir(parents=True, exist_ok=True)
    output_path = image_set / f"{asset_name}.png"
    output_path.write_bytes(image_bytes_path.read_bytes())
    contents = {
        "images": [
            {
                "filename": f"{asset_name}.png",
                "idiom": "universal",
                "scale": "1x",
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1,
        },
    }
    (image_set / "Contents.json").write_text(
        json.dumps(contents, indent=2) + "\n",
        encoding="utf-8",
    )
    return output_path


def build_prompt(template: TemplateImage) -> str:
    return f"""{GLOBAL_PROMPT}
Template title: {template.title}
Template category: {template.category}
Scene to create: {template.prompt}

Output requirements:
- One square preview image for a template picker
- Immediate visual read at thumbnail size
- No watermark, no app UI frame, no real brand names
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate VisualKit template preview images.")
    parser.add_argument("--env-file", type=Path, default=DEFAULT_ENV_FILE, help=f"Upstream environment file. Defaults to {DEFAULT_ENV_FILE}.")
    parser.add_argument("--api-key", default="", help="Override the upstream API key.")
    parser.add_argument("--base-url", default="", help="Override the upstream base URL.")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Image model. Defaults to {DEFAULT_MODEL}.")
    parser.add_argument("--size", default=DEFAULT_SIZE, help=f"Image size. Defaults to {DEFAULT_SIZE}.")
    parser.add_argument("--quality", default=DEFAULT_QUALITY, help="Image quality: auto, low, medium, or high.")
    parser.add_argument("--output-format", default=DEFAULT_FORMAT, choices=["png"], help="Generated image format.")
    parser.add_argument("--asset-dir", type=Path, default=DEFAULT_ASSET_DIR, help=f"Asset catalog directory. Defaults to {DEFAULT_ASSET_DIR}.")
    parser.add_argument("--limit", type=int, default=3, help="Number of templates to generate from the front of the list.")
    parser.add_argument("--only", choices=[template.asset_name for template in TEMPLATE_IMAGES], help="Generate only one template asset.")
    parser.add_argument("--dry-run", action="store_true", help="Print prompts without making provider requests.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    load_env_file(args.env_file.expanduser())

    selected = TEMPLATE_IMAGES
    if args.only:
        selected = [template for template in selected if template.asset_name == args.only]
    else:
        selected = selected[: max(1, args.limit)]

    if args.dry_run:
        for template in selected:
            print(f"--- {template.asset_name} ---")
            print(build_prompt(template))
        return 0

    api_key = (
        args.api_key.strip()
        or os.environ.get("FDE_IMAGE_API_KEY", "").strip()
        or os.environ.get("GATEWAY_IMAGE_UPSTREAM_API_KEY", "").strip()
        or os.environ.get("GATEWAY_UPSTREAM_API_KEY", "").strip()
        or os.environ.get("OPENAI_API_KEY", "").strip()
    )
    base_url = (
        args.base_url.strip()
        or os.environ.get("FDE_IMAGE_BASE_URL", "").strip()
        or os.environ.get("GATEWAY_IMAGE_UPSTREAM_BASE_URL", "").strip()
        or os.environ.get("GATEWAY_UPSTREAM_BASE_URL", "").strip()
        or os.environ.get("OPENAI_BASE_URL", "").strip()
        or "https://api.openai.com"
    )

    if not api_key:
        print("Missing image API key. Set FDE_IMAGE_API_KEY, OPENAI_API_KEY, or configure the TokenDuoDuo gateway environment.", file=sys.stderr)
        return 2

    url = normalize_images_url(base_url)
    asset_dir = args.asset_dir.expanduser()
    temporary_dir = asset_dir / ".generated-template-tmp"
    temporary_dir.mkdir(parents=True, exist_ok=True)

    for index, template in enumerate(selected, start=1):
        temp_path = temporary_dir / f"{template.asset_name}.png"
        payload = {
            "model": args.model,
            "prompt": build_prompt(template),
            "size": args.size,
            "quality": args.quality,
            "output_format": args.output_format,
        }
        print(f"[{index}/{len(selected)}] Generating {template.asset_name} with {args.model}")
        print(f"POST {url}")
        result = post_json(url, api_key, payload)
        save_image(result, temp_path)
        output_path = write_image_set(asset_dir, template.asset_name, temp_path)
        print(f"Saved image set to {output_path.parent}")
        if index < len(selected):
            time.sleep(1)

    shutil.rmtree(temporary_dir, ignore_errors=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
