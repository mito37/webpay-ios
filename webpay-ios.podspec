Pod::Spec.new do |s|
  s.name         = "webpay-ios"
  s.version      = "0.0.1"
  s.summary      = "ios webpay."
  s.homepage     = "https://github.com/mmakoto37/webpay-ios"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "mmakoto37" => "email@address.com" }
  s.source       = { :git => "https://github.com/mmakoto37/webpay-ios.git", :commit => "64235d959c79177aeffe4740b2acab7d8ae3c2e1" }
  s.source_files = 'webpay-ios', 'Webpay/**/*.{h,m}'
  s.requires_arc = true
end
