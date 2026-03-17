# PropTypes

A type validation library for Rails partials, inspired by React's PropTypes. Validate variable types at the top of your partials to catch errors early — no more cryptic `nil` errors bubbling up from deep inside your views.

```erb
<%# app/views/users/_user_card.html.erb %>

<% PropTypes.describe("UserCard props") do %>
<%   PropTypes.string(name) %>
<%   PropTypes.integer(age) %>
<% end %>

<div class="user-card">
  <h2><%= name %></h2>
  <p>Age: <%= age %></p>
</div>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prop_types'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prop_types

## Usage

### Basic Validation

Use `PropTypes.string` and `PropTypes.integer` to validate variable types. Place these at the top of your partials:

```erb
<%# app/views/posts/_post_header.html.erb %>

<% PropTypes.string(title) %>   <%# raises PropTypes::Errors::InvalidType if title is not a String %>
<% PropTypes.integer(count) %>  <%# raises PropTypes::Errors::InvalidType if count is not an Integer %>

<h1><%= title %> (<%= count %>)</h1>
```

### Organizing with `describe`

Use `PropTypes.describe` to group and label your validations. The label is for readability only — it has no runtime behavior:

```erb
<% PropTypes.describe("PostHeader props") do %>
<%   PropTypes.string(title) %>
<%   PropTypes.integer(count) %>
<% end %>
```

### Catching Undefined Variables with `validate_types`

Wrap validations in `PropTypes.validate_types` to catch undefined variables. Without it, an undefined variable raises Ruby's standard `NameError`. With it, you get a friendlier `PropTypes::Errors::UnexistantVariable` error:

```erb
<% PropTypes.validate_types do %>
<%   PropTypes.string(title) %>
<%   PropTypes.string(subtitle) %>  <%# raises PropTypes::Errors::UnexistantVariable if subtitle is undefined %>
<% end %>
```

`validate_types` is optional — basic validations like `PropTypes.string(var)` work perfectly fine on their own.

### Custom Validators

Validate against any Ruby class with `PropTypes::Validator.custom`:

```erb
<% PropTypes::Validator.custom(User, current_user) %>  <%# raises PropTypes::Errors::InvalidType if current_user is not a User %>
<% PropTypes::Validator.custom(Array, items) %>         <%# raises PropTypes::Errors::InvalidType if items is not an Array %>
```

### Block Validations

Pass a block to any validator for custom logic. The block receives the variable as an argument and must return a truthy value:

```erb
<% PropTypes.string(name) { |v| v.length > 0 } %>    <%# raises PropTypes::Errors::FailedValidation if block returns falsy %>
<% PropTypes.integer(age) { |v| v >= 0 && v < 150 } %>

<% PropTypes::Validator.custom(Array, tags) { |v| v.any? } %>
```

## Error Reference

| Error | Raised When |
|---|---|
| `PropTypes::Errors::InvalidType` | A variable doesn't match the expected type |
| `PropTypes::Errors::FailedValidation` | A block validation returns a falsy value |
| `PropTypes::Errors::UnexistantVariable` | A variable is undefined (only within a `validate_types` block) |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Samy-Amar/prop_types.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
