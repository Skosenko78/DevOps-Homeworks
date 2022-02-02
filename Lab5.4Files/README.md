# **5.4. Оркестрация группой Docker контейнеров на примере Docker Compose**

# *Задача 1*

![alt text](image/task1.png "Packer образ")

# *Задача 2*

![alt text](image/task2.png "Node01")

# *Задача 3*

![alt text](image/task3.png "Grafana")

# *Задача 4*

![alt text](image/task4_1.png "Host02")

Совсем не уверен в правильности решения, к тому же так и не удалось победить показатель "CPU Number", но другой идеи не возникло:

- добавить переменную в дашборд:

![alt text](image/task4_3.png "Variable")

- изменить в панелях дашборда запросы к Prometheus, добавив проверку источника метрики {instance="$instance"}:

![alt text](image/task4_2.png "PromQL")

Буду рад, если в комментарии к ДЗ натолкнёте на правильное решение.