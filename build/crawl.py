#!/usr/bin/env python3
"""One-time, key-free corpus builder for the pg-essays plugin.

Fetches Paul Graham's essays from paulgraham.com and writes one cleaned text
file per essay into ../skills/pg-essays/essays/. No API key needed (the index
ships with the plugin). Each user builds their own local copy of the essay text;
the text itself is never redistributed.

Usage:
    pip install -r requirements.txt
    python crawl.py
"""

from __future__ import annotations

import os
import re
import time
from pathlib import Path
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup

BASE_URL = "http://www.paulgraham.com/"
ARTICLES_URL = urljoin(BASE_URL, "articles.html")
_NON_ESSAY = {"index.html", "articles.html", "rss.html"}

# Default to the plugin layout; the curl installer overrides this with the
# user-skill location via the PG_ESSAYS_DIR environment variable.
ESSAYS_DIR = Path(
    os.environ.get(
        "PG_ESSAYS_DIR",
        Path(__file__).resolve().parent.parent / "skills" / "pg-essays" / "essays",
    )
)


def enumerate_essay_urls(index_html: str) -> list[str]:
    soup = BeautifulSoup(index_html, "html.parser")
    urls, seen = [], set()
    for a in soup.find_all("a", href=True):
        href = a["href"].strip()
        if "://" in href or href.startswith("//") or not href.lower().endswith(".html"):
            continue
        if href.split("/")[-1].lower() in _NON_ESSAY:
            continue
        full = urljoin(BASE_URL, href)
        if full not in seen:
            seen.add(full)
            urls.append(full)
    return urls


def slug_for_url(url: str) -> str:
    name = re.sub(r"\.html?$", "", urlparse(url).path.split("/")[-1], flags=re.I)
    return re.sub(r"[^A-Za-z0-9_-]", "-", name).strip("-").lower() or "essay"


def extract_essay(html: str) -> tuple[str, str]:
    """HTML -> (title, clean body). Handles PG's unclosed <font> tags by turning
    <br> into newlines on the raw string before parsing (mutating the tree would
    collapse the implicitly-open body font)."""
    title_soup = BeautifulSoup(html, "html.parser")
    title = title_soup.title.get_text(strip=True) if title_soup.title else ""

    html = re.sub(r"(?i)<br\s*/?>", "\n", html)
    soup = BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style"]):
        tag.decompose()

    fonts = soup.find_all("font")
    block = max(fonts, key=lambda f: len(f.get_text()), default=None)
    if block is None or len(block.get_text(strip=True)) < 40:
        block = soup.body or soup

    lines = [ln.strip() for ln in block.get_text("\n").split("\n")]
    out, blank = [], False
    for ln in lines:
        if ln:
            if blank and out:
                out.append("")
            out.append(ln)
            blank = False
        elif out:
            blank = True
    text = "\n".join(out).strip()
    if title and text.startswith(title):
        text = text[len(title):].lstrip("\n ").strip()
    return title, re.sub(r"\n{3,}", "\n\n", text)


def fetch(url: str) -> str:
    resp = requests.get(url, timeout=20, headers={"User-Agent": "pg-essays-plugin/1.0"})
    resp.raise_for_status()
    resp.encoding = resp.apparent_encoding or resp.encoding
    return resp.text


def main() -> None:
    ESSAYS_DIR.mkdir(parents=True, exist_ok=True)
    urls = enumerate_essay_urls(fetch(ARTICLES_URL))
    print(f"Found {len(urls)} essays. Fetching into {ESSAYS_DIR} ...")
    written = 0
    for url in urls:
        try:
            title, text = extract_essay(fetch(url))
            if not text.strip():
                print(f"  skip (empty): {url}")
                continue
            path = ESSAYS_DIR / f"{slug_for_url(url)}.txt"
            path.write_text(f"Title: {title}\nURL: {url}\n\n{text}\n", encoding="utf-8")
            written += 1
            print(f"  wrote {path.name}  ({title})")
        except Exception as exc:  # noqa: BLE001 — skip+log, never abort
            print(f"  skip ({exc}): {url}")
        time.sleep(0.5)
    print(f"\nDone: {written} essays. You can now chat with Paul Graham in Claude Code.")


if __name__ == "__main__":
    main()
