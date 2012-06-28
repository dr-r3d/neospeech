class Neospeech::Convertor
  include ::HTTParty
  base_uri 'https://tts.neospeech.com'
  RELATIVE_URL = '/rest_1_1.php'

  attr_reader :status
  attr_accessor :audio_file_url, :error, :text, :voice, :speed, :pitch, :volume

  def initialize(args)
    args.each { |key, value| send(key.to_s+'=', value) }
    @response = {}
    self
  end

  def queue
    @response = simple
    @status = @response['statusCode']
    error = @response['resultCode']
    self
  end

  def conversion_number
    @response['conversionNumber']
  end

  def finished?
   error || success?
  end

  def success?
    status.eql?('4')
  end

  def status
    unless @status.eql?('4')
      response = query_status['response']
      if response['resultCode'] == '0'
        @status = response['statusCode']
        @audio_file_url = response['downloadUrl'] if @status.eql?('4')

      end
    end
    @status
  end

  def error= resultCode
    @error = resultCode.eql?('0') ? nil : resultCode
  end

  def audio_file_url
    error || @audio_file_url
  end

  def voice= name
    @voice = name ? "TTS_#{name.upcase}_DB" : 'TTS_KATE_DB'
  end

  def speed= value
    @speed = case(value.to_s)
      when 'very slow'
        '50'
      when 'slow'
        '75'
      when 'normal'
        '100'
      when 'fast'
        '200'
      when 'very fast'
        '400'
      else
        '50'
    end
  end

  private

  def query_status
    options = [::Neospeech.account_auth, {conversionNumber: conversion_number}].reduce(:merge)
    body_xml =  prepare_xml options, 'GetConversionStatus'
    response = self.class.post(RELATIVE_URL, body: body_xml).parsed_response
    error = response['response']['resultCode']
    response
  end

  def simple
    options = [::Neospeech.account_auth, ::Neospeech.api_auth, settings, {text: text}].reduce(:merge)
    body_xml = prepare_xml options, 'ConvertSimple'
    self.class.post(RELATIVE_URL, body: body_xml).parsed_response['response']
  end

  def settings
    {
      voice: voice,
      output_format: 'FORMAT_WAV',
      sample_rate: '16',
      speed: speed,
      volume: volume,
      pitch: pitch
    }.delete_if {|k,v| v.blank?}
  end

  def prepare_xml options={}, method
    options = options.inject({}) { |h, q| h[q[0].to_s.camelcase(:lower)] = q[1]; h }
    options.to_xml(:skip_instruct => true, :root => method)
  end
end
