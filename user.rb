require './main'

file = MyFile.new('F.out', 'copy')
file.add_field('ФИО', 'fio')
file.add_field('Дата рождения', '%d{1, 28}.%d{1, 12}.%d{1750, 1775}')
file.add_field('Дата смерти', '%d{1, 28}.%d{1, 12}.%d{1795, 1825}')
file.add_field('Телефон', 'phone_no')
file.add_field('Адрес', 'address')
file.add_field('Любимая статья', 'article')

file.generate(20)
