# Submarine #

Deep sea string substitution. [Official Website](http://www.submarine-gem.org).

## About ##

`Submarine` is a lightweight string formatter built in [Ruby](https://www.ruby-lang.org/en/). It allows the use of placeholder values inside of a string, which can then be formatted during runtime into whatever else you like. It's best summed up with a quick example:

```ruby
string = "Hello, my name is [[name]]."
Submarine.new(text: string, name: 'Joe').format!
=> "Hello, my name is Joe."
```

Not completely unlike [Handlebars](https://github.com/wycats/handlebars.js/) or [Mustache](https://github.com/mustache/mustache.github.com) or [RedCloth](https://github.com/jgarber/redcloth), `Submarine` takes a string and formats it using predefined key value pairs.

## But why? ##

When is `Submarine` useful? Let's say you have a Ruby web app with some admin editable text fields. The admin has a particular text field that allows them to enter a welcome message that's displayed in a users dashboard. The admin would like to include the users name in the message, as a way of personalizing the greeting. `Submarine` allows the admin to enter text with predefined formatters that will then be magically converted when the user views the message.

Maybe the text copy the admin enters via the web app interface looks like:

```html
// Inside a text field input
Good morning [[name]], welcome back to your dashboard!
```

This string can now be run through `Submarine` to turn `[[name]]` into something useful:

```ruby
greeting = "Good morning [[name]], welcome back to your dashboard!"
Submarine.new(text: greeting, name: user.name).format!
=> "Good morning Joe, welcome back to your dashboard!"
```

## Install ##

Add the gem the standard Gemfile way:

```ruby
# Gemfile
gem 'submarine'
```

## Usage ##

As shown above, `Submarine` takes a string and formats anything surrounded in double square brackets, like `[[name]]`. Maybe you're formatting an email:

```ruby
email_body = "Hello [[name]]. You have [[days]] until your trial expires."
sub = Submarine.new(text: email_body, name: user.name, days: user.account.days_until_expires)
sub.format! => "Hello Joe, you have 7 days until your trial expires."
```

`Submarine` only requires that you provide it a string and the corresponding replacement values.

# Config #

`Submarine` is configurable. Maybe you're not particularly fond of double square brackets and you'd prefer to have your variables surrounded with curly brackets like `{{name}}`. Or maybe you prefer something more esoteric like `<^name^>`. Although `Submarine` defaults to square brackets, you're free to override them:

```ruby
# In an initialization file like config/initializers/submarine.rb
Submarine.configure do |config|
  config.format_key = :text     # Key representing the string to be formatted
  config.left_delimiter = '[['  # The left-hand side matcher
  config.right_delimiter = ']]' # The right-hand side matcher
  config.substitutions = {}     # Optional global default substitutions 
end
```

#### Default Substitutions ####

*config.substitutions*: You can predefine global substitution defaults in the configuration. Maybe you'd always like to match `[[contact_email]]` with `config.substitutions = {contact_email: 'contact@mysite.com'}`.

#### Reloading Defaults ###
If you'd like to reload the `Submarine` defaults at any point during runtime you can call `reload!` on the configuration object:

```ruby
Submarine.config.reload!
```

## Compatibility ##

This gem was created for Ruby 2. It's very likely it could work with older versions. You'll have to test to determine compatibility!

## License, etc ##

`Submarine` is open and free for all. Please use, fork, update, critique, send pull requests, etc.