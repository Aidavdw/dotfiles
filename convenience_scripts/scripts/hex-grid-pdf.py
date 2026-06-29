#!/usr/bin/env python3
"""
hex_grid_pdf.py
===============
Overlay a hexagonal grid on an image and output as a printable PDF.

The image is placed at a known physical size (ignoring embedded DPI metadata).
If the image is larger than the printable area (paper - margins), it is tiled
across multiple pages so the pages can be stitched back together after printing.
The hex grid always aligns perfectly across page boundaries.

Usage
-----
    python hex_grid_pdf.py image.png \
        --image-size 24cm \
        --paper A4 \
        --margin 1cm \
        --hex-size 2.5cm \
        --landscape \
        --output result.pdf

Run `python hex_grid_pdf.py --help` for full option list.
"""

import argparse
import math
import os
import sys

from PIL import Image
from reportlab.lib.pagesizes import A3, A4
from reportlab.pdfgen import canvas


# ---------------------------------------------------------------------------
# Constants / helpers
# ---------------------------------------------------------------------------

PAPER_SIZES = {
    "A4": A4,  # (595.28, 841.89) points  (portrait)
    "A3": A3,  # (841.89, 1190.55) points
}

# 1 cm in ReportLab points (72 pt/inch, 2.54 cm/inch)
CM_TO_PT = 72.0 / 2.54


def parse_length(value: str, default_unit: str = "cm") -> float:
    """Parse a length string like '2.5cm' or '10mm' and return centimetres."""
    value = value.strip().lower()
    if value.endswith("mm"):
        return float(value[:-2]) / 10.0
    elif value.endswith("cm"):
        return float(value[:-2])
    elif value.endswith("in"):
        return float(value[:-2]) * 2.54
    elif value.endswith("pt"):
        return float(value[:-2]) / CM_TO_PT
    else:
        # Assume the default unit
        return float(value)


# ---------------------------------------------------------------------------
# Hexagon geometry (flat-top orientation)
# ---------------------------------------------------------------------------
# We use **flat-top** hexagons.  The "size" parameter the user supplies is the
# longest diameter (= 2 × circumradius R).
#
#   corner coords: (R·cos θ, R·sin θ) for θ = 0,60,120,180,240,300°
#   Horizontal width  = 2R  (left corner to right corner)
#   Vertical  height  = R·√3
#
#   Offset grid (columns shifted):
#     Even column centres: x = col * (3R/2),      y = row * R√3
#     Odd  column centres: x = col * (3R/2),      y = row * R√3 + R√3/2
#
#   So:
#     x-step between columns = 3R/2
#     y-step between rows     = R√3
#     odd-column y-offset     = R√3/2


def hex_corners_flat(cx: float, cy: float, R: float):
    """Return the 6 corner (x,y) tuples for a flat-top hexagon."""
    pts = []
    for k in range(6):
        angle = math.radians(60 * k)  # 0°, 60°, 120°, …
        pts.append((cx + R * math.cos(angle), cy + R * math.sin(angle)))
    return pts


def draw_hex_grid(
    c: canvas.Canvas,
    hex_diameter_cm: float,
    area_x: float,
    area_y: float,
    area_w: float,
    area_h: float,
    image_offset_x: float = 0.0,
    image_offset_y: float = 0.0,
):
    """
    Draw a flat-top hex grid onto the ReportLab canvas.

    Parameters
    ----------
    c               : reportlab canvas
    hex_diameter_cm : longest diameter of a single hex in cm
    area_x, area_y  : bottom-left corner of clipping area in page coordinates
    area_w, area_h  : width and height of clipping area
    image_offset_x  : x position of this tile within the full image (points)
    image_offset_y  : y position of this tile within the full image (points)

    The grid is generated in a single global coordinate system tied to the
    full image, then clipped to the tile. This guarantees perfect continuity
    across page boundaries.
    """
    R = (hex_diameter_cm / 2.0) * CM_TO_PT

    col_step = 1.5 * R
    row_step = math.sqrt(3.0) * R

    # Tile bounds in GLOBAL image coordinates
    global_x0 = image_offset_x
    global_x1 = image_offset_x + area_w

    global_y0 = image_offset_y
    global_y1 = image_offset_y + area_h

    c.saveState()

    # Clip drawing to tile rectangle
    p = c.beginPath()
    p.rect(area_x, area_y, area_w, area_h)
    c.clipPath(p, stroke=0, fill=0)

    c.setLineWidth(0.4)
    c.setStrokeColorRGB(0, 0, 0)

    # Determine which columns could intersect this tile
    start_col = math.floor(global_x0 / col_step) - 2
    end_col = math.ceil(global_x1 / col_step) + 2

    for col in range(start_col, end_col + 1):
        global_cx = col * col_step

        # Odd columns shifted upward by half a row
        cy_offset = row_step / 2.0 if (col % 2) else 0.0

        start_row = math.floor((global_y0 - cy_offset) / row_step) - 2
        end_row = math.ceil((global_y1 - cy_offset) / row_step) + 2

        for row in range(start_row, end_row + 1):
            global_cy = row * row_step + cy_offset

            # Convert from global image coordinates into page coordinates
            cx = area_x + (global_cx - image_offset_x)
            cy = area_y + (global_cy - image_offset_y)

            corners = hex_corners_flat(cx, cy, R)

            path = c.beginPath()
            path.moveTo(*corners[0])

            for px, py in corners[1:]:
                path.lineTo(px, py)

            path.close()
            c.drawPath(path, stroke=1, fill=0)

    c.restoreState()


def process(
    image_path: str,
    image_size_cm: float,
    paper: str,
    margin_cm: float,
    hex_size_cm: float,
    landscape: bool,
    output_path: str,
):
    # When loading, we ignore the embedded DPI.
    img = Image.open(image_path).convert("RGB")
    if landscape:
        img = img.rotate(90, expand=True)

    img_px_w, img_px_h = img.size

    # Compute physical size of image in cm, then points
    # The user says the image's LONGEST side is image_size_cm.
    # We scale uniformly so that longest side == image_size_cm.
    longest_px = max(img_px_w, img_px_h)
    px_per_cm = longest_px / image_size_cm  # how many pixels correspond to 1 cm

    img_w_cm = img_px_w / px_per_cm
    img_h_cm = img_px_h / px_per_cm

    img_w_pt = img_w_cm * CM_TO_PT
    img_h_pt = img_h_cm * CM_TO_PT

    # 3. Paper / printable area
    page_w_pt, page_h_pt = PAPER_SIZES[paper]
    margin_pt = margin_cm * CM_TO_PT

    printable_w = page_w_pt - 2 * margin_pt
    printable_h = page_h_pt - 2 * margin_pt

    if printable_w <= 0 or printable_h <= 0:
        sys.exit("Error: margin is too large for the chosen paper size.")

    # 4. Tile layout: how many pages in x and y?
    n_pages_x = max(1, math.ceil(img_w_pt / printable_w))
    n_pages_y = max(1, math.ceil(img_h_pt / printable_h))

    total_pages = n_pages_x * n_pages_y

    print(f"Image physical size   : {img_w_cm:.2f} cm × {img_h_cm:.2f} cm")
    print(
        f"Printable area        : {printable_w / CM_TO_PT:.2f} cm × {printable_h / CM_TO_PT:.2f} cm"
    )
    print(
        f"Tiling                : {n_pages_x} col(s) × {n_pages_y} row(s) = {total_pages} page(s)"
    )

    # 5. Generate PDF: one page per tile
    c = canvas.Canvas(output_path, pagesize=(page_w_pt, page_h_pt))

    for page_row in range(n_pages_y):
        for page_col in range(n_pages_x):
            # Image crop window (in points, within the full image)
            crop_x0_pt = page_col * printable_w
            crop_y0_pt = page_row * printable_h  # top of crop in image coords (pt)

            crop_w_pt = min(printable_w, img_w_pt - crop_x0_pt)
            crop_h_pt = min(printable_h, img_h_pt - crop_y0_pt)

            # Convert crop window to pixels
            # pixels per point
            scale = img_px_w / img_w_pt

            crop_px_x = int(round(crop_x0_pt * scale))
            # PIL y=0 is top; ReportLab y=0 is bottom
            # Image height in pt from top:
            crop_px_y = int(round(crop_y0_pt * scale))
            crop_px_w = int(round(crop_w_pt * scale))
            crop_px_h = int(round(crop_h_pt * scale))

            # Clamp to image bounds
            crop_px_x = max(0, min(crop_px_x, img_px_w))
            crop_px_y = max(0, min(crop_px_y, img_px_h))
            crop_px_w = max(1, min(crop_px_w, img_px_w - crop_px_x))
            crop_px_h = max(1, min(crop_px_h, img_px_h - crop_px_y))

            # Crop the PIL image
            tile = img.crop(
                (
                    crop_px_x,
                    crop_px_y,
                    crop_px_x + crop_px_w,
                    crop_px_y + crop_px_h,
                )
            )

            # Draw image tile onto page.
            # Place image in the margin area.  ReportLab drawInlineImage expects
            # bottom-left corner.  The tile sits at (margin_pt, margin_pt) but
            # since the image tile might be shorter than printable_h (last tile),
            # we draw it flush to the top-left of the printable area.
            dest_x = margin_pt
            # In ReportLab, y goes upward.  Place the image so its top is at
            # (page_h_pt - margin_pt).
            dest_y = page_h_pt - margin_pt - crop_h_pt  # bottom of image

            c.drawInlineImage(tile, dest_x, dest_y, width=crop_w_pt, height=crop_h_pt)

            # Draw hex grid
            if hex_size_cm > 0:
                draw_hex_grid(
                    c,
                    hex_diameter_cm=hex_size_cm,
                    area_x=dest_x,
                    area_y=dest_y,
                    area_w=crop_w_pt,
                    area_h=crop_h_pt,
                    image_offset_x=crop_x0_pt,
                    image_offset_y=crop_y0_pt,
                )

            # Page label (small, bottom-right corner)
            label = f"[{page_col + 1},{page_row + 1}]"
            c.setFont("Helvetica", 6)
            c.setFillColorRGB(0.5, 0.5, 0.5)
            c.drawRightString(page_w_pt - 4, 4, label)

            c.showPage()

    c.save()
    print(f"Saved → {output_path}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(
        description="Overlay a hexagonal grid on an image and export as a printable PDF.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples
--------
  # Single page, default hex size, A4 portrait
  python hex_grid_pdf.py map.png --image-size 20cm

  # Larger image tiled over multiple A3 pages, 3cm hexes, landscape
  python hex_grid_pdf.py bigmap.jpg --image-size 60cm --paper A3 --hex-size 3cm --landscape

  # No grid (image only, tiled to fit)
  python hex_grid_pdf.py photo.png --image-size 30cm --hex-size 0

Lengths may be given in cm (default), mm, in, or pt, e.g. --margin 15mm.
""",
    )
    parser.add_argument("image", help="Path to the input image file")
    parser.add_argument(
        "--image-size",
        required=True,
        metavar="LENGTH",
        help="Physical size of the image's longest side (e.g. 24cm). "
        "The image's embedded DPI is ignored.",
    )
    parser.add_argument(
        "--paper",
        choices=["A4", "A3"],
        default="A4",
        help="Paper size (default: A4)",
    )
    parser.add_argument(
        "--margin",
        metavar="LENGTH",
        default="1cm",
        help="Margin on each side of the page (default: 1cm)",
    )
    parser.add_argument(
        "--hex-size",
        metavar="LENGTH",
        default="2.5cm",
        help="Longest diameter of a single hexagon (default: 2.5cm). "
        "Set to 0 to disable the grid.",
    )
    parser.add_argument(
        "--landscape",
        action="store_true",
        help="Rotate the image 90° before processing",
    )
    parser.add_argument(
        "--output",
        metavar="FILE",
        default=None,
        help="Output PDF path (default: <image_name>_hex.pdf)",
    )

    args = parser.parse_args()

    if not os.path.isfile(args.image):
        sys.exit(f"Error: image file not found: {args.image!r}")

    image_size_cm = parse_length(args.image_size)
    margin_cm = parse_length(args.margin)
    hex_size_cm = parse_length(args.hex_size)

    if image_size_cm <= 0:
        sys.exit("Error: --image-size must be positive.")
    if margin_cm < 0:
        sys.exit("Error: --margin must be non-negative.")
    if hex_size_cm < 0:
        sys.exit("Error: --hex-size must be non-negative (use 0 to disable grid).")

    if args.output:
        output_path = args.output
    else:
        base = os.path.splitext(os.path.basename(args.image))[0]
        output_path = f"{base}_hex.pdf"

    process(
        image_path=args.image,
        image_size_cm=image_size_cm,
        paper=args.paper,
        margin_cm=margin_cm,
        hex_size_cm=hex_size_cm,
        landscape=args.landscape,
        output_path=output_path,
    )


if __name__ == "__main__":
    main()
