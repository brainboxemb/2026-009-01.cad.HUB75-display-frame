from pathlib import Path

path = Path("dsg/openscad/project_components/corner-edge-coupler/hub75_corner_edge_coupler.scad")
text = path.read_text(encoding="utf-8")
old = "use <../../ext/lib.scad.hub75/openscad/p5-64x32-panel/hub75_p5_64x32_panel.scad>\n"
new = old + "use <../hub75_panel_mating.scad>\n"
if text.count(old) != 1:
    raise SystemExit("corner source HUB75 import not found exactly once")
if "use <../hub75_panel_mating.scad>" not in text:
    path.write_text(text.replace(old, new, 1), encoding="utf-8")
Path(__file__).unlink(missing_ok=True)
