# function is called from core.tcl
proc load_files {core_path output_path project_name} {

    # This is basically what core.tcl does
    set filesList [glob $core_path/*.vhd]
    add_files -norecurse $filesList

    # Set all VHDL files to VHDL 2008 standard
    foreach file $filesList {
        set_property file_type {VHDL 2008} [get_files $file]
    }

    # Define the top level explicity
    set_property top axi4_stream_resize [get_filesets sources_1]

    # now that we have a top level, we can remove unreferenced files
    remove_unreferenced
}

proc remove_unreferenced {} {
    set used_list [split [get_files -compile_order sources -used_in synthesis ] " "]
    set file_list [split [get_files] " " ]
    set removal_list {}

    foreach element $file_list {
        if {[lsearch -exact $used_list $element] == -1} {
            lappend removal_list $element
        }
    }
    remove_files [join $removal_list]
}
