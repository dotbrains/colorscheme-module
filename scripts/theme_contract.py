#!/usr/bin/env python3

import pathlib
import sys
import argparse

import theme_registry


ROOT = pathlib.Path(__file__).resolve().parents[1]
SET_ME_UP_ROOT = ROOT.parents[1]
THEMES_DIR = ROOT / "themes"


def manifests():
    return theme_registry.manifests(THEMES_DIR)


def required_paths(theme, aggregate=True):
    aggregate_root = SET_ME_UP_ROOT if aggregate else None
    return theme_registry.adapter_paths(ROOT, theme, aggregate_root=aggregate_root)


def main():
    parser = argparse.ArgumentParser(description="Validate theme manifest adapters.")
    parser.add_argument(
        "--local",
        action="store_true",
        help="Only check files owned by the colorscheme module checkout.",
    )
    args = parser.parse_args()

    failed = False
    seen = set()

    for theme in manifests():
        theme_id = theme.get("id")
        if not theme_id:
            print("FAIL manifest missing id")
            failed = True
            continue
        if theme_id in seen:
            print(f"FAIL duplicate theme id: {theme_id}")
            failed = True
        seen.add(theme_id)

        missing = []
        for _label, path in required_paths(theme, aggregate=not args.local):
            if not path.exists():
                missing.append(path)
        if missing:
            failed = True
            print(f"FAIL {theme_id}")
            for path in missing:
                print(f"  missing {path}")
        else:
            print(f"OK   {theme_id}")

    if failed:
        return 1
    print(f"Validated {len(seen)} theme(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
