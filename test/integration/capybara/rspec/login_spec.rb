require 'spec_helper'

describe "signing in" do
  it "loads the login page" do
    visit '/login'
    expect(page).to have_title 'raintank'
  end
  it "can log in" do
    visit '/login'
    within ("form.login-form") do
      fill_in 'username', :with => "admin"
      fill_in 'password', :with => "admin"
      find_button("Log in").click
    end
    expect(find("h1.rt-h1")).to have_text "Endpoints"
    expect(page).to have_content 'raintank'
  end

  it "can log out" do
    visit "/logout"
    expect(page).to have_no_css("h1.rt-h1")
  end
end
