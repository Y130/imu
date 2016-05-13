function gz(input, output)
	tup.definerule{
		inputs = {input},
		command = "gzip --best -k %f",
		outputs = {output}
	}
end

-- Concatenate a glob match of files.
function join(input, output)
	tup.definerule{
		inputs = input,
		command = "cat "..tostring(input).." > %o",
		outputs = {output}
	}
end

-- Concatenate two files.
function glue(file1, file2, output)
	tup.definerule{
		inputs = {file1, file2},
		command = "cat "..file1.." "..file2.." > %o",
		outputs = {output}
	}
end

function install(input, output)
	local input = tup.glob(input)
	for _ , file in ipairs(input) do
		tup.definerule{
			inputs = {file},
			command = "install -Dm 644 %f %o",
			outputs = {output}
		}
	end
end
