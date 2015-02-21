Pod::Spec.new do |s|
  s.name             = "iShowcase"
  s.version          = "1.2"
  s.summary          = "Highlight individual parts of your app iShowcase."
  s.homepage         = "https://github.com/rahuliyer95/iShowcase"
  s.screenshots      = "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/screenshot/1.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/screenshot/2.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/screenshot/3.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/screenshot/4.png"
  s.license          = 'MIT'
  s.author           = { "rahuliyer95" => "rahuliyer573@gmail.com" }
  s.source           = { :git => "https://github.com/rahuliyer95/iShowcase.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RahulSIyer'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.frameworks = 'UIKit'
end
