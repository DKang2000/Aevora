from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[3]
OUT_DIR = ROOT / "assets" / "art" / "target-sheets"
WIDTH = 1536
HEIGHT = 2732
MARGIN = 88

PALETTE = {
    "parchment": "#EFE2CA",
    "parchment_deep": "#DCC7A8",
    "stone": "#BCA487",
    "dawn": "#DCA54A",
    "ember": "#B76A36",
    "moss": "#667F56",
    "moss_deep": "#466049",
    "indigo": "#21263A",
    "indigo_deep": "#171A26",
    "ash": "#6E5969",
    "signal": "#A04035",
    "cream": "#F7F1E6",
    "ink": "#241D1A",
    "white": "#FFFDF8",
    "silver": "#C7CFDA",
}

FONT_PATHS = {
    "display": "/System/Library/Fonts/NewYork.ttf",
    "body": "/System/Library/Fonts/HelveticaNeue.ttc",
    "accent": "/System/Library/Fonts/SFNSRounded.ttf",
}


@dataclass
class SheetMeta:
    filename: str
    title: str
    subtitle: str
    prompt_line: str
    notes: list[str]
    anti_patterns: list[str]


def rgba(hex_color: str, alpha: int = 255) -> tuple[int, int, int, int]:
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4)) + (alpha,)


def font(kind: str, size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = FONT_PATHS.get(kind)
    if path:
        try:
            return ImageFont.truetype(path, size=size)
        except OSError:
            pass
    return ImageFont.load_default()


def line_wrap(draw: ImageDraw.ImageDraw, text: str, ft: ImageFont.ImageFont, max_width: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        probe = word if not current else f"{current} {word}"
        if draw.textlength(probe, font=ft) <= max_width:
            current = probe
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def draw_text_block(
    draw: ImageDraw.ImageDraw,
    text: str,
    xy: tuple[int, int],
    ft: ImageFont.ImageFont,
    fill: tuple[int, int, int, int],
    max_width: int,
    line_gap: int = 8,
) -> int:
    x, y = xy
    lines = line_wrap(draw, text, ft, max_width)
    ascent, descent = ft.getmetrics()
    height = ascent + descent
    for line in lines:
        draw.text((x, y), line, font=ft, fill=fill)
        y += height + line_gap
    return y


def gradient_background(top: str, bottom: str) -> Image.Image:
    image = Image.new("RGBA", (WIDTH, HEIGHT), rgba(top))
    overlay = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    top_rgba = rgba(top)
    bottom_rgba = rgba(bottom)
    for y in range(HEIGHT):
        ratio = y / max(HEIGHT - 1, 1)
        color = tuple(int(top_rgba[i] + (bottom_rgba[i] - top_rgba[i]) * ratio) for i in range(3)) + (255,)
        draw.line([(0, y), (WIDTH, y)], fill=color)
    image.alpha_composite(overlay)
    return image


def add_vignette(image: Image.Image, color: str, strength: int = 150) -> None:
    vignette = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(vignette)
    draw.ellipse(
        (-WIDTH * 0.15, HEIGHT * 0.12, WIDTH * 1.15, HEIGHT * 1.02),
        fill=rgba(color, strength),
    )
    vignette = vignette.filter(ImageFilter.GaussianBlur(200))
    image.alpha_composite(vignette)


def shadow(image: Image.Image, box: tuple[int, int, int, int], radius: int = 36, alpha: int = 72) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x1, y1, x2, y2 = box
    draw.rounded_rectangle((x1, y1, x2, y2), radius=radius, fill=(10, 8, 12, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(32))
    image.alpha_composite(layer)


def panel(image: Image.Image, box: tuple[int, int, int, int], fill: str, outline: str | None = None, radius: int = 38) -> None:
    shadow(image, box, radius=radius)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle(box, radius=radius, fill=rgba(fill, 242), outline=rgba(outline) if outline else None, width=2)


def chip(draw: ImageDraw.ImageDraw, label: str, xy: tuple[int, int], fill: str, text_fill: str = "white") -> int:
    ft = font("accent", 28)
    padding_x = 18
    width = int(draw.textlength(label, font=ft)) + padding_x * 2
    x, y = xy
    draw.rounded_rectangle((x, y, x + width, y + 48), radius=24, fill=rgba(fill, 235))
    draw.text((x + padding_x, y + 8), label, font=ft, fill=rgba(PALETTE[text_fill] if text_fill in PALETTE else text_fill))
    return width


def bullet_list(draw: ImageDraw.ImageDraw, items: Iterable[str], xy: tuple[int, int], max_width: int, fill: str) -> int:
    body = font("body", 30)
    x, y = xy
    for item in items:
        draw.ellipse((x, y + 13, x + 10, y + 23), fill=rgba(fill))
        y = draw_text_block(draw, item, (x + 26, y), body, rgba(PALETTE["ink"]), max_width - 26, line_gap=10) + 10
    return y


def swatch(draw: ImageDraw.ImageDraw, label: str, color: str, xy: tuple[int, int]) -> None:
    x, y = xy
    draw.rounded_rectangle((x, y, x + 110, y + 110), radius=26, fill=rgba(color))
    draw.text((x, y + 124), label, font=font("body", 26), fill=rgba(PALETTE["ink"]))


def title_block(image: Image.Image, meta: SheetMeta, section_fill: str) -> None:
    draw = ImageDraw.Draw(image)
    chip(draw, "Aevora ART-01", (MARGIN, 72), section_fill)
    draw.text((MARGIN, 158), meta.title, font=font("display", 88), fill=rgba(PALETTE["white"]))
    draw_text_block(
        draw,
        meta.subtitle,
        (MARGIN, 272),
        font("body", 36),
        rgba(PALETTE["cream"]),
        WIDTH - MARGIN * 2,
    )
    draw_text_block(
        draw,
        meta.prompt_line,
        (MARGIN, 388),
        font("body", 30),
        rgba(PALETTE["parchment_deep"]),
        WIDTH - MARGIN * 2,
        line_gap=6,
    )


def footer_notes(image: Image.Image, meta: SheetMeta) -> None:
    draw = ImageDraw.Draw(image)
    left_box = (MARGIN, HEIGHT - 680, WIDTH // 2 - 20, HEIGHT - 100)
    right_box = (WIDTH // 2 + 20, HEIGHT - 680, WIDTH - MARGIN, HEIGHT - 100)
    panel(image, left_box, PALETTE["cream"], PALETTE["stone"], radius=34)
    panel(image, right_box, PALETTE["cream"], PALETTE["stone"], radius=34)
    draw.text((left_box[0] + 34, left_box[1] + 24), "What This Sheet Must Prove", font=font("accent", 34), fill=rgba(PALETTE["ink"]))
    bullet_list(draw, meta.notes, (left_box[0] + 34, left_box[1] + 84), left_box[2] - left_box[0] - 68, PALETTE["ember"])
    draw.text((right_box[0] + 34, right_box[1] + 24), "Reject These Drifts", font=font("accent", 34), fill=rgba(PALETTE["ink"]))
    bullet_list(draw, meta.anti_patterns, (right_box[0] + 34, right_box[1] + 84), right_box[2] - right_box[0] - 68, PALETTE["signal"])


def glow_circle(image: Image.Image, center: tuple[int, int], radius: int, color: str, alpha: int = 160) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x, y = center
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=rgba(color, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(radius // 2))
    image.alpha_composite(layer)


def draw_world_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-02_world-vertical-slice-target.png",
        title="World Vertical Slice",
        subtitle="One focal Ember Quay neighborhood, portrait-first, with repair-state warmth carrying the story.",
        prompt_line="Final direction: top-down fantasy pixel world, larger-than-retro phone readability, restoration visible through light, order, and civic life.",
        notes=[
            "Canal edge, lanterns, stone and timber massing, and ward sigils should read instantly on a phone.",
            "Repair-state contrast must feel like warmth returning to a place, not a generic before-and-after card.",
            "One NPC silhouette and one witness path anchor keep the scene inhabited without turning into map sprawl.",
        ],
        anti_patterns=[
            "Wide desktop farm-sim sprawl or tiny prop soup.",
            "Grimdark mud palettes that erase civic warmth.",
            "Detail that only reads at desktop zoom instead of portrait iPhone scale.",
        ],
    )
    image = gradient_background(PALETTE["indigo_deep"], PALETTE["indigo"])
    add_vignette(image, PALETTE["ember"], 90)
    title_block(image, meta, PALETTE["dawn"])
    draw = ImageDraw.Draw(image)
    stage_box = (MARGIN, 520, WIDTH - MARGIN, HEIGHT - 700)
    panel(image, stage_box, PALETTE["parchment"], PALETTE["stone"], radius=56)

    canal = Image.new("RGBA", image.size, (0, 0, 0, 0))
    canal_draw = ImageDraw.Draw(canal)
    canal_draw.rounded_rectangle((170, 760, 1380, 1180), radius=80, fill=rgba(PALETTE["silver"], 92))
    canal_draw.polygon([(170, 940), (330, 830), (1270, 1090), (1150, 1260)], fill=rgba("#243A4B", 220))
    canal_draw.line([(270, 880), (1210, 1120)], fill=rgba(PALETTE["silver"], 140), width=10)
    canal = canal.filter(ImageFilter.GaussianBlur(2))
    image.alpha_composite(canal)

    building_colors = [PALETTE["stone"], "#8A6D57", "#9C8363", "#6B594F"]
    building_boxes = [
        (220, 720, 520, 1040),
        (990, 660, 1310, 950),
        (930, 1040, 1310, 1320),
        (250, 1050, 560, 1325),
    ]
    for idx, box in enumerate(building_boxes):
        panel(image, box, building_colors[idx], PALETTE["cream"], radius=42)

    for x, y in [(335, 850), (1120, 790), (1040, 1155), (380, 1180)]:
        draw.rounded_rectangle((x - 30, y - 55, x + 30, y + 18), radius=16, fill=rgba(PALETTE["indigo"]))
        glow_circle(image, (x, y - 18), 44, PALETTE["dawn"], 155)
        draw.ellipse((x - 14, y - 32, x + 14, y - 4), fill=rgba(PALETTE["dawn"]))

    oven_box = (640, 885, 840, 1085)
    panel(image, oven_box, PALETTE["ember"], PALETTE["cream"], radius=28)
    glow_circle(image, (740, 985), 120, PALETTE["dawn"], 130)
    draw.ellipse((700, 930, 780, 1000), fill=rgba(PALETTE["dawn"]))
    draw.rectangle((720, 910, 760, 935), fill=rgba(PALETTE["cream"]))

    sigil = Image.new("RGBA", image.size, (0, 0, 0, 0))
    sigil_draw = ImageDraw.Draw(sigil)
    sigil_draw.ellipse((820, 1210, 1050, 1440), outline=rgba(PALETTE["dawn"], 180), width=8)
    sigil_draw.line([(935, 1215), (935, 1435)], fill=rgba(PALETTE["dawn"], 180), width=6)
    sigil_draw.line([(825, 1325), (1045, 1325)], fill=rgba(PALETTE["dawn"], 180), width=6)
    sigil = sigil.filter(ImageFilter.GaussianBlur(4))
    image.alpha_composite(sigil)

    draw.rounded_rectangle((230, 1380, 1260, 1550), radius=30, fill=rgba(PALETTE["cream"], 214))
    draw.text((270, 1422), "Repair-state cue: soot clears, lantern warmth returns, bustle grows, geometry resolves.", font=font("body", 34), fill=rgba(PALETTE["ink"]))

    inset_box = (1080, 1380, 1365, 1660)
    panel(image, inset_box, PALETTE["indigo_deep"], PALETTE["stone"], radius=30)
    draw.text((1116, 1412), "Before / After", font=font("accent", 28), fill=rgba(PALETTE["cream"]))
    draw.rounded_rectangle((1114, 1464, 1220, 1608), radius=18, fill=rgba(PALETTE["ash"]))
    draw.rounded_rectangle((1234, 1464, 1340, 1608), radius=18, fill=rgba(PALETTE["moss"]))
    glow_circle(image, (1288, 1528), 42, PALETTE["dawn"], 120)

    for x, y, fill in [(640, 1250, PALETTE["parchment"]), (885, 1010, PALETTE["moss"]), (1125, 1015, PALETTE["parchment"])]:
        draw.ellipse((x - 22, y - 22, x + 22, y + 22), fill=rgba(fill))
        draw.rectangle((x - 10, y + 22, x + 10, y + 54), fill=rgba(fill))

    swatches = [("Moon Indigo", PALETTE["indigo"]), ("Dawn Gold", PALETTE["dawn"]), ("Ember Copper", PALETTE["ember"]), ("Moss Green", PALETTE["moss"])]
    base_x = MARGIN
    for label, color in swatches:
        swatch(draw, label, color, (base_x, 1610))
        base_x += 170

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_materials_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-05_cyrane-materials-props-target.png",
        title="Cyrane Materials + Props",
        subtitle="Reusable city language for ovens, lanterns, stalls, archives, canal wards, and charter seals.",
        prompt_line="Final direction: prop silhouettes tuned for tile and item reuse, civic trade and repair equally dignified, no one-off clutter noise.",
        notes=[
            "Every prop should feel native to a city of restoration, trade, study, and hospitality.",
            "Bronze, timber, tile, stone, moss, and ember warmth must read without close zoom.",
            "The kit should support ART-11 through ART-15 without redefining the city.",
        ],
        anti_patterns=[
            "Generic medieval clutter packs with no civic personality.",
            "Over-bespoke props that cannot survive reuse at gameplay scale.",
            "Modern industrial materials or neon accents that break the launch city thesis.",
        ],
    )
    image = gradient_background(PALETTE["indigo"], PALETTE["indigo_deep"])
    add_vignette(image, PALETTE["moss"], 72)
    title_block(image, meta, PALETTE["ember"])
    draw = ImageDraw.Draw(image)
    sheet_box = (MARGIN, 520, WIDTH - MARGIN, HEIGHT - 700)
    panel(image, sheet_box, PALETTE["parchment"], PALETTE["stone"], radius=56)

    prop_cards = [
        ("Oven", (160, 680), PALETTE["ember"]),
        ("Lantern", (520, 680), PALETTE["dawn"]),
        ("Canal Ward", (880, 680), PALETTE["silver"]),
        ("Archive", (1240, 680), PALETTE["stone"]),
        ("Market Stall", (340, 1140), PALETTE["moss"]),
        ("Charter Seal", (700, 1140), PALETTE["ember"]),
        ("Timber + Tile", (1060, 1140), PALETTE["stone"]),
    ]
    for label, (cx, cy), accent in prop_cards:
        panel(image, (cx - 130, cy - 110, cx + 130, cy + 180), PALETTE["cream"], PALETTE["stone"], radius=28)
        draw.text((cx - 96, cy + 96), label, font=font("accent", 28), fill=rgba(PALETTE["ink"]))
        if label == "Oven":
            draw.rounded_rectangle((cx - 48, cy - 32, cx + 48, cy + 36), radius=18, fill=rgba(PALETTE["ember"]))
            glow_circle(image, (cx, cy + 4), 70, PALETTE["dawn"], 120)
        elif label == "Lantern":
            draw.rounded_rectangle((cx - 28, cy - 22, cx + 28, cy + 56), radius=18, fill=rgba(PALETTE["indigo"]))
            glow_circle(image, (cx, cy + 14), 72, accent, 135)
            draw.ellipse((cx - 18, cy - 4, cx + 18, cy + 28), fill=rgba(accent))
        elif label == "Canal Ward":
            draw.ellipse((cx - 52, cy - 52, cx + 52, cy + 52), outline=rgba(accent), width=8)
            draw.line([(cx, cy - 46), (cx, cy + 46)], fill=rgba(accent), width=7)
            draw.line([(cx - 46, cy), (cx + 46, cy)], fill=rgba(accent), width=7)
        elif label == "Archive":
            draw.rectangle((cx - 56, cy - 40, cx + 44, cy + 30), fill=rgba(accent))
            draw.rectangle((cx - 32, cy - 60, cx + 68, cy + 10), fill=rgba("#8D6F58"))
            draw.line([(cx - 18, cy - 44), (cx + 46, cy - 44)], fill=rgba(PALETTE["cream"]), width=5)
        elif label == "Market Stall":
            draw.rectangle((cx - 62, cy - 6, cx + 62, cy + 58), fill=rgba("#8D6F58"))
            draw.polygon([(cx - 78, cy - 8), (cx, cy - 64), (cx + 78, cy - 8)], fill=rgba(accent))
            draw.line([(cx - 58, cy + 58), (cx - 58, cy + 90)], fill=rgba(PALETTE["ink"]), width=6)
            draw.line([(cx + 58, cy + 58), (cx + 58, cy + 90)], fill=rgba(PALETTE["ink"]), width=6)
        elif label == "Charter Seal":
            draw.ellipse((cx - 56, cy - 56, cx + 56, cy + 56), fill=rgba(accent))
            draw.polygon([(cx, cy - 74), (cx - 18, cy + 70), (cx + 18, cy + 70)], fill=rgba(PALETTE["cream"]))
        elif label == "Timber + Tile":
            draw.rectangle((cx - 62, cy - 10, cx + 62, cy + 62), fill=rgba("#78624F"))
            draw.polygon([(cx - 80, cy - 10), (cx, cy - 70), (cx + 80, cy - 10)], fill=rgba("#8A4033"))
            draw.line([(cx - 34, cy - 4), (cx - 34, cy + 56)], fill=rgba(PALETTE["cream"]), width=5)
            draw.line([(cx + 6, cy - 4), (cx + 6, cy + 56)], fill=rgba(PALETTE["cream"]), width=5)

    draw.text((160, 1550), "Material roles", font=font("accent", 34), fill=rgba(PALETTE["white"]))
    swatches = [
        ("Bronze / Brass", "#A87A44"),
        ("Warm Stone", PALETTE["stone"]),
        ("Moss / Patina", PALETTE["moss"]),
        ("Parchment", PALETTE["parchment"]),
        ("Moon Silver", PALETTE["silver"]),
    ]
    x = 160
    for label, color in swatches:
        swatch(draw, label, color, (x, 1606))
        x += 210

    draw.rounded_rectangle((160, 1825, 1376, 1960), radius=30, fill=rgba(PALETTE["cream"], 220))
    draw_text_block(
        draw,
        "Kit note: props should imply law, study, nourishment, trade, and repair with equal dignity. Favor chunkier silhouettes that can downshift into tiles, keepsakes, and shop icons.",
        (196, 1860),
        font("body", 32),
        rgba(PALETTE["ink"]),
        1120,
    )

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_npc_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-04_npc-bust-language-target.png",
        title="NPC Bust Language",
        subtitle="Civic, scholarly, domestic, mercantile, martial, and companion reads with strong mobile silhouettes.",
        prompt_line="Final direction: role-first costume masses and prop logic, warm fantasy realism, readable later as busts and sprite silhouettes.",
        notes=[
            "Faces and role props must stay readable at dialogue scale on iPhone.",
            "Civilian, scholarly, and mercantile fantasies need equal visual authority beside martial reads.",
            "Pollen should feel like wonder and attachment, not mascot clutter.",
        ],
        anti_patterns=[
            "Same-face portrait clones or monoculture costume logic.",
            "Hyper-rendered realism that clashes with the world sheet.",
            "Generic MMO quest-giver styling that ignores civic warmth.",
        ],
    )
    image = gradient_background("#2B2135", PALETTE["indigo"])
    add_vignette(image, PALETTE["dawn"], 60)
    title_block(image, meta, PALETTE["moss"])
    draw = ImageDraw.Draw(image)
    panel(image, (MARGIN, 520, WIDTH - MARGIN, HEIGHT - 700), PALETTE["parchment"], PALETTE["stone"], radius=56)

    roles = [
        ("Maerin Vale", "civic warden", PALETTE["ember"], "cloak + seal"),
        ("Sera Quill", "junior archivist", PALETTE["silver"], "lenses + folio"),
        ("Tovan Hearth", "baker / craft master", PALETTE["dawn"], "apron + bread paddle"),
        ("Brigant Hal", "captain-in-training", PALETTE["moss"], "tabard + practice blade"),
        ("Ilya Fen", "charter clerk", PALETTE["stone"], "ledger + brass clip"),
        ("Pollen", "lantern fox", PALETTE["dawn"], "glow tail + ward spark"),
    ]
    start_x = 140
    start_y = 720
    gap_x = 410
    gap_y = 400
    for index, (name, role, accent, prop) in enumerate(roles):
        col = index % 3
        row = index // 3
        x = start_x + col * gap_x
        y = start_y + row * gap_y
        panel(image, (x, y, x + 330, y + 320), PALETTE["cream"], PALETTE["stone"], radius=28)
        draw.ellipse((x + 104, y + 40, x + 226, y + 162), fill=rgba(accent))
        draw.rounded_rectangle((x + 80, y + 152, x + 250, y + 282), radius=28, fill=rgba(PALETTE["indigo"], 180))
        if name == "Pollen":
            glow_circle(image, (x + 170, y + 120), 72, PALETTE["dawn"], 140)
            draw.polygon([(x + 110, y + 120), (x + 150, y + 90), (x + 136, y + 148)], fill=rgba(PALETTE["cream"]))
            draw.polygon([(x + 230, y + 120), (x + 190, y + 90), (x + 204, y + 148)], fill=rgba(PALETTE["cream"]))
        else:
            draw.rectangle((x + 152, y + 188, x + 178, y + 250), fill=rgba(accent))
        draw.text((x + 26, y + 232), name, font=font("accent", 25), fill=rgba(PALETTE["ink"]))
        draw.text((x + 26, y + 266), role, font=font("body", 23), fill=rgba(PALETTE["ash"]))
        draw.text((x + 26, y + 292), prop, font=font("body", 21), fill=rgba(PALETTE["ember"]))

    draw.rounded_rectangle((160, 1590, 1376, 1735), radius=30, fill=rgba(PALETTE["cream"], 220))
    draw_text_block(
        draw,
        "Bust rule: silhouette first, material language second, face detail third. If the role does not read in half a second from shape and prop massing, the design is not ready.",
        (200, 1630),
        font("body", 32),
        rgba(PALETTE["ink"]),
        1120,
    )

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_hearth_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-03_hearth-target.png",
        title="Hearth Reward Surface",
        subtitle="A warm home that shows identity expression, keepsakes, and visible upgrade states without becoming a storage grid.",
        prompt_line="Final direction: intimate reward-first room composition, avatar placement zone, progression through warmth and density, not menu clutter.",
        notes=[
            "The Hearth should read as earned comfort and personalization, not a plain settings room.",
            "State progression from bare to personalized to prestigious must be obvious at a glance.",
            "Applied keepsakes should feel curated and aspirational rather than stuffed into a grid.",
        ],
        anti_patterns=[
            "Static tavern cliché with no sense of identity or progression.",
            "Storage-grid-first composition that hides the room fantasy.",
            "Cold, sparse staging with no warmth-return story.",
        ],
    )
    image = gradient_background("#241E26", PALETTE["ash"])
    add_vignette(image, PALETTE["ember"], 85)
    title_block(image, meta, PALETTE["ember"])
    draw = ImageDraw.Draw(image)
    room_box = (MARGIN, 520, WIDTH - MARGIN, HEIGHT - 700)
    panel(image, room_box, PALETTE["parchment"], PALETTE["stone"], radius=56)

    wall = (140, 700, 1396, 1530)
    floor = (140, 1420, 1396, 1875)
    draw.rounded_rectangle(wall, radius=42, fill=rgba("#4F403B"))
    draw.rounded_rectangle(floor, radius=42, fill=rgba("#7A6758"))
    draw.rectangle((230, 1100, 560, 1490), fill=rgba("#8E6E58"))
    draw.rectangle((305, 1170, 485, 1490), fill=rgba(PALETTE["indigo_deep"]))
    glow_circle(image, (395, 1270), 170, PALETTE["dawn"], 140)
    draw.rectangle((860, 930, 1180, 1485), fill=rgba("#6C5647"))
    draw.rounded_rectangle((1000, 920, 1236, 1085), radius=24, fill=rgba(PALETTE["cream"]))
    draw.rounded_rectangle((1040, 1142, 1266, 1274), radius=24, fill=rgba("#8D6F58"))
    draw.rounded_rectangle((610, 1210, 820, 1620), radius=34, fill=rgba(PALETTE["moss"], 170))
    draw.ellipse((680, 1030, 780, 1130), fill=rgba(PALETTE["parchment"]))
    draw.rectangle((714, 1125, 744, 1502), fill=rgba(PALETTE["parchment"]))

    for x, y in [(930, 770), (1090, 780), (1250, 770), (1225, 1320), (1000, 1330), (1180, 1510)]:
        glow_circle(image, (x, y), 54, PALETTE["dawn"], 110)
        draw.ellipse((x - 18, y - 18, x + 18, y + 18), fill=rgba(PALETTE["dawn"]))

    draw.text((182, 760), "bare", font=font("accent", 28), fill=rgba(PALETTE["parchment_deep"]))
    draw.text((1110, 760), "personalized", font=font("accent", 28), fill=rgba(PALETTE["parchment_deep"]))
    draw.line([(695, 820), (695, 1560)], fill=rgba(PALETTE["cream"], 120), width=4)

    draw.rounded_rectangle((170, 1600, 1365, 1760), radius=30, fill=rgba(PALETTE["cream"], 220))
    draw_text_block(
        draw,
        "Upgrade signal: lighting warms first, then keepsakes arrive, then surfaces gain richer textiles, trophies, and identity-specific prop logic.",
        (206, 1642),
        font("body", 32),
        rgba(PALETTE["ink"]),
        1120,
    )

    swatches = [("Parchment Stone", PALETTE["parchment"]), ("Ember Copper", PALETTE["ember"]), ("Moon Silver", PALETTE["silver"]), ("Moss Green", PALETTE["moss"])]
    x = 170
    for label, color in swatches:
        swatch(draw, label, color, (x, 1800))
        x += 220

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_today_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-01_today-ui-target.png",
        title="Today Utility Target",
        subtitle="Premium-native iPhone UI with fantasy framing, fast vow logging, and low-noise progress accents.",
        prompt_line="Final direction: manual UI composition over approved art language, no fake AI app text, ornament always subordinate to tappable clarity.",
        notes=[
            "Primary completion actions must read in under a second with strong card hierarchy and bold affordances.",
            "Fantasy motifs should show up in material feel, chapter polish, and completion warmth only where meaning exists.",
            "The Today surface must remain more utility than game scene even when it feels premium and mythic.",
        ],
        anti_patterns=[
            "Generated fake app screenshots with noisy labels or illegible micro-copy.",
            "MMO HUD density and decorative borders around every component.",
            "Gold-heavy mobile fantasy styling that confuses monetization with progress.",
        ],
    )
    image = gradient_background("#2A3146", "#1E2230")
    add_vignette(image, PALETTE["dawn"], 55)
    title_block(image, meta, PALETTE["dawn"])
    draw = ImageDraw.Draw(image)
    phone = (MARGIN + 130, 540, WIDTH - MARGIN - 130, HEIGHT - 760)
    shadow(image, phone, radius=72, alpha=110)
    draw.rounded_rectangle(phone, radius=78, fill=rgba(PALETTE["white"]))
    draw.rounded_rectangle((phone[0] + 180, phone[1] + 24, phone[2] - 180, phone[1] + 62), radius=20, fill=rgba("#17171C"))

    inset = 58
    content = (phone[0] + inset, phone[1] + 110, phone[2] - inset, phone[3] - 54)
    draw.text((content[0], content[1]), "Today's vows", font=font("display", 66), fill=rgba(PALETTE["ink"]))
    draw.text((content[0], content[1] + 94), "Day 4 of The Ember That Returned", font=font("body", 30), fill=rgba(PALETTE["ash"]))

    chapter = (content[0], content[1] + 150, content[2], content[1] + 430)
    panel(image, chapter, PALETTE["parchment"], PALETTE["stone"], radius=40)
    draw.text((chapter[0] + 34, chapter[1] + 30), "Current chapter", font=font("accent", 24), fill=rgba(PALETTE["ash"]))
    draw.text((chapter[0] + 34, chapter[1] + 78), "The Ember That Returned", font=font("accent", 34), fill=rgba(PALETTE["ink"]))
    draw_text_block(draw, "A shuttered oven begins to answer your kept vows. Tonight's beat is gentle but visible.", (chapter[0] + 34, chapter[1] + 130), font("body", 30), rgba(PALETTE["ink"]), 760)
    draw.rounded_rectangle((chapter[0] + 34, chapter[1] + 250, chapter[2] - 34, chapter[1] + 276), radius=12, fill=rgba(PALETTE["parchment_deep"]))
    draw.rounded_rectangle((chapter[0] + 34, chapter[1] + 250, chapter[0] + 430, chapter[1] + 276), radius=12, fill=rgba(PALETTE["dawn"]))
    glow_circle(image, (chapter[2] - 90, chapter[1] + 108), 70, PALETTE["dawn"], 90)

    y = chapter[3] + 30
    cards = [
        ("Morning walk", "Manual logging still takes priority over world browsing.", 0.7, True),
        ("Read ten pages", "Readable progress and completion state, not ornamental framing.", 0.45, False),
        ("Journal one line", "Gentle magical polish appears only after action succeeds.", 1.0, True),
    ]
    for title, subtitle, progress, done in cards:
        card = (content[0], y, content[2], y + 242)
        panel(image, card, PALETTE["cream"], PALETTE["stone"], radius=36)
        draw.text((card[0] + 34, card[1] + 30), title, font=font("accent", 36), fill=rgba(PALETTE["ink"]))
        draw_text_block(draw, subtitle, (card[0] + 34, card[1] + 82), font("body", 28), rgba(PALETTE["ash"]), 650)
        draw.rounded_rectangle((card[0] + 34, card[1] + 162, card[2] - 240, card[1] + 184), radius=10, fill=rgba(PALETTE["parchment_deep"]))
        draw.rounded_rectangle((card[0] + 34, card[1] + 162, int(card[0] + 34 + (card[2] - card[0] - 274) * progress), card[1] + 184), radius=10, fill=rgba(PALETTE["moss"] if done else PALETTE["dawn"]))
        btn_fill = PALETTE["moss"] if done else PALETTE["ember"]
        btn_box = (card[2] - 208, card[1] + 62, card[2] - 34, card[1] + 176)
        draw.rounded_rectangle(btn_box, radius=28, fill=rgba(btn_fill))
        draw.text((btn_box[0] + 34, btn_box[1] + 34), "Done" if done else "Log", font=font("accent", 34), fill=rgba(PALETTE["white"]))
        if done:
            glow_circle(image, (card[2] - 132, card[1] + 118), 54, PALETTE["dawn"], 78)
        y += 268

    stat_y = phone[3] - 220
    for idx, (label, value) in enumerate([("Chains", "4"), ("Embers", "2"), ("Gold", "85"), ("Rank", "3")]):
        x = content[0] + idx * 185
        draw.rounded_rectangle((x, stat_y, x + 160, stat_y + 112), radius=28, fill=rgba(PALETTE["parchment"]))
        draw.text((x + 22, stat_y + 24), label, font=font("body", 24), fill=rgba(PALETTE["ash"]))
        draw.text((x + 22, stat_y + 56), value, font=font("accent", 32), fill=rgba(PALETTE["ink"]))

    draw.rounded_rectangle((content[2] - 310, stat_y, content[2], stat_y + 112), radius=28, fill=rgba(PALETTE["indigo"]))
    draw.text((content[2] - 274, stat_y + 36), "See the district respond", font=font("body", 26), fill=rgba(PALETTE["white"]))

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_identity_sheet() -> None:
    meta = SheetMeta(
        filename="ART-01-06_identity-silhouettes-target.png",
        title="Identity Silhouette Strip",
        subtitle="Ten launch identities reading distinctly through outerwear, stance, and prop logic without implying ten separate class trees.",
        prompt_line="Final direction: flavor-first silhouettes that later survive avatar and sprite production at phone scale.",
        notes=[
            "Each identity should read by shape and prop before surface detail.",
            "Civilian, mercantile, and scholarly silhouettes must carry equal charisma beside knightly reads.",
            "Differences should live in stance, tool, and layering, not bespoke progression promises.",
        ],
        anti_patterns=[
            "Overblown class-fantasy exaggeration that suggests separate combat systems.",
            "Micro-detail costume rendering that will disappear at sprite scale.",
            "Homogenized outerwear that makes the ten identities collapse together.",
        ],
    )
    image = gradient_background(PALETTE["indigo"], "#1A1C26")
    add_vignette(image, PALETTE["moss"], 52)
    title_block(image, meta, PALETTE["moss"])
    draw = ImageDraw.Draw(image)
    panel(image, (MARGIN, 520, WIDTH - MARGIN, HEIGHT - 700), PALETTE["parchment"], PALETTE["stone"], radius=56)

    labels = ["Knight", "Paladin", "Ranger", "Mage", "Scholar", "Farmer", "Baker", "Cafe Keeper", "Merchant", "Charterlord"]
    accents = [PALETTE["ember"], PALETTE["dawn"], PALETTE["moss"], PALETTE["silver"], PALETTE["stone"], "#7C6B49", PALETTE["ember"], "#9A6448", PALETTE["moss"], PALETTE["silver"]]

    start_x = 150
    baseline = 1450
    gap = 122
    for idx, label in enumerate(labels):
        x = start_x + idx * gap
        accent = accents[idx]
        draw.ellipse((x - 26, baseline - 384, x + 26, baseline - 332), fill=rgba(accent))
        width = 42 + (idx % 3) * 6
        draw.rounded_rectangle((x - width, baseline - 320, x + width, baseline - 126), radius=28, fill=rgba(PALETTE["indigo"], 210))
        if idx in {0, 1, 3, 4, 9}:
            draw.polygon([(x - 62, baseline - 288), (x, baseline - 352), (x + 62, baseline - 288), (x, baseline - 140)], fill=rgba(accent, 180))
        if idx in {2, 5, 6, 7, 8}:
            draw.rectangle((x - 8, baseline - 212, x + 8, baseline - 70), fill=rgba(accent))
        if idx in {0, 1}:
            draw.rectangle((x + 40, baseline - 260, x + 58, baseline - 80), fill=rgba(accent))
        if idx == 3:
            draw.line([(x + 52, baseline - 300), (x + 80, baseline - 100)], fill=rgba(accent), width=8)
        if idx == 4:
            draw.rectangle((x + 34, baseline - 260, x + 68, baseline - 208), fill=rgba(accent))
        draw.text((x - 54, baseline - 34), label, font=font("body", 20), fill=rgba(PALETTE["ink"]))

    draw.rounded_rectangle((160, 1600, 1376, 1760), radius=30, fill=rgba(PALETTE["cream"], 220))
    draw_text_block(
        draw,
        "Family logic: Dawnbound silhouettes lean on guard and motion, Archivists on layered tools and drape, Hearthkeepers on practical warmth, Chartermakers on fitted civic structure.",
        (198, 1642),
        font("body", 32),
        rgba(PALETTE["ink"]),
        1125,
    )

    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def draw_sheet_index() -> None:
    meta = SheetMeta(
        filename="ART-01-00_pack-cover.png",
        title="ART-01 Visual Target Sheets",
        subtitle="The first art-production pass for Aevora, locking a hybrid of pixel-world readability and premium-native iPhone UI.",
        prompt_line="Execution note: locally rendered in-repo from the ART-01 prompt pack because no image-generation API is configured in this workspace.",
        notes=[
            "World-facing sheets favor pixel-world silhouette and repair-state readability.",
            "Today remains premium-native and manually composed over the approved visual language.",
            "The set unblocks ART-03, ART-04, ART-06, ART-09, ART-11, ART-12, ART-13, ART-14, ART-15, and ART-16.",
        ],
        anti_patterns=[
            "Treating ART-01 as a generic painterly moodboard pass.",
            "Trusting raw generated UI instead of manual composition discipline.",
            "Trying to solve final sprite animation before the visual thesis is locked.",
        ],
    )
    image = gradient_background(PALETTE["indigo_deep"], PALETTE["indigo"])
    add_vignette(image, PALETTE["dawn"], 74)
    title_block(image, meta, PALETTE["dawn"])
    draw = ImageDraw.Draw(image)
    panel(image, (MARGIN, 560, WIDTH - MARGIN, 1700), PALETTE["parchment"], PALETTE["stone"], radius=58)
    items = [
        "01 Today utility target",
        "02 World vertical slice",
        "03 Hearth reward surface",
        "04 NPC bust language",
        "05 Cyrane materials + props",
        "06 Identity silhouette strip",
    ]
    y = 690
    for item in items:
        draw.rounded_rectangle((180, y, 1360, y + 124), radius=28, fill=rgba(PALETTE["cream"]))
        draw.text((220, y + 36), item, font=font("accent", 34), fill=rgba(PALETTE["ink"]))
        y += 148

    swatches = [
        ("Dawn Gold", PALETTE["dawn"]),
        ("Ember Copper", PALETTE["ember"]),
        ("Moon Indigo", PALETTE["indigo"]),
        ("Moss Green", PALETTE["moss"]),
        ("Parchment Stone", PALETTE["parchment"]),
    ]
    x = 180
    for label, color in swatches:
        swatch(draw, label, color, (x, 1610))
        x += 220
    footer_notes(image, meta)
    image.save(OUT_DIR / meta.filename)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    draw_sheet_index()
    draw_today_sheet()
    draw_world_sheet()
    draw_hearth_sheet()
    draw_npc_sheet()
    draw_materials_sheet()
    draw_identity_sheet()


if __name__ == "__main__":
    main()
