#!/usr/bin/env python3

import os
import shutil
import fitdecode
import re
import argparse


def format_time_created(time_created):
    time_ints = re.findall(r"\d+", time_created)
    output_str = "AT_" + str(time_ints[0])  # year
    output_str = output_str + "_" + str(time_ints[1])  # month
    output_str = output_str + "_" + str(time_ints[2])  # day
    output_str = (
        output_str + "_" + f"{(int(time_ints[3])+1):02}"
    )  # hour (+1h adjustment)
    output_str = output_str + "h" + str(time_ints[4])  # minutes
    output_str = output_str + ".FIT"
    return output_str


def get_activity_time(file_path):
    with fitdecode.FitReader(file_path) as fit_file:
        for frame in fit_file:
            if isinstance(frame, fitdecode.records.FitDataMessage):
                if frame.name == "file_id":
                    if frame.has_field("time_created"):
                        time_created = str(frame.get_value("time_created"))
                        return format_time_created(time_created)


def rename_files(src_path, dst_path):
    nfiles = 0
    for file in os.listdir(src_path):
        if file.endswith(".FIT") or file.endswith(".fit"):
            file_src_path = os.path.join(src_path, file)
            dst_filename = get_activity_time(file_src_path)
            file_dst_path = os.path.join(dst_path, dst_filename)
            print(file_dst_path)
            shutil.copy2(file_src_path, file_dst_path)
            nfiles = nfiles + 1

    return nfiles


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Rename .FIT files with activity date.",
        epilog="""Simple script that copies all input .FIT files in source path to
destination and renames them according to the activity data:
    New name: AT_YYYY_MM_DD_HHhmm.FIT
        YYYY: Year
        MM: Month
        DD: Day
        HH: Hour
        mm: Minute
""",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("src_path", type=str, help="Path to .FIT files")
    parser.add_argument("dst_path", type=str, help="Output path")
    return parser.parse_args()


if __name__ == "__main__":
    print("Rename Script")

    args = parse_arguments()

    print(f"src path: {args.src_path}")
    print(f"dst path: {args.dst_path}")

    nfiles = rename_files(args.src_path, args.dst_path)

    print(f"All {nfiles} renamed")
