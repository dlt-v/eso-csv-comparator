local inputFileInitial = arg[1]
local inputFileOther = arg[2]
local outputFile = arg[3]

assert(inputFileInitial, "No initial file supplied!")
assert(inputFileOther, "No second file supplied!")
assert(outputFile, "No output file supplied!")

local IGNORE_LINES = 1
local SPLIT_COUNT = 5
local NEW_LINE = "\n"
local LINE_DELIMITER = ","

local file1 = assert(io.open(inputFileInitial, "rb"))
local file2 = assert(io.open(inputFileOther, "rb"))
local fileContent1 = file1:read("*all")
local fileContent2 = file2:read("*all")

file1:close()
file2:close()

local function split(str, delimeter)

    local splits = {}

    for content in str:gmatch("[^" .. delimeter .. "]+") do
        table.insert(splits, content)
    end

    return splits
end

local function parseCSV(content)

    local result = {}
    local lineIndex = 1
    local lines = split(content, NEW_LINE)

    for _, line in pairs(lines) do

        if (lineIndex > IGNORE_LINES) then
            if (line ~= NEW_LINE) then
                local csv = split(line, LINE_DELIMITER)
                local splitLine = csv[SPLIT_COUNT]
                if (#csv > SPLIT_COUNT) then
                    for iter = SPLIT_COUNT + 1, #csv do
                        splitLine = splitLine .. LINE_DELIMITER .. csv[iter]
                    end
                end
                result[splitLine] = true
            end
        end

        lineIndex = lineIndex + 1
    end

    return result
end

print("Parsing initial...")
local parsedFile1 = parseCSV(fileContent1)
print("Parsing new...")
local parsedFile2 = parseCSV(fileContent2)
local outputFileObj = io.open(outputFile, "a")

print("Finding changes...")
for content in pairs(parsedFile2) do
    if (not parsedFile1[content]) then
        outputFileObj:write(content, NEW_LINE)
    end
end

local removedStringsFile = io.open("removed_" .. outputFile, "a")

print("Finding removed strings...")
for content in pairs(parsedFile1) do
    if (not parsedFile2[content]) then
        removedStringsFile:write(content, NEW_LINE)
    end
end

outputFileObj:close()
removedStringsFile:close()
print("Done!")