# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'experiments/index' do
  before do
    assign(:experiments, [
             Experiment.create!(
               key: 'Key',
               value: 'Value',
               chance: 2.5
             ),
             Experiment.create!(
               key: 'Key',
               value: 'Value',
               chance: 2.5
             )
           ])
  end

  it 'renders a list of experiments' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Key'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Value'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.5.to_s), count: 2
  end
end
