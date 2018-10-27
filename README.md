## pastebin
Uses https://pastebin.com/api/api_post.php to paste text and make it available

Prerequisites:
* rvm (rvm.io)
* ruby interpreter (2.0+)
* required gems (see Gemfile)
* linux terminal
* pastebin developer api (https://pastebin.com/api#1)

Current State:
* generate and save api_user_key as yaml for future use if no such file found
* compose required and optional parameters and posts the request
* print error message or link to paste

Features to add [coming soon...]
* add privacy setting
* ask to enter api_key

Setup usage with rvm and process event series:
* create a gemset
`$ rvm gemset create <gemset>`
eg. `$ rvm gemset create get_my_news`
* use created gemset
`$ rvm <ruby version>@<gemset>`
* install bundler gem
`$ gem install bundler`
* install necessary gems
`$ bundle`
* make script executable
`$ chmod +x <script_name.rb>`
* run script
`$ ./<script_name.rb>`

Further Development [coming soon...]
