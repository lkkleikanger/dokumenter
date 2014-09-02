require 'git'

module Jekyll
  class GitActivityTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      # We now can adquire the options for this liquid tag
      @p = { "github" => "", "folder" => "" }
      text.gsub("  ", " ").split(" ").each do |part|
        if part.split("=").count != 2
          raise SyntaxError.new("Syntax Error in tag 'gitactivity'")
        end
        var,val = part.split("=")
        @p[var] = val
      end
    end

    def render(context)
      result = ""
      if @p["folder"].length > 0 
      	g = Git.open(Dir.getwd << "/" << @p["folder"])
      else
      	g = Git.open(Dir.getwd)
      end
      	
      lTag = ""
      idx = 0
      date = ""

      # list all between tags
      result << "<h3>" 
      result << "Arbeidsversjon" 
      result << "</h3>"

      if g.tags.count > 0
        commits = g.log(1000).between(g.tags.last)
      else
        commits = g.log(1000)
      end

      commits.each do |log|
          if date != log.date.strftime("%d %b %y")
            result << "<h4>" << log.date.strftime("%d %b %y") << "</h4>"
            date = log.date.strftime("%d %b %y")
          end 
          result << "<li>" 
          result << log.date.strftime("%H:%M")
          result << " - <a href='" << @p["github"] << "/commit/"
          result << log.sha
          result << "/'>"
          result << log.message.gsub(/\n/, "")
          result << "</a>" << " by " << log.author.name << "</li>"
      end

      g.tags.reverse.each.with_index do |tag, idx|
      	result << "<h3>" 
      	result << tag.name 
      	result << "</h3>"
        lTag = g.tags.reverse[idx + 1]

      	tag.log(1000).between(lTag, tag).each do |log|          
          if date != log.date.strftime("%d %b %y")
          	result << "<h4>" << log.date.strftime("%d %b %y") << "</h4>"
          	date = log.date.strftime("%d %b %y")
          end 
          result << "<li>" 
          result << log.date.strftime("%H:%M")
          result << " - <a href='" << @p["github"] << "/commit/"
          result << log.sha
          result << "/'>"
          result << log.message.gsub(/\n/, "")
          result << "</a>" << " by " << log.author.name << "</li>"
        end      
        lTag = tag.name
      end            
      
      "#{result}"
    end
  end
end

Liquid::Template.register_tag('gitactivity', Jekyll::GitActivityTag)