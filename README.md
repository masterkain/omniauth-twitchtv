# OmniAuth Twitchtv

This gem contains the Twitchtv strategy for OmniAuth.

# Usage

    provider :twitchtv, Settings.services.twitchtv.client_key, Settings.services.twitchtv.client_secret, {
      scopes: 'channel_editor channel_commercial user_read channel_read', # space is important
    }
