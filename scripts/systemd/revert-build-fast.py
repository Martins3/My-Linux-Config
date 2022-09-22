import re


def add_file_to_arr(file, arr):
    with open(file) as f:
        lines = f.readlines()
        lines = [line.rstrip() for line in lines]
        for l in lines:
            arr.append(l)


def repalce_include_with_file(file):
    new_lines = []
    with open(file) as f:
        lines = f.readlines()
        lines = [line.rstrip() for line in lines]
        for l in lines:
            r1 = re.findall(r"#include \"(.*\.c)\"", l)
            r2 = re.findall(r"# include \"(.*\.c)\"", l)

            source_files = None
            if r1:
                source_files = r1[0]
            if r2:
                source_files = r2[0]

            if source_files:
                l = "// ============> " + l
                new_lines.append(l)
                add_file_to_arr(working_dir + source_files, new_lines)
            else:
                new_lines.append(l)

    return new_lines


def write_arr_to_file(file, lines):
    with open(file, 'w') as f:
        for line in lines:
            f.write(f"{line}\n")


def revert(file):
    lines = repalce_include_with_file(file)
    write_arr_to_file(file, lines)


if __name__ == "__main__":
    working_dir = "/home/martins3/core/linux/kernel/sched/"
    revert(working_dir + "build_policy.c")
    revert(working_dir + "build_utility.c")
