class Neospeech::Conversion::Simple
  include Neospeech::Config
  include HTTParty

  base_uri 'https://tts.neospeech.com'
  RELATIVE_URL = '/rest_1_1.php'

  attr_reader :status, :text
  attr_accessor :audio_file_url, :error

  def initialize(args = {})
    @response = args['response']
    @status = @response['statusCode']
    error = @response['resultCode']
  end

  def self.queue text
    @text = text
    new simple
  end

  def conversion_number
    @response['conversionNumber']
  end

  def finished?
   error || status.eql?('4')
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

  private

  def query_status
    options = [self.class.account_auth, {conversionNumber: conversion_number}].reduce(:merge)
    body_xml =  self.class.prepare_xml options, 'GetConversionStatus'
    response = self.class.post(RELATIVE_URL, body: body_xml).parsed_response
    error = response['response']['resultCode']
    response
  end

  def self.simple
    options = [account_auth, api_auth, settings, {text: @text}].reduce(:merge)
    body_xml = prepare_xml options, 'ConvertSimple'
    post(RELATIVE_URL, body: body_xml).parsed_response
  end

  def self.settings
    {
      voice: 'TTS_KATE_DB',
      output_format: 'FORMAT_WAV',
      sample_rate: '16',
      speed: '50'
    }
  end

  def self.prepare_xml options={}, method
    options = options.inject({}) { |h, q| h[q[0].to_s.camelcase(:lower)] = q[1]; h }
    options.to_xml(:skip_instruct => true, :root => method)
  end
end
