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
window_height := 360;

viewport_x: s32;
viewport_y: s32;
viewport_w: s32;
viewport_h: s32;
screen_scale: float;

WORLD_WIDTH :: 320;
WORLD_HEIGHT :: 180;

window: Window_Type;
player: Player;

update_viewport :: () {
	screen_scale_x := cast(float)window_width / cast(float)WORLD_WIDTH;
	screen_scale_y := cast(float)window_height / cast(float)WORLD_HEIGHT;
	screen_scale = ifx screen_scale_x < screen_scale_y then screen_scale_x else screen_scale_y;
	viewport_w = cast(s32)(cast(float)WORLD_WIDTH * screen_scale);
	viewport_h = cast(s32)(cast(float)WORLD_HEIGHT * screen_scale);
	viewport_x = xx ((window_width - viewport_w) / 2);
	viewport_y = xx ((window_height - viewport_h) / 2);
}

main :: () {
	window = create_window(window_width, window_height, "Game");
	window_width, window_height = Simp.get_render_dimensions(window);
	update_viewport();

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
				update_viewport();
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
	Simp.clear_render_target(0, 0, 0, 1);
	GL.glViewport(viewport_x, viewport_y, cast(u32)viewport_w, cast(u32)viewport_h);

	Simp.set_shader_for_color();
	Simp.immediate_set_2d_projection(WORLD_WIDTH, WORLD_HEIGHT);
	Simp.immediate_quad(0, 0, cast(float) WORLD_WIDTH, cast(float) WORLD_HEIGHT, .{1, 1, 1, 1});

	draw(*player);
	
	Simp.swap_buffers(window);
}
