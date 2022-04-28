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
            string[] surnames = File.ReadAllLines(@$"source\surnames_{sex}.dat");
            string[] names = File.ReadAllLines(@$"source\common_names_{sex}.dat");
            string[] patronymics = File.ReadAllLines(@$"source\patronymics_{sex}.dat");
            string[] information = new string[EmployeeNumber];
            string[] streets = File.ReadAllLines(@$"source\streets.dat");

            //Создание объекта для генерации чисел
            Random rnd = new Random();

            // Environment.CurrentDirectory = .\....\StreetGeneration\bin\Debug\net6.0
            string path = @$"{sex}.out";
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