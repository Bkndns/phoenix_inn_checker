# InnChecker Elixir + Phoenix Проверка ИНН

Elixir / Phoenix приложение которое проверяет ИНН на корректность

#### [Quick Demo](https://agile-fjord-12058.herokuapp.com/)

***

### Установка
Процесс установки и запуска достаточно прост.
На компьютере должен быть установлен **Erlang и Elixir** , а также **Postgres и Redis**

* Шаг 1 - склонировать репозиторий
``` 
git clone https://github.com/Bkndns/phoenix_inn_checker.git
```
* Шаг 2 - установить все зависимости 
```
mix deps.get
```
* Шаг 3 - запустить миграции
```
mix ecto.create
mix ecto.migrate
```
* Шаг 4 - запустить seeds
```
mix run priv/repo/seeds.exs
```

После этого можно открыть страницу [`localhost:4000`](http://localhost:4000) в браузере.
```
http://localhost:4000
```

*На этом установка и запуск завершена.*
***
### Примечания

  * #### [Quick Demo](https://agile-fjord-12058.herokuapp.com/)
  * Эта сборка использует *redis && postgres*
  * Ссылка на демо парсера
  * Ссылка на гитхаб парсера
  * Ссылка на гитхаб Граф куэл
  * Другое
