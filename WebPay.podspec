Pod::Spec.new do |s|
  s.name         = "WebPay"
  s.version      = "0.0.1"
  s.summary      = "ios webpay."
  s.homepage     = "https://github.com/mmakoto37/webpay-ios"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "mmakoto37" => "email@address.com" }
  s.source       = { :git => "https://github.com/mmakoto37/webpay-ios.git", :submodules => 'true' }
  s.source_files        = 'WebPay/**/*.{h,m}'
  s.public_header_files = 'WebPay/**/*.h''
  s.requires_arc = true
end
