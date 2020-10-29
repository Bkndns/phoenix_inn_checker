# InnChecker Elixir + Phoenix Проверка ИНН

Elixir / Phoenix приложение которое проверяет ИНН на корректность

#### [Quick Demo](https://agile-fjord-12058.herokuapp.com/)

***

### Установка
Процесс установки и запуска достаточно прост.
На компьютере должен быть установлен **Erlang и Elixir** , а также **Postgres и Redis**
Блокировать IP может только администратор.
Блокировка происходит в `Список ИНН > Посмотреть > Форма - Заблокировать IP`. После чего заблокированный IP становиться виден в разделе `Заблокированные IP`
Проверка на разблокировку происходит с интервалом в 1 минуту

#### **Пароли**
* Логин и Пароль от аккаунта обычного пользователя `user@server.com` - `user_33g7b531cs`
* Логин и Пароль от учйтной записи менеджера `manager@server.com` - `manager_9265Z3o75ds`
* Логин и Пароль от учётной администратора `admin@server.com` - `admin_31415QnoCTuT`

[Скриншот](https://imgur.com/7JmwD5c)

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
  * Elixir Awesome Parser (GitHub) [Elixir Awesome Parser](https://github.com/Bkndns/phoenix_gitsome/)
  * Elixir Awesome Parser [Quick Demo](https://miniature-loose-blowfish.gigalixirapp.com/)
  * Elixir GraphQL Test Example [GitHub](https://github.com/Bkndns/elixir_test_graphql_news_and_users)
  * Elixir Tutorial Project [GitHub](https://github.com/Bkndns/elixir_phoenix_tutorial_project)
  * Erlang Example Book [GitHub](https://github.com/Bkndns/erlang_learning_examples_files)
