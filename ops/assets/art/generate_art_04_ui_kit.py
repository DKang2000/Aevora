from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[3]
TOKENS_PATH = ROOT / "shared" / "tokens" / "aevora-v1-design-tokens.json"
OUT_DIR = ROOT / "assets" / "art" / "ui-kit"
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
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle((0, 0, x2 - x1, y2 - y1), radius=radius, fill=255)
    shadow(image, box, radius=radius, alpha=66)
    image.paste(panel_image, (x1, y1), mask)
    if outline:
        ImageDraw.Draw(image).rounded_rectangle(box, radius=radius, outline=rgba(outline), width=2)


def background_shell() -> Image.Image:
    image = gradient_image(
        WIDTH,
        HEIGHT,
        TOKENS.gradient("gradient.world.deep"),
    )
    add_glow(image, (WIDTH // 2, 220), 360, TOKENS.color("color.emberCopper.500"), 72)
    add_glow(image, (WIDTH - 180, 720), 240, TOKENS.color("color.dawnGold.300"), 54)
    add_glow(image, (220, HEIGHT - 340), 260, TOKENS.color("color.mossGreen.300"), 48)
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


def chip(draw: ImageDraw.ImageDraw, label: str, xy: tuple[int, int], fill: str, text_fill: str) -> int:
    ft = font("accent", 28)
    padding_x = 18
    width = int(draw.textlength(label, font=ft)) + padding_x * 2
    x, y = xy
    draw.rounded_rectangle((x, y, x + width, y + 48), radius=24, fill=rgba(fill))
    draw.text((x + padding_x, y + 8), label, font=ft, fill=rgba(text_fill))
    return width


def swatch(draw: ImageDraw.ImageDraw, label: str, color: str, xy: tuple[int, int]) -> None:
    x, y = xy
    draw.rounded_rectangle((x, y, x + 118, y + 118), radius=24, fill=rgba(color))
    draw.text((x, y + 132), label, font=font("body", 24), fill=rgba(TOKENS.color("color.text.primary")))


def add_glow(image: Image.Image, center: tuple[int, int], radius: int, color: str, alpha: int) -> None:
    layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x, y = center
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=rgba(color, alpha))
    layer = layer.filter(ImageFilter.GaussianBlur(radius // 2))
    image.alpha_composite(layer)


def board_header(image: Image.Image, meta: BoardMeta, chip_fill: str) -> None:
    draw = ImageDraw.Draw(image)
    chip(draw, meta.chip_label, (MARGIN, 74), chip_fill, TOKENS.color("color.text.inverse"))
    draw.text((MARGIN, 158), meta.title, font=font("display", 80), fill=rgba(TOKENS.color("color.text.inverse")))
    draw_text_block(
        draw,
        meta.subtitle,
        (MARGIN, 262),
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
        alpha=246,
    )
    return box


def section_label(draw: ImageDraw.ImageDraw, title: str, subtitle: str, xy: tuple[int, int], width: int) -> int:
    x, y = xy
    draw.text((x, y), title, font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    y = draw_text_block(
        draw,
        subtitle,
        (x, y + 44),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        width,
        line_gap=6,
    )
    return y


def draw_button(
    image: Image.Image,
    box: tuple[int, int, int, int],
    label: str,
    fill: str,
    text_fill: str,
    outline: str | None = None,
) -> None:
    radius = int(TOKENS.get("radius.md"))
    panel(image, box, fill, outline, radius=radius, alpha=255)
    draw = ImageDraw.Draw(image)
    ft = font("accent", 26)
    text_width = draw.textlength(label, font=ft)
    draw.text(
        ((box[0] + box[2] - text_width) / 2, box[1] + 18),
        label,
        font=ft,
        fill=rgba(text_fill),
    )


def draw_progress_bar(image: Image.Image, box: tuple[int, int, int, int], ratio: float, fill: str) -> None:
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle(box, radius=box[3] - box[1], fill=rgba(TOKENS.color("color.parchmentStone.200")))
    width = max(int((box[2] - box[0]) * ratio), box[3] - box[1])
    draw.rounded_rectangle((box[0], box[1], box[0] + width, box[3]), radius=box[3] - box[1], fill=rgba(fill))


def draw_headline_cluster(
    image: Image.Image,
    box: tuple[int, int, int, int],
    title: str,
    supporting: str,
    eyebrow: str | None = None,
    chapter_mode: bool = False,
) -> None:
    if chapter_mode:
        apply_gradient_panel(image, box, TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    else:
        panel(image, box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw = ImageDraw.Draw(image)
    x = box[0] + 28
    y = box[1] + 24
    if eyebrow:
        draw.text((x, y), eyebrow, font=font("accent", 24), fill=rgba(TOKENS.color("color.text.secondary")))
        y += 36
    draw.text((x, y), title, font=font("display", 44), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(
        draw,
        supporting,
        (x, y + 62),
        font("body", 24),
        TOKENS.color("color.text.secondary"),
        box[2] - box[0] - 56,
        line_gap=6,
    )


def draw_vow_card(
    image: Image.Image,
    box: tuple[int, int, int, int],
    title: str,
    meta: str,
    status: str,
    ratio: float,
    button_label: str,
    state: str,
) -> None:
    fill = TOKENS.color("color.surface.cardPrimary")
    outline = TOKENS.color("color.border.success") if state == "complete" else TOKENS.color("color.border.default")
    panel(image, box, fill, outline, radius=int(TOKENS.get("radius.lg")))
    draw = ImageDraw.Draw(image)
    x = box[0] + 26
    y = box[1] + 24
    draw.text((x, y), title, font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((x, y + 38), meta, font=font("body", 22), fill=rgba(TOKENS.color("color.text.secondary")))
    status_fill = TOKENS.color("color.text.success") if state == "complete" else TOKENS.color("color.text.secondary")
    draw.text((box[2] - 180, y + 8), status, font=font("body", 22), fill=rgba(status_fill))
    draw_progress_bar(
        image,
        (x, y + 88, box[2] - 26, y + 108),
        ratio,
        TOKENS.color("color.state.successFill") if state == "complete" else TOKENS.color("color.action.progress"),
    )
    if state == "complete":
        draw.text((x, y + 120), "Kept today • calm confirmation", font=font("body", 21), fill=rgba(TOKENS.color("color.text.success")))
    else:
        draw.text((x, y + 120), "Last kept: yesterday • partial progress", font=font("body", 21), fill=rgba(TOKENS.color("color.text.secondary")))
    if state == "disabled":
        draw_button(
            image,
            (x, box[3] - 74, box[2] - 26, box[3] - 22),
            button_label,
            TOKENS.color("color.surface.disabled"),
            TOKENS.color("color.text.secondary"),
            TOKENS.color("color.border.default"),
        )
    else:
        draw_button(
            image,
            (x, box[3] - 74, box[2] - 26, box[3] - 22),
            button_label,
            TOKENS.color("color.action.primaryFill"),
            TOKENS.color("color.action.primaryText"),
        )


def draw_stat_chip(image: Image.Image, box: tuple[int, int, int, int], title: str, value: str) -> None:
    panel(image, box, TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.subtle"), radius=int(TOKENS.get("radius.sm")))
    draw = ImageDraw.Draw(image)
    draw.text((box[0] + 22, box[1] + 16), value, font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((box[0] + 22, box[1] + 52), title, font=font("body", 20), fill=rgba(TOKENS.color("color.text.secondary")))


def draw_small_callout(image: Image.Image, box: tuple[int, int, int, int], title: str, lines: Iterable[str]) -> None:
    panel(image, box, TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.md")))
    draw = ImageDraw.Draw(image)
    draw.text((box[0] + 20, box[1] + 18), title, font=font("accent", 26), fill=rgba(TOKENS.color("color.text.primary")))
    y = box[1] + 56
    for line in lines:
        y = draw_text_block(draw, line, (box[0] + 20, y), font("body", 20), TOKENS.color("color.text.secondary"), box[2] - box[0] - 40, line_gap=4) + 6


def draw_core_chrome_board() -> None:
    meta = BoardMeta(
        "ART-04-01_core-chrome-board.png",
        "Core Chrome Board",
        "Headline clusters, eyebrow rhythm, button family, bottom-sheet shells, and token callouts grounded in ART-03.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.700"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left = (canvas[0] + 40, canvas[1] + 40, canvas[0] + 660, canvas[3] - 40)
    right = (canvas[0] + 700, canvas[1] + 40, canvas[2] - 40, canvas[3] - 40)

    section_label(draw, "Headline cluster", "Large rounded type, quiet metadata, and one visual priority per surface.", (left[0], left[1]), left[2] - left[0])
    draw_headline_cluster(image, (left[0], left[1] + 102, left[2], left[1] + 286), "Today's vows", "Day 3 of 7 in Rekindling Ember Quay", chapter_mode=False)
    draw_headline_cluster(image, (left[0], left[1] + 320, left[2], left[1] + 556), "Starter arc in motion", "Chapter-aware variant with warmth held behind real hierarchy.", eyebrow="Current chapter", chapter_mode=True)

    section_label(draw, "Button family", "Primary warmth, bordered secondary actions, quiet text actions, and clear destructive states.", (left[0], left[1] + 612), left[2] - left[0])
    button_y = left[1] + 710
    draw_button(image, (left[0], button_y, left[2], button_y + 64), "Primary CTA", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))
    draw_button(image, (left[0], button_y + 86, left[2], button_y + 150), "Secondary CTA", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))
    draw_button(image, (left[0], button_y + 172, left[2], button_y + 236), "Quiet text action", TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.text.secondary"), TOKENS.color("color.border.subtle"))
    draw_button(image, (left[0], button_y + 258, left[2], button_y + 322), "Destructive CTA", TOKENS.color("color.signalRed.500"), TOKENS.color("color.text.inverse"))
    draw_button(image, (left[0], button_y + 344, left[2], button_y + 408), "Disabled CTA", TOKENS.color("color.surface.disabled"), TOKENS.color("color.text.secondary"), TOKENS.color("color.border.default"))

    section_label(draw, "Bottom-sheet shells", "Reward, progress, paywall, and support-sheet containers stay airy and premium-native.", (right[0], right[1]), right[2] - right[0])
    apply_gradient_panel(image, (right[0], right[1] + 102, right[2], right[1] + 356), TOKENS.gradient("gradient.reward.warm"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((right[0] + 28, right[1] + 128), "Reward sheet", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Warm halo kept behind readable copy and one strong action.", (right[0] + 28, right[1] + 170), font("body", 24), TOKENS.color("color.text.primary"), right[2] - right[0] - 56)

    panel(image, (right[0], right[1] + 392, right[2], right[1] + 620), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right[0] + 28, right[1] + 420), "Progress sheet", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((right[0] + 28, right[1] + 468), "42 minutes", font=font("display", 46), fill=rgba(TOKENS.color("color.text.primary")))
    draw_button(image, (right[0] + 28, right[1] + 536, right[2] - 28, right[1] + 596), "Save progress", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    panel(image, (right[0], right[1] + 656, right[2], right[1] + 930), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right[0] + 28, right[1] + 686), "Token callouts", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    callouts = [
        "type.display.large",
        "radius.xl",
        "stroke.default",
        "elevation.card",
        "color.action.primaryFill",
        "gradient.reward.warm",
    ]
    y = right[1] + 736
    for callout in callouts:
        chip(draw, callout, (right[0] + 28, y), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.text.primary"))
        y += 56

    image.save(OUT_DIR / meta.filename)


def draw_today_components_board() -> None:
    meta = BoardMeta(
        "ART-04-02_today-components-board.png",
        "Today Components Board",
        "Chapter, reminder, return-surface, vow, stat, and district-transition components in the current launch inventory.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.dawnGold.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    x = canvas[0] + 40
    y = canvas[1] + 40
    section_label(draw, "Chapter card states", "Baseline, in-motion, and nearly-complete states use the same chapter material and progress token.", (x, y), 620)
    apply_gradient_panel(image, (x, y + 104, x + 620, y + 316), TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((x + 26, y + 130), "Current chapter", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((x + 26, y + 164), "Rekindling Ember Quay", font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Restore the quay by keeping morning vows visible and returning warmth to daily routines.", (x + 26, y + 208), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    draw_progress_bar(image, (x + 26, y + 266, x + 594, y + 286), 0.62, TOKENS.color("color.action.progress"))

    apply_gradient_panel(image, (x, y + 344, x + 620, y + 528), TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.focus"))
    draw.text((x + 26, y + 374), "Nearly complete", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((x + 26, y + 408), "One more kept vow before dusk", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw_progress_bar(image, (x + 26, y + 466, x + 594, y + 486), 0.9, TOKENS.color("color.action.progress"))

    draw_small_callout(image, (x, y + 560, x + 620, y + 724), "Reminder strip states", [
        "One item: single prompt with quick scan rhythm.",
        "Multi-item: stacked reminders using color.surface.cardSecondary.",
        "Hidden: no empty chrome when there is nothing to remind.",
    ])

    right_x = x + 660
    section_label(draw, "Return surfaces + vow states", "Notification, HealthKit, and witness-surface education stay secondary to the vow list.", (right_x, y), 620)
    panel(image, (right_x, y + 104, right_x + 620, y + 286), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.md")))
    draw.text((right_x + 26, y + 130), "Return surfaces", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Notification education + premium witness messaging variants live here without crowding Today.", (right_x + 26, y + 170), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    chip(draw, "free", (right_x + 26, y + 236), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.text.primary"))
    chip(draw, "premium-active", (right_x + 150, y + 236), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.text.primary"))

    draw_vow_card(image, (right_x, y + 320, right_x + 620, y + 544), "Morning walk", "binary vow • 1 circuit", "Idle", 0.18, "Completed", "idle")
    draw_vow_card(image, (right_x, y + 570, right_x + 620, y + 794), "Journal pages", "count vow • 3 pages", "In progress", 0.66, "Log progress", "progress")
    draw_vow_card(image, (right_x, y + 820, right_x + 620, y + 1044), "Stretch at dusk", "duration vow • 15 min", "Complete", 1.0, "Completed", "complete")
    draw_vow_card(image, (right_x, y + 1070, right_x + 620, y + 1294), "Tea reset", "binary vow • 1 ritual", "Disabled", 1.0, "Completed", "disabled")

    stats_y = canvas[3] - 340
    draw.text((x, stats_y - 42), "Stat row + district CTA", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
    draw_stat_chip(image, (x, stats_y, x + 140, stats_y + 104), "Chains", "5")
    draw_stat_chip(image, (x + 156, stats_y, x + 296, stats_y + 104), "Embers", "2")
    draw_stat_chip(image, (x + 312, stats_y, x + 452, stats_y + 104), "Gold", "180")
    draw_stat_chip(image, (x + 468, stats_y, x + 608, stats_y + 104), "Rank", "7")
    panel(image, (right_x, stats_y - 10, right_x + 620, stats_y + 140), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((right_x + 24, stats_y + 16), "See the district respond", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Transition CTA with keepsake note and tomorrow prompt support copy.", (right_x + 24, stats_y + 56), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    image.save(OUT_DIR / meta.filename)


def draw_modal_sheet_board() -> None:
    meta = BoardMeta(
        "ART-04-03_modal-sheet-board.png",
        "Modal + Sheet Board",
        "Reward, journal, progress, and paywall shells using the token system without turning into a cluttered card stack.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_x = canvas[0] + 40
    right_x = canvas[0] + 740
    y = canvas[1] + 56

    section_label(draw, "Reward modals", "Two states: level-up warmth and simple success with calmer emphasis.", (left_x, y), 620)
    apply_gradient_panel(image, (left_x, y + 104, left_x + 620, y + 364), TOKENS.gradient("gradient.reward.warm"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((left_x + 28, y + 132), "Level up", font=font("display", 48), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Rank 7 unlocked. Witness warmth and one keepsake slot expanded.", (left_x + 28, y + 196), font("body", 24), TOKENS.color("color.text.primary"), 560)
    draw_button(image, (left_x + 28, y + 286, left_x + 592, y + 346), "See the district respond", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    panel(image, (left_x, y + 396, left_x + 620, y + 640), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((left_x + 28, y + 426), "Simple success", font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Calmer reward state for one kept vow and a single item line.", (left_x + 28, y + 474), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    draw_button(image, (left_x + 28, y + 560, left_x + 592, y + 620), "Back to Today", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    section_label(draw, "Journal, progress, and paywall sheets", "Detent-safe layouts with readable copy and one clear primary action.", (right_x, y), 620)
    panel(image, (right_x, y + 104, right_x + 620, y + 358), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right_x + 28, y + 132), "Quest journal", font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Day 3 • The quay remembers effort. A short narrative block sits above the scroll region.", (right_x + 28, y + 180), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    panel(image, (right_x + 28, y + 246, right_x + 592, y + 330), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.subtle"), radius=int(TOKENS.get("radius.md")))

    panel(image, (right_x, y + 392, right_x + 620, y + 592), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right_x + 28, y + 420), "Progress sheet", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((right_x + 28, y + 466), "42", font=font("display", 54), fill=rgba(TOKENS.color("color.text.primary")))
    draw_button(image, (right_x + 28, y + 520, right_x + 592, y + 576), "Save progress", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    panel(image, (right_x, y + 626, right_x + 620, y + 980), TOKENS.color("color.surface.cardElevated"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    draw.text((right_x + 28, y + 656), "Soft paywall preview", font=font("accent", 34), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Premium expands breadth: Chapter One access, witness surfaces, and HealthKit verification.", (right_x + 28, y + 704), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    draw_button(image, (right_x + 28, y + 790, right_x + 592, y + 846), "Start free trial", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))
    draw_button(image, (right_x + 28, y + 862, right_x + 592, y + 918), "Restore purchase", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))

    image.save(OUT_DIR / meta.filename)


def draw_world_npc_shop_board() -> None:
    meta = BoardMeta(
        "ART-04-04_world-npc-shop-board.png",
        "World, NPC, + Shop Board",
        "District progression, witness cards, dialogue panels, and market surfaces aligned to the current World inventory.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.mossGreen.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    left_x = canvas[0] + 40
    right_x = canvas[0] + 738
    y = canvas[1] + 56

    section_label(draw, "District + witness cards", "Before, mid, and improved states stay secondary to the world scene instead of replacing it.", (left_x, y), 620)
    for index, label in enumerate(["Before repair", "Mid repair", "Visibly improved"]):
        top = y + 108 + index * 204
        panel(image, (left_x, top, left_x + 620, top + 176), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
        draw.text((left_x + 24, top + 22), label, font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
        draw_text_block(draw, "Stage title, mood, world-change note, repair progress, and problem summary.", (left_x + 24, top + 62), font("body", 21), TOKENS.color("color.text.secondary"), 560)
        draw_progress_bar(image, (left_x + 24, top + 126, left_x + 596, top + 144), [0.2, 0.56, 0.88][index], TOKENS.color("color.action.progress"))

    panel(image, (left_x, y + 740, left_x + 620, y + 936), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((left_x + 24, y + 766), "Walk the quay", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Promenade or witness card with one supporting line and subtle sigil accent.", (left_x + 24, y + 812), font("body", 22), TOKENS.color("color.text.secondary"), 560)
    chip(draw, "Anchor selected", (left_x + 24, y + 878), TOKENS.color("color.dawnGold.300"), TOKENS.color("color.text.primary"))

    section_label(draw, "NPC dialogue + shop states", "Narrative and transactional panels feel related without becoming identical.", (right_x, y), 620)
    panel(image, (right_x, y + 108, right_x + 620, y + 430), TOKENS.color("color.surface.darkShell"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.xl")))
    panel(image, (right_x + 24, y + 166, right_x + 596, y + 406), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.subtle"), radius=int(TOKENS.get("radius.lg")))
    draw.ellipse((right_x + 48, y + 128, right_x + 144, y + 224), fill=rgba(TOKENS.color("color.emberCopper.300")))
    draw.text((right_x + 170, y + 146), "Maerin Vale", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.inverse")))
    draw.text((right_x + 170, y + 184), "restoration reaction", font=font("body", 21), fill=rgba(TOKENS.color("color.parchmentStone.100")))
    draw_text_block(draw, "The quay feels steadier. Keep the next vow visible and the warded path will hold.", (right_x + 52, y + 238), font("body", 21), TOKENS.color("color.text.primary"), 520)
    draw_button(image, (right_x + 52, y + 338, right_x + 570, y + 392), "Back to district", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))

    for index, label in enumerate(["Affordable", "Owned", "Featured"]):
        top = y + 470 + index * 182
        panel(image, (right_x, top, right_x + 620, top + 156), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
        draw.text((right_x + 24, top + 22), f"{label} item tile", font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
        draw_text_block(draw, "Item name, bucket, rarity, price, and purchase or owned state.", (right_x + 24, top + 62), font("body", 21), TOKENS.color("color.text.secondary"), 560)
        if label == "Affordable":
            draw_button(image, (right_x + 380, top + 96, right_x + 592, top + 140), "Buy with Gold", TOKENS.color("color.action.primaryFill"), TOKENS.color("color.action.primaryText"))
        elif label == "Owned":
            chip(draw, "Owned", (right_x + 462, top + 96), TOKENS.color("color.mossGreen.300"), TOKENS.color("color.text.primary"))
        else:
            chip(draw, "Featured", (right_x + 442, top + 96), TOKENS.color("color.dawnGold.300"), TOKENS.color("color.text.primary"))

    image.save(OUT_DIR / meta.filename)


def draw_hearth_inventory_board() -> None:
    meta = BoardMeta(
        "ART-04-05_hearth-inventory-board.png",
        "Hearth + Inventory Board",
        "Warm summary panels, item-card states, and calm empty states that keep Hearth premium instead of placeholder.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.emberCopper.700"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)

    x = canvas[0] + 40
    y = canvas[1] + 56
    section_label(draw, "Hearth summary + item states", "Stored, applied, locked, and empty-state inventory surfaces grounded in the current Hearth inventory.", (x, y), 1340)

    panel(image, (x, y + 108, x + 1350, y + 320), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((x + 26, y + 136), "Hearth summary panel", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Home warmth, gold on hand, and chapter-closure notice live together without turning into a grid.", (x + 26, y + 184), font("body", 22), TOKENS.color("color.text.secondary"), 1280)

    cards = [
        ("Stored keepsake", "Place in Hearth", TOKENS.color("color.surface.cardElevated")),
        ("Applied keepsake", "Return to inventory", TOKENS.color("color.surface.cardElevated")),
        ("Locked keepsake", "Unlock later in Chapter One", TOKENS.color("color.surface.disabled")),
    ]
    card_y = y + 366
    for index, (title, cta, fill) in enumerate(cards):
        left = x + index * 452
        panel(image, (left, card_y, left + 410, card_y + 304), fill, TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.sm")))
        draw.text((left + 22, card_y + 22), title, font=font("accent", 28), fill=rgba(TOKENS.color("color.text.primary")))
        draw_text_block(draw, "Item name, summary, bucket, rarity, and action are all visible at a glance.", (left + 22, card_y + 66), font("body", 20), TOKENS.color("color.text.secondary"), 366)
        button_fill = TOKENS.color("color.action.primaryFill") if index < 2 else TOKENS.color("color.surface.disabled")
        button_text = TOKENS.color("color.action.primaryText") if index < 2 else TOKENS.color("color.text.secondary")
        draw_button(image, (left + 22, card_y + 236, left + 388, card_y + 286), cta, button_fill, button_text, TOKENS.color("color.border.default") if index == 2 else None)

    panel(image, (x, y + 710, x + 1350, y + 942), TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((x + 26, y + 738), "Calm premium empty state", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Room for a future keepsake visual, warm domestic grounding, and no cold placeholder-box feeling.", (x + 26, y + 786), font("body", 22), TOKENS.color("color.text.secondary"), 980)
    add_glow(image, (x + 1120, y + 834), 120, TOKENS.color("color.dawnGold.300"), 110)
    draw.rounded_rectangle((x + 1030, y + 754, x + 1224, y + 914), radius=32, fill=rgba(TOKENS.color("color.surface.cardElevated")))

    image.save(OUT_DIR / meta.filename)


def draw_tab_icons_board() -> None:
    meta = BoardMeta(
        "ART-04-06_tab-icons-board.png",
        "Tab Icons Board",
        "Silhouette-first tabs for Today, World, Hearth, Inventory, and Profile, with refined variants and a small-size read test.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.moonIndigo.500"))
    canvas = main_canvas(image)
    draw = ImageDraw.Draw(image)
    section_label(draw, "Primary silhouettes", "The first row establishes immediate reads. The second row adds refined trim without losing clarity.", (canvas[0] + 40, canvas[1] + 56), 1340)

    labels = ["Today", "World", "Hearth", "Inventory", "Profile"]
    centers = [canvas[0] + 160 + index * 250 for index in range(5)]

    def icon_shape(center_x: int, center_y: int, label: str, refined: bool) -> None:
        accent = TOKENS.color("color.emberCopper.500") if refined else TOKENS.color("color.parchmentStone.100")
        draw.ellipse((center_x - 82, center_y - 82, center_x + 82, center_y + 82), fill=rgba(TOKENS.color("color.surface.darkShell")))
        if label == "Today":
            draw.rounded_rectangle((center_x - 34, center_y - 38, center_x + 34, center_y + 44), radius=18, fill=rgba(accent))
            draw.rectangle((center_x - 24, center_y - 8, center_x + 24, center_y + 0), fill=rgba(TOKENS.color("color.surface.darkShell")))
        elif label == "World":
            draw.ellipse((center_x - 42, center_y - 42, center_x + 42, center_y + 42), outline=rgba(accent), width=10)
            draw.line([(center_x, center_y - 42), (center_x, center_y + 42)], fill=rgba(accent), width=8)
            draw.line([(center_x - 42, center_y), (center_x + 42, center_y)], fill=rgba(accent), width=8)
        elif label == "Hearth":
            draw.polygon([(center_x, center_y - 44), (center_x - 46, center_y - 2), (center_x - 46, center_y + 44), (center_x + 46, center_y + 44), (center_x + 46, center_y - 2)], fill=rgba(accent))
        elif label == "Inventory":
            draw.rounded_rectangle((center_x - 48, center_y - 22, center_x + 48, center_y + 42), radius=18, fill=rgba(accent))
            draw.arc((center_x - 30, center_y - 48, center_x + 30, center_y - 6), start=180, end=360, fill=rgba(accent), width=8)
        else:
            draw.ellipse((center_x - 30, center_y - 42, center_x + 30, center_y + 18), fill=rgba(accent))
            draw.rounded_rectangle((center_x - 46, center_y + 10, center_x + 46, center_y + 66), radius=20, fill=rgba(accent))
        if refined:
            draw.arc((center_x - 68, center_y - 68, center_x + 68, center_y + 68), start=18, end=152, fill=rgba(TOKENS.color("color.dawnGold.300")), width=6)

    for idx, label in enumerate(labels):
        icon_shape(centers[idx], canvas[1] + 268, label, False)
        draw.text((centers[idx] - 44, canvas[1] + 372), label, font=font("body", 22), fill=rgba(TOKENS.color("color.text.inverse")))
        icon_shape(centers[idx], canvas[1] + 612, label, True)
        draw.text((centers[idx] - 56, canvas[1] + 716), f"{label} refined", font=font("body", 20), fill=rgba(TOKENS.color("color.text.inverse")))

    panel(image, (canvas[0] + 40, canvas[1] + 840, canvas[2] - 40, canvas[1] + 1120), TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((canvas[0] + 64, canvas[1] + 872), "Icon read test at small size", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    for idx, label in enumerate(labels):
        center_x = canvas[0] + 130 + idx * 250
        center_y = canvas[1] + 992
        draw.ellipse((center_x - 28, center_y - 28, center_x + 28, center_y + 28), fill=rgba(TOKENS.color("color.surface.darkShell")))
        icon_shape(center_x, center_y, label, False)
        draw.text((center_x - 42, center_y + 52), label, font=font("body", 18), fill=rgba(TOKENS.color("color.text.primary")))

    image.save(OUT_DIR / meta.filename)


def draw_today_polished_pass() -> None:
    meta = BoardMeta(
        "ART-04-07_today-polished-pass.png",
        "Today Polished Pass",
        "A portrait Today composition proving the component kit works end-to-end, with close-up zones for chapter material and vow fidelity.",
        "Aevora ART-04",
    )
    image = background_shell()
    board_header(image, meta, TOKENS.color("color.dawnGold.500"))
    draw = ImageDraw.Draw(image)

    phone_box = (146, 430, 960, 2440)
    panel(image, phone_box, TOKENS.color("color.surface.app"), TOKENS.color("color.border.default"), radius=72)
    draw.rounded_rectangle((phone_box[0] + 286, phone_box[1] + 22, phone_box[0] + 528, phone_box[1] + 54), radius=16, fill=rgba(TOKENS.color("color.surface.disabled")))
    draw_headline_cluster(
        image,
        (phone_box[0] + 44, phone_box[1] + 94, phone_box[2] - 44, phone_box[1] + 258),
        "Today's vows",
        "Day 3 of 7 in Rekindling Ember Quay",
    )

    chapter_box = (phone_box[0] + 44, phone_box[1] + 286, phone_box[2] - 44, phone_box[1] + 534)
    apply_gradient_panel(image, chapter_box, TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((chapter_box[0] + 24, chapter_box[1] + 24), "Current chapter", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((chapter_box[0] + 24, chapter_box[1] + 56), "Rekindling Ember Quay", font=font("accent", 32), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((chapter_box[0] + 24, chapter_box[1] + 96), "Keep three vows visible before dusk to warm the warded lane.", font=font("body", 20), fill=rgba(TOKENS.color("color.text.secondary")))
    draw_progress_bar(image, (chapter_box[0] + 24, chapter_box[1] + 136, chapter_box[2] - 24, chapter_box[1] + 154), 0.72, TOKENS.color("color.action.progress"))
    draw_button(image, (chapter_box[0] + 24, chapter_box[1] + 176, chapter_box[2] - 24, chapter_box[1] + 232), "Open chapter journal", TOKENS.color("color.action.secondaryFill"), TOKENS.color("color.action.secondaryText"), TOKENS.color("color.border.default"))

    reminder_box = (phone_box[0] + 44, phone_box[1] + 560, phone_box[2] - 44, phone_box[1] + 706)
    panel(image, reminder_box, TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.md")))
    draw.text((reminder_box[0] + 24, reminder_box[1] + 22), "Steady today", font=font("accent", 22), fill=rgba(TOKENS.color("color.text.secondary")))
    draw.text((reminder_box[0] + 24, reminder_box[1] + 56), "Finish your morning walk before the quay gets loud.", font=font("body", 20), fill=rgba(TOKENS.color("color.text.primary")))
    draw.text((reminder_box[0] + 24, reminder_box[1] + 92), "Second reminder: brew tea before logging your midday pages.", font=font("body", 18), fill=rgba(TOKENS.color("color.text.secondary")))

    return_box = (phone_box[0] + 44, phone_box[1] + 732, phone_box[2] - 44, phone_box[1] + 912)
    panel(image, return_box, TOKENS.color("color.surface.cardSecondary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.md")))
    draw.text((return_box[0] + 24, return_box[1] + 22), "Return surfaces", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Notifications are ready. Premium witness surfaces go deeper, but the free path stays intact.", (return_box[0] + 24, return_box[1] + 56), font("body", 19), TOKENS.color("color.text.secondary"), 560)

    base_y = phone_box[1] + 940
    draw_vow_card(image, (phone_box[0] + 44, base_y, phone_box[2] - 44, base_y + 214), "Morning walk", "binary vow • 1 circuit", "Complete", 1.0, "Completed", "complete")
    draw_vow_card(image, (phone_box[0] + 44, base_y + 236, phone_box[2] - 44, base_y + 450), "Journal pages", "count vow • 3 pages", "In progress", 0.66, "Log progress", "progress")
    draw_vow_card(image, (phone_box[0] + 44, base_y + 472, phone_box[2] - 44, base_y + 686), "Stretch at dusk", "duration vow • 15 min", "Idle", 0.24, "Log progress", "idle")

    stat_y = phone_box[1] + 1662
    draw_stat_chip(image, (phone_box[0] + 44, stat_y, phone_box[0] + 208, stat_y + 94), "Chains", "5")
    draw_stat_chip(image, (phone_box[0] + 228, stat_y, phone_box[0] + 392, stat_y + 94), "Embers", "2")
    draw_stat_chip(image, (phone_box[0] + 412, stat_y, phone_box[0] + 576, stat_y + 94), "Gold", "180")
    draw_stat_chip(image, (phone_box[0] + 596, stat_y, phone_box[2] - 44, stat_y + 94), "Rank", "7")

    cta_box = (phone_box[0] + 44, phone_box[1] + 1780, phone_box[2] - 44, phone_box[1] + 1934)
    panel(image, cta_box, TOKENS.color("color.surface.cardPrimary"), TOKENS.color("color.border.default"), radius=int(TOKENS.get("radius.lg")))
    draw.text((cta_box[0] + 24, cta_box[1] + 22), "See the district respond", font=font("accent", 30), fill=rgba(TOKENS.color("color.text.primary")))
    draw_text_block(draw, "Latest keepsake: Ember Quay token. Tomorrow prompt stays tucked below the CTA.", (cta_box[0] + 24, cta_box[1] + 60), font("body", 20), TOKENS.color("color.text.secondary"), 560)

    add_glow(image, (phone_box[2] - 120, base_y + 92), 70, TOKENS.color("color.mossGreen.300"), 120)

    draw_small_callout(image, (1010, 656, 1410, 1094), "Close-up A • chapter material fidelity", [
        "Uses gradient.chapter.primary.",
        "Progress bar uses color.action.progress.",
        "Rounded shell follows radius.xl.",
    ])
    apply_gradient_panel(image, (1040, 786, 1380, 1010), TOKENS.gradient("gradient.chapter.primary"), radius=int(TOKENS.get("radius.xl")), outline=TOKENS.color("color.border.default"))
    draw.text((1062, 812), "Rekindling Ember Quay", font=font("accent", 24), fill=rgba(TOKENS.color("color.text.primary")))
    draw_progress_bar(image, (1062, 914, 1358, 930), 0.72, TOKENS.color("color.action.progress"))

    draw_small_callout(image, (1010, 1140, 1410, 1648), "Close-up B • vow + button + completion fidelity", [
        "Vow shell uses color.surface.cardPrimary.",
        "Completion uses color.state.successFill.",
        "Primary button uses color.action.primaryFill.",
    ])
    draw_vow_card(image, (1040, 1280, 1380, 1584), "Morning walk", "binary vow • 1 circuit", "Complete", 1.0, "Completed", "complete")

    draw_small_callout(image, (1010, 1702, 1410, 2134), "QA lock", [
        "No fake generated app text.",
        "Portrait-first density preserved.",
        "Success state remains calm, not neon.",
    ])

    image.save(OUT_DIR / meta.filename)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    draw_core_chrome_board()
    draw_today_components_board()
    draw_modal_sheet_board()
    draw_world_npc_shop_board()
    draw_hearth_inventory_board()
    draw_tab_icons_board()
    draw_today_polished_pass()


if __name__ == "__main__":
    main()
