### Задание

Написать скрипт, который открывает URL, считывает оттуда тело ответа и записывает его в файл.

1. Он должен принимать URL в формате: http://ya.ru, в качестве параметра при запуске.
2. И он должен принимать как параметр при запуске путь к файлу, куда записать тело.

## Настройка Python окружения

Чтобы можно было работать с Python на linux, надо 3 пакета:

```bash
python-dev
python-pip
python-virtualenv
```

Установка пакетов:

```bash
sudo apt-get install ...
```

Чтобы создать копию окружения Python:

```bash
virtualenv env
env/bin/python
env/bin/pip install requests
```

Чтобы не вводить env/bin в 1 сессии терминала можно набрать команду:

```bash
source env/bin/activate
```

Потом вызов:

```bash
python будет вызывать python из env/bin
```

Далее есть файлик, в котором хранятся все зависимости.

`<package>==<version>` - Ссылается на определенную версию
`<package>` - Ссылается на последнюю версию

Установка всех зависимостей из requirements:
```bash
env/bin/pip install -r requirements.txt
```

Пакеты можно искать тут:
https://pypi.python.org/pypi

### Задание

1. Сделать virtualenv.
2. Надо все сторонние зависимости записать в файл.
3. Добавить зависимость для HTTP сервера (wsgi).
4. Сделать Makefile, который будет сам запускать создание virtualenv и ставить пакеты.

## HTTP Server

Пример URL:
http://host:8080/path?query=133

Примеры URI:
POST /path/to/resource?query=123
GET /1234/

У HTTP есть разные виды запросов:
POST - это запрос с телом (JSON, Binary, XML), если объект существует
GET - в нем нет тела.

PUT - используется для создания объектов.
DELETE - удаление объекта.

HEAD - он для получения только заголовков. GET который не возвращает тело. Например, чтобы проверить, что объект существует.

OPTIONS

В качестве примера простейшего HTTP сервера, можно рассмотреть wsgiref https://docs.python.org/2/library/wsgiref.html.
wsgiref в коллбек возвращать будет все.
Сокет можно привязать к определенному IP.
Например 127.0.0.1.

А если задать 0.0.0.0, то сервер будет доступен на всех интерфейсах.

## Создание скрипта установки модуля:

Чтобы сделать возможным установку Python пакета в систему, необходимо создать 
установочный скрипт.
Скрипт должен называться `setup.py` и располагаться в корне проекта:
Формат:

```python
from distutils.core import setup
import http_server

setup(
    name='sandbox',
    version='0.0.1',
    py_modules=['http_server', 'start', 'server.http_handler'],
    author='',
    author_email='',
    url='',
    description='Python library for',
)
```
Внутри можно даже компилировать C++.

чтобы установить такой пакет есть 3 варианта:
1. Скачать его из репы, затем запустить `setup.py`:

```bash
python setup.py install
```

2. Скачать его через pip

```bash
pip install -e git+http://ruch-net.ru:10022/artem/python-sandbox.git#egg=sandbox
```

3. Положить его в архиве на FTP сервер, добавить этот FTP в конфиги PIP.
И тогда он скачается:

```bash
pip install sandbox
```