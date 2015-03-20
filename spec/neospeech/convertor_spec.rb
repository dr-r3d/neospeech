require 'spec_helper'

describe Neospeech::Convertor do
  subject { Neospeech::Convertor.new text: 'test', voice: 'Paul', speed: 'normal' }
  context 'variables' do
    it 'should give speed' do
      expect(subject.speed).to eq('100')
    end
    it 'should give voice' do
      expect(subject.voice).to eq('TTS_PAUL_DB')
    end
  end

  context 'queueing' do
    it 'should queue a request' do
      allow(subject).to receive(:start_conversion).with('simple').and_return({})
      expect(subject.queue 'simple').to eq(subject)
    end
    it 'should give error on a failed request' do
      allow(subject).to receive(:start_conversion).with('simple').and_return({"resultCode"=>"-12", "resultString"=>"invalid REST request", "resultDetail"=>"REST method is not defined: "})
      expect(subject.queue 'simple').to eq(subject)
      expect(subject.error).to be true
    end
  end

  context 'successful send' do
    before do
      allow(subject).to receive(:start_conversion).with('simple').and_return({"resultCode"=>"0", "resultString"=>"success", "conversionNumber"=>"31", "status"=>"Queued", "statusCode"=>"1"})
      expect(subject.queue 'simple').to eq(subject)
    end
    it 'should return conversion number' do
      expect(subject.conversion_number).to eq('31')
    end
  end

  context 'successful status query' do
    before do
      allow(subject).to receive(:query_status).and_return({"response"=>{"resultCode"=>"0", "resultString"=>"success", "conversionNumber"=>"31", "status"=>"Processing", "statusCode"=>"2"}})
      allow(subject).to receive(:start_conversion).with('simple').and_return({"resultCode"=>"0", "resultString"=>"success", "conversionNumber"=>"31", "status"=>"Queued", "statusCode"=>"1"})
      expect(subject.queue 'simple').to eq(subject)
    end
    it 'should not be finished' do
      expect(subject.finished?).to be false
    end
    it 'should timeout' do
      subject.count = 31
      expect(subject.finished?).to be true
    end
    it 'should not be sucessful' do
      expect(subject.success?).to be false
    end
    it 'should return status' do
      expect(subject.status).to eq('2')
    end
    it 'should return no error' do
      expect(subject.error).to be false
    end
    it 'should return no audio file' do
      expect(subject.audio_file_url).to be_nil
    end
  end

  context 'successful status query' do
    before do
      allow(subject).to receive(:query_status).and_return({"response"=>{"resultCode"=>"0", "resultString"=>"success", "status"=>"Completed", "statusCode"=>"4", "downloadUrl"=>"https://tts.neospeech.com/audio/a.php/000/111/result_1.wav"}})
      allow(subject).to receive(:start_conversion).with('simple').and_return({"resultCode"=>"0", "resultString"=>"success", "conversionNumber"=>"31", "status"=>"Queued", "statusCode"=>"1"})
      expect(subject.queue 'simple').to eq(subject)
    end
    it 'should not be finished' do
      expect(subject.finished?).to be true
    end
    it 'should not be sucessful' do
      expect(subject.success?).to be true
    end
    it 'should return status' do
      expect(subject.status).to eq('4')
      expect(subject.audio_file_url).to eq('https://tts.neospeech.com/audio/a.php/000/111/result_1.wav')
    end
    it 'should return no error' do
      expect(subject.error).to be false
    end
  end
end