# Connector verification renders

All verification renders use unique filenames so component and size variants
can be compared directly without navigating through separate directories.
Normal standalone component renders are intentionally kept in the Build output
instead of being duplicated here.

## Reading the section views

Project coordinates are:

| Axis | Direction |
| --- | --- |
| X | horizontal across the display |
| Y | panel front → rear |
| Z | vertical |

Section orientation follows the retained plane:

| Plane | Normal / section axis |
| --- | --- |
| XY | Z |
| YZ | X |
| XZ / rear-facing | Y |

Unless explicitly described as a retained volume, **position** below is the
centre of the section slab and **thickness** is the retained slab thickness.
The implementation may therefore use `position = centre - thickness / 2`
with `direction = "Positive"`.

The HUB75 rear mounting plane is at **Y = 14.50 mm**. Rear-fit positions are
described relative to that datum as well as by their absolute Y coordinate.

# Middle coupler

## Section geometry

| View | Orientation | Position | Thickness / depth | Purpose |
| --- | --- | --- | --- | --- |
| Rear fit — small | XZ, normal Y | cutoff Y = 11.50 mm | 3.00 mm inward from mounting plane; retained rear volume rather than a thin slice | Shows panel/coupler overlap behind the mounting plane |
| Rear fit — medium / large | XZ, normal Y | cutoff Y = 9.50 mm | 5.00 mm inward from mounting plane; retained rear volume rather than a thin slice | Same rear-interface check at the deeper guide presets |
| XY seam — small | XY, normal Z | centre Z ≈ -18.241 mm | 0.50 mm | Slice through the vertical seam below the horizontal arm |
| XY seam — medium | XY, normal Z | centre Z ≈ -20.241 mm | 0.50 mm | Same seam slice for the medium arm height |
| XY seam — large | XY, normal Z | centre Z ≈ -22.241 mm | 0.50 mm | Same seam slice for the large arm height |
| Angled fit | 3D view | — | — | Local visual fit context; not a section |

The middle XY position is derived from
`-hub75_middle_coupler_horizontal_arm_height(coupler) / 2 - 6 mm`, so it
tracks the selected coupler preset rather than using one hard-coded Z value.

## Small

![Middle small rear fit](middle-coupler-small-rear-fit-section.png)

![Middle small XY seam](middle-coupler-small-xy-seam-section.png)

![Middle small angled fit](middle-coupler-small-fit-detail.png)

## Medium

![Middle medium rear fit](middle-coupler-medium-rear-fit-section.png)

![Middle medium XY seam](middle-coupler-medium-xy-seam-section.png)

![Middle medium angled fit](middle-coupler-medium-fit-detail.png)

## Large

![Middle large rear fit](middle-coupler-large-rear-fit-section.png)

![Middle large XY seam](middle-coupler-large-xy-seam-section.png)

![Middle large angled fit](middle-coupler-large-fit-detail.png)

# Horizontal-edge coupler

## Section geometry

| View | Orientation | Position | Thickness | Purpose |
| --- | --- | --- | --- | --- |
| Rear fit — small | XZ, normal Y | centre Y = 11.50 mm | 0.10 mm | Thin rear-interface slice, 3 mm inward from the mounting plane |
| Rear fit — medium / large | XZ, normal Y | centre Y = 9.50 mm | 0.10 mm | Thin rear-interface slice, 5 mm inward from the mounting plane |
| YZ edge profile | YZ, normal X | centre X = 12.00 mm | 0.50 mm | Cross-section through the right panel rear end rail near the seam |
| XY seam profile | XY, normal Z | centre Z = 138.00 mm | 0.50 mm | Section 22 mm inward from the nominal top edge at Z = 160 mm |
| Angled fit | 3D view | — | — | Local visual fit context; not a section |

## Small

![Horizontal edge small rear fit](horizontal-edge-coupler-small-rear-fit-section.png)

![Horizontal edge small YZ edge profile](horizontal-edge-coupler-small-yz-edge-section.png)

![Horizontal edge small XY seam profile](horizontal-edge-coupler-small-xy-seam-section.png)

![Horizontal edge small angled fit](horizontal-edge-coupler-small-fit-detail.png)

## Medium

![Horizontal edge medium rear fit](horizontal-edge-coupler-medium-rear-fit-section.png)

![Horizontal edge medium YZ edge profile](horizontal-edge-coupler-medium-yz-edge-section.png)

![Horizontal edge medium XY seam profile](horizontal-edge-coupler-medium-xy-seam-section.png)

![Horizontal edge medium angled fit](horizontal-edge-coupler-medium-fit-detail.png)

## Large

![Horizontal edge large rear fit](horizontal-edge-coupler-large-rear-fit-section.png)

![Horizontal edge large YZ edge profile](horizontal-edge-coupler-large-yz-edge-section.png)

![Horizontal edge large XY seam profile](horizontal-edge-coupler-large-xy-seam-section.png)

![Horizontal edge large angled fit](horizontal-edge-coupler-large-fit-detail.png)

# Corner-edge couplers

## Section geometry

The canonical profile views use the left/top corner as their reference. The
left/right fit views then show the mirrored physical corner positions.

| View | Orientation | Position | Thickness | Purpose |
| --- | --- | --- | --- | --- |
| Canonical horizontal profile | YZ, normal X | centre X = -60.00 mm | 0.50 mm | 20 mm inward from the nominal left edge at X = -80 mm |
| Canonical vertical profile | XY, normal Z | centre Z = 140.00 mm | 0.50 mm | 20 mm inward from the nominal top edge at Z = 160 mm |
| Rear fit — small | XZ, normal Y | centre Y = 11.50 mm | 0.10 mm | Thin corner rear-fit slice, 3 mm inward from mounting plane |
| Rear fit — medium / large | XZ, normal Y | centre Y = 9.50 mm | 0.10 mm | Thin corner rear-fit slice, 5 mm inward from mounting plane |
| Left YZ top-edge | YZ, normal X | centre X = -60.00 mm | 0.10 mm | 20 mm inward from the top-left corner |
| Right YZ top-edge | YZ, normal X | centre X = +60.00 mm | 0.10 mm | Mirrored 20 mm inward slice at the top-right corner |
| Left / right XY side-edge | XY, normal Z | centre Z = 140.00 mm | 0.10 mm | 20 mm inward from the top edge |
| Angled fit | 3D view | — | — | Local visual corner-fit context; not a section |

## Small

### Canonical profiles

![Corner small horizontal profile](corner-edge-coupler-small-horizontal-profile-section.png)

![Corner small vertical profile](corner-edge-coupler-small-vertical-profile-section.png)

### Left

![Corner left small rear fit](corner-edge-coupler-left-small-rear-fit-section.png)

![Corner left small YZ top-edge slice](corner-edge-coupler-left-small-yz-top-edge-section.png)

![Corner left small XY side-edge slice](corner-edge-coupler-left-small-xy-side-edge-section.png)

![Corner left small angled fit](corner-edge-coupler-left-small-fit-detail.png)

### Right

![Corner right small rear fit](corner-edge-coupler-right-small-rear-fit-section.png)

![Corner right small YZ top-edge slice](corner-edge-coupler-right-small-yz-top-edge-section.png)

![Corner right small XY side-edge slice](corner-edge-coupler-right-small-xy-side-edge-section.png)

![Corner right small angled fit](corner-edge-coupler-right-small-fit-detail.png)

## Medium

### Canonical profiles

![Corner medium horizontal profile](corner-edge-coupler-medium-horizontal-profile-section.png)

![Corner medium vertical profile](corner-edge-coupler-medium-vertical-profile-section.png)

### Left

![Corner left medium rear fit](corner-edge-coupler-left-medium-rear-fit-section.png)

![Corner left medium YZ top-edge slice](corner-edge-coupler-left-medium-yz-top-edge-section.png)

![Corner left medium XY side-edge slice](corner-edge-coupler-left-medium-xy-side-edge-section.png)

![Corner left medium angled fit](corner-edge-coupler-left-medium-fit-detail.png)

### Right

![Corner right medium rear fit](corner-edge-coupler-right-medium-rear-fit-section.png)

![Corner right medium YZ top-edge slice](corner-edge-coupler-right-medium-yz-top-edge-section.png)

![Corner right medium XY side-edge slice](corner-edge-coupler-right-medium-xy-side-edge-section.png)

![Corner right medium angled fit](corner-edge-coupler-right-medium-fit-detail.png)

## Large

### Canonical profiles

![Corner large horizontal profile](corner-edge-coupler-large-horizontal-profile-section.png)

![Corner large vertical profile](corner-edge-coupler-large-vertical-profile-section.png)

### Left

![Corner left large rear fit](corner-edge-coupler-left-large-rear-fit-section.png)

![Corner left large YZ top-edge slice](corner-edge-coupler-left-large-yz-top-edge-section.png)

![Corner left large XY side-edge slice](corner-edge-coupler-left-large-xy-side-edge-section.png)

![Corner left large angled fit](corner-edge-coupler-left-large-fit-detail.png)

### Right

![Corner right large rear fit](corner-edge-coupler-right-large-rear-fit-section.png)

![Corner right large YZ top-edge slice](corner-edge-coupler-right-large-yz-top-edge-section.png)

![Corner right large XY side-edge slice](corner-edge-coupler-right-large-xy-side-edge-section.png)

![Corner right large angled fit](corner-edge-coupler-right-large-fit-detail.png)

# Tube-mount coupler and canonical clamp

The clamp is one canonical part for all three coupler presets. The section
position changes only because the small coupler uses a different clamp location.

## Section geometry

| View | Orientation | Position | Thickness | Purpose |
| --- | --- | --- | --- | --- |
| Clamp fit | 3D view | clamp centre X = 18 mm small; 25 mm medium / large | — | Shows the complete local tube-mount, clamp and Ø10 aluminium tube |
| YZ dovetail section — small | YZ, normal X | centre X = 18.00 mm | 0.20 mm | Section through the centre of the local dovetail engagement |
| YZ dovetail section — medium / large | YZ, normal X | centre X = 25.00 mm | 0.20 mm | Same section at the common medium/large clamp position |
| XY lock section | XY, normal Z | centre Z = 10.00 mm | 0.20 mm | Shows the lib.scad.mechint ramped threshold, male recess/release and female spring tongue |

The implementation starts these 0.20 mm slabs half a section thickness before
the listed centre and retains them in the positive section-axis direction.

## Small

![Small tube-mount coupler with canonical clamp](horizontal-edge-tube-mount-coupler-small-clamp-fit.png)

![Small tube-mount coupler YZ section](horizontal-edge-tube-mount-coupler-small-yz-section.png)

![Small tube-mount coupler lock section](horizontal-edge-tube-mount-coupler-small-lock-section.png)

## Medium

![Medium tube-mount coupler with canonical clamp](horizontal-edge-tube-mount-coupler-medium-clamp-fit.png)

![Medium tube-mount coupler YZ section](horizontal-edge-tube-mount-coupler-medium-yz-section.png)

![Medium tube-mount coupler lock section](horizontal-edge-tube-mount-coupler-medium-lock-section.png)

## Large

![Large tube-mount coupler with canonical clamp](horizontal-edge-tube-mount-coupler-large-clamp-fit.png)

![Large tube-mount coupler YZ section](horizontal-edge-tube-mount-coupler-large-yz-section.png)

![Large tube-mount coupler lock section](horizontal-edge-tube-mount-coupler-large-lock-section.png)
