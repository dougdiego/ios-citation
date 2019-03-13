platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

def common_pods
    pod 'RealmSwift'
    pod 'SwiftLint'
end

target "Citation" do
	common_pods
 	pod 'PopupDialog', '~> 0.9'
end

target "Citation Share Extension" do 
	common_pods
end 
