Pod::Spec.new do |s|
  s.name             = "Chinwag"
  s.version          = "0.1.0"
  s.summary          = "Swift bindings for Chinwag text-synthesis library, for layout testing (and more)."
  s.description      = <<-DESC
                       #{s.summary} It houses flexible methods for generation, and a dictionary object allowing adequate token files (or embedded defaults) to be used as the basis for output creation. It effectively supersedes modern Lorem Ipsum generators, in terms of functionality and speed.
                       DESC
  s.homepage         = "https://github.com/vulcancreative/chinwag-swift"
  s.license          = 'MIT'
  s.author           = { "Chris Calo" => "ccalo@vulcanca.com" }
  s.source           = { :git => "https://github.com/vulcancreative/chinwag-swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/vulcan_creative'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/**/*.{h,c,swift}'
  s.public_header_files = 'Source/Core/*.h'

  s.requires_arc = true
end
