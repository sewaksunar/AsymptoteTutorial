"""
Root Locus for G(s)H(s) = k(s^2 - 2s + 5) / (s^2 + 1.5s - 1)
All values computed analytically / numerically via numpy & control.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.lines import Line2D
import control
import warnings
warnings.filterwarnings("ignore")

# ── Transfer function ────────────────────────────────────────────────────────
num = [1, -2, 5]          # s^2 - 2s + 5
den = [1,  1.5, -1]       # s^2 + 1.5s - 1
sys = control.tf(num, den)

# ── Analytical poles & zeros ─────────────────────────────────────────────────
poles = np.roots(den)
zeros = np.roots(num)

print("=" * 60)
print("G(s)H(s) = k(s² - 2s + 5) / (s² + 1.5s - 1)")
print("=" * 60)
print(f"\nPoles  (open-loop):  {poles}")
print(f"Zeros  (open-loop):  {zeros}")

n = len(poles)   # 2
m = len(zeros)   # 2
print(f"\nNumber of poles n = {n}")
print(f"Number of zeros m = {m}")
print(f"Branches going to ∞ = n - m = {n - m}  (no asymptotes needed)")

# ── Real-axis locus segments ─────────────────────────────────────────────────
# Real-axis rule: point on RL if #(real poles + real zeros) to its RIGHT is odd
real_poles = poles[np.abs(poles.imag) < 1e-9].real
real_zeros = zeros[np.abs(zeros.imag) < 1e-9].real
all_real = np.sort(np.concatenate([real_poles, real_zeros]))[::-1]
print(f"\nReal-axis critical points (right→left): {all_real}")
print("Real-axis RL segments:")
for i, s in enumerate(all_real):
    count = i + 1
    if count % 2 == 1:
        if i + 1 < len(all_real):
            print(f"  [{all_real[i+1]:.4f}, {s:.4f}]")
        else:
            print(f"  (-∞, {s:.4f}]")

# ── Breakaway / break-in points ──────────────────────────────────────────────
# dK/ds = 0  where K = -den(s)/num(s)
# d/ds [den/num] = (den'·num - den·num') / num² = 0  → den'·num = den·num'
# Numerically: find roots of den'(s)·num(s) - den(s)·num'(s) = 0
dden = np.polyder(den)
dnum = np.polyder(num)
# polynomial: dden * num - den * dnum
char_poly = np.polysub(np.polymul(dden, num), np.polymul(den, dnum))
breakpts_all = np.roots(char_poly)
print(f"\nBreakaway/break-in candidate roots: {breakpts_all}")

# Keep only real roots that lie on the real-axis locus
def k_at_s(s_val):
    """Return K = -P(s)/Z(s), real part only for real s."""
    return -np.polyval(den, s_val) / np.polyval(num, s_val)

breakpts = []
for bp in breakpts_all:
    if np.abs(bp.imag) < 1e-6:
        bpr = bp.real
        k_val = k_at_s(bpr).real
        if k_val >= 0:
            breakpts.append((bpr, k_val))
            print(f"  Valid breakaway/break-in at s = {bpr:.6f},  K = {k_val:.6f}")

# ── Gain K at specific points ────────────────────────────────────────────────
def gain_at_s(s_complex):
    """K = |den(s)| / |num(s)|  (magnitude condition)."""
    return np.abs(np.polyval(den, s_complex)) / np.abs(np.polyval(num, s_complex))

# ── Compute root locus numerically over a fine K range ──────────────────────
k_values = np.concatenate([
    np.linspace(0, 0.001, 200),
    np.linspace(0.001, 0.1, 500),
    np.linspace(0.1, 5, 2000),
    np.linspace(5, 50, 500),
])

all_roots = []
for k in k_values:
    cl_den = np.polyadd(den, k * np.array(num))
    roots = np.roots(cl_den)
    all_roots.append(np.sort_complex(roots))

all_roots = np.array(all_roots)

# ── Sort branches continuously (greedy nearest-neighbor) ─────────────────────
branches = all_roots.copy()
for i in range(1, len(branches)):
    prev = branches[i-1]
    curr = all_roots[i]
    # Try both orderings and pick the one minimising total movement
    order = list(range(n))
    for j in range(n):
        dists = np.abs(curr - prev[j])
        order[j] = np.argmin(dists)
        curr_copy = curr.copy()
    branches[i] = curr[order] if len(set(order)) == n else curr

# ── Departure angles from complex poles (none here, poles are real) ──────────
# All poles are real → angles are 0° or 180°, handled by real-axis rule.

# ── Arrival angles at complex zeros ─────────────────────────────────────────
print("\nArrival angles at zeros:")
for z in zeros:
    angle_from_poles = sum(np.angle(z - p) for p in poles)
    angle_from_zeros = sum(np.angle(z - ze) for ze in zeros if ze != z)
    # angle condition: angle_from_poles - angle_from_zeros = (2k+1)π
    arrival = np.pi * (2*0+1) - angle_from_poles + angle_from_zeros
    print(f"  zero={z:.3f}  arrival angle = {np.degrees(arrival):.2f}°")

# ── Imaginary-axis crossing (jω-axis) ────────────────────────────────────────
# Characteristic: s^2(1+k) + s(1.5-2k) + (-1+5k) = 0
# At s=jω: -(1+k)ω² + j·ω(1.5-2k) + (-1+5k) = 0
# Real: -(1+k)ω² + (-1+5k) = 0  →  ω² = (5k-1)/(k+1)
# Imag: ω(1.5-2k) = 0 → ω=0 (trivial) or k=0.75
k_cross = 0.75
w_cross = np.sqrt((5*k_cross - 1)/(k_cross + 1))
print(f"\nImaginary-axis crossing: K = {k_cross:.4f},  jω = ±{w_cross:.4f}j")

# ── Gain at key points ────────────────────────────────────────────────────────
print(f"\nGain at breakaway point s={breakpts[0][0]:.4f}:  K = {breakpts[0][1]:.6f}")
print(f"Gain at jω-crossing s=j{w_cross:.4f}:   K = {k_cross:.4f}")
print(f"Gain at zeros (K→∞): {zeros}")

# ════════════════════════════════════════════════════════════════════════════════
#  PLOT
# ════════════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(9, 9))
ax.set_facecolor("#f8f9fa")
fig.patch.set_facecolor("white")

# Grid
ax.grid(True, color="white", linewidth=1.2, zorder=0)
ax.set_axisbelow(True)

# ── Draw root locus branches ──────────────────────────────────────────────────
colors = ["#1f77b4", "#d62728"]
labels_added = set()

# Use control library for clean branch data
rlist, klist = control.root_locus(sys, plot=False)

# rlist shape: (len_k, n_poles)
for branch_idx in range(n):
    br = rlist[:, branch_idx]
    real_parts = br.real
    imag_parts = br.imag

    label = "Root Locus Branch" if "branch" not in labels_added else None
    ax.plot(real_parts, imag_parts, color="#1565C0", linewidth=2.2,
            label=label, zorder=3)
    if "branch" not in labels_added:
        labels_added.add("branch")

    # Arrow at mid-point to show direction of increasing K
    mid = len(br) // 2
    dx = br[mid+1].real - br[mid].real
    dy = br[mid+1].imag - br[mid].imag
    ax.annotate("", xy=(br[mid].real + dx*3, br[mid].imag + dy*3),
                xytext=(br[mid].real, br[mid].imag),
                arrowprops=dict(arrowstyle="->", color="#1565C0", lw=2.0),
                zorder=5)

# ── Poles (×) ────────────────────────────────────────────────────────────────
for i, p in enumerate(poles):
    ax.plot(p.real, p.imag, 'x', color='#C62828', markersize=14,
            markeredgewidth=3, zorder=6,
            label="Open-loop Pole" if i == 0 else None)
    ax.annotate(f"  Pole: $s={p.real:+.1f}$",
                xy=(p.real, p.imag), xytext=(p.real + 0.12, p.imag + 0.22),
                color='#C62828', fontsize=9,
                arrowprops=dict(arrowstyle="-", color='#C62828', lw=0.8))

# ── Zeros (○) ────────────────────────────────────────────────────────────────
for i, z in enumerate(zeros):
    ax.plot(z.real, z.imag, 'o', color='#1B5E20', markersize=11,
            markerfacecolor='none', markeredgewidth=2.5, zorder=6,
            label="Open-loop Zero" if i == 0 else None)
    sign = "+" if z.imag >= 0 else "-"
    ax.annotate(f"  Zero: $s={z.real:.0f}{sign}{abs(z.imag):.0f}j$",
                xy=(z.real, z.imag), xytext=(z.real + 0.18, z.imag + (0.3 if z.imag>0 else -0.3)),
                color='#1B5E20', fontsize=9,
                arrowprops=dict(arrowstyle="-", color='#1B5E20', lw=0.8))

# ── Breakaway point ───────────────────────────────────────────────────────────
for bp, k_bp in breakpts:
    ax.plot(bp, 0, 'D', color='#6A0DAD', markersize=9, zorder=7,
            label=f"Breakaway  $s={bp:.3f}$,  $K={k_bp:.4f}$")
    ax.annotate(f"  Breakaway\n  $s={bp:.3f}$\n  $K={k_bp:.4f}$",
                xy=(bp, 0), xytext=(bp - 1.1, 0.55),
                fontsize=8.5, color='#6A0DAD',
                arrowprops=dict(arrowstyle="->", color='#6A0DAD', lw=1.2))

# ── jω-axis crossing ─────────────────────────────────────────────────────────
for sign in [+1, -1]:
    ax.plot(0, sign * w_cross, '*', color='#E65100', markersize=13, zorder=7,
            label=f"$j\\omega$-crossing  $K={k_cross}$,  $\\omega={w_cross:.3f}$"
                  if sign == 1 else None)
ax.annotate(f"  $j\\omega$-axis crossing\n  $K={k_cross}$,  $\\omega=\\pm{w_cross:.3f}$",
            xy=(0, w_cross), xytext=(0.35, w_cross + 0.4),
            fontsize=8.5, color='#E65100',
            arrowprops=dict(arrowstyle="->", color='#E65100', lw=1.2))

# ── Real-axis locus segment shading ──────────────────────────────────────────
ax.axhspan(-0.04, 0.04, xmin=0, xmax=1, alpha=0)   # invisible baseline
seg_left  = min(real_poles)   # -2.0
seg_right = max(real_poles)   # +0.5
ax.fill_betweenx([-0.04, 0.04],
                 [seg_left, seg_left], [seg_right, seg_right],
                 color="#1565C0", alpha=0.18, zorder=2,
                 label=f"Real-axis RL: $[{seg_left},{seg_right}]$")

# ── Axes styling ──────────────────────────────────────────────────────────────
ax.axhline(0, color='black', linewidth=1.0, zorder=1)
ax.axvline(0, color='black', linewidth=1.0, zorder=1)
ax.set_xlim(-3.5, 2.8)
ax.set_ylim(-3.2, 3.2)
ax.set_xlabel(r"Real axis $\sigma$", fontsize=12)
ax.set_ylabel(r"Imaginary axis $j\omega$", fontsize=12)
ax.set_title(
    r"Root Locus  —  $G(s)H(s)=\dfrac{k(s^2-2s+5)}{s^2+1.5s-1}$"
    "\n"
    r"Poles: $s=-2,\;s=0.5$     Zeros: $s=1\pm2j$     $(n=m=2$, no asymptotes$)$",
    fontsize=12, pad=14
)

# ── Info box ──────────────────────────────────────────────────────────────────
info = (
    "Key values (computed)\n"
    "─────────────────────\n"
    f"Poles:        $s = {poles[0]:.1f},\\;{poles[1]:.1f}$\n"
    f"Zeros:        $s = 1\\pm2j$\n"
    f"Breakaway:  $s \\approx {breakpts[0][0]:.3f}$,  $K={breakpts[0][1]:.4f}$\n"
    f"$j\\omega$-crossing: $K={k_cross}$, $\\omega=\\pm{w_cross:.3f}$\n"
    f"Asymptotes: none  $(n-m=0)$"
)
ax.text(0.015, 0.985, info, transform=ax.transAxes,
        fontsize=8.2, verticalalignment='top',
        bbox=dict(boxstyle='round,pad=0.6', facecolor='#FFF9C4',
                  edgecolor='#F9A825', linewidth=1.3),
        family='monospace', linespacing=1.55, zorder=10)

ax.legend(loc="lower left", fontsize=8.5, framealpha=0.92,
          edgecolor="#bbb", fancybox=True)
ax.tick_params(labelsize=9)

plt.tight_layout()
plt.savefig("root_locus.png", dpi=180, bbox_inches="tight")
print("\n✓ Saved → root_locus.png")
plt.close()