Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "SwipeableTextField"
s.summary = "Your text field's hint swipe up when you enter something and it looks cool"
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "AtaerCaner" => "ataercanercelik@gmail.com" }



# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/AtaerCaner/SwipeableTextField"



# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/AtaerCaner/SwipeableTextField.git", :tag => "#{s.version}"}



# 7
s.framework = "UIKit"


# 8
s.source_files = "SwipeableTextField/**/*.{swift}"

end
