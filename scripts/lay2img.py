# SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import os
import argparse
import klayout.lay as lay
import klayout.db as db


def main(input_layout, output_image, width, height, oversampling, pdk_root, pdk):

    # Background colors
    background_white = "#FFFFFF"
    background_black = "#000000"

    lv = lay.LayoutView()

    lv.set_config("grid-visible", "false")
    lv.set_config("grid-show-ruler", "false")
    lv.set_config("text-visible", "false")

    lv.load_layout(input_layout, 0)
    lv.max_hier()

    top_cell = lv.active_cellview().layout().top_cell()
    top_bbox = top_cell.dbbox()
    aspect_ratio = top_bbox.width() / top_bbox.height()

    if not height and not width:
        width = 1024

    if not height:
        height = int(width / aspect_ratio)

    # Load the layer properties
    lv.load_layer_props(os.path.join(pdk_root, pdk, "libs.tech", "klayout", "tech", "sg13g2.lyp"))

    disable_layers = [
        (189, 4),
        (134, 23)
    ]

    fill_layer = [
        (134, 0)
    ]

    for lyp in lv.each_layer():
        #lyp.fill_color     = 0
        #lyp.frame_color    = 0
        #lyp.dither_pattern = 0
        #lyp.visible = False
        
        layer_datatype = (lyp.source_layer, lyp.source_datatype) 
        
        if layer_datatype in disable_layers:
            lyp.visible = False
        
        if layer_datatype in fill_layer:
            lyp.dither_pattern = 0
            #lyp.line_style = 0
            #lyp.frame_color = 0
            #lyp.width = 2

    # Save the images
    base_name = os.path.splitext(os.path.basename(output_image))[0]
    directory = os.path.dirname(output_image)

    lv.set_config("background-color", background_white)
    lv.save_image_with_options(
        os.path.join(directory, base_name + "_white.png"),
        width,
        height,
        oversampling=oversampling,
    )

    lv.set_config("background-color", background_black)
    lv.save_image_with_options(
        os.path.join(directory, base_name + "_black.png"),
        width,
        height,
        oversampling=oversampling,
    )


if __name__ == "__main__":

    pdk_root = os.getenv("PDK_ROOT", os.path.expanduser("~/.ciel"))
    pdk = os.getenv("PDK", "ihp-sg13g2")

    parser = argparse.ArgumentParser(
        prog="lay2img", description="Convert a layout to an image."
    )
    parser.add_argument("layout", help="input layout")
    parser.add_argument("image", help="output image")
    parser.add_argument("--width", type=int, default=None, help="image width")
    parser.add_argument("--height", type=int, default=None, help="image height")
    parser.add_argument(
        "--oversampling", type=int, default=1, help="oversampling factor"
    )

    args = parser.parse_args()

    main(
        args.layout,
        args.image,
        args.width,
        args.height,
        args.oversampling,
        pdk_root,
        pdk,
    )
