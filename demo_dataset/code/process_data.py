#!/usr/bin/env python3
import argparse, csv, json, os, time, random
from datetime import datetime

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True, help="path to input CSV")
    ap.add_argument("--out", required=True, help="path to output CSV")
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    random.seed(args.seed)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)

    rows = []
    with open(args.input, newline="") as f:
        reader = csv.DictReader(f)
        for r in reader:
            r2 = dict(r)
            # simple transform: add score = value_a*2 + value_b*3 + noise
            va = float(r["value_a"])
            vb = float(r["value_b"])
            r2["score"] = round(2*va + 3*vb + random.uniform(-0.5, 0.5), 3)
            rows.append(r2)

    out_fields = list(rows[0].keys())
    with open(args.out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=out_fields)
        w.writeheader()
        w.writerows(rows)

    meta = {
        "input": os.path.abspath(args.input),
        "output": os.path.abspath(args.out),
        "seed": args.seed,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }
    with open(os.path.join(os.path.dirname(args.out), "run.json"), "w") as f:
        json.dump(meta, f, indent=2)

    print(f"Wrote {args.out} and run.json")

if __name__ == "__main__":
    main()
