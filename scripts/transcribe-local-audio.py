"""Create timestamped Markdown transcripts with local faster-whisper."""

from __future__ import annotations

import argparse
from pathlib import Path

from faster_whisper import WhisperModel


def timestamp(seconds: float) -> str:
    total = int(seconds)
    hours, remainder = divmod(total, 3600)
    minutes, secs = divmod(remainder, 60)
    return f"{hours:02d}:{minutes:02d}:{secs:02d}"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("audio", nargs="+", type=Path)
    parser.add_argument("--destination", required=True, type=Path)
    parser.add_argument("--model", default="base.en")
    parser.add_argument("--model-cache", type=Path)
    args = parser.parse_args()

    args.destination.mkdir(parents=True, exist_ok=True)
    model = WhisperModel(
        args.model,
        device="cpu",
        compute_type="int8",
        download_root=str(args.model_cache) if args.model_cache else None,
    )

    for source in args.audio:
        segments, info = model.transcribe(
            str(source),
            language="en",
            beam_size=5,
            vad_filter=True,
        )
        output = [
            f"# Transcript: {source.stem}",
            "",
            f"Provenance: local speech recognition with faster-whisper `{args.model}` from downloaded audio.",
            f"Detected language: {info.language} (probability {info.language_probability:.3f}).",
            "Timestamps and wording should be checked against the media for critical claims.",
            "",
        ]
        for segment in segments:
            text = segment.text.strip()
            if text:
                output.append(f"- `{timestamp(segment.start)}` {text}")
        target = args.destination / f"{source.stem}.md"
        target.write_text("\n".join(output) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
