# **7.4. Основы golang**

# *Задача 1. Установите golang.*

Установим GoLang через менеджер пакетов:

```
s_kosenko@linuxvb:~$ sudo apt install golang
Чтение списков пакетов… Готово
Построение дерева зависимостей       
Чтение информации о состоянии… Готово
Следующий пакет устанавливался автоматически и больше не требуется:
  libfwupdplugin1
Для его удаления используйте «sudo apt autoremove».
Будут установлены следующие дополнительные пакеты:
  golang-1.13 golang-1.13-doc golang-1.13-go golang-1.13-race-detector-runtime golang-1.13-src golang-doc golang-go golang-race-detector-runtime
  golang-src
Предлагаемые пакеты:
  bzr | brz mercurial subversion
Следующие НОВЫЕ пакеты будут установлены:
  golang golang-1.13 golang-1.13-doc golang-1.13-go golang-1.13-race-detector-runtime golang-1.13-src golang-doc golang-go
  golang-race-detector-runtime golang-src
...
...
Распаковывается golang-go (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang-doc.
Подготовка к распаковке …/6-golang-doc_2%3a1.13~1ubuntu2_all.deb …
Распаковывается golang-doc (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang.
Подготовка к распаковке …/7-golang_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang (2:1.13~1ubuntu2) …
Выбор ранее не выбранного пакета golang-1.13-race-detector-runtime.
Подготовка к распаковке …/8-golang-1.13-race-detector-runtime_0.0+svn332029-0ubuntu2_amd64.deb …
Распаковывается golang-1.13-race-detector-runtime (0.0+svn332029-0ubuntu2) …
Выбор ранее не выбранного пакета golang-race-detector-runtime.
Подготовка к распаковке …/9-golang-race-detector-runtime_2%3a1.13~1ubuntu2_amd64.deb …
Распаковывается golang-race-detector-runtime (2:1.13~1ubuntu2) …
Настраивается пакет golang-1.13-src (1.13.8-1ubuntu1) …
Настраивается пакет golang-1.13-race-detector-runtime (0.0+svn332029-0ubuntu2) …
Настраивается пакет golang-1.13-go (1.13.8-1ubuntu1) …
Настраивается пакет golang-src (2:1.13~1ubuntu2) …
Настраивается пакет golang-race-detector-runtime (2:1.13~1ubuntu2) …
Настраивается пакет golang-go (2:1.13~1ubuntu2) …
Настраивается пакет golang-1.13-doc (1.13.8-1ubuntu1) …
Настраивается пакет golang-1.13 (1.13.8-1ubuntu1) …
Настраивается пакет golang-doc (2:1.13~1ubuntu2) …
Настраивается пакет golang (2:1.13~1ubuntu2) …
Обрабатываются триггеры для man-db (2.9.1-1) … 
s_kosenko@linuxvb:~$ go version
go version go1.13.8 linux/amd64
s_kosenko@linuxvb:~$ 
```
Более свежую версию GoLang нужно будет устанавливать с официального сайта.

# *Задача 2. Знакомство с gotour.*

Ознакомился с обучающей интерактивной консолью https://tour.golang.org/ и примерами в ней.

# *Задача 3. Написание кода.*
1. Напишите программу для перевода метров в футы.

```
package main

import "fmt"

func main() {
	fmt.Print("Enter a number in meters: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input * 3.28084

	fmt.Println(input, "meters is", output, "feets")
}
```
Результат:

```
go run convert.go 
Enter a number in meters: 5
5 meters is 16.4042 feets
```

2. Напишите программу, которая найдет наименьший элемент в любом заданном списке

```
package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := x[0]
	for _, value := range x {
		if min > value {
			min = value
		}
	}
	fmt.Println("The least value is:", min)
}
```
Результат:

```
go run least.go 
The least value is: 9
```

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3.

```
package main

import "fmt"

func main() {

	var array []int
	for i := 1; i < 100; i++ {
		if (i % 3) == 0 {
			array = append(array, i)
		}
	}
	fmt.Println("Can be divided by 3:", array)
}
```
Результат:

```
go run division.go 
Can be divided by 3: [3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```