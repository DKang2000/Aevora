from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[3]
TOKENS_PATH = ROOT / "shared" / "tokens" / "aevora-v1-design-tokens.json"
CONTENT_PATH = ROOT / "content" / "launch" / "launch-content.min.v1.json"
OUT_DIR = ROOT / "assets" / "art" / "avatar-kit"
WIDTH = 1536
HEIGHT = 2732
MARGIN = 88

FONT_PATHS = {
    "display": "/System/Library/Fonts/NewYork.ttf",
    "body": "/System/Library/Fonts/HelveticaNeue.ttc",
    "accent": "/System/Library/Fonts/SFNSRounded.ttf",
}

PALETTE_SPECS = {
    "palette_burnished_gold": {"cloth": "#A87925", "trim": "#F0CF7A", "neutral": "#544430"},
    "palette_dawn_white": {"cloth": "#F1E9D8", "trim": "#D9A647", "neutral": "#61503B"},
    "palette_moss_steel": {"cloth": "#496255", "trim": "#9CC193", "neutral": "#4A5662"},
    "palette_moon_ink": {"cloth": "#2E3654", "trim": "#A28AA3", "neutral": "#5C6788"},
    "palette_amber_ink": {"cloth": "#7A5335", "trim": "#E7A46C", "neutral": "#574A46"},
    "palette_harvest_green": {"cloth": "#55724C", "trim": "#D9A647", "neutral": "#6A5B4E"},
    "palette_ember_ochre": {"cloth": "#C7722F", "trim": "#F0CF7A", "neutral": "#6B4A35"},
    "palette_roasted_clay": {"cloth": "#9C5F49", "trim": "#E7A46C", "neutral": "#6E554A"},
    "palette_copper_blue": {"cloth": "#47627E", "trim": "#E38C40", "neutral": "#695949"},
    "palette_stone_plum": {"cloth": "#6B536E", "trim": "#CDBEAC", "neutral": "#625851"},
}

SKIN_TONES = ["#F4D8C2", "#E7BE9A", "#D4976A", "#A66B4F", "#6B4637"]
HAIR_COLORS = ["#2D231B", "#5D4534", "#7A5A34", "#8B6D58", "#D3C4B0"]
HAIR_SHAPES = [
    ("soft_crop", "Rounded crop"),
    ("ward_bob", "Ward bob"),
    ("tied_wrap", "Tied wrap"),
    ("long_fall", "Long fall"),
]


@dataclass(frozen=True)
class BoardMeta:
    filename: str
    title: str
    subtitle: str
    chip_label: str


@dataclass(frozen=True)
class IdentitySeed:
    identity_id: str
    family_id: str
    silhouette_id: str
    palette_id: str
    accessory_ids: list[str]


class TokenBook:
    def __init__(self, path: Path) -> None:
        self.data = json.loads(path.read_text())

    def get(self, dot_path: str):
        node = self.data
        for part in dot_path.split("."):
            node = node[part]
        return node

    def color(self, dot_path: str) -> str:
        value = self.get(dot_path)
        if not isinstance(value, str):
            raise TypeError(f"{dot_path} did not resolve to a color string.")
        return value

    def gradient(self, dot_path: str) -> list[str]:
        value = self.get(dot_path)
        if not isinstance(value, list):
            raise TypeError(f"{dot_path} did not resolve to a gradient array.")
        return value


TOKENS = TokenBook(TOKENS_PATH)


def rgba(hex_color: str, alpha: int = 255) -> tuple[int, int, int, int]:
    trimmed = hex_color.lstrip("#")
    return tuple(int(trimmed[i : i + 2], 16) for i in (0, 2, 4)) + (alpha,)


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
    fill: str,
    max_width: int,
    line_gap: int = 8,
) -> int:
    x, y = xy
    lines = line_wrap(draw, text, ft, max_width)
    ascent, descent = ft.getmetrics()
    height = ascent + descent
    for line in lines:
        draw.text((x, y), line, font=ft, fill=rgba(fill))
        y += height + line_gap
    return y


def gradient_image(width: int, height: int, colors: list[str], vertical: bool = True) -> Image.Image:
    image = Image.new("RGBA", (width, height), rgba(colors[0]))
    overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    start = rgba(colors[0])
    end = rgba(colors[-1])
    length = height if vertical else width
    for step in range(length):
        ratio = step / max(length - 1, 1)
        color = tuple(int(start[i] + (end[i] - start[i]) * ratio) for i in range(3)) + (255,)
        if vertical:
            draw.line([(0, step), (width, step)], fill=color)
        else:
            draw.line([(step, 0), (step, height)], fill=color)
    image.alpha_composite(overlay)
    return image


def shadow(image: Image.Image, box: tuple[int, int, int, int], radius: int = 30, alpha: int = 72) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    draw.rounded_rectangle(box, radius=radius, fill=(0, 0, 0, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(28))
    image.alpha_composite(layer)


def panel(
    image: Image.Image,
    box: tuple[int, int, int, int],
    fill: str,
    outline: str | None = None,
    radius: int = 34,
    alpha: int = 245,
) -> None:
    shadow(image, box, radius=radius)
    ImageDraw.Draw(image).rounded_rectangle(
        box,
        radius=radius,
        fill=rgba(fill, alpha),
        outline=rgba(outline) if outline else None,
        width=2,
    )


def add_glow(image: Image.Image, center: tuple[int, int], radius: int, color: str, alpha: int) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x, y = center
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=rgba(color, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(radius // 2))
    image.alpha_composite(layer)


def background_shell() -> Image.Image:
    image = gradient_image(WIDTH, HEIGHT, TOKENS.gradient("gradient.world.deep"))
    add_glow(image, (WIDTH // 2, 250), 360, TOKENS.color("color.emberCopper.500"), 66)
    add_glow(image, (WIDTH - 260, 690), 260, TOKENS.color("color.dawnGold.300"), 52)
    add_glow(image, (280, HEIGHT - 320), 300, TOKENS.color("color.mossGreen.300"), 36)
    return image


def chip(draw: ImageDraw.ImageDraw, label: str, xy: tuple[int, int], fill: str, text_fill: str) -> int:
    ft = font("accent", 28)
    padding_x = 18
    width = int(draw.textlength(label, font=ft)) + padding_x * 2
    x, y = xy
    draw.rounded_rectangle((x, y, x + width, y + 48), radius=24, fill=rgba(fill))
    draw.text((x + padding_x, y + 8), label, font=ft, fill=rgba(text_fill))
    return width


def board_header(image: Image.Image, meta: BoardMeta, chip_fill: str) -> None:
    draw = ImageDraw.Draw(image)
    chip(draw, meta.chip_label, (MARGIN, 74), chip_fill, TOKENS.color("color.text.inverse"))
    draw.text((MARGIN, 158), meta.title, font=font("display", 78), fill=rgba(TOKENS.color("color.text.inverse")))
    draw_text_block(
        draw,
        meta.subtitle,
        (MARGIN, 258),
        font("body", 34),
        TOKENS.color("color.parchmentStone.100"),
        WIDTH - MARGIN * 2,
        line_gap=10,
    )


def main_canvas(image: Image.Image) -> tuple[int, int, int, int]:
    box = (MARGIN, 452, WIDTH - MARGIN, HEIGHT - 84)
    panel(
        image,
        box,
        TOKENS.color("color.surface.app"),
        TOKENS.color("color.border.default"),
        radius=58,
        alpha=247,
    )
    return box


def section_label(draw: ImageDraw.ImageDraw, title: str, subtitle: str, xy: tuple[int, int], width: int) -> int:
    x, y = xy
    draw.text((x, y), title, font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    return draw_text_block(
        draw,
        subtitle,
        (x, y + 44),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        width,
        line_gap=6,
    )


def humanize(identifier: str) -> str:
    trimmed = identifier.replace("silhouette_", "").replace("palette_", "").replace("accessory_", "")
    return trimmed.replace("_", " ").title()


def load_identity_seeds() -> list[IdentitySeed]:
    payload = json.loads(CONTENT_PATH.read_text())
    seeds: list[IdentitySeed] = []
    for shell in payload["identityShells"]:
        defaults = shell["defaultAvatar"]
        seeds.append(
            IdentitySeed(
                identity_id=shell["id"],
                family_id=shell["originFamilyId"],
                silhouette_id=defaults["silhouetteId"],
                palette_id=defaults["paletteId"],
                accessory_ids=defaults["accessoryIds"],
            )
        )
    return seeds


def family_seeds(identity_seeds: list[IdentitySeed], family_id: str) -> list[IdentitySeed]:
    return [seed for seed in identity_seeds if seed.family_id == family_id]


def garment_shape(
    center_x: int,
    top_y: int,
    body_height: int,
    shoulder: int,
    waist: int,
    hem: int,
) -> list[tuple[int, int]]:
    return [
        (center_x - shoulder // 2, top_y),
        (center_x + shoulder // 2, top_y),
        (center_x + waist // 2, top_y + int(body_height * 0.42)),
        (center_x + hem // 2, top_y + body_height),
        (center_x - hem // 2, top_y + body_height),
        (center_x - waist // 2, top_y + int(body_height * 0.42)),
    ]


def draw_avatar_figure(
    image: Image.Image,
    box: tuple[int, int, int, int],
    silhouette_id: str,
    palette_id: str,
    show_bust: bool = False,
    hair_index: int = 1,
    skin_index: int = 1,
    accent: str | None = None,
) -> None:
    palette = PALETTE_SPECS.get(palette_id, PALETTE_SPECS["palette_ember_ochre"])
    draw = ImageDraw.Draw(image)
    x1, y1, x2, y2 = box
    width = x2 - x1
    height = y2 - y1
    center_x = x1 + width // 2
    baseline = y2 - 48
    head_radius = max(42, height // (7 if show_bust else 11))
    head_center = (center_x, y1 + head_radius + (28 if show_bust else 34))

    draw.ellipse((center_x - int(width * 0.2), baseline - 26, center_x + int(width * 0.2), baseline + 18), fill=rgba("#D8CCBA", 120))

    draw.ellipse(
        (head_center[0] - head_radius, head_center[1] - head_radius, head_center[0] + head_radius, head_center[1] + head_radius),
        fill=rgba(SKIN_TONES[skin_index % len(SKIN_TONES)]),
    )

    hair_color = HAIR_COLORS[hair_index % len(HAIR_COLORS)]
    hair_box = (head_center[0] - head_radius - 10, head_center[1] - head_radius - 18, head_center[0] + head_radius + 10, head_center[1] + head_radius // 2)
    draw.rounded_rectangle(hair_box, radius=head_radius, fill=rgba(hair_color))
    if silhouette_id in {"silhouette_archive_robe", "silhouette_sigil_coat", "silhouette_civic_cloak"}:
        draw.rectangle((hair_box[0] + 16, hair_box[3] - 8, hair_box[2] - 16, hair_box[3] + 32), fill=rgba(hair_color))
    elif silhouette_id in {"silhouette_field_apron", "silhouette_oven_apron"}:
        draw.polygon(
            [(hair_box[0] + 14, hair_box[3] - 2), (hair_box[2] - 14, hair_box[3] - 2), (head_center[0], hair_box[3] + 34)],
            fill=rgba(hair_color),
        )
    else:
        draw.ellipse((head_center[0] - head_radius + 6, head_center[1] - 4, head_center[0] + head_radius - 6, head_center[1] + head_radius + 10), fill=rgba(hair_color))

    if show_bust:
        body_height = int(height * 0.46)
        top_y = head_center[1] + head_radius - 4
    else:
        body_height = int(height * 0.58)
        top_y = head_center[1] + head_radius + 12

    shoulder = int(width * 0.46)
    waist = int(width * 0.30)
    hem = int(width * 0.40)

    if silhouette_id in {"silhouette_guard", "silhouette_vow_ward"}:
        shoulder = int(width * 0.48)
        waist = int(width * 0.29)
        hem = int(width * 0.34)
    elif silhouette_id in {"silhouette_archive_robe", "silhouette_sigil_coat", "silhouette_civic_cloak"}:
        shoulder = int(width * 0.42)
        waist = int(width * 0.34)
        hem = int(width * 0.46)
    elif silhouette_id in {"silhouette_field_apron", "silhouette_oven_apron", "silhouette_counter_vest"}:
        shoulder = int(width * 0.44)
        waist = int(width * 0.33)
        hem = int(width * 0.42)
    elif silhouette_id in {"silhouette_pathfinder"}:
        shoulder = int(width * 0.40)
        waist = int(width * 0.28)
        hem = int(width * 0.36)

    cloak = silhouette_id in {"silhouette_guard", "silhouette_vow_ward", "silhouette_pathfinder", "silhouette_civic_cloak"}
    apron = silhouette_id in {"silhouette_field_apron", "silhouette_oven_apron"}
    vest = silhouette_id in {"silhouette_counter_vest", "silhouette_ledger_coat"}
    robe = silhouette_id in {"silhouette_archive_robe", "silhouette_sigil_coat"}

    if cloak:
        cloak_points = garment_shape(center_x, top_y - 12, body_height + 22, shoulder + 60, waist + 70, hem + 120)
        draw.polygon(cloak_points, fill=rgba(palette["neutral"]))
    body_points = garment_shape(center_x, top_y, body_height, shoulder, waist, hem)
    draw.polygon(body_points, fill=rgba(palette["cloth"]))

    robe_bottom = top_y + body_height - 14
    vest_bottom = top_y + body_height - 28
    if robe and robe_bottom > top_y + 52:
        draw.rectangle((center_x - 16, top_y + 40, center_x + 16, robe_bottom), fill=rgba(palette["trim"]))
    elif vest and vest_bottom > top_y + 56:
        draw.rounded_rectangle((center_x - 56, top_y + 44, center_x + 56, vest_bottom), radius=34, outline=rgba(palette["trim"]), width=12)
    else:
        draw.rectangle((center_x - hem // 4, top_y + 28, center_x + hem // 4, top_y + 48), fill=rgba(palette["trim"]))

    if apron:
        apron_top = top_y + 88
        apron_bottom = top_y + body_height - 24
        if apron_bottom > apron_top:
            draw.rounded_rectangle((center_x - 72, apron_top, center_x + 72, apron_bottom), radius=28, fill=rgba("#F1E7D8"))
        draw.rectangle((center_x - 84, top_y + 72, center_x + 84, top_y + 94), fill=rgba(palette["trim"]))

    if silhouette_id == "silhouette_guard":
        draw.ellipse((center_x + 58, top_y + 74, center_x + 116, top_y + 132), outline=rgba(palette["trim"]), width=8)
    elif silhouette_id == "silhouette_vow_ward":
        draw.polygon([(center_x + 78, top_y + 76), (center_x + 114, top_y + 114), (center_x + 84, top_y + 150), (center_x + 48, top_y + 112)], fill=rgba(palette["trim"]))
    elif silhouette_id == "silhouette_pathfinder":
        draw.rounded_rectangle((center_x - 124, top_y + 118, center_x - 70, top_y + 186), radius=18, fill=rgba(palette["neutral"]))
    elif silhouette_id == "silhouette_sigil_coat":
        draw.ellipse((center_x - 24, top_y + 84, center_x + 24, top_y + 132), outline=rgba(palette["trim"]), width=7)
    elif silhouette_id == "silhouette_archive_robe":
        draw.rectangle((center_x + 74, top_y + 96, center_x + 90, top_y + 178), fill=rgba(palette["trim"]))
        draw.ellipse((center_x + 58, top_y + 82, center_x + 106, top_y + 112), outline=rgba(palette["trim"]), width=6)
    elif silhouette_id == "silhouette_field_apron":
        draw.rounded_rectangle((center_x - 120, top_y + 148, center_x - 66, top_y + 206), radius=16, fill=rgba(palette["neutral"]))
    elif silhouette_id == "silhouette_oven_apron":
        draw.ellipse((center_x + 72, top_y + 152, center_x + 120, top_y + 200), fill=rgba(palette["trim"]))
    elif silhouette_id == "silhouette_counter_vest":
        draw.rectangle((center_x - 108, top_y + 136, center_x - 56, top_y + 154), fill=rgba(palette["trim"]))
    elif silhouette_id == "silhouette_ledger_coat":
        draw.rounded_rectangle((center_x + 58, top_y + 120, center_x + 112, top_y + 176), radius=14, fill=rgba(palette["neutral"]))
    elif silhouette_id == "silhouette_civic_cloak":
        draw.ellipse((center_x - 18, top_y + 72, center_x + 18, top_y + 108), fill=rgba(palette["trim"]))

    draw.rectangle((center_x - 84, y2 - 40, center_x - 44, y2 - 6), fill=rgba(palette["neutral"]))
    draw.rectangle((center_x + 44, y2 - 40, center_x + 84, y2 - 6), fill=rgba(palette["neutral"]))

    if accent:
        draw.rounded_rectangle((x1 + 18, y1 + 18, x2 - 18, y2 - 18), radius=26, outline=rgba(accent), width=6)


def draw_small_chip(draw: ImageDraw.ImageDraw, label: str, box: tuple[int, int, int, int], fill: str, text_fill: str) -> None:
    draw.rounded_rectangle(box, radius=24, fill=rgba(fill))
    ft = font("accent", 22)
    tw = draw.textlength(label, font=ft)
    draw.text(((box[0] + box[2] - tw) / 2, box[1] + 12), label, font=ft, fill=rgba(text_fill))


def render_board_01(identity_seeds: list[IdentitySeed]) -> Image.Image:
    image = background_shell()
    meta = BoardMeta(
        filename="ART-06-01_base-frame-silhouette-board.png",
        title="Avatar Base Silhouettes",
        subtitle="Four launch-facing body-frame abstractions prove the system before deep outfit work. Each silhouette reads quickly on portrait iPhone and keeps civilian, scholarly, mercantile, and quietly martial roles in the same dignity band.",
        chip_label="ART-06-01",
    )
    board_header(image, meta, TOKENS.color("color.emberCopper.500"))
    x1, y1, x2, y2 = main_canvas(image)
    draw = ImageDraw.Draw(image)
    section_label(draw, "Base frame language", "Neutral standing poses do most of the work. Bust crops confirm the head-and-shoulder read survives compressed onboarding and Hearth placements.", (x1 + 40, y1 + 36), x2 - x1 - 80)

    cards_top = y1 + 170
    card_w = 300
    gap = 24
    silhouettes = [
        identity_seeds[0].silhouette_id,
        identity_seeds[4].silhouette_id,
        identity_seeds[6].silhouette_id,
        identity_seeds[8].silhouette_id,
    ]
    palettes = [
        identity_seeds[0].palette_id,
        identity_seeds[4].palette_id,
        identity_seeds[6].palette_id,
        identity_seeds[8].palette_id,
    ]
    labels = ["Quietly martial", "Scholarly", "Domestic craft", "Mercantile civic"]

    for index, (silhouette_id, palette_id, role_label) in enumerate(zip(silhouettes, palettes, labels)):
        left = x1 + 38 + index * (card_w + gap)
        box = (left, cards_top, left + card_w, y2 - 320)
        panel(image, box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)
        draw_avatar_figure(image, (left + 28, cards_top + 84, left + card_w - 28, y2 - 430), silhouette_id, palette_id, show_bust=False, hair_index=index, skin_index=index)
        draw.text((left + 26, y2 - 404), role_label, font=font("accent", 26), fill=rgba(TOKENS.color("color.text.primary")))
        draw_text_block(draw, humanize(silhouette_id), (left + 26, y2 - 368), font("body", 22), TOKENS.color("color.text.secondary"), card_w - 52, line_gap=4)
        bust_box = (left + 84, y2 - 286, left + card_w - 84, y2 - 126)
        panel(image, bust_box, TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
        draw_avatar_figure(image, (bust_box[0] + 10, bust_box[1] + 10, bust_box[2] - 10, bust_box[3] - 10), silhouette_id, palette_id, show_bust=True, hair_index=index + 1, skin_index=index)

    footer_box = (x1 + 38, y2 - 108, x2 - 38, y2 - 34)
    panel(image, footer_box, TOKENS.color("color.surface.cardSecondary"), None, radius=26, alpha=255)
    draw.text((footer_box[0] + 20, footer_box[1] + 18), "Readability note", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Keep shoulder mass, hem shape, and one prop or trim cue distinct. The system should never need tiny eye detail or MMO gear clutter to communicate identity.",
        (footer_box[0] + 190, footer_box[1] + 15),
        font("body", 21),
        TOKENS.color("color.text.secondary"),
        footer_box[2] - footer_box[0] - 220,
        line_gap=4,
    )
    return image


def render_board_02() -> Image.Image:
    image = background_shell()
    meta = BoardMeta(
        filename="ART-06-02_head-hair-skin-anchor-board.png",
        title="Head, Hair, And Skin Anchors",
        subtitle="Launch avatar variation stays compact: skin-tone range, readable hair silhouettes, and one accessory anchor zone that survives smaller portrait placements.",
        chip_label="ART-06-02",
    )
    board_header(image, meta, TOKENS.color("color.mossGreen.500"))
    x1, y1, x2, y2 = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_box = (x1 + 38, y1 + 38, x1 + 650, y2 - 38)
    right_box = (x1 + 676, y1 + 38, x2 - 38, y2 - 38)
    panel(image, left_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)
    panel(image, right_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)

    section_label(draw, "Starter skin-tone matrix", "Five launch-safe tones cover the first-run range without muddy compression or overshading.", (left_box[0] + 28, left_box[1] + 24), left_box[2] - left_box[0] - 56)
    for index, tone in enumerate(SKIN_TONES):
        row = index // 2
        col = index % 2
        sw_left = left_box[0] + 34 + col * 254
        sw_top = left_box[1] + 136 + row * 230
        panel(image, (sw_left, sw_top, sw_left + 220, sw_top + 170), TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
        draw.ellipse((sw_left + 38, sw_top + 26, sw_left + 182, sw_top + 148), fill=rgba(tone))
        draw.text((sw_left + 24, sw_top + 186), f"Tone {index + 1}", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.primary")))

    note_box = (left_box[0] + 34, left_box[3] - 220, left_box[2] - 34, left_box[3] - 34)
    panel(image, note_box, TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
    draw.text((note_box[0] + 22, note_box[1] + 20), "Readability proof", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_avatar_figure(image, (note_box[0] + 22, note_box[1] + 52, note_box[0] + 242, note_box[3] - 18), "silhouette_sigil_coat", "palette_moon_ink", show_bust=True, hair_index=0, skin_index=2)
    draw_text_block(draw, "Face plane stays legible at phone scale because shape, contrast, and hairline do more work than micro features.", (note_box[0] + 264, note_box[1] + 70), font("body", 22), TOKENS.color("color.text.secondary"), note_box[2] - note_box[0] - 286, line_gap=6)

    section_label(draw, "Hair silhouettes and accessory anchor", "Starter hair needs outer-shape clarity first. Accessory placement stays close to shoulder, collar, or wrap zones so one small slot still reads.", (right_box[0] + 28, right_box[1] + 24), right_box[2] - right_box[0] - 56)
    for index, (hair_id, label) in enumerate(HAIR_SHAPES):
        sw_left = right_box[0] + 34 + (index % 2) * 250
        sw_top = right_box[1] + 136 + (index // 2) * 280
        panel(image, (sw_left, sw_top, sw_left + 220, sw_top + 220), TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
        draw_avatar_figure(image, (sw_left + 18, sw_top + 16, sw_left + 202, sw_top + 194), "silhouette_oven_apron", "palette_ember_ochre", show_bust=True, hair_index=index, skin_index=1)
        draw.text((sw_left + 22, sw_top + 228), label, font=font("accent", 21), fill=rgba(TOKENS.color("color.text.primary")))
        draw.text((sw_left + 22, sw_top + 254), hair_id, font=font("body", 18), fill=rgba(TOKENS.color("color.text.secondary")))

    anchor_box = (right_box[0] + 38, right_box[3] - 328, right_box[2] - 38, right_box[3] - 34)
    panel(image, anchor_box, TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
    draw_avatar_figure(image, (anchor_box[0] + 24, anchor_box[1] + 22, anchor_box[0] + 258, anchor_box[3] - 22), "silhouette_ledger_coat", "palette_copper_blue", show_bust=True, hair_index=2, skin_index=3)
    accent_color = TOKENS.color("color.emberCopper.500")
    draw.ellipse((anchor_box[0] + 196, anchor_box[1] + 92, anchor_box[0] + 246, anchor_box[1] + 142), outline=rgba(accent_color), width=6)
    draw.line([(anchor_box[0] + 246, anchor_box[1] + 116), (anchor_box[0] + 332, anchor_box[1] + 84)], fill=rgba(accent_color), width=5)
    draw.text((anchor_box[0] + 350, anchor_box[1] + 70), "Accessory anchor zone", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Keep the slot near collar, shoulder, satchel, or wrap seams so one token accessory reads cleanly in onboarding and Hearth.", (anchor_box[0] + 350, anchor_box[1] + 106), font("body", 21), TOKENS.color("color.text.secondary"), anchor_box[2] - anchor_box[0] - 380, line_gap=6)
    return image


def render_board_03() -> Image.Image:
    image = background_shell()
    meta = BoardMeta(
        filename="ART-06-03_palette-material-application-board.png",
        title="Palette And Material Logic",
        subtitle="One silhouette repeats across several launch palettes to prove cloth, trim, and neutral materials shift intentionally instead of becoming random recolors.",
        chip_label="ART-06-03",
    )
    board_header(image, meta, TOKENS.color("color.dawnGold.500"))
    x1, y1, x2, y2 = main_canvas(image)
    draw = ImageDraw.Draw(image)

    section_label(draw, "Application logic", "Warm cloth, readable trim, and controlled neutrals keep launch avatars premium-native instead of metallic or noisy.", (x1 + 40, y1 + 36), x2 - x1 - 80)
    palette_ids = ["palette_burnished_gold", "palette_moon_ink", "palette_ember_ochre", "palette_copper_blue"]
    silhouette_id = "silhouette_ledger_coat"
    card_w = 300
    gap = 26
    top = y1 + 170
    for index, palette_id in enumerate(palette_ids):
        left = x1 + 40 + index * (card_w + gap)
        box = (left, top, left + card_w, y2 - 430)
        panel(image, box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)
        draw_avatar_figure(image, (left + 24, top + 60, left + card_w - 24, y2 - 560), silhouette_id, palette_id, hair_index=index, skin_index=index)
        draw.text((left + 22, y2 - 528), humanize(palette_id), font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
        spec = PALETTE_SPECS[palette_id]
        swatch_y = y2 - 480
        for color_index, (label, color) in enumerate(spec.items()):
            sw_x = left + 24 + color_index * 82
            draw.rounded_rectangle((sw_x, swatch_y, sw_x + 58, swatch_y + 58), radius=16, fill=rgba(color))
            draw.text((sw_x, swatch_y + 70), label, font=font("body", 17), fill=rgba(TOKENS.color("color.text.secondary")))

    warning_box = (x1 + 40, y2 - 352, x2 - 40, y2 - 180)
    panel(image, warning_box, TOKENS.color("color.surface.cardSecondary"), None, radius=28, alpha=255)
    draw.text((warning_box[0] + 24, warning_box[1] + 20), "Combinations to avoid", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Avoid gold-on-gold metallic flooding, high-shine silver trim on parchment surfaces, and deep plum plus dark indigo pairings that collapse into one silhouette on phone screens.", (warning_box[0] + 24, warning_box[1] + 58), font("body", 22), TOKENS.color("color.text.secondary"), warning_box[2] - warning_box[0] - 48, line_gap=6)
    draw_small_chip(draw, "Too metallic", (warning_box[0] + 28, warning_box[3] - 68, warning_box[0] + 220, warning_box[3] - 22), TOKENS.color("color.emberCopper.300"), TOKENS.color("color.text.primary"))
    draw_small_chip(draw, "Value collapse", (warning_box[0] + 240, warning_box[3] - 68, warning_box[0] + 438, warning_box[3] - 22), TOKENS.color("color.ashPlum.300"), TOKENS.color("color.text.primary"))
    draw_small_chip(draw, "Keep trim restrained", (warning_box[0] + 458, warning_box[3] - 68, warning_box[0] + 718, warning_box[3] - 22), TOKENS.color("color.parchmentStone.200"), TOKENS.color("color.text.primary"))

    footer_box = (x1 + 40, y2 - 148, x2 - 40, y2 - 36)
    panel(image, footer_box, TOKENS.color("color.surface.cardSecondary"), None, radius=26, alpha=255)
    draw.text((footer_box[0] + 22, footer_box[1] + 18), "Material callout", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Cloth carries identity mood, trim signals care and craft, and neutral materials steady the silhouette. Premium breadth should feel richer, not gaudier.", (footer_box[0] + 196, footer_box[1] + 16), font("body", 20), TOKENS.color("color.text.secondary"), footer_box[2] - footer_box[0] - 220, line_gap=4)
    return image


def render_board_04() -> Image.Image:
    image = background_shell()
    meta = BoardMeta(
        filename="ART-06-04_onboarding-avatar-preview-board.png",
        title="Onboarding Avatar Preview",
        subtitle="Avatar setup stays one-screen and fast: a visual preview card, short text inputs, compact silhouette controls, palette swatches, and one light accessory note.",
        chip_label="ART-06-04",
    )
    board_header(image, meta, TOKENS.color("color.emberCopper.300"))
    x1, y1, x2, y2 = main_canvas(image)
    draw = ImageDraw.Draw(image)

    phone_box = (x1 + 160, y1 + 64, x2 - 160, y2 - 64)
    panel(image, phone_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=52, alpha=255)
    draw.text((phone_box[0] + 36, phone_box[1] + 34), "Shape your arrival", font=font("display", 42), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Keep this fast. One screen, one preview, and no long character creator detour.", (phone_box[0] + 36, phone_box[1] + 92), font("body", 24), TOKENS.color("color.text.secondary"), phone_box[2] - phone_box[0] - 72, line_gap=6)

    input_w = phone_box[2] - phone_box[0] - 72
    panel(image, (phone_box[0] + 36, phone_box[1] + 178, phone_box[0] + 36 + input_w, phone_box[1] + 258), TOKENS.color("color.surface.cardSecondary"), None, radius=24, alpha=255)
    draw.text((phone_box[0] + 58, phone_box[1] + 205), "Juniper Vale", font=font("body", 24), fill=rgba(TOKENS.color("color.text.primary")))
    panel(image, (phone_box[0] + 36, phone_box[1] + 274, phone_box[0] + 36 + input_w, phone_box[1] + 354), TOKENS.color("color.surface.cardSecondary"), None, radius=24, alpha=255)
    draw.text((phone_box[0] + 58, phone_box[1] + 302), "she / they", font=font("body", 24), fill=rgba(TOKENS.color("color.text.secondary")))

    preview_box = (phone_box[0] + 36, phone_box[1] + 388, phone_box[2] - 36, phone_box[1] + 1080)
    panel(image, preview_box, TOKENS.color("color.surface.cardSecondary"), None, radius=34, alpha=255)
    draw.text((preview_box[0] + 28, preview_box[1] + 22), "Arrival preview", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_avatar_figure(image, (preview_box[0] + 40, preview_box[1] + 90, preview_box[0] + 430, preview_box[1] + 600), "silhouette_oven_apron", "palette_ember_ochre", hair_index=2, skin_index=1, accent=TOKENS.color("color.border.focus"))
    draw.text((preview_box[0] + 500, preview_box[1] + 112), "Juniper Vale", font=font("display", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((preview_box[0] + 500, preview_box[1] + 164), "Baker", font=font("accent", 24), fill=rgba(TOKENS.color("color.emberCopper.700")))
    draw_text_block(draw, "The preview proves the silhouette and palette immediately, while the copy stays plain-language and quick to scan.", (preview_box[0] + 500, preview_box[1] + 206), font("body", 22), TOKENS.color("color.text.secondary"), preview_box[2] - preview_box[0] - 532, line_gap=6)
    draw_small_chip(draw, "Flour Wrap", (preview_box[0] + 500, preview_box[1] + 332, preview_box[0] + 690, preview_box[1] + 378), TOKENS.color("color.parchmentStone.200"), TOKENS.color("color.text.primary"))
    draw_small_chip(draw, "Fast setup", (preview_box[0] + 704, preview_box[1] + 332, preview_box[0] + 876, preview_box[1] + 378), TOKENS.color("color.mossGreen.300"), TOKENS.color("color.text.primary"))

    silhouette_row_y = preview_box[1] + 662
    draw.text((preview_box[0] + 28, silhouette_row_y), "Silhouette", font=font("accent", 23), fill=rgba(TOKENS.color("color.text.primary")))
    silhouette_ids = ["silhouette_field_apron", "silhouette_oven_apron", "silhouette_counter_vest"]
    for index, silhouette_id in enumerate(silhouette_ids):
        chip_box = (preview_box[0] + 28 + index * 274, silhouette_row_y + 34, preview_box[0] + 268 + index * 274, silhouette_row_y + 192)
        is_selected = silhouette_id == "silhouette_oven_apron"
        panel(image, chip_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.focus") if is_selected else TOKENS.color("color.border.default"), radius=26, alpha=255)
        draw_avatar_figure(image, (chip_box[0] + 12, chip_box[1] + 12, chip_box[0] + 108, chip_box[1] + 116), silhouette_id, "palette_ember_ochre", show_bust=True, hair_index=index, skin_index=1)
        draw_text_block(draw, humanize(silhouette_id), (chip_box[0] + 116, chip_box[1] + 30), font("body", 18), TOKENS.color("color.text.secondary"), chip_box[2] - chip_box[0] - 132, line_gap=4)

    palette_row_y = preview_box[1] + 900
    draw.text((preview_box[0] + 28, palette_row_y), "Palette", font=font("accent", 23), fill=rgba(TOKENS.color("color.text.primary")))
    palette_ids = ["palette_harvest_green", "palette_ember_ochre", "palette_roasted_clay"]
    for index, palette_id in enumerate(palette_ids):
        spec = PALETTE_SPECS[palette_id]
        start_x = preview_box[0] + 28 + index * 250
        card = (start_x, palette_row_y + 34, start_x + 214, palette_row_y + 162)
        panel(image, card, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.focus") if palette_id == "palette_ember_ochre" else TOKENS.color("color.border.default"), radius=24, alpha=255)
        for color_index, color in enumerate(spec.values()):
            sw_x = start_x + 22 + color_index * 58
            draw.rounded_rectangle((sw_x, palette_row_y + 58, sw_x + 42, palette_row_y + 100), radius=12, fill=rgba(color))
        draw_text_block(draw, humanize(palette_id), (start_x + 22, palette_row_y + 108), font("body", 18), TOKENS.color("color.text.secondary"), 170, line_gap=4)

    footer_box = (phone_box[0] + 36, phone_box[3] - 110, phone_box[2] - 36, phone_box[3] - 38)
    panel(image, footer_box, TOKENS.color("color.action.primaryFill"), None, radius=24, alpha=255)
    button_text = "Next"
    tw = draw.textlength(button_text, font=font("accent", 26))
    draw.text(((footer_box[0] + footer_box[2] - tw) / 2, footer_box[1] + 18), button_text, font=font("accent", 26), fill=rgba(TOKENS.color("color.text.inverse")))
    return image


def render_board_05() -> Image.Image:
    image = background_shell()
    meta = BoardMeta(
        filename="ART-06-05_hearth-avatar-preview-board.png",
        title="Hearth Avatar Presence",
        subtitle="The Hearth surface becomes avatar plus home witness. The hero region carries name, identity, and restorative status without crowding the inventory rows below.",
        chip_label="ART-06-05",
    )
    board_header(image, meta, TOKENS.color("color.mossGreen.300"))
    x1, y1, x2, y2 = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_box = (x1 + 38, y1 + 38, x1 + 654, y2 - 38)
    right_box = (x1 + 688, y1 + 38, x2 - 38, y2 - 38)
    panel(image, left_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)
    panel(image, right_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=36, alpha=255)

    for box, title, summary, palette_id, applied_count in [
        (left_box, "Low-collection state", "A first proof of care has reached home.", "palette_ember_ochre", 0),
        (right_box, "More-settled state", "The bakery hearth is warm again, and earned props now stay visible here.", "palette_copper_blue", 3),
    ]:
        draw.text((box[0] + 28, box[1] + 24), title, font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
        hero = (box[0] + 26, box[1] + 72, box[2] - 26, box[1] + 430)
        panel(image, hero, TOKENS.color("color.surface.cardSecondary"), None, radius=30, alpha=255)
        draw_avatar_figure(image, (hero[0] + 24, hero[1] + 20, hero[0] + 244, hero[1] + 286), "silhouette_oven_apron" if applied_count == 0 else "silhouette_ledger_coat", palette_id, show_bust=False, hair_index=1 + applied_count, skin_index=1 + applied_count)
        draw.text((hero[0] + 276, hero[1] + 38), "Juniper Vale" if applied_count == 0 else "Cyrus Fen", font=font("display", 32), fill=rgba(TOKENS.color("color.text.primary")))
        draw.text((hero[0] + 276, hero[1] + 86), "Baker" if applied_count == 0 else "Merchant", font=font("accent", 22), fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw_text_block(draw, summary, (hero[0] + 276, hero[1] + 126), font("body", 21), TOKENS.color("color.text.secondary"), hero[2] - hero[0] - 308, line_gap=6)
        draw_small_chip(draw, "Gold on hand" if applied_count == 0 else "Chapter keepsakes", (hero[0] + 276, hero[1] + 244, hero[0] + 490, hero[1] + 290), TOKENS.color("color.parchmentStone.200"), TOKENS.color("color.text.primary"))

        section_top = box[1] + 454
        draw.text((box[0] + 28, section_top), "Already visible" if applied_count else "In your pack", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.primary")))
        for row in range(3):
            top = section_top + 42 + row * 150
            card = (box[0] + 28, top, box[2] - 28, top + 122)
            panel(image, card, TOKENS.color("color.surface.cardSecondary"), None, radius=24, alpha=255)
            label = "Place a prop or keepsake here to make progress visible at home." if applied_count == 0 and row == 0 else f"{'Lantern shelf' if row == 0 else 'Archive token' if row == 1 else 'Canal map'}"
            body = "Inventory rows stay intact below the hero avatar region." if applied_count == 0 and row == 0 else "Applied keepsake" if applied_count else "Stored item"
            draw.text((card[0] + 20, card[1] + 18), label, font=font("body", 21), fill=rgba(TOKENS.color("color.text.primary")))
            draw.text((card[0] + 20, card[1] + 54), body, font=font("body", 18), fill=rgba(TOKENS.color("color.text.secondary")))
            if applied_count:
                draw_small_chip(draw, "Visible", (card[2] - 136, card[1] + 18, card[2] - 18, card[1] + 58), TOKENS.color("color.mossGreen.300"), TOKENS.color("color.text.primary"))
            elif row == 0:
                draw_small_chip(draw, "Empty-state", (card[2] - 164, card[1] + 18, card[2] - 18, card[1] + 58), TOKENS.color("color.parchmentStone.200"), TOKENS.color("color.text.primary"))

    return image


def save_image(image: Image.Image, filename: str) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    image.save(OUT_DIR / filename)


def main() -> None:
    identity_seeds = load_identity_seeds()
    boards = [
        render_board_01(identity_seeds),
        render_board_02(),
        render_board_03(),
        render_board_04(),
        render_board_05(),
    ]
    for image, filename in zip(
        boards,
        [
            "ART-06-01_base-frame-silhouette-board.png",
            "ART-06-02_head-hair-skin-anchor-board.png",
            "ART-06-03_palette-material-application-board.png",
            "ART-06-04_onboarding-avatar-preview-board.png",
            "ART-06-05_hearth-avatar-preview-board.png",
        ],
    ):
        save_image(image, filename)


if __name__ == "__main__":
    main()
