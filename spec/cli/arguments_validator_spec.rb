# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Cli::ArgumentsValidator do
  describe '#call' do
    it 'builds arguments object' do
      stub_const('ARGV', ['', '--month=012024', '--theme=winter'])
      args = described_class.new.call

      expect(args.theme).to eq('winter')
      expect(args.date.year).to eq(2024)
      expect(args.date.month).to eq(1)
    end

    it 'requires theme argument' do
      stub_const('ARGV', ['', '--month=112222'])
      expect do
        described_class.new.call
      end.to raise_error(
        Cli::InvalidArgumentsError,
        'Theme argument is required'
      )
    end

    it 'requires month argument' do
      stub_const('ARGV', [''])
      expect do
        described_class.new.call
      end.to raise_error(
        Cli::InvalidArgumentsError,
        'Month argument is required and must have 6 digits'
      )
    end

    it 'validates month argument' do
      stub_const('ARGV', ['', '--month=0234'])
      expect do
        described_class.new.call
      end.to raise_error(
        Cli::InvalidArgumentsError,
        'Month argument is invalid and must have 6 digits'
      )
    end

    it 'does not allow unlisted arguments' do
      stub_const('ARGV', ['', '--a 1'])
      expect do
        described_class.new.call
      end.to raise_error Cli::InvalidArgumentsError, 'invalid option: --a 1'
    end
  end
end
