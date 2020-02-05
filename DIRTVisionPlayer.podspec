Pod::Spec.new do |s|
  s.name             = "DIRTVisionPlayer"
  s.version          = '0.1.0'
  s.summary          = "DIRTVisionPlayer"
  s.description      = <<-DESC
                        Player for DIRTVision, based off JWPlayer.
                       DESC
  s.homepage         = "https://github.com/applicaster-plugins/DIRTVisionPlayer.git"
  s.license          = 'CMPS'
  s.author           = { "cmps" => "andrii.novoselskyi@corewillsoft.com" }
  s.source           = { :git => "git@github.com:applicaster-plugins/DIRTVisionPlayer.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.public_header_files = 'iOS/DIRTVisionPlayer/**/*.h'
  s.source_files = 'iOS/DIRTVisionPlayer/**/*.{h,m,swift}'
  s.resources = [
    'iOS/DIRTVisionPlayer/Resources/**/*.plist',
    'iOS/DIRTVisionPlayer/Resources/**/*.xib'
  ]

  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                  'ENABLE_BITCODE' => 'YES',
                  'OTHER_CFLAGS'  => '-fembed-bitcode',
                  'OTHER_LDFLAGS' => '$(inherited) -framework "JWPlayer_iOS_SDK"'
                  }

  s.dependency 'ZappPlugins'
  s.dependency 'JWPlayerPlugin'
  s.dependency 'PluginPresenter'

end
