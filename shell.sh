#!/bin/bash

input_file="input.csv"
output_file="output.csv"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file $input_file not found."
    exit 1
fi

# Create or truncate the output file
> "$output_file"

# Function to extract category from URL
get_category() {
    local url=$1
    local category=$(echo "$url" | awk -F'/' '{print $4}')
    echo "$category"
}

# Process the CSV file
while IFS=, read -r url title; do
    # Sanitize title (remove leading/trailing spaces)
    title=$(echo "$title" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')

    # Skip empty lines
    if [ -z "$url" ]; then
        continue
    fi

    # Extract category from URL
    category=$(get_category "$url")

    # Print category header if not already printed
    if [ ! -f "$output_file" ] || ! grep -q "$category" "$output_file"; then
        echo -e "\n$category" >> "$output_file"
    fi

    # Print URL and title
    echo -e "$url\n$title" >> "$output_file"

done < "$input_file"

echo "Output written to $output_file"

