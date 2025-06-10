set display_name {TDD-RT Port ctrl}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

set_property VENDOR {amd} $core
set_property VENDOR_DISPLAY_NAME {amd} $core

