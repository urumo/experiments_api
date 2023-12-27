require 'rails_helper'

RSpec.describe "experiments/edit", type: :view do
  let(:experiment) {
    Experiment.create!(
      key: "MyString",
      value: "MyString",
      chance: 1.5
    )
  }

  before(:each) do
    assign(:experiment, experiment)
  end

  it "renders the edit experiment form" do
    render

    assert_select "form[action=?][method=?]", experiment_path(experiment), "post" do

      assert_select "input[name=?]", "experiment[key]"

      assert_select "input[name=?]", "experiment[value]"

      assert_select "input[name=?]", "experiment[chance]"
    end
  end
end
