### Встановлення тестів
####   Для роботи тестів потрібні:
	* Python 2.7
	* Git
	* GCC
	* Development-версії Python 2.7, libffi, libjpeg, libyaml, zlib
	* Для Fedora / CentOS / RHEL потрібен пакет redhat-rpm-config
	* Рекомендовано використовувати virtualenv
###	Щоб встановити їх для Fedora:
	sudo dnf install python2-devel git gcc libffi-devel libjpeg-devel libyaml-devel redhat-rpm-config zlib-devel

###	Для openSUSE і інших RPM-дистрибутивів список пакетів такий самий, але замість dnf використовується інший пакетний менеджер, наприклад, zypper. Також пакет python2-devel може називатись python-devel.
###	Для Debian і похідних дистрибутивів (Ubuntu, Mint):
	sudo apt-get install python-minimal python2.7-dev git gcc libffi-dev libjpeg-dev libyaml-dev libz-dev
###	Для встановлення тестів:

	* Завантажте репозиторій з кодом та перейдіть в новостворений каталог:
		
		git clone git://github.com/openprocurement/robot_tests.git
		cd robot_tests

	*	Для роботи з тестами перейдіть на гілку master:

		git checkout master

	*  Підготуйте середовище:

	   python2 bootstrap.py
	   bin/buildout -N

	Система Buildout завантажить компоненти та встановить усе необхідне для запуску тестів.

 	Також виконання bin/buildout буває потрібним після оновлення пакету з Git, зокрема, коли змінюються версії залежностей.

	Якщо ви отримуєте помилку, пов'язану з HTTPS/SSL, встановіть в системі пакет ca-certificates.


###	Запуск тестів
	
	Для запуску виконайте:

	bin/op_tests

###	Вибір test scenario

	За замовчуванням виконуються всі наявні test scenario. Щоб вибрати test scenario, використовуйте опцію -A:

	bin/op_tests  -A  robot_tests_arguments/criteria.txt

    В цьому прикладі буде виконано criteria.txt
    
    bin/op_tests  -A  robot_tests_arguments/impossibility_criteria.txt

	В цьому прикладі буде виконано impossibility_criteria.txt.

###	Вибір версії API і адреси сервера

	Якщо для одної з ролей використовується робота з ЦБД напряму, а не через майданчик, то можна вибрати версію API, до якої будуть надсилатись запити, і нестандартну адресу сервера. Приклад

		bin/op_tests -v API_VERSION:0.12 -v API_HOST_URL:http://localhost:6543/

###	Перевизначення у командному рядку параметрів представлених у файлах brokers.yaml та users.yaml

######	Приклад:

	-v BROKERS_PARAMS:'{"Quinta": {"intervals": {"default": {"enquiry": [0, 0], "tender": [0, 1.2], "accelerator": 1440000}}, "timeout_on_wait": 0.15}}'

	-v USERS_PARAMS:'{"users": {"Catalogues_Admin": {"api_key": "aaabbbccc000"}}}'


###	Користувачі
	
	* глядача - viewer
	* адміністратор - catalogues_admin

	Приклад

	users:
    Catalogues_Admin:
        broker:   Quinta
        auth_catalogues: [admin, adminpassword]
        browser:  phantomjs
        position: [0, 0]
        size:     [1400, 900]
    Tender_Viewer:      
        auth_edr: [test.quintagroup.com, f5111c99a97a45348d8165ba8fcf0d62]
        auth_catalogues: [user, userpassword]
        browser:  phantomjs
        position: [0, 0]
        size:     [1400, 900]
