from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[3]
TOKENS_PATH = ROOT / "shared" / "tokens" / "aevora-v1-design-tokens.json"
OUT_DIR = ROOT / "assets" / "art" / "onboarding-kit"
WIDTH = 1536
HEIGHT = 2732
MARGIN = 88

FONT_PATHS = {
    "display": "/System/Library/Fonts/NewYork.ttf",
    "body": "/System/Library/Fonts/HelveticaNeue.ttc",
    "accent": "/System/Library/Fonts/SFNSRounded.ttf",
}


@dataclass
class BoardMeta:
    filename: str
    title: str
    subtitle: str
    chip_label: str


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


def apply_gradient_panel(
    image: Image.Image,
    box: tuple[int, int, int, int],
    colors: list[str],
    radius: int,
    outline: str | None = None,
) -> None:
    x1, y1, x2, y2 = box
    panel_image = gradient_image(x2 - x1, y2 - y1, colors)
    mask = Image.new("L", (x2 - x1, y2 - y1), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, x2 - x1, y2 - y1), radius=radius, fill=255)
    shadow(image, box, radius=radius, alpha=66)
    image.paste(panel_image, (x1, y1), mask)
    if outline:
        ImageDraw.Draw(image).rounded_rectangle(box, radius=radius, outline=rgba(outline), width=2)


def add_glow(image: Image.Image, center: tuple[int, int], radius: int, color: str, alpha: int) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x, y = center
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=rgba(color, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(radius // 2))
    image.alpha_composite(layer)


def background_shell() -> Image.Image:
    image = gradient_image(WIDTH, HEIGHT, TOKENS.gradient("gradient.world.deep"))
    add_glow(image, (WIDTH // 2, 220), 340, TOKENS.color("color.emberCopper.500"), 74)
    add_glow(image, (WIDTH - 220, 660), 220, TOKENS.color("color.dawnGold.300"), 60)
    add_glow(image, (250, HEIGHT - 260), 260, TOKENS.color("color.mossGreen.300"), 42)
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


def draw_button(
    image: Image.Image,
    box: tuple[int, int, int, int],
    label: str,
    fill: str,
    text_fill: str,
    outline: str | None = None,
) -> None:
    panel(image, box, fill, outline, radius=int(TOKENS.get("radius.md")), alpha=255)
    draw = ImageDraw.Draw(image)
    ft = font("accent", 26)
    text_width = draw.textlength(label, font=ft)
    draw.text(
        ((box[0] + box[2] - text_width) / 2, box[1] + 18),
        label,
        font=ft,
        fill=rgba(text_fill),
    )


def draw_card(
    image: Image.Image,
    box: tuple[int, int, int, int],
    title: str,
    body: str,
    eyebrow: str | None = None,
    fill: str | None = None,
    outline: str | None = None,
    title_fill: str | None = None,
) -> None:
    fill = fill or TOKENS.color("color.surface.cardPrimary")
    outline = outline or TOKENS.color("color.border.default")
    title_fill = title_fill or TOKENS.color("color.text.primary")
    panel(image, box, fill, outline, radius=int(TOKENS.get("radius.lg")))
    draw = ImageDraw.Draw(image)
    x = box[0] + 24
    y = box[1] + 22
    if eyebrow:
        draw.text((x, y), eyebrow, font=font("body", 20), fill=rgba(TOKENS.color("color.text.secondary")))
        y += 32
    draw.text((x, y), title, font=font("accent", 30), fill=rgba(title_fill))
    draw_text_block(
        draw,
        body,
        (x, y + 44),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        box[2] - box[0] - 48,
        line_gap=5,
    )


def draw_selection_visual(
    image: Image.Image,
    art_box: tuple[int, int, int, int],
    accent: str,
    key: str,
) -> None:
    panel(
        image,
        art_box,
        TOKENS.color("color.surface.cardSecondary"),
        TOKENS.color("color.border.subtle"),
        radius=26,
        alpha=255,
    )
    draw = ImageDraw.Draw(image)
    add_glow(
        image,
        ((art_box[0] + art_box[2]) // 2, (art_box[1] + art_box[3]) // 2),
        46,
        accent,
        50,
    )

    if key == "family_dawnbound":
        draw.polygon(
            [
                (art_box[0] + 38, art_box[1] + 42),
                (art_box[0] + 96, art_box[1] + 42),
                (art_box[0] + 112, art_box[1] + 72),
                (art_box[0] + 76, art_box[1] + 126),
                (art_box[0] + 24, art_box[1] + 78),
            ],
            fill=rgba(accent, 225),
        )
        draw.rectangle((art_box[0] + 124, art_box[1] + 26, art_box[0] + 132, art_box[1] + 132), fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.polygon(
            [
                (art_box[0] + 132, art_box[1] + 28),
                (art_box[0] + 168, art_box[1] + 42),
                (art_box[0] + 132, art_box[1] + 64),
            ],
            fill=rgba(TOKENS.color("color.dawnGold.300")),
        )
        draw.rounded_rectangle((art_box[0] + 58, art_box[1] + 126, art_box[0] + 94, art_box[1] + 174), radius=16, fill=rgba(TOKENS.color("color.emberCopper.700")))
    elif key == "family_archivist":
        draw.rounded_rectangle((art_box[0] + 24, art_box[1] + 54, art_box[0] + 92, art_box[1] + 140), radius=18, fill=rgba(TOKENS.color("color.moonIndigo.500")))
        draw.rounded_rectangle((art_box[0] + 94, art_box[1] + 70, art_box[0] + 142, art_box[1] + 114), radius=12, fill=rgba(accent, 230))
        draw.ellipse((art_box[0] + 126, art_box[1] + 40, art_box[0] + 164, art_box[1] + 78), outline=rgba(TOKENS.color("color.text.primary")), width=5)
        draw.line((art_box[0] + 152, art_box[1] + 68, art_box[0] + 174, art_box[1] + 94), fill=rgba(TOKENS.color("color.text.primary")), width=5)
        draw.line((art_box[0] + 34, art_box[1] + 152, art_box[0] + 140, art_box[1] + 152), fill=rgba(TOKENS.color("color.border.focus")), width=5)
    elif key == "family_hearthkeeper":
        draw.rounded_rectangle((art_box[0] + 42, art_box[1] + 36, art_box[0] + 118, art_box[1] + 150), radius=24, fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.rectangle((art_box[0] + 70, art_box[1] + 20, art_box[0] + 90, art_box[1] + 40), fill=rgba(TOKENS.color("color.parchmentStone.050")))
        draw.rectangle((art_box[0] + 132, art_box[1] + 36, art_box[0] + 142, art_box[1] + 150), fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.rounded_rectangle((art_box[0] + 132, art_box[1] + 26, art_box[0] + 176, art_box[1] + 52), radius=10, fill=rgba(accent, 230))
        draw.arc((art_box[0] + 26, art_box[1] + 12, art_box[0] + 60, art_box[1] + 56), start=240, end=340, fill=rgba(TOKENS.color("color.parchmentStone.050")), width=5)
        draw.arc((art_box[0] + 52, art_box[1] + 2, art_box[0] + 86, art_box[1] + 46), start=240, end=340, fill=rgba(TOKENS.color("color.parchmentStone.050")), width=5)
    elif key == "family_chartermaker":
        draw.rounded_rectangle((art_box[0] + 28, art_box[1] + 44, art_box[0] + 108, art_box[1] + 148), radius=18, fill=rgba(TOKENS.color("color.mossGreen.500")))
        draw.line((art_box[0] + 48, art_box[1] + 68, art_box[0] + 88, art_box[1] + 68), fill=rgba(TOKENS.color("color.parchmentStone.050")), width=4)
        draw.line((art_box[0] + 48, art_box[1] + 88, art_box[0] + 88, art_box[1] + 88), fill=rgba(TOKENS.color("color.parchmentStone.050")), width=4)
        draw.line((art_box[0] + 48, art_box[1] + 108, art_box[0] + 78, art_box[1] + 108), fill=rgba(TOKENS.color("color.parchmentStone.050")), width=4)
        draw.ellipse((art_box[0] + 122, art_box[1] + 58, art_box[0] + 170, art_box[1] + 106), fill=rgba(accent, 225))
        draw.rectangle((art_box[0] + 142, art_box[1] + 102, art_box[0] + 150, art_box[1] + 144), fill=rgba(TOKENS.color("color.emberCopper.700")))
    elif key == "identity_knight":
        draw.polygon(
            [
                (art_box[0] + 38, art_box[1] + 44),
                (art_box[0] + 86, art_box[1] + 44),
                (art_box[0] + 100, art_box[1] + 74),
                (art_box[0] + 70, art_box[1] + 126),
                (art_box[0] + 28, art_box[1] + 80),
            ],
            fill=rgba(accent, 225),
        )
        draw.rounded_rectangle((art_box[0] + 112, art_box[1] + 26, art_box[0] + 142, art_box[1] + 146), radius=14, fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.rectangle((art_box[0] + 146, art_box[1] + 28, art_box[0] + 154, art_box[1] + 140), fill=rgba(TOKENS.color("color.text.primary")))
    elif key == "identity_scholar":
        draw.rounded_rectangle((art_box[0] + 26, art_box[1] + 58, art_box[0] + 104, art_box[1] + 134), radius=18, fill=rgba(TOKENS.color("color.moonIndigo.500")))
        draw.rectangle((art_box[0] + 44, art_box[1] + 40, art_box[0] + 72, art_box[1] + 58), fill=rgba(accent, 225))
        draw.ellipse((art_box[0] + 122, art_box[1] + 38, art_box[0] + 154, art_box[1] + 70), outline=rgba(TOKENS.color("color.text.primary")), width=5)
        draw.line((art_box[0] + 146, art_box[1] + 66, art_box[0] + 170, art_box[1] + 92), fill=rgba(TOKENS.color("color.text.primary")), width=4)
        draw.rounded_rectangle((art_box[0] + 118, art_box[1] + 96, art_box[0] + 164, art_box[1] + 134), radius=10, fill=rgba(accent, 220))
    elif key == "identity_baker":
        draw.rounded_rectangle((art_box[0] + 42, art_box[1] + 28, art_box[0] + 118, art_box[1] + 146), radius=22, fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.rectangle((art_box[0] + 68, art_box[1] + 16, art_box[0] + 92, art_box[1] + 34), fill=rgba(TOKENS.color("color.parchmentStone.050")))
        draw.rectangle((art_box[0] + 128, art_box[1] + 38, art_box[0] + 138, art_box[1] + 144), fill=rgba(TOKENS.color("color.emberCopper.700")))
        draw.rounded_rectangle((art_box[0] + 138, art_box[1] + 30, art_box[0] + 176, art_box[1] + 52), radius=10, fill=rgba(accent, 220))
        draw.ellipse((art_box[0] + 134, art_box[1] + 88, art_box[0] + 172, art_box[1] + 118), fill=rgba(TOKENS.color("color.dawnGold.300")))
    elif key == "identity_merchant":
        draw.rounded_rectangle((art_box[0] + 36, art_box[1] + 36, art_box[0] + 114, art_box[1] + 150), radius=20, fill=rgba(TOKENS.color("color.mossGreen.500")))
        draw.line((art_box[0] + 62, art_box[1] + 54, art_box[0] + 62, art_box[1] + 138), fill=rgba(TOKENS.color("color.parchmentStone.050")), width=4)
        draw.line((art_box[0] + 86, art_box[1] + 54, art_box[0] + 86, art_box[1] + 138), fill=rgba(TOKENS.color("color.parchmentStone.050")), width=4)
        draw.rounded_rectangle((art_box[0] + 126, art_box[1] + 54, art_box[0] + 172, art_box[1] + 116), radius=10, fill=rgba(accent, 225))
        draw.ellipse((art_box[0] + 136, art_box[1] + 120, art_box[0] + 166, art_box[1] + 150), fill=rgba(TOKENS.color("color.emberCopper.700")))


def draw_selection_card(
    image: Image.Image,
    box: tuple[int, int, int, int],
    title: str,
    body: str,
    accent: str,
    visual_key: str,
    material_label: str,
    selected: bool = False,
) -> None:
    fill = TOKENS.color("color.surface.cardElevated") if selected else TOKENS.color("color.surface.cardPrimary")
    outline = TOKENS.color("color.border.focus") if selected else TOKENS.color("color.border.subtle")
    panel(image, box, fill, outline, radius=int(TOKENS.get("radius.lg")))
    draw = ImageDraw.Draw(image)

    art_box = (box[0] + 20, box[1] + 20, box[0] + 204, box[1] + 204)
    draw_selection_visual(image, art_box, accent, visual_key)
    draw.rounded_rectangle(
        (art_box[0], art_box[3] + 12, art_box[2], art_box[3] + 42),
        radius=14,
        fill=rgba(accent, 205),
    )
    draw.text((art_box[0] + 14, art_box[3] + 18), material_label, font=font("body", 18), fill=rgba(TOKENS.color("color.text.primary")))

    text_x = box[0] + 230
    text_y = box[1] + 28
    draw.text((text_x, text_y), title, font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        body,
        (text_x, text_y + 40),
        font("body", 20),
        TOKENS.color("color.text.secondary"),
        box[2] - text_x - 24,
        line_gap=4,
    )

    if selected:
        chip(
            draw,
            "Selected",
            (box[2] - 170, box[3] - 54),
            TOKENS.color("color.dawnGold.500"),
            TOKENS.color("color.text.primary"),
        )


def draw_progress_bar(image: Image.Image, box: tuple[int, int, int, int], ratio: float, fill: str) -> None:
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle(box, radius=box[3] - box[1], fill=rgba(TOKENS.color("color.parchmentStone.200")))
    width = max(int((box[2] - box[0]) * ratio), box[3] - box[1])
    draw.rounded_rectangle((box[0], box[1], box[0] + width, box[3]), radius=box[3] - box[1], fill=rgba(fill))


def draw_segmented_control(image: Image.Image, box: tuple[int, int, int, int], labels: list[str], selected_index: int) -> None:
    panel(image, box, TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.pill")))
    draw = ImageDraw.Draw(image)
    segment_width = (box[2] - box[0] - 16) // len(labels)
    for index, label in enumerate(labels):
        seg_box = (
            box[0] + 8 + index * segment_width,
            box[1] + 8,
            box[0] + 8 + (index + 1) * segment_width - 8,
            box[3] - 8,
        )
        if index == selected_index:
            panel(
                image,
                seg_box,
                TOKENS.color("color.surface.cardElevated"),
                TOKENS.color("color.border.focus"),
                radius=int(TOKENS.get("radius.pill")),
                alpha=255,
            )
        draw.text(
            (seg_box[0] + 32, seg_box[1] + 14),
            label,
            font=font("accent", 24),
            fill=rgba(TOKENS.color("color.text.primary")),
        )


def draw_scene_panel(image: Image.Image, box: tuple[int, int, int, int], title: str, subtitle: str) -> None:
    apply_gradient_panel(
        image,
        box,
        TOKENS.gradient("gradient.world.deep"),
        radius=int(TOKENS.get("radius.xl")),
        outline=TOKENS.color("color.border.default"),
    )
    add_glow(image, (box[0] + 180, box[1] + 220), 120, TOKENS.color("color.emberCopper.500"), 96)
    add_glow(image, (box[0] + 300, box[1] + 170), 70, TOKENS.color("color.dawnGold.300"), 108)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((box[0] + 56, box[1] + 184, box[0] + 190, box[1] + 316), radius=28, fill=rgba(TOKENS.color("color.emberCopper.700")))
    draw.rounded_rectangle((box[0] + 224, box[1] + 160, box[0] + 286, box[1] + 290), radius=22, fill=rgba(TOKENS.color("color.dawnGold.500")))
    draw.rounded_rectangle((box[0] + 324, box[1] + 188, box[0] + 580, box[1] + 270), radius=24, fill=rgba(TOKENS.color("color.moonIndigo.300"), 210))
    draw.text((box[0] + 34, box[1] + 28), title, font=font("accent", 30), fill=rgba(TOKENS.color("color.text.inverse")))
    draw_text_block(
        draw,
        subtitle,
        (box[0] + 34, box[1] + 72),
        font("body", 22),
        TOKENS.color("color.parchmentStone.100"),
        box[2] - box[0] - 68,
        line_gap=5,
    )


def draw_promise_board() -> None:
    meta = BoardMeta(
        "ART-05-01_promise-cards-board.png",
        "Promise Cards Board",
        "Hero promise, reassurance cards, and a low-pressure continue treatment that keeps trust ahead of friction.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.700"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    hero = (canvas[0] + 40, canvas[1] + 40, canvas[2] - 40, canvas[1] + 560)
    apply_gradient_panel(image, hero, TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    add_glow(image, (hero[2] - 190, hero[1] + 120), 120, TOKENS.color("color.emberCopper.300"), 64)
    draw.text((hero[0] + 34, hero[1] + 34), "Hero promise", font=font("body", 22), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((hero[0] + 34, hero[1] + 82), "Level up in Aevora as you level up in real life.", font=font("display", 48), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Keep a few meaningful vows, and Ember Quay begins to answer. The first flicker of change appears before any premium ask.",
        (hero[0] + 34, hero[1] + 162),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        hero[2] - hero[0] - 260,
        line_gap=6,
    )
    draw_button(
        image,
        (hero[0] + 34, hero[1] + 396, hero[0] + 520, hero[1] + 466),
        "Continue as guest",
        TOKENS.color("color.action.primaryFill"),
        TOKENS.color("color.action.primaryText"),
    )
    draw_button(
        image,
        (hero[0] + 548, hero[1] + 396, hero[0] + 984, hero[1] + 466),
        "Continue with Apple",
        TOKENS.color("color.surface.cardElevated"),
        TOKENS.color("color.text.primary"),
        TOKENS.color("color.border.default"),
    )

    section_label(draw, "Reassurance cards", "Three supporting beats keep the emotional promise clear without feeling like marketing copy pasted into a survey.", (canvas[0] + 40, canvas[1] + 610), canvas[2] - canvas[0] - 80)
    y = canvas[1] + 710
    draw_card(image, (canvas[0] + 40, y, canvas[0] + 446, y + 240), "Seen, not scored", "The city responds to cadence and small kept promises, not perfection.", "Reassurance")
    draw_card(image, (canvas[0] + 476, y, canvas[0] + 882, y + 240), "Small plans win", "Default to three believable vows and a humane first chapter beat.", "Starter plan")
    draw_card(image, (canvas[0] + 912, y, canvas[2] - 40, y + 240), "Free path stays visible", "The first magical moment lands before any premium framing and the free path stays obvious.", "Trust")

    panel(image, (canvas[0] + 40, canvas[3] - 330, canvas[2] - 40, canvas[3] - 40), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((canvas[0] + 68, canvas[3] - 292), "Execution note", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Onboarding opens with premium-native warmth and clear value. The call to continue stays touchable and calm, never louder than the promise itself.",
        (canvas[0] + 68, canvas[3] - 242),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        canvas[2] - canvas[0] - 140,
        line_gap=6,
    )

    image.save(OUT_DIR / meta.filename)


def draw_problem_solution_board() -> None:
    meta = BoardMeta(
        "ART-05-02_problem-solution-carousel-board.png",
        "Problem / Solution Carousel Board",
        "Three clear messages: dead trackers, humane recovery, and progress that visibly warms the district.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.dawnGold.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    section_label(draw, "Carousel rhythm", "Each card carries one message, one icon language, and enough negative space to read in a quick onboarding swipe.", (canvas[0] + 40, canvas[1] + 40), canvas[2] - canvas[0] - 80)
    y = canvas[1] + 150
    cards = [
        ("Boring trackers don't stick", "Rigid dashboards and stale checklists feel dead before the week is done.", TOKENS.color("color.ashPlum.300")),
        ("One bad day shouldn't erase you", "Cooling momentum stays recoverable. Missing a day does not erase identity.", TOKENS.color("color.mossGreen.300")),
        ("Progress should feel visible", "A kept vow relights a place, shifts witness copy, and makes the world warmer.", TOKENS.color("color.emberCopper.300")),
    ]
    for index, (title, body, accent) in enumerate(cards):
        x1 = canvas[0] + 40 + index * 436
        box = (x1, y, x1 + 396, y + 610)
        panel(image, box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
        add_glow(image, (box[0] + 198, box[1] + 178), 88, accent, 84)
        draw.rounded_rectangle((box[0] + 138, box[1] + 118, box[0] + 258, box[1] + 238), radius=32, fill=rgba(accent, 230))
        draw.text((box[0] + 28, box[1] + 294), title, font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
        draw_text_block(draw, body, (box[0] + 28, box[1] + 350), font("body", 22), TOKENS.color("color.text.secondary"), 340, line_gap=5)
        chip(draw, f"Card {index + 1}", (box[0] + 28, box[3] - 60), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.text.primary"))

    panel(image, (canvas[0] + 40, canvas[3] - 420, canvas[2] - 40, canvas[3] - 40), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((canvas[0] + 66, canvas[3] - 382), "Support direction", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "The icon language is intentionally small and supportive. The message lands through one strong title and one short supporting paragraph, not tiny explanatory text.",
        (canvas[0] + 66, canvas[3] - 330),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        canvas[2] - canvas[0] - 132,
        line_gap=6,
    )

    image.save(OUT_DIR / meta.filename)


def draw_goals_tone_board() -> None:
    meta = BoardMeta(
        "ART-05-03_goals-tone-utility-board.png",
        "Goals / Tone / Utility Board",
        "Question surfaces inherit Aevora warmth while preserving fast scan speed, tappability, and plain-language clarity.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_x = canvas[0] + 40
    right_x = canvas[0] + 760
    y = canvas[1] + 44

    section_label(draw, "Multi-select + single-choice", "Warm materials and clear borders make the answer surfaces feel premium-native instead of blank survey rows.", (left_x, y), 620)
    draw_card(image, (left_x, y + 104, left_x + 620, y + 230), "What do you want more of right now?", "Choose up to three goals that feel real this month.", "Goals")
    goal_boxes = [
        ("Consistency", True),
        ("Energy", True),
        ("Focus", False),
        ("Calm", True),
        ("Momentum", False),
        ("Balance", False),
    ]
    gy = y + 256
    for idx, (label, selected) in enumerate(goal_boxes):
        row = idx // 2
        col = idx % 2
        gx = left_x + col * 310
        box = (gx, gy + row * 116, gx + 280, gy + row * 116 + 92)
        fill = TOKENS.color("color.surface.cardElevated") if selected else TOKENS.color("color.surface.cardPrimary")
        outline = TOKENS.color("color.border.focus") if selected else TOKENS.color("color.border.subtle")
        panel(image, box, fill, outline, radius=int(TOKENS.get("radius.md")))
        draw.text((box[0] + 22, box[1] + 28), label, font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))

    draw_card(image, (left_x, y + 624, left_x + 620, y + 920), "What usually gets in your way?", "A single blocker answer stays plain and readable so setup never feels like paperwork.", "Blocker")
    blocker_rows = [
        ("I try to do too much", False),
        ("I feel all-or-nothing", True),
        ("My current tools feel dead", False),
    ]
    by = y + 742
    for idx, (label, selected) in enumerate(blocker_rows):
        box = (left_x + 26, by + idx * 62, left_x + 594, by + idx * 62 + 52)
        fill = TOKENS.color("color.surface.cardElevated") if selected else TOKENS.color("color.surface.cardSecondary")
        outline = TOKENS.color("color.border.focus") if selected else TOKENS.color("color.border.subtle")
        panel(image, box, fill, outline, radius=int(TOKENS.get("radius.sm")), alpha=255)
        draw.text((box[0] + 18, box[1] + 14), label, font=font("body", 20), fill=rgba(TOKENS.color("color.text.primary")))

    section_label(draw, "Daily load + tone + footer", "Segmented decisions stay obvious, and the footer CTA keeps momentum without ornamental noise.", (right_x, y), 620)
    draw_card(image, (right_x, y + 104, right_x + 620, y + 250), "How many daily vows can you realistically keep?", "Default to three unless the user explicitly wants more.", "Daily load")
    draw_segmented_control(image, (right_x + 26, y + 274, right_x + 594, y + 352), ["3", "5", "7"], 0)
    draw_card(image, (right_x, y + 392, right_x + 620, y + 700), "What tone do you want from Aevora?", "Tone shifts copy, reminder framing, and the emotional temperature of the first chapter.", "Tone")
    tone_rows = [
        ("Gentle", TOKENS.color("color.mossGreen.300"), False),
        ("Balanced", TOKENS.color("color.dawnGold.300"), True),
        ("Driven", TOKENS.color("color.emberCopper.300"), False),
    ]
    ty = y + 516
    for idx, (label, accent, selected) in enumerate(tone_rows):
        box = (right_x + 26, ty + idx * 58, right_x + 594, ty + idx * 58 + 48)
        fill = TOKENS.color("color.surface.cardElevated") if selected else TOKENS.color("color.surface.cardSecondary")
        outline = TOKENS.color("color.border.focus") if selected else TOKENS.color("color.border.subtle")
        panel(image, box, fill, outline, radius=int(TOKENS.get("radius.sm")), alpha=255)
        draw.rounded_rectangle((box[0] + 14, box[1] + 12, box[0] + 42, box[1] + 36), radius=12, fill=rgba(accent))
        draw.text((box[0] + 58, box[1] + 12), label, font=font("body", 20), fill=rgba(TOKENS.color("color.text.primary")))

    panel(image, (right_x, canvas[3] - 300, right_x + 620, canvas[3] - 40), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right_x + 28, canvas[3] - 262), "Footer CTA row", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Back stays secondary. Continue stays warm and clear. Setup still reads like a guided path, not a dense form.", (right_x + 28, canvas[3] - 214), font("body", 22), TOKENS.color("color.text.secondary"), 560, line_gap=5)
    draw_button(image, (right_x + 28, canvas[3] - 120, right_x + 250, canvas[3] - 56), "Back", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))
    draw_button(image, (right_x + 274, canvas[3] - 120, right_x + 592, canvas[3] - 56), "Continue", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    image.save(OUT_DIR / meta.filename)


def draw_family_selection_board() -> None:
    meta = BoardMeta(
        "ART-05-04_family-selection-board.png",
        "Family Selection Board",
        "Four origin families use silhouette, material, and prop accents to feel distinct while staying touch-friendly and utility-clear.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.dawnGold.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    section_label(draw, "Family card language", "Selection cards should feel premium-native first, with mythic civic flavor carried by shape, materials, and small prop blocks.", (canvas[0] + 40, canvas[1] + 40), canvas[2] - canvas[0] - 80)
    cards = [
        ("Dawnbound", "Civic warding, duty, bright standards, and defended streets.", TOKENS.color("color.dawnGold.500"), True),
        ("Archivist", "Lamps, ledgers, sigils, and patient memory work.", TOKENS.color("color.moonIndigo.300"), False),
        ("Hearthkeeper", "Warm tools, domestic craft, nourishment, and neighborhood steadiness.", TOKENS.color("color.emberCopper.300"), False),
        ("Chartermaker", "Contracts, seals, measured order, and mercantile stewardship.", TOKENS.color("color.mossGreen.300"), False),
    ]
    start_y = canvas[1] + 166
    for index, card in enumerate(cards):
        row = index // 2
        col = index % 2
        x1 = canvas[0] + 40 + col * 660
        y1 = start_y + row * 430
        title, body, accent, selected = card
        draw_selection_card(
            image,
            (x1, y1, x1 + 620, y1 + 360),
            title,
            body,
            accent,
            f"family_{title.lower()}",
            {
                "Dawnbound": "tabard + standard",
                "Archivist": "sigil + archive brass",
                "Hearthkeeper": "steam + warm timber",
                "Chartermaker": "seal + measured cloth",
            }[title],
            selected,
        )

    panel(image, (canvas[0] + 40, canvas[3] - 260, canvas[2] - 40, canvas[3] - 40), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((canvas[0] + 68, canvas[3] - 222), "Selection rule", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "The selected state relies on warmer border focus, lifted surface tone, and a compact selection chip. Civilian and scholarly families must carry as much charisma as martial ones.",
        (canvas[0] + 68, canvas[3] - 172),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        canvas[2] - canvas[0] - 136,
        line_gap=6,
    )

    image.save(OUT_DIR / meta.filename)


def draw_identity_selection_board() -> None:
    meta = BoardMeta(
        "ART-05-05_identity-selection-board.png",
        "Identity Selection Board",
        "Mixed-family identity cards stay silhouette-first, selected states stay obvious, and premium breadth is hinted without gating the free-path choice.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.700"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    section_label(draw, "Identity shell treatment", "Identity cards feel distinct through outer shape and props, not through tiny character-sheet detail or separate class-system implication.", (canvas[0] + 40, canvas[1] + 40), canvas[2] - canvas[0] - 80)
    identities = [
        ("Knight", "Shielded civic defender with strong silhouette mass.", TOKENS.color("color.dawnGold.500"), False),
        ("Scholar", "Satchel, lamp, and archive posture.", TOKENS.color("color.moonIndigo.300"), False),
        ("Baker", "Apron, paddle, and hearth warmth cues.", TOKENS.color("color.emberCopper.300"), True),
        ("Merchant", "Ledger, seal, and tailored market silhouette.", TOKENS.color("color.mossGreen.300"), False),
    ]
    y = canvas[1] + 166
    for index, card in enumerate(identities):
        x1 = canvas[0] + 40 + index % 2 * 660
        y1 = y + index // 2 * 360
        title, body, accent, selected = card
        draw_selection_card(
            image,
            (x1, y1, x1 + 620, y1 + 290),
            title,
            body,
            accent,
            f"identity_{title.lower()}",
            {
                "Knight": "shield + civic cloth",
                "Scholar": "lamp + archive paper",
                "Baker": "apron + bread warmth",
                "Merchant": "ledger + market seal",
            }[title],
            selected,
        )

    panel(image, (canvas[0] + 40, canvas[1] + 940, canvas[2] - 40, canvas[1] + 1260), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((canvas[0] + 68, canvas[1] + 978), "Premium-ready, not gated", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "The free path can choose any one launch identity. Premium breadth is framed as deeper switching and chapter expression later, not as a lock sitting on the initial identity grid.",
        (canvas[0] + 68, canvas[1] + 1028),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        canvas[2] - canvas[0] - 136,
        line_gap=6,
    )
    draw_button(
        image,
        (canvas[0] + 68, canvas[1] + 1166, canvas[0] + 410, canvas[1] + 1230),
        "Choose this path",
        TOKENS.color("color.action.primaryFill"),
        TOKENS.color("color.action.primaryText"),
    )
    draw_button(
        image,
        (canvas[0] + 438, canvas[1] + 1166, canvas[0] + 858, canvas[1] + 1230),
        "Switch identities later",
        TOKENS.color("color.action.secondaryFill"),
        TOKENS.color("color.action.secondaryText"),
        TOKENS.color("color.border.default"),
    )

    image.save(OUT_DIR / meta.filename)


def draw_starter_vow_board() -> None:
    meta = BoardMeta(
        "ART-05-06_starter-vow-and-quest-preview-board.png",
        "Starter Vow + Quest Preview Board",
        "A humane starter plan bridges onboarding answers into low-friction vows and a calm quest teaser without blocking setup.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.mossGreen.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_x = canvas[0] + 40
    right_x = canvas[0] + 760
    y = canvas[1] + 44

    section_label(draw, "Starter vow stack", "Recommendations stay small, believable, and editable. At least one vow should be low-friction and immediately achievable.", (left_x, y), 620)
    vow_cards = [
        ("Walk 10 minutes", "Physical • low-friction consistency cue", False),
        ("Read 10 pages", "Intellectual • steady focus without overload", False),
        ("Write one journal line", "Emotional • minimum viable consistency", True),
    ]
    for index, (title, body, highlight) in enumerate(vow_cards):
        box = (left_x, y + 110 + index * 202, left_x + 620, y + 278 + index * 202)
        fill = TOKENS.color("color.surface.cardElevated") if highlight else TOKENS.color("color.surface.cardPrimary")
        outline = TOKENS.color("color.border.focus") if highlight else TOKENS.color("color.border.default")
        panel(image, box, fill, outline, radius=int(TOKENS.get("radius.lg")))
        draw.text((box[0] + 24, box[1] + 24), title, font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
        draw.text((box[0] + 24, box[1] + 68), body, font=font("body", 20), fill=rgba(TOKENS.color("color.text.secondary")))
        draw_button(image, (box[2] - 176, box[1] + 92, box[2] - 24, box[1] + 144), "Replace", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))

    panel(image, (left_x, canvas[3] - 300, left_x + 620, canvas[3] - 40), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((left_x + 28, canvas[3] - 262), "Minimum viable consistency", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "The plan feels kind and plausible. Nothing reads like an aspirational overload deck or a dense self-optimization wizard.",
        (left_x + 28, canvas[3] - 214),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        560,
        line_gap=5,
    )

    section_label(draw, "Quest preview", "Quest framing reinforces witness and chapter motion without becoming a blocker between setup and the first kept vow.", (right_x, y), 620)
    apply_gradient_panel(image, (right_x, y + 110, right_x + 620, y + 360), TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((right_x + 28, y + 142), "Day 1 • Arrival in a dim quarter", font=font("body", 20), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((right_x + 28, y + 184), "The Ember That Returned", font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Keep one small vow today and Ember Quay answers. The quarter does not need perfection. It needs cadence.",
        (right_x + 28, y + 236),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        560,
        line_gap=5,
    )
    draw_progress_bar(image, (right_x + 28, y + 318, right_x + 592, y + 338), 0.18, TOKENS.color("color.action.progress"))

    draw_scene_panel(image, (right_x, y + 404, right_x + 620, y + 726), "Quest journal teaser", "A short witness summary and visible warmth cue connect the plan to the world without forcing a lore detour.")
    panel(image, (right_x, canvas[3] - 300, right_x + 620, canvas[3] - 40), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right_x + 28, canvas[3] - 262), "Flow note", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Quest preview remains inviting and secondary. The fastest path still leads to a believable first vow and the first magical moment.",
        (right_x + 28, canvas[3] - 214),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        560,
        line_gap=5,
    )

    image.save(OUT_DIR / meta.filename)


def draw_magical_moment_board() -> None:
    meta = BoardMeta(
        "ART-05-07_first-magical-moment-and-soft-paywall-board.png",
        "First Magical Moment + Soft Paywall Board",
        "The user sees world consequence and witness warmth before any premium invitation, and the free path stays plainly available.",
        "Aevora ART-05",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.700"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_x = canvas[0] + 40
    right_x = canvas[0] + 760
    y = canvas[1] + 44

    section_label(draw, "First magical moment", "A kept vow relights Ember Quay in the same session. Warm consequence is visible before any monetization framing appears.", (left_x, y), 620)
    draw_scene_panel(image, (left_x, y + 110, left_x + 620, y + 472), "Ember Quay rekindles", "A shuttered oven glows, a canal lantern steadies, and the district feels warmer in one beat.")
    panel(image, (left_x, y + 510, left_x + 620, y + 860), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((left_x + 28, y + 548), "Reward / witness beat", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((left_x + 28, y + 598), "Resonance +12", font=font("accent", 26), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((left_x + 28, y + 638), "Gold +8", font=font("accent", 26), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "\"The city remembers those who keep cadence.\" Reward copy stays readable and grounded in visible change.",
        (left_x + 28, y + 694),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        560,
        line_gap=5,
    )

    section_label(draw, "Soft paywall preview", "The offer follows the witness beat. It expands breadth and chapter depth while preserving an obvious free-path secondary action.", (right_x, y), 620)
    apply_gradient_panel(image, (right_x, y + 110, right_x + 620, y + 700), TOKENS.gradient("gradient.reward.warm"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((right_x + 28, y + 146), "Keep building your world", font=font("display", 40), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Unlock more active vows, the full chapter, deeper identity expression, and expanded witness surfaces. The offer stays invitational, never punitive.",
        (right_x + 28, y + 224),
        font("body", 23),
        TOKENS.color("color.text.primary"),
        560,
        line_gap=6,
    )
    draw_card(image, (right_x + 28, y + 374, right_x + 592, y + 502), "Free starter path remains", "7-day starter arc, 3 active vows, one launch identity, basic world witness.", "Free path", fill=TOKENS.color("color.surface.cardElevated"))
    draw_button(image, (right_x + 28, y + 560, right_x + 592, y + 628), "Start free trial", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))
    draw_button(image, (right_x + 28, y + 642, right_x + 592, y + 710), "Keep the free path", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))

    panel(image, (canvas[0] + 40, canvas[3] - 250, canvas[2] - 40, canvas[3] - 40), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((canvas[0] + 68, canvas[3] - 212), "Sequence rule", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        "Visible world response, then reward summary, then a dismissible premium invitation. The free path stays legible in the same glance.",
        (canvas[0] + 68, canvas[3] - 164),
        font("body", 22),
        TOKENS.color("color.text.secondary"),
        canvas[2] - canvas[0] - 136,
        line_gap=5,
    )

    image.save(OUT_DIR / meta.filename)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    draw_promise_board()
    draw_problem_solution_board()
    draw_goals_tone_board()
    draw_family_selection_board()
    draw_identity_selection_board()
    draw_starter_vow_board()
    draw_magical_moment_board()


if __name__ == "__main__":
    main()
