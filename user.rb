require './main'

file = MyFile.new('F.out', 'insert')
file.add_field('ФИО', 'fio')
file.add_field('Дата рождения', '%d{1, 28}.%d{1, 12}.%d{1700, 1980}')
file.add_field('Дата смерти', '%d{1, 28}.%d{1, 12}.%d{1740, 2022}')
file.add_field('Ссылка', 'random 1..50')

file.generate(100)
