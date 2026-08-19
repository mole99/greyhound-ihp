# SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import pya
import click

@click.command()
@click.argument(
    "input",
    type=click.Path(exists=True, file_okay=True, dir_okay=False),
)
@click.argument(
    "output",
    type=click.Path(exists=False, file_okay=True, dir_okay=False),
)
def convert_oasis(
    input: str,
    output: str,
):

    layout = pya.Layout()
    layout.read(input)
    layout.write(output)

if __name__ == "__main__":
    convert_oasis()
