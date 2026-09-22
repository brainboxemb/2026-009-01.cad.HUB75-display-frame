// STL export entrypoint for the left corner-edge tube-mount coupler.

use <../ext/lib.scad.forge/openscad/resolution.scad>
use <../components/hub75/corner-edge-coupler/hub75_corner_edge_coupler.scad>
use <../project_components/tube_mount/corner-edge-coupler/hub75_tube_corner_edge_coupler.scad>
use <../export_support/export_orientation.scad>

// tool.scad-project multi-size adapter: overridden by -D size=...
size = "medium";
d_profile = size;
_coupler = hub75_corner_edge_coupler_create_for_size(side = "left", size = d_profile);

hub75_export_rear_face_down(_coupler.base_thickness)
    hub75_tube_corner_edge_coupler_build(
        _coupler,
        resolution = FG_RES_EXPORT()
    );
