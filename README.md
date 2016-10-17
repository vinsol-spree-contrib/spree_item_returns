# spree_item_returns

This is an extension of spree, It has extended the line item return functionality and enabled customer to create return authorization for purchased items, it provide user an interface(CRUD) to return their ordered product from website.

## FEATURES

* Provides an user account interface for creating item return.
* Provide a list of returns created by user

## NOTE

The current version supports Spree's versions: 3.0.0.

## Installation

### In a rails application with Spree installed include the following line in your Gemfile:

  * Get the latest greatest from github:

    ```ruby
      gem 'spree_item_returns' , :github => 'vinsol-spree-contrib/spree_item_returns'
    ```

### Then run the following commands:

    $ bundle install
    $ rails g spree_item_returns:install
    $ rake db:migrate
    $ rails s

##Uses

### To view Return history

  1. Go to Account -> 'Return History' Button.
     A list of all return made by users will be shown.
  2. User can select individual return and see it's details.

### To create Return
  1. Go to Account
  2. Open order which has return item.
  3. Click on 'Return Product' button.
  4. Select the product which need to be returned, and fill fields with appropriate data. And click on 'Create'


## Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

## Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo) the project
2. Make one or more well commented and clean commits to the repository. You can make a new branch here if you are modifying more than one part or feature.
3. Add tests for it. This is important so I don’t break it in a future version unintentionally.
4. Perform a [pull request](https://help.github.com/articles/using-pull-requests) in github's web interface.
