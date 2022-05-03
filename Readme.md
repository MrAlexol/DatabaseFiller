# Fake Data Generator

This generator was created to fill custom database with random odd records.  
*All data is fictitious. Any similarity to actual persons, living or dead, is purely coincidental.*

## A Ruby Program

This generator allows to make odd records with fake full name, date field, telephone number and address.

### How to use

Use `user.rb` to interact with the generator.

First off all initialize a file with its name and type of output (INSERT or COPY).  
`file = MyFile.new('file.out', 'copy')`  
Then add desired fields using:  
`file.add_field(field_name, field_type)`  
Where `field_name` can be any string and `field_type` is one of the following list:

- `fio` will generate full name in Russian
- `phone_no` will generate Russian cell number
- `address` will generate location in Russian
- `article` will generate fake article name. *It can be either funny or rude. Sorry for that*
- `random a..b` will generate a field with random number from `a` to `b`
- `%d{x, y}` will be substituted anywhere in string with random number from `x` to `y`

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
file.generate(20)
```
Output (In Russian):
```
Козлов Руслан Маркович|16.3.1763|21.8.1820|+7(911)217-64-34|Волгоград, Просторная ул., 24|Исследование качества обоняния среди подростков, находящихся в малых городах
```
