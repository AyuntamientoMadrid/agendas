[![Build Status](https://travis-ci.org/AyuntamientoMadrid/agendas.svg?branch=master)](https://travis-ci.org/AyuntamientoMadrid/agendas)
[![Code Climate](https://codeclimate.com/github/AyuntamientoMadrid/agendas/badges/gpa.svg)](https://codeclimate.com/github/AyuntamientoMadrid/agendas)
[![Dependency Status](https://gemnasium.com/AyuntamientoMadrid/agendas.svg)](https://gemnasium.com/AyuntamientoMadrid/agendas)
[![Coverage Status](https://coveralls.io/repos/github/AyuntamientoMadrid/agendas/badge.svg?branch=master)](https://coveralls.io/github/AyuntamientoMadrid/agendas?branch=master)

Este es el repositorio de código abierto de la aplicación de Transparencia del Ayuntamiento de Madrid.

## Estado del proyecto

Inicio el desarrollo de esta aplicación [15 septiembre de 2015]
La evolución y futura lista de funcionalidades a implementar se pueden consultar en la lista de [tareas por hacer](https://github.com/IAMCorporativos/agendas/projects/1).

## Tecnología

El backend de esta aplicación se desarrolla con el lenguaje de programación [Ruby](https://www.ruby-lang.org/) sobre el *framework* [Ruby on Rails](http://rubyonrails.org/).
Los estilos de la página usan [SCSS](http://sass-lang.com/) sobre [Foundation](http://foundation.zurb.com/)

## Configuración para desarrollo y tests

Prerequisitos: tener instalado git, Ruby 2.3.5, Java, la gema `bundler`, ghostscript y PostgreSQL (9.4 o superior).

```
git clone https://github.com/AyuntamientoMadrid/agendas
cd agendas
bundle install
cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml
rake db:create
rake db:schema:load
rake sunspot:solr:start
rake db:test_seeds
```

**Nota**: Si al ejecutar `rake db:test_seeds` o al correr algún spec saltan errores relacionadas a Sunspot (como `404 Not Found` o `503 Service unavailable`), [esta respuesta](https://stackoverflow.com/a/18646348/4844313) en StackOverflow debería solventarlos.

Para ejecutar la aplicación en local:
```
bin/rails s
```

El usuario admin por defecto es `admin@agendas.dev` con password `12345678`

Prerequisitos para los tests: tener instalado PhantomJS >= 2.0

Para ejecutar los tests:

```
bin/rspec
```
