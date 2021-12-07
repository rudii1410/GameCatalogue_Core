Pod::Spec.new do |spec|
  spec.name         = "GameCatalogue_Core"
  spec.version      = "1.0.1"
  spec.summary      = "Game Catalogue Core Module"
  spec.description  = "Core module for main project https://github.com/rudii1410/Game-Catalogue"
  spec.license      = { :type => "GNU", :file => "LICENSE" }
  spec.author             = { "Rudiyanto" => "hello@rudiyanto.dev" }
  spec.platform     = :ios
  spec.ios.deployment_target = "14.0"
  spec.homepage = "https://github.com/rudii1410/GameCatalogue_Core"
  spec.source       = { :git => "https://github.com/rudii1410/GameCatalogue_Core.git", :tag => "#{spec.version}" }
  spec.source_files  = "Core/**/*.{swift}"
  spec.framework = "UIKit"
  spec.swift_version = "5.4.2"
  spec.requires_arc = true
end
