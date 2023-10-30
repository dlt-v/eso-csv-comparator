import csv
import sys

def parse_csv(file_path, split_count):
    with open(file_path, 'r', encoding='utf-8') as file:  # Specify the encoding here
        reader = csv.reader(file)
        results = {}
        for index, row in enumerate(reader):
            if index == 0:  # Skip header
                continue
            content = ','.join(row[split_count - 1:])
            results[content] = True
        return results

def main():
    if len(sys.argv) < 4:
        print("Usage: python script_name.py inputFileInitial inputFileOther outputFile")
        sys.exit(1)

    input_file_initial = sys.argv[1]
    input_file_other = sys.argv[2]
    output_file = sys.argv[3]
    split_count = 5  # Same as in the Lua code

    print("Parsing initial...")
    parsed_file_initial = parse_csv(input_file_initial, split_count)
    
    print("Parsing new...")
    parsed_file_other = parse_csv(input_file_other, split_count)

    print("Finding differences...")
    with open(output_file, 'w') as out_file:
        for content in parsed_file_other:
            if content not in parsed_file_initial:
                out_file.write("Added: " + content + "\n")

        for content in parsed_file_initial:
            if content not in parsed_file_other:
                out_file.write("Removed: " + content + "\n")

    print("Done!")

if __name__ == "__main__":
    main()
