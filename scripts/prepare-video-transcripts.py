"""Convert yt-dlp WebVTT caption files into readable timestamped transcripts."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

TIMESTAMP = re.compile(r"^(?P<start>\d{2}:\d{2}:\d{2}\.\d{3})\s+-->")
TAG = re.compile(r"<[^>]+>")


def novel_caption_text(previous: str, current: str) -> str:
    """Return only words newly introduced by a rolling caption cue."""
    if not previous or current not in previous and previous not in current:
        previous_words = previous.split()
        current_words = current.split()
        for overlap in range(min(len(previous_words), len(current_words)), 1, -1):
            if previous_words[-overlap:] == current_words[:overlap]:
                return " ".join(current_words[overlap:])
        return current
    if current in previous:
        return ""
    return current[len(previous) :].strip()


def transcript_from_vtt(source: Path) -> str:
    lines = source.read_text(encoding="utf-8").splitlines()
    output = [f"# Transcript: {source.stem}", "", "Provenance: YouTube automatic English captions downloaded with yt-dlp.", "Timing is retained from the WebVTT captions; wording should be checked against the media for critical claims.", ""]
    previous = ""
    index = 0
    while index < len(lines):
        match = TIMESTAMP.match(lines[index])
        if not match:
            index += 1
            continue
        start = match.group("start")
        index += 1
        cue = []
        while index < len(lines) and lines[index].strip():
            cue.append(lines[index])
            index += 1
        text = re.sub(r"\s+", " ", TAG.sub("", " ".join(cue)).replace("&nbsp;", " ")).strip()
        if text:
            novel = novel_caption_text(previous, text)
            if novel:
                output.append(f"- `{start[:-4]}` {novel}")
            previous = text
        index += 1
    return "\n".join(output) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    args.destination.mkdir(parents=True, exist_ok=True)
    sources = {
        source.name.removesuffix(".en.vtt"): source
        for source in args.source.glob("*.en.vtt")
    }
    sources.update(
        {
            source.name.removesuffix(".en-orig.vtt"): source
            for source in args.source.glob("*.en-orig.vtt")
        }
    )
    for name, source in sorted(sources.items()):
        target = args.destination / f"{name}.md"
        target.write_text(transcript_from_vtt(source), encoding="utf-8")


if __name__ == "__main__":
    main()
