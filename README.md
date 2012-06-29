# Neospeech

Ruby wrapper for NeoSpeech Text to Speech API. Neospeech engine provides highly customizable high quality TTS conversion (http://www.gizmag.com/go/2708/). The gem is written to consume the TTS engine of NeoSpeech as REST Webservice via various helper methods. This is pre-release andt the gem is under active developement. Test cases plus documentation are the next priority.


## Installation

Add this line to your application's Gemfile:

    gem 'neospeech'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install neospeech
    
## Configuration
Before using, you must register with nespeech https://ws.neospeech.com and add a configuration file containing account and API keys.

    # config/initializers/text_to_speech.rb
    
    Neospeech.setup do |config|
      config.email = 'your-email'
      config.account_id = 'neospeech-account-id'
      config.login_key = 'your-login-key'
      config.login_password = 'your-api-password'
    end

## Usage

This wrapper supports there voices - 'paul', 'kate', 'julie' and comes with built-in string helper to provide a downloadable audio url.

    'Hello World'.speak 'kate'
    #=> "https://tts.neospeech.com/audio/a.php/4682669/a97ec98568f8/result_11.wav"

Any name may be used (single word). If the TTS engine does not supports, kate voice will be used.

Five ready made speech speed can also be specified. Default is normal

    'very slow' , 'slow', 'normal', 'fast', 'very fast'
    
    'Hello World'.speak 'kate', 'fast'

For more control over the speech integer between 50 and 400 can be specified.

    'Hello World'.speak 'kate', 95

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
