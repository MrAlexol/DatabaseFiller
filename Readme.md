# Fake Data Generator

This generator was created to fill custom database with random odd records.  
*All data is fictitious. Any similarity to actual persons, living or dead, is purely coincidental.*

## A Ruby Program

This generator allows to make odd records with fake full name, date field, telephone number and address.

### How to use

Use `user.rb` to interact with the generator.

First off all initialize a file with its name and type of output (INSERT or COPY).  
`file = MyFile.new('file.out', 'copy')`  
Give a name to your table if you want to put data into db using `INSERT`.  
`file.table_name = ''Persons'`  
Then add desired fields using:  
`file.add_field(field_name, field_type)`  
Where `field_name` can be any string and `field_type` is one of the following list:

- `fio` will generate full name;
- `phone_no` will generate cell number;
- `address` will generate location;
- `article` will generate fake article title;
- `book` will generate fake book title;
- `textbook` will generate fake textbook title;
- `novel` will generate fake novel title;
- `random a..b` will generate a field with random number from `a` to `b`;
- `%d{x, y}` will be substituted anywhere in string with random number from `x` to `y`.

 *Automatically formed titles can be either funny or rude. Sorry for that.*

At the end type this command:  
`file.generate(n)`  
Here `n` is number of records to generate.

And that's all! Look through the example and start creating.

### Example
The following code will generate records with data collected from source files.
```Ruby
file = MyFile.new('F.out', 'copy')
file.add_field('Full name', 'fio')
file.add_field('Date of birth', '%d{1, 28}.%d{1, 12}.%d{1750, 1775}')
file.add_field('Date of death', '%d{1, 28}.%d{1, 12}.%d{1795, 1825}')
file.add_field('Phone', 'phone_no')
file.add_field('Address', 'address')
file.add_field('Favourite article', 'article')
file.add_field('Favourite book', 'book')
file.add_field('Favourite science book', 'science_book')
file.add_field('Favourite novel', 'novel_book')
file.add_field('Favourite number', 'random 0.1000')
file.generate(10)
```
Output (In Russian):
```
Козлов Руслан Маркович|16.10.1763|21.12.1820|+7(911)217-64-34|Волгоград, Просторная ул., 24|Исследование качества обоняния среди подростков, находящихся в малых городах|Сказка о странствии Гарри Поттера и Полумны Лавгуд под палящим солнцем|Введение в специальность аналитика данных и основы практической теории игр|Приключения моего друга Андрея на вокзале|10
```

## A C# Program

This generator allows to make odd records with fake full name, sex, telephone number, marital status and address.

### How to use

If you want to use *Visual Studio*: 
1. Create a project;
2. Paste the `generate_staff.cs` code there;
3. Move source folder to the following path: `...\bin\Debug\net6.0`;
4. Run the program.

Then answer the questions in the terminal:

```console
How many records do you want to generate?
500
Choose the sex: female or male?
male
```
You can see the result of generation in the file `.out` located on the path: `...\bin\Debug\net6.0`

### Example

Output (In Russian):

```sql
('Потапов Георгий Эдуардович', 'Мужской', '89350863497', 'Не женат', 'Домодедовская ул., 159'),
('Панфилов Максим Эрастович', 'Мужской', '89408900804', 'Не женат', 'Осенняя ул., 82'),
('Борисов Гавриил Филимонович', 'Мужской', '89534121027', 'Не женат', 'Мадридская площадь, 156'),
```
