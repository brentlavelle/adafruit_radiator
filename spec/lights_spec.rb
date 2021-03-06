require 'rspec'
require_relative '../lib/usb_lights'

describe 'watch the lights' do
  before :all do
    @test_light = 0
    @light_bridge = AdafruitRadiator::LightBridge.new Dir.glob('/dev/cu.usbserial-*').first
  end

  after :all do
    @light_bridge.set_light @test_light, '000000'
  end

  after :each do
    sleep 0.4 # so we can see the colors change
  end

  it 'can turn white' do
    @light_bridge.set_light @test_light , 'FFFFFF'
  end

  it 'can turn red' do
    @light_bridge.set_light @test_light , 'FF0202'
  end

  it 'can turn blue' do
    @light_bridge.set_light @test_light , '0300FF'
  end

  it 'can turn green' do
    @light_bridge.set_light @test_light , '02FF02'
  end

  it 'can blend colors like yellow' do
    @light_bridge.set_light @test_light , 'EEEE00'
  end

  it 'needs a valid color to work' do
    expect {@light_bridge.set_light @test_light , 'yellow'}.to raise_exception ArgumentError
  end

  it 'needs an integer light number' do
    expect {@light_bridge.set_light -1 , '050505'}.to raise_exception ArgumentError
    expect {@light_bridge.set_light 256 , '050505'}.to raise_exception ArgumentError
  end
end
