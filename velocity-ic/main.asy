// =============================================================================
// slider_crank.asy
// Slider-crank mechanism diagram
//
// Geometry:
//   O  – fixed pivot (origin)
//   B  – crank pin, |OB| = 100, at 45° above the horizontal
//   A  – slider (block), on the horizontal axis through O
//   |AB| = 400 (connecting rod)
//
// Intersection points constructed:
//   I14 – foot of the perpendicular from A onto the extended crank line OB
//   I24 – foot of the perpendicular from O onto the line AB
// =============================================================================

import fontsize;
import patterns;

settings.outformat = "pdf";
defaultpen(fontsize(10pt));

// ─── unit / scale ─────────────────────────────────────────────────────────────
real u = 1mm;          // 1 Asymptote unit = 1 mm  (everything in mm below)

// =============================================================================
// § 1  Helper functions
// =============================================================================

// Draw a dimension line between A and B with an optional offset perpendicular
// to the line (n > 0 offsets to the left when walking A→B).
void dimLine(picture pic = currentpicture,
             pair A, pair B,
             Label L = "",
             real offset = 0,
             pen  p = currentpen)
{
    real d = 3mm;
    path g = A -- B;
    transform T = shift(-offset * d * unit(B - A) * I);

    pic.add(new void(frame f, transform t) {
        picture tmp;
        draw(tmp, Label(L, Center, UnFill(1)), T * t * g, p,
             Arrows(NoFill), Bars, PenMargins);
        add(f, tmp.fit());
    });
    pic.addBox(min(g), max(g), T * min(p), T * max(p));
}

// Extend point P in the given direction by length len.
pair extend(pair P, pair direction, real len)
{
    return P + len * unit(direction);
}

// Rotate vector v by 90° counter-clockwise (perpendicular).
pair perp(pair v) { return v * I; }

// =============================================================================
// § 2  Primary geometry
// =============================================================================

// ── fixed pivot ──────────────────────────────────────────────────────────────
pair O = (0, 0);

// ── crank pin B  (|OB| = 100, crank angle = 45° from horizontal) ─────────────
real crankLen   = 100;
real crankAngle = 45;        // degrees, measured from the positive x-axis
pair B = O + crankLen * dir(crankAngle + 90);   // +90 keeps the original orientation

// ── slider pin A  (on the horizontal ray to the left of O, |AB| = 400) ───────
real rodLen = 400;

// Find A as the intersection of the circle centred at B (radius = rodLen)
// with the negative-x ray from O, picking the point closest to the axis.
pair findSlider(pair centre, real radius, pair origin)
{
    pair   rayEnd = origin + (-1, 0) * 1000;
    pair[] hits   = intersectionpoints(circle(centre, radius), origin -- rayEnd);

    if (hits.length == 0) return origin;   // fallback: degenerate configuration

    pair best     = hits[0];
    real bestDist = abs(best.y);
    for (int i = 1; i < hits.length; ++i) {
        if (abs(hits[i].y) < bestDist) {
            best      = hits[i];
            bestDist  = abs(hits[i].y);
        }
    }
    return best;
}

pair A = findSlider(B, rodLen, O);

// =============================================================================
// § 3  Derived geometry
// =============================================================================

pair dirOA   = unit(A - O);          // unit vector along slider axis
pair dirPerp = perp(dirOA);          // perpendicular to slider axis

real dashLen = 500;                  // length of construction / dashed lines

// Extended crank line  O → beyond B
path crankRay = O -- extend(O, B - O, 7 * crankLen);

// Perpendicular through A (perpendicular to OA)
path perpAtA  = (A) -- (A - dashLen * dirPerp);

// Perpendicular through O (perpendicular to OA), drawn downward
path perpAtO  = O -- (O - dashLen * dirPerp);

// ── I14: intersection of extended crank line with perpendicular at A ──────────
pair[] hitsI14 = intersectionpoints(crankRay, perpAtA);
pair   I14     = (hitsI14.length > 0) ? hitsI14[0] : A;

// ── I24: foot of perpendicular from O onto the connecting rod line AB ─────────
path rodLine = A -- extend(A, B - A, rodLen + 200);   // ray along AB, beyond B
pair[] hitsI24 = intersectionpoints(rodLine, perpAtO);
pair   I24     = (hitsI24.length > 0) ? hitsI24[0] : B;

// =============================================================================
// § 4  Drawing
// =============================================================================

// ── construction lines (draw first so they sit behind solid elements) ─────────
draw(crankRay,  dashed + gray);
draw(perpAtA,   dashed + gray);
// mark the intersection point on the perpendicular from A
dot("$I_{14}$ at $\infty$", (O - dashLen * dirPerp), N);
dot("$I_{14}$ at $\infty$", (A - dashLen * dirPerp), N);

draw(perpAtO,   dashed + gray);
draw(B -- I24,  dashed + gray);

// ── main links ────────────────────────────────────────────────────────────────
draw(O -- B, linewidth(1.2));        // crank
draw(B -- A, linewidth(1.2));        // connecting rod

// ── crank angle annotation ────────────────────────────────────────────────────
draw(arc(O, 20, 180, 135));
label("$45^\circ$", O + 30 * dir(157.5));

// ── slider block at A ─────────────────────────────────────────────────────────
real bw = 40, bh = 20;
path sliderBlock = shift(A) * (
    (-bw/2, -bh/2) -- ( bw/2, -bh/2) --
    ( bw/2,  bh/2) -- (-bw/2,  bh/2) -- cycle);
filldraw(sliderBlock, blue + opacity(0.3), blue);

// ── key points ────────────────────────────────────────────────────────────────
dot("$O$",     O,   SE);
dot("$B$",     B,   NE);
dot("$A$",     A,   SW);
dot("$I_{14}$", I14, NE);
dot("$I_{24}$", I24, NE);

// ── dimension lines ───────────────────────────────────────────────────────────
dimLine(O, B, "$OB = " + format("%g", length(B - O)) + "$",  offset= 3);
dimLine(A, B, "$AB = " + format("%g", length(B - A)) + "$",  offset=-2);
