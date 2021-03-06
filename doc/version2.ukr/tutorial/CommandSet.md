# Командa <code>.set</code>

Як користуватись командою <code>.set</code> для зміни станів утиліти, наприклад, для зміни рівня вербальності.
  
Утиліта `willbe` призначена для побудови модульних систем, а взаємодія з нею здійснюється через командний рядок. До цього моменту внутрішні процеси роботи утиліти при побудові модуля були приховані, а з командою `.set` можливо прослідкувати і за ними.  

[Команда `.set`](../concept/Command.md#Таблиця-команд-утиліти-willbe) призначена для зміни внутрішніх станів (налаштувань) утиліти. Наприклад, `willbe` може встановити параметр `verbosity`, який відповідає за вивід сервісної інформації виконання команди. 

Для використання команди введіть `will .imply verbosity:[n] ; [command] [argument]` (в деяких терміналах  ввід з лапками - `will ".imply verbosity:[n] ; [command] [argument]"`), де `verbosity` - відповідно, деталізація виводу; `[n]` - число від 0 до 9 яке встановлює ступінь деталізації, 9 - найвищий ступінь; `[command]` - команда для якої виводиться інформація виконання; `[argument]` - аргумент команди, якщо він необхідний.  

### Дослідження команди `.set` 

<details>
  <summary><u>Структура модуля</u></summary>

```
setCommand
     └── .will.yml

```

</details>

Створіть приведену конфігурацію файлів для дослідження параметру `verbosity` в команді `.set`. 

<details>
    <summary><u>Код файла <code>.will.yml</code></u></summary>

```yaml
about :

  name : setVerbosity
  description : "To use .imply command"
  version : 0.0.1

submodule :
  PathBasic : git+https:///github.com/Wandalen/wPathBasic.git/out/wPathBasic#master

path :

  out : 'out'
  submodule.pathfundamental : '.module/PathBasic'

step  :

  export.submodule :
    export : path::submodule.*

build :

  submodules.download :
    criterion :
      default : 1
    steps :
      - submodules.download

  submodules.export :
    criterion :
      export : 1
      default : 1
    steps :
      - export.*

```

</details>

Помістіть в файл `.will.yml` код, що приведений вище. 

В `вілфайлі` поміщено два сценарії. Перший, з назвою `submodules.download`, для завантаження віддалених підмодулів, а другий, з назвою `submodules.export` - для експорту файлів з директорії підмодуля `PathBasic`.  

<details>
    <summary><u>Вивід команди <code>will .imply verbosity:9 ; .build</code></u></summary>

```
[user@user ~]$ will ".imply verbosity:9 ; .build"
Command ".imply ; .build"
 s module::/path_to_module/UsingSetCommand preformed 1
 s module::/path_to_module/UsingSetCommand preformed 2
 s module::/path_to_module/UsingSetCommand preformed 3
 s module::/path_to_module/UsingSetCommand willFilesFound 1
 s module::/path_to_module/UsingSetCommand willFilesFound 2
Trying to open /path_to_module/UsingSetCommand.will
Trying to open /path_to_module/UsingSetCommand.im.will
Trying to open /path_to_module/UsingSetCommand.ex.will
Trying to open /path_to_module/UsingSetCommand/.will
Trying to open /path_to_module/UsingSetCommand/.im.will
Trying to open /path_to_module/UsingSetCommand/.ex.will
 s module::/path_to_module/UsingSetCommand willFilesFound 3
 s module::/path_to_module/UsingSetCommand willFilesOpened 1
 s module::/path_to_module/UsingSetCommand willFilesOpened 2
   . Read : /path_to_module/UsingSetCommand/.will.yml
 . Read 1 will-files in 0.081s
 s module::setVerbosity willFilesOpened 3
 s module::setVerbosity submodulesFormed 1
 s module::setVerbosity submodulesFormed 2
 s module::PathBasic preformed 1
 s module::PathBasic preformed 2
 s module::PathBasic preformed 3
 s module::PathBasic willFilesFound 1
 s module::PathBasic willFilesFound 2
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.im.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.ex.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.out.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.out.im.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.out.ex.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.im.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.ex.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.im.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic/.ex.will
 !s module::PathBasic willFilesFound failed
 s module::PathBasic willFilesOpened 1
 !s module::PathBasic willFilesOpened failed
 s module::PathBasic submodulesFormed 1
 !s module::PathBasic 3 failed
 s module::PathBasic resourcesFormed 1
 !s module::PathBasic resourcesFormed failed
 s module::setVerbosity resourcesFormed 1
 ! Failed to read submodule::PathBasic, try to download it with .submodules.download or even clean it before downloading
Failed to open submodule::PathBasic at "/path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic"
Found no .out.will file for module::setVerbosity at "/path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic"             
 s module::setVerbosity submodulesFormed 3
 s module::setVerbosity resourcesFormed 2
 s module::setVerbosity resourcesFormed 3

  Building submodules.download
     - filesDelete 1 files at /path_to_module/UsingSetCommand/.module/PathBasic in 0.017s
 > git clone https://github.com/Wandalen/wPathBasic.git/ .
Cloning into '.'...
 > git checkout master
Already on 'master'
Your branch is up-to-date with 'origin/master'.
 > git merge
Already up-to-date.
     + Reflect 92 files /path_to_module/UsingSetCommand/.module/PathBasic <- git+https:///github.com/Wandalen/wPathBasic.git/out/wPathBasic#master in 3.612s
 s module::PathBasic willFilesFound 1
 s module::PathBasic willFilesFound 2
    Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.will
    Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.im.will
    Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.ex.will
 s module::PathBasic willFilesFound 3
 s module::PathBasic willFilesOpened 1
 s module::PathBasic willFilesOpened 2
     . Read : /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.will.yml
 s module::PathBasic willFilesOpened 3
 s module::PathBasic submodulesFormed 1
 s module::PathBasic submodulesFormed 2
 s module::PathBasic submodulesFormed 3
 s module::PathBasic resourcesFormed 1
 s module::PathBasic resourcesFormed 2
 s module::PathBasic resourcesFormed 3
     + module::PathBasic was downloaded in 4.276s
   + 1/1 submodule(s) of module::setVerbosity were downloaded in 4.282s
  Built submodules.download in 4.326s

```

</details>

Запустіть побудову завантаження підмодулів з найвищим рівнем вербальності (`will .imply verbosity:9 ; .build`). Порівняйте результати виводу з приведеними вище.

Вивід команди з найвищим рівнем вербальності показує всі етапи виконання. Починається з підготовки `вілфайла`, зчитування інформації про підмодулі і лише після цього, побудова. На етапі побудови також виводиться додаткова інформація про завантаження підмодуля і зчитування його `вілфайлів`.

<details>
  <summary><u>Структура модуля після побудови</u></summary>

```
setCommand
     ├── .module
     └── .will.yml

```

</details>

Після побудови в модулі з'явилась директорія `.module` з віддаленим підмодулем `PathBasic`.

<details>
    <summary><u>Вивід команди <code>will .imply verbosity:4 ; .export</code></u></summary>

```
[user@user ~]$ will .imply verbosity:4 ; .export
Command ".imply ; .export"
Trying to open /path_to_module/UsingSetCommand.will
Trying to open /path_to_module/UsingSetCommand.im.will
Trying to open /path_to_module/UsingSetCommand.ex.will
Trying to open /path_to_module/UsingSetCommand/.will
Trying to open /path_to_module/UsingSetCommand/.im.will
Trying to open /path_to_module/UsingSetCommand/.ex.will
   . Read : /path_to_module/UsingSetCommand/.will.yml
 . Read 1 will-files in 0.104s
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.im.will
Trying to open /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.ex.will
 . Read : /path_to_module/UsingSetCommand/.module/PathBasic/out/wPathBasic.out.will.yml

  Exporting submodules.export
     . Read : /path_to_module/UsingSetCommand/out/setVerbosity.out.will.yml
   . Read 1 will-files in 0.195s
   + Write out archive /path_to_module/UsingSetCommand/ : out/setVerbosity.out.tgs <- .module/PathBasic
   + Write out will-file /path_to_module/UsingSetCommand/out/setVerbosity.out.will.yml
   + Exported submodules.export with 46 files in 2.423s
  Exported submodules.export in 2.467s

```

</details>

Експортуйте модуль зі значенням `verbosity:4`.

Вивід інформації розширений, але не такий повний. Переважно виводиться інформація про підготовчий етап побудови. 

<details>
  <summary><u>Структура модуля після експорту</u></summary>

```
setCommand
     ├── out
     ├── .module
     └── .will.yml

```

</details>

Перегляньте зміни в структурі файлів. В модулі додатково згенерована директорія `out` з експортованими файлами.

<details>
    <summary><u>Вивід команди <code>will .imply verbosity:0 ; .build</code></u></summary>

```
[user@user ~]$ will .imply verbosity:0 ; .build
Command ".imply ; .build"
 . Read 1 will-files in 0.082s

```

</details>

Видаліть підмодулі (`will .submodules.clean` або `rm -Rf .module`) та завантажте з встановленим `verbosity:0`.  

Зі зменшенням величини параметра `verbosity` зменшувалась кількість рядків виводу результатів команди в консоль, а при `verbosity:0` утиліта взагалі не вивела повідомлень.

<details>
  <summary><u>Структура модуля після вводу <code>will .imply verbosity:0 ; .build</code></u></summary>

```
setCommand
     ├── out
     ├── .module
     └── .will.yml

```

</details>

Перегляньте вміст директорії модуля. Навіть без приведеного виводу в консолі утиліта завантажила віддалений підмодуль в директорію `.module`.

### Підсумок

- Для зміни станів утиліти (налаштувань) використовується команда `.set`.
- Команда `.set` може встановити параметр `verbosity`, який контролює рівень вербальності виводу консолі - кількість виводу сервісної інформації про виконання команди. 
- Найвищий рівень вербальності - "9". Утиліта виводить максимум сервісної інформації.
- Найнижчий рівень вербальності - "0". Утиліта не виводить інформацію про побудову.
- Встановлення параметра `verbosity` корисне при відладці модулів.
  
[Повернутись до змісту](../README.md#tutorials)
