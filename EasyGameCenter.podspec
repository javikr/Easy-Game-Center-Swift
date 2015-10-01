Pod::Spec.new do |s|
s.name        = "EasyGameCenter"
s.version     = "0.0.3"
s.summary     = "Easy Game Center helps to manage Game Center in iOS"
s.homepage    = "https://github.com/DaRkD0G/Easy-Game-Center-Swift"
s.license     = { :type => "MIT" }
s.authors     = { "DaRkD0G" => "stephan.yannick@me.com" }

s.ios.deployment_target = "7.0"
s.source   = { :git => "https://github.com/DaRkD0G/Easy-Game-Center-Swift.git", :tag => "1.5"}
s.source_files = "/EasyGameCenter.swift"
end