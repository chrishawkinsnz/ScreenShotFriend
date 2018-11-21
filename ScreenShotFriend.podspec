Pod::Spec.new do |s|
  s.name             = "ScreenShotFriend"
  s.version          = "0.0.1"
  s.summary          = "Adds a small actionable friend to the screen when the user takes a screenshot."
  s.homepage         = "https://this-page-intentionally-left-blank.org"
  s.author           = { "Chris Hawkins" => "chrishawkinsnz@gmail.com" }
  s.source           = { :git => "https://github.com/chrishawkinsnz/ScreenShotFriend.git", :tag => s.version }
  s.license          = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  s.platform     = :ios, '10.0'
  s.requires_arc = true
  s.source_files = "ScreenShotFriend/**/*.swift"
  s.resources = "ScreenShotFriend/**/*.xib", "ScreenShotFriend/*.xcassets"

  s.frameworks = 'UIKit' 
  s.module_name = 'ScreenShotFriend'
  s.swift_version = "4.2"
end
