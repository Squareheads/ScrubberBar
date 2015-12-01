Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "ScrubberBar"
  s.summary = "An IBDesignable media scrubber bar similar to apple music, in swift"
  s.requires_arc = true
 
  s.version = "0.1.0"
 
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  s.author = { "Owen Worley" => "owen@squareheads.io]" }
 
  s.homepage = "https://github.com/squareheads/ScrubberBar"
 
  s.source = { :git => "https://github.com/Squareheads/ScrubberBar.git", :tag => "#{s.version}"}
 
  s.framework = "UIKit"
 
  s.source_files = "ScrubberBar/**/*.{swift}"
 
  s.resources = "ScrubberBar/**/*.{png,jpeg,jpg,storyboard,xib}"
end
