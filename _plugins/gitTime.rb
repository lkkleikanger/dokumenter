require 'git'

module Jekyll
  class RenderTimeTag < Liquid::Tag
 
    def initialize(tag_name, text, tokens)
      super
      # We now can adquire the options for this liquid tag
      @p = { "folder" => Dir.getwd, "tag" => "HEAD", "format" => "%d.%m.%y %H:%M"  }
      text.gsub("  ", " ").split(" ").each do |part|
        if part.split("=").count != 2
          raise SyntaxError.new("Syntax Error in tag 'git_changed_time'")
        end
        var,val = part.split("=")
        @p[var] = val
      end
    end
 
    def render(context)
	open = false
	tag = @p["tag"]

	filename = context['page.path']

	if tag != "HEAD"
		tag = context[@p["tag"]]
		if filename.start_with?(tag)
			filename[tag + "/"] = ''
		end
	end

	#get log info
	begin
		wd = Dir.getwd
		gitDate = `git --git-dir=#{wd}/.git log #{tag} -1 --format="%ad" -- #{filename} 2>&1`

		theDate = DateTime.parse(gitDate)
		returnDate = theDate.strftime(@p["format"])
	rescue => e
		returnDate = e.message
	end

      	"#{returnDate}"
    end

  end
end
 
Liquid::Template.register_tag('git_changed_time', Jekyll::RenderTimeTag)