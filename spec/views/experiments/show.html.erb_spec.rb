# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'experiments/show' do
  before do
    assign(:experiment, Experiment.create!(
                          key: 'Key',
                          value: 'Value',
                          chance: 2.5
                        ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/2.5/)
  end
end
