require_relative 'ara2yml/version'
require 'zip'
require 'mdb'

module Mdb
  class Database
    private
    # monkeypatch in order to strip binary data, that only produces errors
    def open_csv(table)
      command = "mdb-export -bstrip -D '%F %T' -d #{Shellwords.escape(delimiter)} #{file_name} #{table}"
      Open3.popen3(command) do |stdin, stdout, stderr|
        yield CSV.new(stdout, col_sep: delimiter)
      end
    end
  end
end

module Ara2yml
  module_function

  def convert(input, output)
    tempfile = extract_database(input)
    translations = extract_translations(tempfile.path)
    tempfile.unlink
    dump_nice_yaml(translations, output)
  end

  def extract_database(ara_filename)
    tempfile = Tempfile.new('ara2yml')
    tempfile.close
    Zip::File.open(ara_filename) do |zip_file|
      entry = zip_file.entries[0]
      $stderr.puts "Extracting #{entry.name} from #{ara_filename} into #{tempfile.path}"
      entry.extract(tempfile.path) { true }
    end
    tempfile
  end

  def extract_translations(db_filename)
    db = Mdb.open(db_filename)
    language_names = db['LanguageNames'].each_with_object({}) { |e, a|
      a[e[:Id]] = e[:LName].to_sym
    }
    languages = db['Languages'].each_with_object({}) { |e, a|
      a[e[:Id]] = language_names[e[:Id_LanguageName]]
    }
    result = db['Paragraphs'].each_with_object([]) { |e, a|
      if (text = e[:XmlData])
        start = text.index('<text>') + 6
        finish = text.index('</text>')
        text = text[start...finish]
      end
      (a[Integer(e[:PIndex])] ||= {})[languages[e[:Id_Language]]] = text
    }
    result.each_with_index { |v, k|
      if !v || v.values.all?(&:nil?)
        result.delete_at(k)
      elsif v.values.all? { |s| s.strip.length == 0 }
        result[k] = nil
      end
    }
    result
  end

  def dump_nice_yaml(translations, filename)
    File.open(filename, 'w') { |f|
      f.write "---\n"
      translations.each { |e|
        first_key = true
        if e
          f.write '- '
          e.each { |k, v|
            f.write '  ' unless first_key
            f.write ":#{k}: |-\n"
            f.write "    #{v}\n"
            first_key = false
          }
        else
          f.write "-\n"
        end
      }
    }
  end
end
