import re
import sys

def replace_fortran_contiguous(file_path):
    with open(file_path, "r") as f:
        lines = f.readlines()

    # Regex to match `%X = call i1 @_FortranAIsContiguous(ptr nonnull %Y)`
    #pattern = re.compile(r"(%\d+)\s*=\s*call i1 @_FortranAIsContiguous\(ptr nonnull %\d+\)")
    pattern = re.compile(r"(%\d+)\s*=\s*call i1 @_FortranAIsContiguous.*")

    modified_lines = []
    replaced = False

    for line in lines:
        match = pattern.search(line)
        if match:
            var_name = match.group(1)
            replacement = f"{var_name} = add i1 1, 0  ; Force to true\n"
            modified_lines.append(replacement)
            replaced = True
        else:
            modified_lines.append(line)

    if replaced:
        with open(file_path, "w") as f:
            f.writelines(modified_lines)
        print(f"Processed: {file_path}")
    else:
        print(f"No changes made to: {file_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python replace_fortran_contiguous.py <file1.ll> <file2.ll> ...")
        sys.exit(1)

    for file in sys.argv[1:]:
        replace_fortran_contiguous(file)
