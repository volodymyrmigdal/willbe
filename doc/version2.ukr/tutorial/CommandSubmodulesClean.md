# Команди оновлення, апгрейду та очищення підмодулів

Команди оновлення підмодулів, апгрейду підмодулів автоматизовним перезаписом <code>вілфайла</code> та очищення модуля.

Зазвичай, один програмний продукт залежить від багатьох сторонніх модулів, бібліотек, програм. Розробка програмного забезпечення - динамічний процес і їх версії постійно змінюються. Саме тому, потрібне швидке і безпечне оновлення допоміжного програмного забезпечення, в термінології `willbe`, підмодулів.

<<<<<<< HEAD:doc/version2.ukr/tutorial/CommandSubmodulesClean.md
Утиліта `willbe` дозволяє розробнику зафіксувати версії віддалених підмодулів в `вілфайлі` командою `.submodules.fixate`, здійснювати автоматизований перезапис ресурсів командою `.submodules.upgrade.refs`, оновлювати підмодулі командою `.submodules.update` i видаляти - `.submodules.clean`.   
=======
Утиліта `willbe` дозволяє розробнику зафіксувати версії віддалених підмодулів в `will-файлі` командою `.submodules.fixate`, здійснювати автоматизований перезапис ресурсів командою `.submodules.upgrade`, оновлювати підмодулі командою `.submodules.update` i видаляти - `.submodules.clean`.   
>>>>>>> b7f2289f135effbc194eef4e4e146a58e114c9fe:doc/version2.ukr/tutorial/CommandsSubmodules.md

### Команда `.submodules.fixate`

<<<<<<< HEAD:doc/version2.ukr/tutorial/CommandSubmodulesClean.md
Команда `.submodules.fixate` призначена для автоматизованого запису (фіксації) поточної версії підмодуля в `вілфайл`. Фіксація проводиться для підмодулів, які не мають версії, тобто, посилання не містить вказаної версії програми чи коміту. 
=======
Команда `.submodules.fixate` призначена для автоматизованого запису (фіксації) поточної версії підмодуля в `will-файл`. Фіксація проводиться для підмодулів, які не мають версії, тобто, посилання не містить вказаної версії програми чи коміту.
>>>>>>> b7f2289f135effbc194eef4e4e146a58e114c9fe:doc/version2.ukr/tutorial/CommandsSubmodules.md

Команда має опцію `dry` для ввімкнення перезапису `вілфайла`. Опція `dry` приймає значення `0` i `1`. При `dry:0` (значення за замовчуванням) фраза замінить URI-посилання на актуальні. При значенні `dry:1` команда `will .submodules.fixate dry:1` виводить список доступних оновлень не змінюючи `вілфайл`. Команда `.submodules.fixate` пропускає підмодулі з вказаними версіями підмодуля або комміту.    

<details>
  <summary><u>Файлова структура</u></summary>

```
submodulesCommands
        ├── submodulesFixate
        │           └── .will.yml
        └── submodulesUpgrade
                    └── .will.yml

```

</details>

Для дослідження команди створіть приведену структуру файлів в директорії `submodulesCommands`.

<details>
  <summary><u>Код файлів <code>.will.yml</code> в директоріях <code>submodulesFixate</code> і <code>submodulesUpgrade</code></u></summary>

```yaml
about :

  name : submodulesCommands
  description : "To test submodule control commands"

submodule :

  Tools : git+https:///github.com/Wandalen/wTools.git/out/wTools#master
  PathFundamentals : git+https:///github.com/Wandalen/wPathFundamentals.git/out/wPathFundamentals#master
  Files : git+https:///github.com/Wandalen/wFiles.git/out/wFiles#master

```
</details>

Внесіть в файли `.will.yml` приведений код.

<details>
  <summary><u>Вивід команди <code>will .submodules.fixate dry:1</code></u></summary>

```
[user@user ~]$ will .submodules.fixate dry:1
...
Remote path of module::submodulesCommands / module::Tools will be fixated
  git+https:///github.com/Wandalen/wTools.git/out/wTools : .#56afe924c2680301078ccb8ad24a9e7be7008485 <- .#master
  in /path_to_file/.will.yml
Remote path of module::submodulesCommands / module::PathFundamentals will be fixated
  git+https:///github.com/Wandalen/wPathFundamentals.git/out/wPathFundamentals : .#84dd78771fd257bf8599dafe3cc37a9407a29896 <- .#master
  in /path_to_file/.will.yml
Remote path of module::submodulesCommands / module::Files will be fixated
  git+https:///github.com/Wandalen/wFiles.git/out/wFiles : .#5a29f780c4c7ff7f2202dd8c61562d1f2ae095e9 <- .#master
  in /path_to_file/.will.yml

```

</details>

Файл `.will.yml` в директорії `submodulesUpgrade` призначений для дослідження команди `.submodules.upgrade` тому, перейдіть в директорію `submodulesFixate` та виконайте пошук оновлень для підмодулів командою `.submodules.fixate` з опцією `dry:1` - без заміни значень.

Вивід з указанням `will be fixated` говорить про те, що при опції `dry:0` ресурс буде змінено.  

<details>
  <summary><u>Секція <code>submodule</code> зі змінами в підмодулі <code>Tools</code></u></summary>

```yaml    
submodule :

  Tools : git+https:///github.com/Wandalen/wTools.git/out/wTools#ec60e39ded1669e27abaa6fc2798ee13804c400a
  PathFundamentals : git+https:///github.com/Wandalen/wPathFundamentals.git/out/wPathFundamentals#master
  Files : git+https:///github.com/Wandalen/wFiles.git/out/wFiles#master

```

</details>
<details>
  <summary><u>Файлова структура</u></summary>

```
submodulesCommands
        ├── submodulesFixate
        │           └── .will.yml
        └── submodulesUpgrade
                    └── .will.yml

```

</details>

Відкрийте файли `.will.yml` в директоріях `submodulesFixate` і `submodulesUpgrade` та змініть ресурс `Tools` в секції `submodule` на приведений вище.    

<details>
  <summary><u>Вивід команди <code>will .submodules.fixate</code></u></summary>

```
[user@user ~]$ will .submodules.fixate
...
Remote path of module::submodulesCommands / module::PathFundamentals fixated
  git+https:///github.com/Wandalen/wPathFundamentals.git/out/wPathFundamentals : .#84dd78771fd257bf8599dafe3cc37a9407a29896 <- .#master
  in /path_to_file/submodulesFixate/.will.yml
Remote path of module::submodulesCommands / module::Files fixated
  git+https:///github.com/Wandalen/wFiles.git/out/wFiles : .#5a29f780c4c7ff7f2202dd8c61562d1f2ae095e9 <- .#master
  in /path_to_file/submodulesFixate/.will.yml

```

</details>

Застосуйте команду `.submodules.fixate` без аргументів.

Утиліта змінила ресурси в секції `submodule` `вілфайлa` згідно останніх коммітів на віддаленому сервері. При цьому команда `.submodules.fixate` не змінила ресурс `Tools`, в якому вказано версію.  

### Команда `.submodules.upgrade`

Команда `.submodules.upgrade`, здійснює пошук оновлень для віддалених підмодулів та перезапис значень в відповідних ресурсах секції `submodule`. Команда має опцію `dry` аналогічно до команди `.submodules.fixate`. При використанні команди `.submodules.upgrade` ресурси секції `submodule` замінюються незалежно від наявності вказаної версії підмодуля.  

<details>
  <summary><u>Вивід команди <code>will .submodules.upgrade dry:1</code></u></summary>

```
[user@user ~]$ will .submodules.upgrade dry:1
...
Module at /path_to_file/.will.yml
...
  Remote path of module::submodulesCommands / module::Tools will be fixated
  git+https:///github.com/Wandalen/wTools.git/out/wTools : .#56afe924c2680301078ccb8ad24a9e7be7008485 <- .#master
  in /path_to_file/submodulesUpgrade/.will.yml
Remote path of module::submodulesCommands / module::PathFundamentals will be fixated
  git+https:///github.com/Wandalen/wPathFundamentals.git/out/wPathFundamentals : .#84dd78771fd257bf8599dafe3cc37a9407a29896 <- .#master
  in /path_to_file/submodulesUpgrade/.will.yml
Remote path of module::submodulesCommands / module::Files will be fixated
  git+https:///github.com/Wandalen/wFiles.git/out/wFiles : .#5a29f780c4c7ff7f2202dd8c61562d1f2ae095e9 <- .#master
  in /path_to_file/submodulesUpgrade/.will.yml

```

</details>

Перевірте, які підмодулі потребують оновлення в `вілфайлі` директорії `submodulesUpgrade`.

Вивід свідчить, що команда `.submodules.upgrade` оновить всі застарілі посилання не зважаючи на те, що в підмодулі `Tools` вказаний комміт - застарілий комміт, який не змінювала команда `.submodules.fixate`.   

### Команда `.submodules.update`

<<<<<<< HEAD:doc/version2.ukr/tutorial/CommandSubmodulesClean.md
Команди `.submodules.fixate` i `.submodules.upgrade.refs` переписують ресурси `вілфайла` не виконуючи оновлення. Це дозволяє розробнику вибрати зручний момент для оновлення і забезпечити надійне функціонування модуля.  
=======
Команди `.submodules.fixate` i `.submodules.upgrade` переписують ресурси `will-файла` не виконуючи оновлення. Це дозволяє розробнику вибрати зручний момент для оновлення і забезпечити надійне функціонування модуля.  
>>>>>>> b7f2289f135effbc194eef4e4e146a58e114c9fe:doc/version2.ukr/tutorial/CommandsSubmodules.md

Для завантаження і встановлення оновлень використовуйте команду `.submodules.update`.  

<details>
  <summary><u>Вивід команди <code>will .submodules.update</code></u></summary>

```
[user@user ~]$ will .submodules.update
...
   . Read : /path_to_file/submodulesFixate/.module/Tools/out/wTools.out.will.yml
   + module::Tools version ec60e39ded1669e27abaa6fc2798ee13804c400a was downloaded in 14.897s
   . Read : /path_to_file/submodulesFixate/.module/PathFundamentals/out/wPathFundamentals.out.will.yml
   + module::PathFundamentals version 84dd78771fd257bf8599dafe3cc37a9407a29896 was downloaded in 3.464s
   . Read : /path_to_file/submodulesFixate/.module/Files/out/wFiles.out.will.yml
   + module::Files version 5a29f780c4c7ff7f2202dd8c61562d1f2ae095e9 was downloaded in 10.199s
 + 3/3 submodule(s) of module::submodulesCommands were downloaded in 28.569s

```

</details>
<details>
  <summary><u>Файлова структура після оновлення підмодулів</u></summary>

```
submodulesCommands
        ├── submodulesFixate
        │           ├── .module
        │           └── .will.yml
        └── submodulesUpgrade
                    └── .will.yml

```

</details>

Введіть команду `will .submodules.update` в директорії `submodulesFixate`.

Утиліта завантажила підмодулі згідно версій указаних в `вілфайлі`. Тобто, якщо модуль має незавантажені підмодулі, наприклад, додані після побудови, то команда `.submodules.update` їх завантажить.  

<details>
  <summary><u>Вивід команди <code>will .submodules.upgrade</code></u></summary>

```
[user@user ~]$ will .submodules.upgrade
...
Remote path of module::submodulesCommands / module::Tools fixated
  git+https:///github.com/Wandalen/wTools.git/out/wTools : .#56afe924c2680301078ccb8ad24a9e7be7008485 <- .#ec60e39ded1669e27abaa6fc2798ee13804c400a
  in /path_to_file/submodulesFixate/.will.yml

```

</details>
<details>
  <summary><u>Вивід команди <code>will .submodules.update</code></u></summary>

```
[user@user ~]$ will .submodules.update
...
   . Read : /path_to_file/submodulesFixate/.module/Tools/out/wTools.out.will.yml
   + module::Tools version 56afe924c2680301078ccb8ad24a9e7be7008485 was updated in 15.177s
   . Read : /path_to_file/submodulesFixate/.module/PathFundamentals/out/wPathFundamentals.out.will.yml
   + module::PathFundamentals version 84dd78771fd257bf8599dafe3cc37a9407a29896 was updated in 3.489s
   . Read : /path_to_file/submodulesFixate/.module/Files/out/wFiles.out.will.yml
   + module::Files version 5a29f780c4c7ff7f2202dd8c61562d1f2ae095e9 was updated in 11.897s
 + 3/3 submodule(s) of module::submodulesCommands were updated in 30.574s

```

</details>
<details>
  <summary><u>Файлова структура після оновлення підмодулів</u></summary>

```
submodulesCommands
        ├── submodulesFixate
        │           ├── .module
        │           └── .will.yml
        └── submodulesUpgrade
                    └── .will.yml

```

</details>

Зробіть апґрейд ресурсів та повторіть апдейт віддалених підмодулів в директорії `submodulesFixate`.  

Було оновлено застарілу версію підмодуля `Tools` та встановлено оновлення підмодулів.

### Команда `.submodules.clean`    

Для видалення підмодулів з директорією `.module` використовуйте команду `will .submodules.clean`.

<details>
  <summary><u>Вивід команди <code>will .submodules.clean</code></u></summary>

```
[user@user ~]$ will .submodules.clean
...
 - Clean deleted 551 file(s) in 1.753s

```

</details>

<details>
  <summary><u>Файлова структура після видалення підмодулів</u></summary>

```
submodulesCommands
        ├── submodulesFixate
        │           └── .will.yml
        └── submodulesUpgrade
                    └── .will.yml    

```

</details>

Введіть в директорії `submodulesFixate` команду `will .submodules.clean`.

### Підсумок

- `Willbe` виконує операції з віддаленими підмодулями з командної оболонки системи.  
- Команда `.submodules.fixate` -  фіксує версію віддаленого підмодуля, а команда `.submodules.upgrade` оновлює ресурси `вілфайла` до останньої версії віддаленого підмодуля.  
- Використання команд `.submodules.fixate` i `.submodules.upgrade` разом з командою `.submodules.update`, розділяє оновлення підмодулів на два етапи - оновлення посилань і завантаження підмодулів, що забезпечує безпечне оновлення підмодулів і надійність роботи модуля.   
- Команда `.submodules.clean` очищає модуль від завантажених підмодулів разом з директорією `.module`.

[Повернутись до змісту](../README.md#tutorials)