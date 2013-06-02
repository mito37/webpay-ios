Pod::Spec.new do |s|
  s.name         = "WebPay"
  s.version      = "0.0.1"
  s.summary      = ""
  s.homepage     = "https://github.com/mmakoto37/WebPay"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "mmakoto37" => "email@address.com" }
  s.source       = { :git => "https://github.com/mmakoto37/WebPay.git", :commit => "b23e5d36bda81bb8591651a9a5bff9ad945db988" }
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'Stripe', '~> 1.0.1'
end
