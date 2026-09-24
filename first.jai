#run build();

#import "Compiler";
#import "File";
#import "Basic";
#import "Process";

build :: () {
	set_build_options_dc(.{do_output=false, write_added_strings=false});

	w := compiler_create_workspace("Build");
	if !w {
		log_error("Workspace creation failed.\n");
		return;
	}

	make_directory_if_it_does_not_exist("build");

	opts := get_build_options(w);
	opts.output_path = "build";
	opts.output_executable_name = "game";
	set_build_options(opts, w);


	flags := Intercept_Flags.SKIP_ALL;
	compiler_begin_intercept(w, flags);

	add_build_file("src/main.jai", w);

	has_errors := false;

	while true {
		message := compiler_wait_for_message();

		if message.kind == .COMPLETE {
			break;
		} else if message.kind == .ERROR {
			has_errors = true;
		}
	}

	compiler_end_intercept(w);

	if has_errors then return;

	#if OS == .WINDOWS {
		run_command("build/game.exe");
	} else {
		run_command("./build/game");
	}
}
