using System;

namespace StreetGeneration
{
    class Program
    {
        const int EmployeeNumber = 200;
        static void Main(string[] args)
        {
            Console.WriteLine("Choose the sex: female or male?");
            string sex = Console.ReadLine();
            string[] surnames = File.ReadAllLines(@$"surnames_{sex}.dat");
            string[] names = File.ReadAllLines(@$"common_names_{sex}.dat");
            string[] patronymics = File.ReadAllLines(@$"patronymics_{sex}.dat");
            string[] information = new string[EmployeeNumber];
            string[] streets = new string[] { "Ясеневая ул.", "Авангардная ул.", "Тверская ул.", "ул. Земляной Вал", "ул. Петровка", "Театральная пл.",
                                              "ул. Кузнецкий мост", "Спартаковская ул.", "Каширское ш.", "Сиреневый бул.", "ул. Арбат", "ул. Новый Арбат",
                                              "Пятницкое ш.", "Митинская ул.", "Балаклавский просп.", "Кировоградская ул.", "Варшавское ш.", "Нахимовский просп.",
                                              "Новочеремушкинская ул.", "Ломоносовкий просп.", "ул. 10-летия Октября", "ул. Крымский Вал", "Смоленская ул.", "ул. 1905 года",
                                              "2-я Бауманская ул.", "Рубцовская наб.", "Госпитальная наб.", "Красноказарменная ул.", "Севанская ул.", "ул. Колобашкина",
                                              "Кантемировская ул.", "Чагинская ул.", "ул. Верхние Поля", "Нагорная ул.", "ул. Капотня", "Ставропольская ул.",
                                              "Тихая ул.", "ул. Кухмистерова", "Нагатинская наб.", "просп. Лихачёва", "Автозаводская ул.", "ул. Варварка",
                                              "ул. Ильинка", "Софийская наб.", "Садовническая ул.", "Болотная ул.", "Кремлевская наб.", "ул. Большая Любянка",
                                              "Мясницкая ул.", "ул. Дурова", "Стрелецкая ул.", "ул. Фонвизина", "Уссурийская ул.", "Алтайская ул.", "Курганская ул.",
                                              "Щёлковское ш.", "Первомайская ул.", "ул. Золоторжский Вал", "ул. Свободы", "ул. Тюрина", "Шипиловский просп.",
                                              "ул. Пресненский Вал.", "Октябрьский пер.", "Трифоновская ул.", "Пантелеевская ул.", "Аманьевский пер.", "Сретенский бул.",
                                              "Пятницкая ул.", "ул. Большая Ордынка", "ул. Малая Ордынка", "ул. Большая Полянка", "Донская ул.", "Домодедовская ул.",
                                              "Красносельяская ул.", "Скорняжный пер."};

            //Создание объекта для генерации чисел
            Random rnd = new Random();

            // Environment.CurrentDirectory = .\....\StreetGeneration\bin\Debug\net6.0
            string path = @$"{sex}.txt";
            FileInfo fileInf = new FileInfo(path);
            if (fileInf.Exists)
                fileInf.Delete();
            for (int i = 0; i < EmployeeNumber; i++)
            {
                string surname = surnames[rnd.Next(surnames.Length)];
                string name = names[rnd.Next(names.Length)];
                string patronymic = patronymics[rnd.Next(patronymics.Length)];

                string sexRu;
                if (sex == "female") sexRu = "Женский";
                else sexRu = "Мужской";

                string phoneNumber = "89";
                for (int j = 0; j < 9; j++)
                {
                    int phoneDigit = rnd.Next(10);
                    phoneNumber += phoneDigit.ToString();
                }

                string family;
                int familyNumber = rnd.Next(21);
                switch (familyNumber)
                {
                    case < 8:
                        if (sex == "female")
                            family = "Не замужем";
                        else family = "Не женат";
                        break;
                    case < 15:
                        if (sex == "female")
                            family = "Замужем";
                        else family = "Женат";
                        break;
                    case < 20:
                        if (sex == "female")
                            family = "Разведена";
                        else family = "Разведен";
                        break;
                    default:
                        if (sex == "female")
                            family = "Вдова";
                        else family = "Вдовец";
                        break;
                }

                string address;
                int value = rnd.Next(400) + 1;
                int streetIndex = rnd.Next(0, streets.Length);
                address = $"{streets[streetIndex]}, {value}";

                if (i == EmployeeNumber - 1)
                    information[i] = $"(\'{surname} {name} {patronymic}\', \'{sexRu}\', \'{phoneNumber}\', \'{family}\', \'{address}\');";
                else
                    information[i] = $"(\'{surname} {name} {patronymic}\', \'{sexRu}\', \'{phoneNumber}\', \'{family}\', \'{address}\'),";
            }
            File.WriteAllLines(path, information);
        }
    }
}