#!/usr/bin/env bash
python3 -c '
import random, time, sys, shutil

cols, rows = shutil.get_terminal_size()
streams = {}
chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%^&*(){}[]|;:<>?/~∑∏∫∂√∞≈≠≤≥αβγδεζηθλμπσφψω"

sys.stdout.write("\033[2J\033[?25l\033[32m")
sys.stdout.flush()

try:
    while True:
        for c in range(cols):
            if c not in streams and random.random() < 0.04:
                streams[c] = {"row": 0, "speed": random.randint(1, 3), "length": random.randint(8, 25)}

        to_remove = []
        for c, s in streams.items():
            for _ in range(s["speed"]):
                r = s["row"]
                if r < rows:
                    ch = random.choice(chars)
                    sys.stdout.write(f"\033[{r+1};{c+1}H\033[97;1m{ch}")
                    if r > 0:
                        prev_ch = random.choice(chars)
                        sys.stdout.write(f"\033[{r};{c+1}H\033[32;1m{prev_ch}")
                    tail = r - s["length"]
                    if tail >= 0 and tail < rows:
                        sys.stdout.write(f"\033[{tail+1};{c+1}H ")
                s["row"] += 1
                if s["row"] - s["length"] > rows:
                    to_remove.append(c)
                    break

        for c in to_remove:
            del streams[c]

        sys.stdout.flush()
        time.sleep(0.03)
finally:
    sys.stdout.write("\033[0m\033[?25h\033[2J\033[H")
    sys.stdout.flush()
'
