require './main'

file = MyFile.new('F.out', 'insert')
file.table_name = 'Персоналии'
file.add_field('ФИО', 'fio')
file.add_field('Дата рождения', '%d{1, 28}.%d{1, 12}.%d{1750, 1775}')
file.add_field('Дата смерти', '%d{1, 28}.%d{1, 12}.%d{1795, 1825}')
file.add_field('Телефон', 'phone_no')
file.add_field('Адрес', 'address')
file.add_field('Любимая статья', 'article')
file.add_field('Любимая книга', 'book')
file.add_field('Любимая научная книга', 'textbook')
file.add_field('Любимый роман', 'novel')
file.add_field('Любимое число', 'random 0.1000')

file.generate(20)
