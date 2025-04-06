# SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import pya
import argparse

def main(inputs, output):

    layout = pya.Layout()

    for file in inputs:
      layout.read(file)

    layout.write(output)

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()

    parser.add_argument('inputs', nargs='+', help='input gds files')
    parser.add_argument('output', help='output gds file')
    
    args = parser.parse_args()
    
    main(args.inputs, args.output)
