# Секція `step` 
В секції описуються процедури побудови модуля. Ресурси секції - кроки - поміщають в сценарії збірок секції `build` для виконання побудови. 

### Поля ресурсів секції `step`   

| Поле           | Опис                                        |
|----------------|---------------------------------------------|
| description    | опис кроку (процедури)                      |
| criterion      | умова використання ресурса (див. критеріон) |
| opts           | процедура побудови модуля                   |
| inherit        | наслідування значень полів іншого ресурса   |

Приклад секції `step` з ресурсами `export.proto`, `proto.release`: 

![step.section.png](./Images/step.section.png)