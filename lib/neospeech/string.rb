module Neospeech
  module String
    def speak voice, speed = 'normal'
      conversion = TextToSpeech::Neospeech::Convertor.new text: self, voice: voice, speed: speed
      conversion.queue
      sleep(1) until conversion.finished?
      conversion.audio_file_url
    end
  end
end

String.send(:include, Neospeech::String)
