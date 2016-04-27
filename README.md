This is the back-end repository for the Meetnow application. Please make sure you are running this project before running the front-end.

You can find the front-end in the following link: https://github.com/luisgrases/meetnow-frontend

## How to use this project

To use this starter create a new project folder (e.g. 'myApp') for your app and clone this repository into it.
```bash
$ cd mkdir myApp
$ git clone https://github.com/luisgrases/meetnow-backend
```

Then install the required gems and make the database migrations.
```bash
$ bundle install
$ rake db:migrate
```
Lastly run the faye server and then the project server in a separate terminal window.
```bash
$ rackup faye.ru -s thin -E production
$ rails s
```