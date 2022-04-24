# File class
class MyFile
  def initialize(file_name, output_type)
    @file_name = file_name # string
    # raise StandardError, "File #{@file_name} exists!" if File.exist?(file_name)

    case output_type
    when 'insert'
      @output_type = :insert
    when 'copy'
      @output_type = :copy
    else
      raise StandardError, 'No such output type!'
    end

    initialize_arrays
  end

  def add_field(field_name, source)
    @fields = {} if @fields.nil?

    @fields.merge! @fields, { field_name => source }
  end

  def inspect
    "Output file: #{@file_name}\nOutput type: #{@output_type}\nFields:\n#{@fields.inspect}"
  end

  def generate(number)
    raise StandardError, 'Fields were not set!' if @fields.nil?

    f = File.new(@file_name, 'w')

    case @output_type
    when :insert
      f.write("INSERT INTO \"my table\"\n\t(\"#{@fields.keys.join('", "')}\")\nVALUES\n")
    when :copy

    end

    # record = @fields.inject('') { |acc, hsh| acc << "#{generate_value(hsh[1])}#{delim}" }
    number.times do |current_number|
      case @output_type
      when :insert
        record = "\t("
        record << @fields.inject('') { |acc, hsh| acc << "'#{generate_value(hsh[1])}', " }
        record.gsub!(/, $/, '),')
        record.gsub!(/,$/, ';') if current_number == number - 1
      when :copy
        record = @fields.inject('') { |acc, hsh| acc << "#{generate_value(hsh[1])}|" }
        record.gsub!(/\|$/, '')
      end
      f.puts(record)
    end

    f.close
  end

  protected

  def generate_value(key)
    case key
    when /^random.*/
      arg = key.gsub(/\d+/)
      rand(arg.next.to_i..arg.next.to_i).to_s
    when 'fio'
      case rand(0..1)
      when 0
        "#{@surnames_f.sample} #{@names_f.sample} #{@patronymics_f.sample}"
      when 1
        "#{@surnames_m.sample} #{@names_m.sample} #{@patronymics_m.sample}"
      end
    else
      # random number
      digits = key.gsub(/%d{\d+, *\d+}/)
      rand_numbers = digits.inject([]) do |acc, subplace|
        digit = subplace.gsub(/\d+/)
        acc << rand(digit.next.to_i..digit.next.to_i)
      end
      result = key.clone
      rand_numbers.map { |elem| result.sub!(/%d{\d+, *\d+}/, elem.to_s) }

      # known field
      # TODO
      result
    end
  end

  def initialize_arrays
    @surnames_f = IO.readlines('surnames_female.dat', chomp: true)
    @names_f = IO.readlines('names_female.dat', chomp: true)
    @patronymics_f = IO.readlines('patronymics_female.dat', chomp: true)
    @surnames_m = IO.readlines('surnames_male.dat', chomp: true)
    @names_m = IO.readlines('names_male.dat', chomp: true)
    @patronymics_m = IO.readlines('patronymics_male.dat', chomp: true)
  end
end
