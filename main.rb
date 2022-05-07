# A generator class
class Generator
  def initialize(sources)
    @sources = sources
    @initialized_constructors = []
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

  def generate_value(field_value)
    case field_value
    when /^random.*/
      # random number in field
      arg = field_value.gsub(/\d+/)
      rand(arg.next.to_i..arg.next.to_i).to_s
    when 'fio'
      # full name (russian)
      initialize_constructor(:fio)
      case rand(0..1)
      when 0
        "#{@surnames_f.sample} #{@names_f.sample} #{@patronymics_f.sample}"
      when 1
        "#{@surnames_m.sample} #{@names_m.sample} #{@patronymics_m.sample}"
      end
    when 'phone_no'
      # mobile phone number (Russia)
      '+7' + ['(963)', '(964)', '(965)', '(903)', '(910)', '(911)', '(985)', '(980)', '(983)'].sample +
        rand(100..999).to_s + '-' + rand(10..99).to_s + '-' + rand(10..99).to_s
    when 'address'
      # Random location
      initialize_constructor(:address)
      "#{@cities.sample}, #{@streets.sample}, #{rand(1..100)}"
    when 'article', 'book', 'textbook', 'novel'
      # Construct a title (header)
      initialize_constructor(field_value.to_sym)
      @headers[field_value.to_sym].inject('') { |acc, elem| acc << elem.sample << ' ' }[0..-2]
    else
      # handle string to regexp random number generator
      number_sub(field_value)
    end
  end

  def initialize_constructor(name)
    return if @initialized_constructors.include?(name)

    case name
    when :fio
      @surnames_f = IO.readlines(@sources[:female_full_name][:surname], chomp: true)
      @names_f = IO.readlines(@sources[:female_full_name][:name], chomp: true)
      @patronymics_f = IO.readlines(@sources[:female_full_name][:patronymic], chomp: true)
      @surnames_m = IO.readlines(@sources[:male_full_name][:surname], chomp: true)
      @names_m = IO.readlines(@sources[:male_full_name][:name], chomp: true)
      @patronymics_m = IO.readlines(@sources[:male_full_name][:patronymic], chomp: true)
    when :address
      @cities = IO.readlines(@sources[:address][:city], chomp: true)
      @streets = IO.readlines(@sources[:address][:street], chomp: true)
    when :article, :book, :textbook, :novel
      @headers = {} if @headers.nil?

      @headers[name] = File.read(@sources[name]).split("\n").each_with_object([]) do |line, acc|
        array_number = line.gsub(/^\d+\//).first.to_i - 1
        acc << [] if acc[array_number].nil?
        acc[array_number] << line.gsub(/\/.*/).first[1..-1].chomp
      end.to_a
    else
      raise 'Unknown constructor for Generator!'
    end

    @initialized_constructors << name
  end

  def inspect
    "Generator\nInitialized constructors:\n#{@initialized_constructors.inspect}"
  end
end

# Record class
class Record
  attr_reader :fields, :values

  def initialize(fields)
    @fields = {}
    fields.map { |field| add_field field }
    @values = {}

    @my_generator = Generator.new({ female_full_name: { surname: 'source/surnames_female.dat',
                                                         name: 'source/names_female.dat',
                                                         patronymic: 'source/patronymics_female.dat' },
                                     male_full_name: { surname: 'source/surnames_male.dat',
                                                       name: 'source/names_male.dat',
                                                       patronymic: 'source/patronymics_male.dat' },
                                     address: { city: 'source/cities.dat',
                                                street: 'source/streets.dat' },
                                     article: 'source/articles.dat',
                                     book: 'source/books.dat',
                                     novel: 'source/novel_books.dat',
                                     textbook: 'source/science_books.dat' })
  end

  def add_field(new_field)
    @fields[new_field[0]] = new_field[1] if new_field.is_a? Array
    @fields.merge! @fields, new_field if new_field.is_a? Hash
  end

  def create_record
    @values = @fields.each_with_object({}) do |field, acc|
      acc[field[0]] = @my_generator.generate_value(field[1])
    end
  end

  def inspect
    "Type: Record\nFields: (Name|type|value)\n" << @fields.inject('') do |acc, field|
      acc << "#{field[0]}|#{field[1]}|#{@values.empty? ? '*empty*' : @values[field[0]]}\n"
    end
  end
end

# File class
class MyFile
  attr_accessor :table_name

  def initialize(file_name, output_type)
    @file_name = file_name # string
    @table_name = 'My_table'

    case output_type # string
    when 'insert'
      @output_type = :insert
    when 'copy'
      @output_type = :copy
    else
      raise 'No such output type!'
    end
  end

  def add_field(field_name, source)
    if @record.nil?
      @record = Record.new({ field_name => source })
    else
      @record.add_field({ field_name => source })
    end
  end

  def inspect
    "Output file: #{@file_name}\nOutput type: #{@output_type}\nFields:\n
    #{@record.nil? ? 'Empty' : @record.fields.inspect}"
  end

  def generate(number)
    raise StandardError, 'Fields were not set!' if @record.fields.nil?

    f = File.new(@file_name, 'w')

    f.write("INSERT INTO \"#{@table_name}\"\n\t(\"#{@record.fields.keys.join('", "')}\")\nVALUES\n") if @output_type == :insert

    number.times do |current_number|
      @record.create_record
      string = record_to_s(@record)
      string << if current_number < number - 1
                  ','
                else
                  ';'
                end if @output_type == :insert
      f.puts(string)
    end

    f.close
  end

  def record_to_s(record)
    case @output_type
    when :insert
      result = '('
      result << record.values.inject('') { |acc, hsh| acc << "'#{hsh[1]}', " }
      result.gsub(/, $/, ')').gsub(/^/, "\t")
    when :copy
      result = record.values.inject('') { |acc, hsh| acc << "#{hsh[1]}|" }
      result.gsub(/\|$/, '')
    end
  end
end
