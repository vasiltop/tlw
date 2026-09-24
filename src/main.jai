#import "Basic";
#import "Window_Creation";
#import "System";
#import "String";
#import "Math";

GL :: #import "GL";
Input :: #import "Input";
Simp :: #import "Simp";

#load "player.jai";

window_width := 640;
window_height := 480;

WORLD_WIDTH:: 640;
WORLD_HEIGHT :: 480;

window: Window_Type;
player: Player;

main :: () {
	window = create_window(window_width, window_height, "Game");
	window_width, window_height = Simp.get_render_dimensions(window);

	Simp.set_render_target(window, .RIGHT_HANDED);

	context.allocator = temp;
	path := path_strip_filename(get_path_of_running_executable());
	set_working_directory(join(path, "../assets"));

	init();

	quit := false;
	while !quit {
		Input.update_window_events();

		for Input.get_window_resizes() {
			Simp.update_window(it.window);

			if it.window == window {
				window_width = it.width;
				window_height = it.height;
			}
		}

		for Input.events_this_frame {
			if it.type == .QUIT then quit = true;

			if it.type == {
				case .KEYBOARD;
				if it.key_pressed && it.key_code == .ESCAPE {
					quit = true;
				}
			}
		}

		draw();
		sleep_milliseconds(10);
		reset_temporary_storage();
	}
}

init :: () {
	init(*player);
}

draw :: () {
	Simp.clear_render_target(.15, .08, .08, 1);

	draw(*player);
	
	Simp.swap_buffers(window);
}
