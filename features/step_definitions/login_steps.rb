# encoding: UTF-8

假如(/^存在用户 "(.*?)" 且他的密码是 "(.*?)"$/) do |username, password|
  @username = username
  create_user username, password
end

def create_user username, password
  %x[ wp user create "#{username}" "#{username}@chaifeng.com" --role=contributor --user_pass="#{password}" ]
end

当(/^使用用户名 "(.*?)" 和密码 "(.*?)" 登录$/) do |username, password|
  login username, password
end

def login username, password
  visit "http://atdd.local/wp-admin/"
  fill_in "user_login", with: username
  fill_in "user_pass", with: password
  click_on "Sign In"
end

那么(/^能够成功登录$/) do
  expect(title).to eq("Dashboard ‹ Specification By Example Workshop — WordPress")
  %x[wp user delete #{@username} --yes]
end

那么(/^会因为密码错误而登录失败$/) do
  expect(page).to have_content("ERROR: The password you entered for the username #{@username} is incorrect.")
  %x[wp user delete #{@username} --yes]
end

那么(/^会因为没有填写密码而登录失败$/) do
  expect(page).to have_content("ERROR: The password field is empty.")
  %x[wp user delete #{@username} --yes]
end

那么(/^会因为无效的用户名而登录失败$/) do
  expect(page).to have_content("ERROR: Invalid username.")
  %x[wp user delete #{@username} --yes]
end
