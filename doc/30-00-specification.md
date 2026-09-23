# HUB75 display-frame specification

This document explains **why the project exists** and what the frame should achieve.

## Why this project exists

The project turns five reusable portrait HUB75 panels into one modular display
while keeping panel mating, structural reinforcement and serviceable tube
retention understandable and independently verifiable. The older frame project
is historical evidence only, not a geometry authority.

## What the frame should achieve

- arrange five nominal 160 × 320 mm panel cells as one 800 × 320 mm display;
- preserve the physical front-face datum and explicit rear mounting-plane datum;
- consume reusable HUB75 dimensions through public accessors instead of copied constants;
- provide printable core couplers whose panel-facing fit can be qualified independently;
- keep aluminium-tube reinforcement separate from core panel fit;
- use a separately printable/serviceable tube clamp;
- reuse shared clamp and sliding-dovetail mechanics rather than reimplementing them;
- retain focused digital evidence and require physical evidence where CAD cannot establish fit.

## Ownership boundaries

`lib.scad.hub75` owns reusable panel geometry and mating dimensions.
`lib.scad.clamps` owns the reusable clamp body. `lib.scad.mechint` owns the
sliding-dovetail fit/lock/release mechanics. `lib.scad.util` owns ordinary
axis-aligned inspection slabs. `lib.scad.forge` owns the shared modeling vocabulary.

This project owns panel ordering/orientation, project couplers, reinforcement
placement, project-specific carriers/adapters, complete assemblies and project verification.

## Core versus reinforcement layers

Panel-facing core couplers are a separate acceptance boundary. Their physical
fit must not be silently changed merely to make later reinforcement work easier.
The tube-mount layer may develop digitally in parallel but remains WIP until
the core interface and detachable interface are physically qualified.
Standard core couplers therefore remain the default complete assembly.

## Coordinate and orientation intent

```text
X = 0   centre of complete display width
Y = 0   HUB75 front face
Z = 0   centre of panel/display height
```
The panel is not symmetric in Y. Rear mating geometry uses explicit mechanical
datums rather than a geometric-depth midpoint. Adjacent panels alternate
orientation according to rear-view data-chain order while front/rear datum stays fixed.

## Verification intent

Digital fit against the panel model is necessary but not physical print-fit proof.
Core acceptance requires the prepared physical PF cases on identified hardware.
Sliding force, print clearance, lock behavior and repeated serviceability also
require later physical qualification.

## Non-goals

The project does not own generic repository/tooling workflow, reusable panel
geometry, generic clamp/dovetail algorithms, a universal print-tolerance policy
or permission to present WIP reinforcement geometry as physically accepted.
