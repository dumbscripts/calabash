require 'calabash-cucumber/calabash_steps'

Then(/^I take a screenshot$/) do
  sleep(STEP_PAUSE)
  screenshot
end