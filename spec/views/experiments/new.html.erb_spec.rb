# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'experiments/new' do
  before do
    assign(:experiment, Experiment.new(
                          key: 'MyString',
                          value: 'MyString',
                          chance: 1.5
                        ))
  end

  it 'renders new experiment form' do
    render

    assert_select 'form[action=?][method=?]', experiments_path, 'post' do
      assert_select 'input[name=?]', 'experiment[key]'

      assert_select 'input[name=?]', 'experiment[value]'

      assert_select 'input[name=?]', 'experiment[chance]'
    end
  end
end
