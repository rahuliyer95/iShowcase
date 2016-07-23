Pod::Spec.new do |s|
  s.name             = "iShowcase"
  s.version          = "2.0"
  s.summary          = "Highlight individual parts of your app iShowcase."
  s.homepage         = "https://github.com/rahuliyer95/iShowcase"
  s.screenshots      = "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/assets/1.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/assets/2.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/assets/3.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/assets/4.png", "https://raw.githubusercontent.com/rahuliyer95/iShowcase/master/assets/5.png"
  s.license          = 'MIT'
  s.author           = { "rahuliyer95" => "rahuliyer573@gmail.com" }
  s.source           = { :git => "https://github.com/rahuliyer95/iShowcase.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RahulSIyer'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*.{swift,h}'
  s.frameworks = 'UIKit'
end
