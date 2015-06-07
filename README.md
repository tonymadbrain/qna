# README
Учебное приложение для курсов профессиональной разработки на ROR - http://ror.thinknetica.com/

Используется:
* Ruby - 2.2.1
* Rails - 4.2.0
* RSpec - 3.2.1
* PostgreSQL - 9.3.6

Приложение дублирует функционал сайта http://stackoverflow.com/

Для запуска:
* запустить само приложение, например - rails s
* запустить faye сервер - rackup private_pub.ru -s thin -E production
* запустить redis - redis-server
* запустить sidekiq - sidekiq
