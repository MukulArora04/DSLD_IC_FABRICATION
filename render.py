import pya

layout = pya.Layout()
gds_file = "runs/RUN_2026-10-30_16-56-25/final/gds/tcam_top.gds"
layout.read(gds_file)

top_cell = layout.top_cell()
print(f"Top cell: {top_cell.name}")
print(f"Bounding Box: {top_cell.bbox()}")
