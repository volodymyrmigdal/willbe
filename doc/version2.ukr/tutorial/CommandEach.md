# Як користуватись командою <code>.each</code>

Команда <code>.each</code> для виконання одної дії для багатьох модулів чи підмодулів.

Для роботи з декількома модулями, використовуйте [команду `.each`](../concept/Command.md#Таблиця-команд-утиліти-willbe), котра виконує вказану фразу для кожного `вілфайла` в зазначеній директорії. 

Для вводу команди використовуйте синтаксис `will .each [dir] [command] [argument]`, де `[dir]` - директорія з `вілфайлами`; `[command]` - команда для файлів в директорії; `[argument]` - аргумент команди, якщо він необхідний. Для всіх `вілфайлів` застосовується один аргумент, для запобігання помилок використовуйте ґлоби. 

### Використання команди `.each`

<details>
  <summary><u>Файлова структура</u></summary>

```  
named
  ├── proto
  │     └── file.txt
  ├── submodule.will.yml
  ├── export.will.yml
  └── .will.yml       

```

</details>

Для дослідження команди `.each` cтворіть приведену вище структуру файлів. Внесіть код в відповідні `вілфайли`.

<details>
    <summary><u>Код файла <code>.will.yml</code></u></summary>

```yaml
about :

  name : deleteOut
  description : "To test .each command"

path :

  fileToDelete :
    path : 'out'

step  :

  delete.out :
    inherit : files.delete
    filePath : path::fileToDelete

build :

  delete.out :
    criterion :
      default : 1
    steps :
      - delete.*

```

</details>

Файл `.will.yml` призначений для видалення директорії `out`. Збірка `delete.out` встановлена за замовчуванням.  

<details>
    <summary><u>Код <code>submodule.will.yml</code></u></summary>

```yaml
about :

  name : submodules
  description : "To test .each command"
  version : 0.0.1

submodule :

  PathBasic : git+https:///github.com/Wandalen/wPathBasic.git/out/wPathBasic#master

build :

  download :
    criterion :
      default : 1
    steps :
      - submodules.download

```

</details>

В збірці `download`, що встановлена за замовчуванням, проходить завантаження віддаленого підмодуля `PathBasic`.

<details>
    <summary><u>Код <code>export.will.yml</code></u></summary>

```yaml
about :

  name : export
  description : "To test .each command"
  version : 0.0.1

path :

  out : 'out'
  proto : 'proto'

step :

  export :
    inherit : module.export
    export : path::proto

build :

  proto.export :
    criterion :
      export : 1
      default : 1
    steps :
      - step::export

```

</details>

Файл `export.will.yml` призначений для експортування файлів модуля з директорії `proto`.

### Виконання побудов

<details>
  <summary><u>Вивід команди <code>will .each . .build</code></u></summary>

```
[user@user ~]$ will .each . .build
...
Module at /path_to_file/.will.yml
 . Read : /path_to_file/.will.yml
 . Read 1 will-files in 0.924s

    Building module::deleteOut / build::delete.submodule
     - filesDelete 0 files at /path_to_file/out in 0.002s
    Built module::deleteOut / build::delete.submodule in 0.108s

...

    Building module::export / build::export
     + Write out archive /path_to_file/ : out/export.out.tgs <- proto
     + Write out will-file /path_to_file/out/export.out.will.yml
     + Exported export with 2 files in 2.311s
    Built module::export / build::export in 2.363s

...

    Building module::submodules / build::download
       . Read : /path_to_file/.module/PathBasic/out/wPathBasic.out.will.yml
       + module::PathBasic version master was downloaded in 5.974s
     + 1/1 submodule(s) of module::submodules were downloaded in 5.981s
    Built module::submodules / build::download in 6.019s

```
</details>

Введіть фразу `will .each . .build` для виконання побудов в директорії з файлами. 

Першою побудовою було видалення директорії `out`, яка на момент виконання не існувала. Далі, команда `.each` запустила експорт з файла `export.will.yml`. Після виконання експорту, в директорію `out` поміщено `out-вілфайл` та архів з файлами модуля. Останнім було запущено файл `submodule.will.yml` та завантажено підмодуль в директорію `.module`. Тобто, команда `.each` запускає `вілфайли` згідно алфавітного порядку. Тому, якщо вам потрібно послідовно виконати декілька дій над спільними файлами модулів, прослідкуйте за чергуванням назв іменованих `вілфайлів`.  

Згідно виводу консолі, структура модуля має наступний вигляд:

<details>
  <summary><u>Файлова структура після побудов</u></summary>

```  
named
  ├── .module
  │     └── PathBasic
  ├── proto
  │     └── file.txt
  ├── out
  │     ├── export.out.will.tgs
  │     └── export.out.will.yml
  ├── submodule.will.yml
  ├── export.will.yml
  └── .will.yml       

```

</details>

Команда `.each` може виконати будь-яку іншу команду утиліти над групою модулів. Та особливого значення вона набуває для команди `.shell`. Щоб дізнатись більше про призначення і особливості  команди `.shell` пройдіть [туторіал](CommandShell.md).

### Підсумок  

- Команда `.each` працює з групою `вілфайлів`.
- Команда `.each` виконує команди як з іменованими так і неіменованими `вілфайлами`.
- Команда `.each` виконує фразу над `вілфайлами ` в алфавітному порядку.

[Повернутись до змісту](../README.md#tutorials)
