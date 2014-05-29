require 'spec_helper'

describe School do
  it 'has a valid factory' do
    school = build(:school)
    school.should be_valid
    school.save!
  end

  it 'is connected to kid' do
    school = create(:school)
    kid = create(:kid, :school => school)
    Kid.find(kid.id).school.should eq(school)
  end
end
