-- Writes inlined SVG images from $dest/inline to an HTML file.
-- '/bin/echo' avoids problematic shell built-ins.
function inline_img(dest, output)
	tup.definerule{
		inputs = {dest.."/inline/*"},
		command = [[
		/bin/echo -e "<svg style='display: none;'>" >> %o;
		for img in ]]..dest..[[/inline/*.svg; do
			var=`basename $img |sed -e 's@\..*$@@'`;
			if [ ! "$var" = '*' ]; then
				/bin/echo -e "<symbol viewbox='0 0 1792 1792' id='svg-$var'>" >> %o;
				path=`cat $img |grep -oP 'd="[^"]+"' |grep -oP '"[^"]+"' |grep -oP '[^"]+'`;
				/bin/echo -e "<path d='$path'></path>" >> %o;
				/bin/echo -e "</symbol>" >> %o;
			fi;
		done;
		/bin/echo -e "</svg>" >> %o;
		]],
		outputs = {output}
	}
end
