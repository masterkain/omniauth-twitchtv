## OmniAuth Twitchtv

This gem contains a Twitchtv OAuth2 Strategy for OmniAuth.

## Installation

Add to your `Gemfile`:

```ruby
gem 'omniauth-twitchtv'
```

Then `bundle install`.


## Usage
Add the config line below to application's Devise intitializer.

config.omniauth :twitchtv, Settings.twitchtv.client_id, Settings.twitchtv.client_secret, scope: Settings.twitchtv.permissions.join(" ")

Sample config:

config.omniauth :twitchtv, 4n6jy6klu89s300ap05t, a3d3dm9ag6s5an33p01, scope: 'user_read channel_editor channel_commercial channel_read'


## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'twitchtv',
  :uid => '1234567',
  :info => {
    :nickname => 'jmbloggs',
    :email => 'jm@bloggs.com',
    :name => 'jmbloggs',
    :image => 'http://static-cdn.jtvnw.net/jtv_user_pictures/jmbloggs-profile_image-e22f9c709cb15002-300x300.jpeg',
    :urls => { 
      :twitchtv => 'https://www.twitch.tv/jmb0000/profile', 
      :website => 'https://api.twitch.tv/kraken/users/jmb0000' 
    },
    :partnered => false
  },
  :credentials => {
    :expires => false,
    :token => '897cacaca...',
    :secret => '8c2na7ca7and7...'
  },
  :extra => {
    :raw_info => {
      ...
    }
  }
}
```

  