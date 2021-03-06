# Фільтри рефлектора

Використання фільтрів рефлектора для відбору файлів для копіювання. 

З допомогою [мапи шляхів](ReflectorMapPaths.md#) в полі `filePath` здійснюється відбір за іменем файлів. При цьому поле `filePath` може записуватись самостійно, а також бути розділеним між полями фільтрів `src` i `dst`. Проте, рефлектори мають додаткові можливості по відбору файлів - файлові фільтри, які використовуються виключно в полях `src` i `dst`.  

### Структура модуля 

<details>
  <summary><u>Структура файлів</u></summary>

```
fileFilters
     ├── proto
     │     ├── proto.two
     │     │     └── script.js
     │     ├── files
     │     │     ├── manual.md
     │     │     └── tutorial.md
     │     ├── build.txt.js
     │     └── package.json   
     └── .will.yml       

```

</details>

Створіть приведену конфігурацію файлів для дослідження фільтрів рефлектора.  

### Прості фільтри рефлектора  

Рефлектори мають декілька видів фільтрів, одним з яких є прості. Прості фільтри використовуються для сортування файлів за назвою та розширенням.  

До простих фільтрів відносяться:  
`begins` - виключає з вибірки файли, назва яких не починається з указаного в фільтрі слова.  
`ends` - виключає з вибірки файли, назва яких не закінчується на вказане в фільтрі слово.  
`hasExtension` - виключає з вибірки файли, які не мають вказаного розширення. Розширення файла може бути складним і утиліта `willbe` зчитує його, починаючи з першої крапки в назві файла. Наприклад, файл `somefile.txt.md` має два розширення - `.txt` i `.md`.  

##### Фільтр `begins`

<details>
  <summary><u>Код файла <code>.will.yml</code></u></summary>

```yaml

about :
  name : filters
  description : "To use reflector filter"
  version : 0.0.1

path :

  in : '.'
  out : 'out'
  proto : './proto'
  out.debug :
    path : './out/debug'
    criterion :
      debug : 1
  out.release :
    path : './out/release'
    criterion :
      debug : 0

reflector :

  reflect.copy.:
    recursive: 2
    src:
      filePath: ./proto
      begins:
        - 'pac'
        - 'file'
    dst:
      filePath: path::out.*=1
    criterion:
      debug: [ 0,1 ]

step :

  reflect.copy :
    inherit : files.reflect
    reflector : reflect.*
    criterion :
       debug : [ 0,1 ]

build :

  copy :
    criterion :
      debug : [ 0,1 ]
    steps :
      - reflect.*

```

</details>

Для вибору файлів, які починаються на `pac` та `file`, помістіть в файл `.will.yml` приведений вище код. 

<details>
  <summary><u>Вивід команди <code>will .build copy.</code></u></summary>

```
[user@user ~]$ will .build copy.
...
 Building copy.
   + reflect.copy. reflected 5 files /path_to_file/ : out/release <- proto in 0.416s
  Built copy. in 0.463s

```

</details>

Запустіть реліз-побудову командою `will .build copy.`. Порівняйте вивід команди і зміни в структурі модуля після побудови.

<details>
  <summary><u>Структура модуля після побудови</u></summary>

```
fileFilters
     ├── proto
     │     ├── proto.two
     │     │     └── script.js
     │     ├── files
     │     │     ├── manual.md
     │     │     └── tutorial.md
     │     ├── build.txt.js
     │     └── package.json  
     ├── out
     │     └── release
     │            ├── files
     │            │     ├── manual.md
     │            │     └── tutorial.md
     │            └── package.json  
     └── .will.yml       

```

</details>

Рефлектор скопіював файли з відповідними назвами - директорію `filel` і файл `package.json`. Відповідно опції `recursive` скопійована директорія `files` включає файли `manual.md` i `tutorial.md`.  

##### Фільтр `ends`

Щоб використати відбір за закінченням назви файла використовується фільтр `ends`.    

<details>
  <summary><u>Секція <code>reflector</code> з фільтром <code>ends</code></u></summary>

```yaml
reflector :

  reflect.copy.:
    recursive: 2
    src:
      filePath: ./proto
      ends: 'js'
    dst:
      filePath: path::out.*=1
    criterion:
      debug: [ 0,1 ]

```

</details>

Змініть секцію `reflector` в `вілфайлі` як в приведеному прикладі. 

Фільтр, згідно опції `recursive`, буде шукати всі файли, які закінчуються на `js`. При цьому, не важливо, чи це буде розширення, чи закінчення назви директорії `nodejs`.   

<details>
  <summary><u>Вивід команди <code> will .build copy.debug</code></u></summary>

```
[user@user ~]$ will .build copy.debug
...
 Building copy.debug
   + reflect.copy. reflected 4 files /path_to_file/ : out/debug <- proto in 0.316s
  Built copy. in 0.463s

```

</details>

Запустіть побудову відладки командою `will .build copy.debug` та прогляньте зміни в директоріях за шляхом `out/`.

<details>
  <summary><u>Структура модуля після побудови</u></summary>

```
fileFilters
     ├── proto
     │     ├── proto.two
     │     │     └── script.js
     │     ├── files
     │     │     ├── manual.md
     │     │     └── tutorial.md
     │     ├── build.txt.js
     │     └── package.json  
     ├── out
     │     ├── release
     │     └── debug
     │           ├── build.txt.js
     │           └── proto.two
     │                   └── script.js
     └── .will.yml       

```

</details>

При фільтруванні за закінченням файла утиліта відібрала файли `build.txt.js` i `script.js`. 

##### Фільтр `hasExtension`  

Фільтр `hasExtension` переважно використовується для файлів зі складними розширеннями. Адже, складне розширення вказує додаткові особливості. Наприклад, файл має назву `somefile.debug.js`, де перше розширення `.debug` вказує на призначення файла - відладка. Тоді, файл для реліз-модуля може мати розширення `.release.js`.  

В директорії `proto` є файл `build.txt.js` для вибору якого можна використати фільтр `hasExtension`.

<details>
  <summary><u>Секція <code>reflector</code> з фільтром <code>hasExtension</code></u></summary>

```yaml
reflector :

  reflect.copy.:
    recursive: 2
    src:
      filePath: ./proto
      hasExtension:
         - 'txt'
         - 'two'
    dst:
      filePath: path::out.*=1
    criterion:
      debug: [ 0,1 ]

```

</details>

Для вибору файлів з розширеннями `.txt` i `.two` змініть фільтр `ends` на `hasExtension` згідно приведеного вище коду.   

<details>
  <summary><u>Вивід команди <code>will .build copy.debug</code></u></summary>

```
[user@user ~]$ will .build copy.debug
...
 Building copy.
   + reflect.copy. reflected 4 files /path_to_file/ : out/release <- proto in 0.342s
  Built copy. in 0.384s

```

</details>

Очистіть директорію `out` (`rm -Rf out/`) та запустіть збірку відладки. 

Після виконання побудови перевірте вміст в директорії `out/debug`.

<details>
  <summary><u>Структура модуля після побудови</u></summary>

```
fileFilters
     ├── proto
     │     ├── proto.two
     │     │     └── script.js
     │     ├── files
     │     │     ├── manual.md
     │     │     └── tutorial.md
     │     ├── build.txt.js
     │     └── package.json  
     ├── out
     │     └── debug
     │           ├── build.txt.js
     │           └── proto.two
     │                   └── script.js 
     └── .will.yml       

```

</details>

В директорії `out/debug` знаходяться три файла. Файл `build.txt.js` утиліта скопіювала згідно фільтра `hasExtension` так же, як і директорію `proto.two`. Згідно опції `recursive` утиліта скопіювала вміст директорії `proto.two` - файл `script.js`. 

### Підсумок

- Фільтри рефлектора вносяться в поля `src` і `dst`.   
- Прості фільтри вибирають файли за початком назви файла, закінченням назви і розширенням.   
- Фільтр `hasExtension` зчитує розширення починаючи з першої крапки в назві файла.

[Повернутись до змісту](../README.md#tutorials)
