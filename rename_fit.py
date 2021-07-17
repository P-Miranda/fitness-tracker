"""
Simple script that copies all input .FIT files in input path (argv[1]) to 
destination (argv[2]) and renames them according to the activity data:
    New name: AT_YYYY_MM_DD_HHhmm.FIT
        YYYY: Year
        MM: Month
        DD: Day
        HH: Hour
        mm: Minute
"""

import sys
import os
import shutil
import fitdecode
import re


def format_time_created(time_created):
    # print(time_created.split())
    time_ints = re.findall(r'\d+', time_created)
    output_str = 'AT_' + str(time_ints[0]) # year
    output_str = output_str + '_' + str(time_ints[1]) # month
    output_str = output_str + '_' + str(time_ints[2]) # day
    output_str = output_str + '_' + f"{(int(time_ints[3])+1):02}" # hour (+1h adjustment)
    output_str = output_str + 'h' + str(time_ints[4]) # minutes
    output_str = output_str + '.FIT'
    return output_str
    
def get_activity_type(file_path):
    # print(file_path)
    with fitdecode.FitReader(file_path) as fit_file:
        for frame in fit_file:
            if isinstance(frame, fitdecode.records.FitDataMessage):
                if frame.name == "file_id":
                    # print(frame.name)
                    if frame.has_field('time_created'):
                        # print(frame.get_value('time_created'))
                        time_created = str(frame.get_value('time_created'))
                        return format_time_created(time_created)

def rename_files(src_path, dst_path):
    nfiles = 0
    for file in os.listdir(src_path):
        if file.endswith(".FIT"):
            # print(file)
            file_src_path = os.path.join(src_path, file)
            dst_filename = get_activity_type(file_src_path)
            file_dst_path = os.path.join(dst_path, dst_filename)
            print(file_dst_path)
            shutil.copy2(file_src_path, file_dst_path)
            nfiles = nfiles + 1

    return nfiles

def main():
    print("Rename Script")

    try:
        src_path = sys.argv[1]
        dst_path = sys.argv[2]
    except:
        print(f'Usage: python3 {sys.argv[0]} <src path> <dst path>')
        sys.exit()

    print(f'src path: {src_path}')
    print(f'dst path: {dst_path}')

    nfiles = rename_files(src_path, dst_path)

    print(f"All {nfiles} renamed")


if __name__ == '__main__':
    main()
