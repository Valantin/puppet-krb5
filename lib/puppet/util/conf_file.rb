# frozen_string_literal: true

module Puppet::Util
  class ConfFile
    def initialize(_path, indent_char = ' ', indent_width = nil)
      @indent_char = indent_char
      @indent_width = indent_width&.to_i
      @section_regex = section_regex @path = path
      @key_val_separator = '='
      @section_names = []
      @sections_hash = {}
      parse_file
    end

    def gen(key, values, intent)
      if values.is_a?(Hash)
        s = "#{intent}#{key} = {\n"
        values.each do |k, v|
          s += gen(k, v, "#{intent}\t")
        end
        s += "#{intent}}\n"
      elsif values.is_a?(Array)
        "#{intent}#{key} = #{values.join("\n#{intent}#{key} = ")}\n"
      else
        "#{intent}#{key} = #{values}\n"
      end
    end
  end
end
