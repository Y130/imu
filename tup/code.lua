
function csso(input, output)
	tup.definerule{
		inputs = {input},
		command = "csso --comments none -o %o -i %f",
		outputs = {output}
	}
end

function sass(input, output)
	tup.definerule{
		inputs = {input},
		command = "node-sass %f %o",
		outputs = {output}
	}
end

function buble(input, output)
	tup.definerule{
		inputs = {input},
		command = "buble %f > %o",
		outputs = {output}
	}
end

function rollup(app, output)
	local file =  app..".js"
	tup.definerule{
		inputs = {
			file,
			app.."/*.js",
		},
		command = "rollup -f es "..file.." > %o",
		outputs = {output}
	}
end

function uglifyjs(input, output)
	tup.definerule{
		inputs = {input},
		command = "uglifyjs -c --keep-fnames -b beautify=false,max-line-len=0 -o %o %f",
		outputs = {output}
	}
end

-- ECMASCRIPT5 required by Vue.js.
function closurecc(input, output)
	tup.definerule{
		inputs = {input},
		command = "closure-compiler --language_out ES5 %f > %o",
		outputs = {output}
	}
end

function autoprefix(input, output)
	tup.definerule{
		inputs = {input},
		command = "postcss -u autoprefixer -o %o %f",
		outputs = {output}
	}
end

function htmlminifier(input, output)
	tup.definerule{
		inputs = {input},
		command =
		[[html-minifier --case-sensitive --collapse-whitespace \
			--conservative-collapse --remove-attribute-quotes \
			--remove-comments --remove-optional-tags \
			--process-scripts "x/templates" \
			--remove-redundant-attributes -o %o %f
		]],
		outputs = {output}
	}
end
