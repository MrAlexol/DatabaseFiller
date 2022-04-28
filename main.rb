# File class
class MyFile
  def initialize(file_name, output_type)
    @file_name = file_name # string
    # raise StandardError, "File #{@file_name} exists!" if File.exist?(file_name)

    case output_type # string
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

  def record_to_s(record)
    case @output_type
    when :insert
      result = '('
      result << record.inject('') { |acc, hsh| acc << "'#{generate_value(hsh[1])}', " }
      result.gsub(/, $/, ')').gsub(/^/, "\t")
    when :copy
      result = record.inject('') { |acc, hsh| acc << "#{generate_value(hsh[1])}|" }
      result.gsub(/\|$/, '')
    end
  end

  def generate(number)
    raise StandardError, 'Fields were not set!' if @fields.nil?

    f = File.new(@file_name, 'w')

    f.write("INSERT INTO \"my table\"\n\t(\"#{@fields.keys.join('", "')}\")\nVALUES\n") if @output_type == :insert

    number.times do |current_number|
      string = record_to_s(create_record)
      string << if current_number < number - 1
                  ','
                else
                  ';'
                end
      f.puts(string)
    end

    f.close
  end

  protected

  def generate_value(field_value)
    case field_value
    when /^random.*/
      # random number in field
      arg = field_value.gsub(/\d+/)
      rand(arg.next.to_i..arg.next.to_i).to_s
    when 'fio'
      # full name (russian)
      case rand(0..1)
      when 0
        "#{@surnames_f.sample} #{@names_f.sample} #{@patronymics_f.sample}"
      when 1
        "#{@surnames_m.sample} #{@names_m.sample} #{@patronymics_m.sample}"
      end
    else
      # random number in string field
      number_sub(field_value)
    end
  end

  # arrays of full names initialization
  def initialize_arrays
    @surnames_f = IO.readlines('source/surnames_female.dat', chomp: true)
    @names_f = IO.readlines('source/names_female.dat', chomp: true)
    @patronymics_f = IO.readlines('source/patronymics_female.dat', chomp: true)
    @surnames_m = IO.readlines('source/surnames_male.dat', chomp: true)
    @names_m = IO.readlines('source/names_male.dat', chomp: true)
    @patronymics_m = IO.readlines('source/patronymics_male.dat', chomp: true)
  end

  def create_record
    @fields.each_with_object({}) do |field, acc|
      acc[field[0]] = generate_value(field[1])
    end
  end

  def number_sub(key)
    digits = key.gsub(/%d{\d+, *\d+}/)
    rand_numbers = digits.inject([]) do |acc, subplace|
      digit = subplace.gsub(/\d+/)
      acc << rand(digit.next.to_i..digit.next.to_i)
    end
    result = key.clone
    rand_numbers.map { |elem| result.sub!(/%d{\d+, *\d+}/, elem.to_s) }

    result
  end
end
