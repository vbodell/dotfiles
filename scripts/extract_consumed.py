#!/usr/bin/env python3
"""
Extract recent consumed entries from consume.json and format as garden.md entries.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.request
import urllib.error
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional

API_URL = "https://retention-server-944819226385.europe-north1.run.app/api/consume"


def parse_args():
    parser = argparse.ArgumentParser(
        description="Extract recent consumed articles and format for garden.md"
    )
    parser.add_argument(
        "-d", "--days",
        type=int,
        default=7,
        help="Number of days to look back (default: 7)"
    )
    parser.add_argument(
        "-f", "--file",
        type=Path,
        default=None,
        help="Path to consume.json (fallback if RETENTION_API_KEY not set)"
    )
    parser.add_argument(
        "--since",
        type=str,
        help="Start date in YYYY-MM-DD format (overrides --days)"
    )
    return parser.parse_args()


def fetch_from_api() -> list[dict]:
    """Fetch entries from the retention API."""
    api_key = os.getenv("RETENTION_API_KEY")
    if not api_key:
        return None
    
    req = urllib.request.Request(API_URL, headers={"X-Api-Key": api_key})
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.URLError as e:
        print(f"API request failed: {e}", file=sys.stderr)
        return None


def load_entries(filepath: Path | None) -> list[dict]:
    # Try API first
    entries = fetch_from_api()
    if entries is not None:
        return entries
    
    # Fallback to file
    if filepath is None:
        filepath = Path(__file__).parent.parent / "consume.json"
    
    if not filepath.exists():
        print(f"No API key set and file not found: {filepath}", file=sys.stderr)
        sys.exit(1)
    
    with open(filepath) as f:
        return json.load(f)


def filter_articles(entries: list[dict], since_date: datetime) -> list[dict]:
    """Filter to completed articles with date_completed >= since_date."""
    articles = []
    for entry in entries:
        if entry.get("medium") != "article":
            continue
        if not entry.get("completed"):
            continue
        date_str = entry.get("date_completed", "")
        if not date_str:
            continue
        try:
            completed = datetime.strptime(date_str, "%Y-%m-%d")
            if completed >= since_date:
                articles.append(entry)
        except ValueError:
            continue
    return articles


def format_entry(entry: dict) -> str:
    """Format a single entry in garden.md style."""
    what = entry.get("what", "")
    who = entry.get("who", "").strip()
    url = entry.get("url", "")
    comment = entry.get("comment", "").strip()

    # Build the title part
    if who:
        title = f"[{what}]({url}) by {who}"
    else:
        title = f"[{what}]({url})"

    # Decide inline vs block format based on comment length
    if not comment:
        return f"- {title}."
    elif len(comment) < 100 and "\n" not in comment:
        return f"- {title}. {comment}"
    else:
        # Block format for longer comments
        return f"- {title}\n\n{comment}"


def group_by_date(articles: list[dict]) -> dict[str, list[dict]]:
    """Group articles by completion date."""
    grouped = {}
    for article in articles:
        date = article.get("date_completed", "")
        if date not in grouped:
            grouped[date] = []
        grouped[date].append(article)
    return grouped


def main():
    args = parse_args()

    if args.since:
        since_date = datetime.strptime(args.since, "%Y-%m-%d")
    else:
        since_date = datetime.now() - timedelta(days=args.days)

    entries = load_entries(args.file)
    articles = filter_articles(entries, since_date)

    if not articles:
        print(f"No completed articles found since {since_date.date()}", file=sys.stderr)
        sys.exit(0)

    grouped = group_by_date(articles)

    # Output in reverse chronological order
    for date in sorted(grouped.keys(), reverse=True):
        print(f"## {date}\n")
        for article in grouped[date]:
            print(format_entry(article))
        print()


if __name__ == "__main__":
    main()
