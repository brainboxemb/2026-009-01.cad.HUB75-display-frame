# PR 25 refinement note

Problem: in the small horizontal-edge preset the reinforcement locator pad extends beyond the normal T-shaped base footprint, leaving too little backing material around part of the pad.

Proposed rule: keep the guide/mating profile unchanged, but derive the base footprint from the union of the normal T profile and the reinforcement-pad support footprints. Where the T already contains those footprints (normally medium/large), the visible outline must remain unchanged.
