require './main'

file = MyFile.new('F.out', 'copy')
file.add_field('Номер', 'random 1..20')
file.add_field('ФИО', 'fio')
file.add_field('Информация', 'Телефон: %d{20, 500}-%d{10, 50}')

file.generate(100)